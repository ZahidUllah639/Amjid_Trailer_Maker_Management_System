import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:drift/drift.dart';
import '../models/traila.dart';
import '../models/supplier.dart';
import '../models/labour.dart';
import '../models/account.dart';
import '../models/payment.dart';
import '../models/buyer.dart';
import '../models/sale.dart';
import '../models/app_profile.dart';
import '../models/invoice.dart';
import '../models/product.dart';
import '../models/printer_setting.dart';
import '../models/khata.dart';

import '../database/database.dart';

part 'erp_state.dart';

class ERPCubit extends Cubit<ERPState> {
  final AppDatabase _db = AppDatabase();

  ERPCubit() : super(ERPState.initial()) {
    loadData();
  }

  void setModuleIndex(int index) {
    emit(state.copyWith(currentModuleIndex: index));
  }

  void setTrailaHistoryId(String? id) {
    emit(state.copyWith(currentTrailaHistoryId: () => id));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  Future<void> updateAppProfile(AppProfile profile) async {
    await _db.into(_db.appProfiles).insert(
      AppProfileData(
        id: profile.id,
        ownerName: profile.ownerName,
        phoneNumber: profile.phoneNumber,
        businessName: profile.businessName,
        address: profile.address,
        whatsappNumber: profile.whatsappNumber,
      ),
      mode: InsertMode.insertOrReplace,
    );
    emit(state.copyWith(
      appProfile: () => profile,
      ownerName: profile.ownerName,
      ownerWhatsapp: profile.whatsappNumber ?? profile.phoneNumber,
      ownerPhone: profile.phoneNumber,
      ownerAddress: profile.address ?? '',
    ));
  }

  Future<void> loadData() async {
    // 1. Fetch all data using Drift
    final productDatas = await _db.getAllProducts();
    final supplierDatas = await _db.getAllSuppliers();
    final labourDatas = await _db.getAllLabours();
    final trailaDatas = await _db.select(_db.trailas).get();
    final expenseDatas = await _db.select(_db.trailaExpenses).get();
    var paymentDatas = await _db.select(_db.payments).get();
    final splitDatas = await _db.select(_db.splitDetails).get();
    final transactionDatas = await _db.select(_db.transactions).get();
    final buyerDatas = await _db.select(_db.buyers).get();
    final saleDatas = await _db.select(_db.sales).get();
    final settingDatas = await _db.select(_db.appSettings).get();
    final profileDatas = await _db.select(_db.appProfiles).get();
    final accountDatas = await _db.select(_db.accounts).get();
    final printerSettingDatas = await _db.select(_db.printerSettings).get();
    final khataDatas = await _db.getAllKhatas();
    final khataItemDatas = await _db.select(_db.khataItems).get();

    // --- DATA INTEGRITY HEALING & BACKFILL ---
    // 1. Healing: Restore remaining balance from opening balance if nothing else exists
    for (var s in supplierDatas) {
      if (s.remainingBalance.abs() < 0.01 && s.openingBalance.abs() > 0.01 && s.totalAmount.abs() < 0.01) {
        await (_db.update(_db.suppliers)..where((t) => t.id.equals(s.id))).write(SuppliersCompanion(
          remainingBalance: Value(s.openingBalance),
        ));
      }
    }
    for (var l in labourDatas) {
      if (l.remainingBalance.abs() < 0.01 && l.openingBalance.abs() > 0.01 && l.totalPayable.abs() < 0.01) {
        await (_db.update(_db.labours)..where((t) => t.id.equals(l.id))).write(LaboursCompanion(
          remainingBalance: Value(l.openingBalance),
        ));
      }
    }

    // 2. Backfill: Create missing OPEN-BAL invoices for legacy records
    final currentInvoices = await _db.select(_db.invoices).get();
    for (var s in supplierDatas) {
      if (s.openingBalance > 0 && !currentInvoices.any((i) => i.ownerId == s.id && i.invoiceNumber == 'OPEN-BAL')) {
        await _db.into(_db.invoices).insert(InvoicesCompanion.insert(
          id: 'SOB-${s.id}-BACKFILL',
          invoiceNumber: 'OPEN-BAL',
          date: s.registrationDate,
          type: InvoiceType.purchase.name,
          ownerId: s.id,
          ownerName: s.name,
          ownerType: 'supplier',
          amount: s.openingBalance,
          previousBalance: 0.0,
          remainingBalance: s.openingBalance,
          paymentMethod: 'Credit',
          ownerNameDisplay: state.ownerName,
        ));
      }
    }
    for (var l in labourDatas) {
      if (l.openingBalance > 0 && !currentInvoices.any((i) => i.ownerId == l.id && i.invoiceNumber == 'OPEN-BAL')) {
        await _db.into(_db.invoices).insert(InvoicesCompanion.insert(
          id: 'LOB-${l.id}-BACKFILL',
          invoiceNumber: 'OPEN-BAL',
          date: l.registrationDate,
          type: InvoiceType.labourWork.name,
          ownerId: l.id,
          ownerName: l.name,
          ownerType: 'labour',
          amount: l.openingBalance,
          previousBalance: 0.0,
          remainingBalance: l.openingBalance,
          paymentMethod: 'Credit',
          ownerNameDisplay: state.ownerName,
        ));
      }
    }

    // 3. Backfill: Create missing Downpayment records for legacy sales
    for (var s in saleDatas) {
      if (s.paidAmount > 0.01 && !paymentDatas.any((p) => p.ownerId == s.id && p.id.startsWith('DP-'))) {
        final double grossTotal = s.salePrice + s.globalPreviousBalance;
        await _db.into(_db.payments).insert(PaymentsCompanion.insert(
          id: 'DP-${s.id}-BACKFILL',
          amount: s.paidAmount,
          date: s.saleDate,
          method: 'Cash', // Heuristic: default to Cash for backfill
          receiptNumber: Value(s.receiptNumber),
          ownerId: s.id,
          ownerType: 'sale',
          previousBalance: Value(grossTotal),
          updatedBalance: Value(grossTotal - s.paidAmount),
          createdAt: Value(DateTime.now()),
        ));
      }
    }

    // Re-fetch all if healing or backfill occurred to ensure mapping uses latest data
    final updatedSupplierDatas = await _db.getAllSuppliers();
    final updatedLabourDatas = await _db.getAllLabours();
    final updatedInvoiceDatas = await _db.getInvoicesWithItems();
    final updatedPaymentDatas = await _db.select(_db.payments).get(); // ✅ Also re-fetch payments
    paymentDatas = updatedPaymentDatas;


    // Ensure at least 'Cash' exists if no accounts
    if (accountDatas.isEmpty) {
      await _db.into(_db.accounts).insert(AccountData(
        id: 'cash',
        name: 'Cash',
        balance: 0.0,
        type: 'cash',
        createdAt: DateTime.now(),
      ));
      final updatedAccountDatas = await _db.select(_db.accounts).get();
      accountDatas.clear();
      accountDatas.addAll(updatedAccountDatas);
    }

    // Mapping Helpers
    final products = productDatas.map((p) => Product(
      id: p.id, 
      name: p.name, 
      defaultPrice: p.defaultPrice, 
      unit: p.unit
    )).toList();
    
    final Map<String, List<Transaction>> txnsByAccount = {};
    for (var t in transactionDatas) {
      txnsByAccount.putIfAbsent(t.accountName, () => []).add(Transaction(
        id: t.id,
        accountName: t.accountName,
        type: TransactionType.values.firstWhere((e) => e.name == t.type, orElse: () => TransactionType.add),
        amount: t.amount,
        person: t.person,
        description: t.description,
        date: t.date,
        category: t.category,
        linkedTransferId: t.linkedTransferId,
      ));
    }

    final Map<String, List<TrailaExpense>> epByT = {};
    for (var e in expenseDatas) {
      final tId = e.trailaId ?? "General";
      epByT.putIfAbsent(tId, () => []).add(TrailaExpense(
        id: e.id,
        type: e.type,
        description: e.description,
        amount: e.amount,
        date: e.date,
        supplierId: e.supplierId,
        labourId: e.labourId,
      ));
    }

    final Map<String, List<SplitDetail>> splitsByP = {};
    for (var s in splitDatas) {
      splitsByP.putIfAbsent(s.paymentId, () => []).add(SplitDetail(method: s.method, amount: s.amount));
    }

    final Map<String, List<Payment>> paymentsByOwner = {};
    for (var p in paymentDatas) {
      final key = '${p.ownerType}-${p.ownerId}';
      paymentsByOwner.putIfAbsent(key, () => []).add(Payment(
        id: p.id,
        amount: p.amount,
        date: p.date,
        method: p.method,
        receiptNumber: p.receiptNumber,
        previousBalance: p.previousBalance,
        updatedBalance: p.updatedBalance,
        splitDetails: splitsByP[p.id],
      ));
    }

    final List<Invoice> invoiceList = updatedInvoiceDatas.map((invWithItems) {
      final inv = invWithItems.invoice;
      return Invoice(
        id: inv.id,
        invoiceNumber: inv.invoiceNumber,
        date: inv.date,
        type: InvoiceType.values.firstWhere((e) => e.name == inv.type),
        ownerId: inv.ownerId,
        ownerName: inv.ownerName,
        ownerType: inv.ownerType,
        trailaId: inv.trailaId,
        amount: inv.amount,
        previousBalance: inv.previousBalance,
        remainingBalance: inv.remainingBalance,
        paymentMethod: inv.paymentMethod,
        ownerNameDisplay: inv.ownerNameDisplay,
        items: invWithItems.items.map((it) => PurchaseItem(
          id: it.id.toString(),
          name: it.productName,
          quantity: it.quantity.toInt(),
          unitPrice: it.unitPrice,
          total: it.lineTotal,
        )).toList(),
      );
    }).toList();

    // Map Invoices to SupplierPurchases
    final Map<String, List<SupplierPurchase>> purchasesByS = {};
    for (var inv in invoiceList) {
      if (inv.type == InvoiceType.purchase) {
        purchasesByS.putIfAbsent(inv.ownerId, () => []).add(SupplierPurchase(
          id: inv.id,
          billNumber: inv.invoiceNumber,
          date: inv.date,
          trailaId: inv.trailaId ?? '',
          totalAmount: inv.amount,
          items: inv.items ?? [],
          previousOutstanding: inv.previousBalance,
          updatedBalance: inv.remainingBalance, // ✅ Map final balance
          paymentAmount: (inv.previousBalance + inv.amount) - inv.remainingBalance, // ✅ Infer payment amount
          paymentMethod: inv.paymentMethod, // ✅ Map payment method (e.g., Cash, Bank, etc.)
          description: inv.invoiceNumber == 'OPEN-BAL' ? 'Opening Balance' : 'Purchase',
        ));
      }
    }

    // Map Invoices to WorkEntries
    final Map<String, List<WorkEntry>> workByL = {};
    for (var inv in invoiceList) {
      if (inv.type == InvoiceType.labourWork) {
        workByL.putIfAbsent(inv.ownerId, () => []).add(WorkEntry(
          id: inv.id,
          entryNumber: inv.invoiceNumber,
          trailaId: inv.trailaId ?? '',
          cost: inv.amount,
          previousOutstanding: inv.previousBalance,
          updatedBalance: inv.remainingBalance, // ✅ Map final balance
          paymentAmount: (inv.previousBalance + inv.amount) - inv.remainingBalance, // ✅ Infer payment amount
          date: inv.date,
          description: inv.invoiceNumber == 'OPEN-BAL' ? 'Opening Balance' : 'Labour Work',
        ));
      }
    }

    final List<Supplier> suppliers = updatedSupplierDatas.map((s) => Supplier(
      id: s.id,
      name: s.name,
      phone: s.phone,
      shopName: s.shopName,
      location: s.location,
      whatsappNumber: s.whatsappNumber,
      registrationDate: s.registrationDate,
      openingBalance: s.openingBalance,
      totalAmount: s.totalAmount,
      totalPaid: s.totalPaid,
      remainingBalance: s.remainingBalance,
      advanceBalance: s.advanceBalance,
      purchases: purchasesByS[s.id] ?? [],
      payments: paymentsByOwner['supplier-${s.id}'] ?? [],
    )).toList();

    final List<Labour> labours = updatedLabourDatas.map((l) => Labour(
      id: l.id,
      name: l.name,
      phone: l.phone,
      whatsappNumber: l.whatsappNumber,
      address: l.address,
      registrationDate: l.registrationDate,
      openingBalance: l.openingBalance, 
      totalPayable: l.totalPayable,
      totalPaid: l.totalPaid,
      remainingBalance: l.remainingBalance,
      workEntries: workByL[l.id] ?? [],
      payments: paymentsByOwner['labour-${l.id}'] ?? [],
    )).toList();


    final List<Buyer> buyers = buyerDatas.map((b) => Buyer(
      id: b.id, 
      name: b.name, 
      phone: b.phone ?? '', 
      cnic: b.cnic ?? '',
      address: b.address ?? '',
      whatsappNumber: b.whatsappNumber ?? ''
    )).toList();

    final List<Sale> sales = saleDatas.map((s) => Sale(
      id: s.id,
      trailaId: s.trailaId,
      buyerId: s.buyerId,
      salePrice: s.salePrice,
      manufacturingCost: s.manufacturingCost,
      profit: s.profit,
      saleDate: s.saleDate,
      totalPaid: s.paidAmount,
      remainingBalance: s.remainingBalance,
      status: SaleStatus.values.firstWhere(
        (e) => e.name == (s.paidAmount >= s.salePrice ? 'paid' : (s.paidAmount > 0 ? 'partial' : 'pending')),
        orElse: () => SaleStatus.pending
      ),
      receiptNumber: s.receiptNumber,
      globalPreviousBalance: s.globalPreviousBalance, // ✅ Map new field
      payments: paymentsByOwner['sale-${s.id}'] ?? [],
    )).toList();

    final List<Traila> trailas = trailaDatas.map((t) => Traila(
      id: t.id,
      name: t.name,
      registrationDate: t.registrationDate,
      status: TrailaStatus.values.firstWhere((e) => e.name == t.status),
      totalManufacturingCost: t.totalManufacturingCost,
      expenses: epByT[t.id] ?? [],
    )).toList();

    final Map<String, String> settings = { for (var s in settingDatas) s.key: s.value };
    final ownerName = settings['ownerName'] ?? 'Manager';
    final ownerWhatsapp = settings['ownerWhatsapp'] ?? '';
    final AppProfile? appProfile = profileDatas.isNotEmpty ? AppProfile(
      id: profileDatas.first.id,
      businessName: profileDatas.first.businessName,
      ownerName: profileDatas.first.ownerName,
      phoneNumber: profileDatas.first.phoneNumber,
      address: profileDatas.first.address,
      whatsappNumber: profileDatas.first.whatsappNumber,
    ) : null;

    final Map<String, Account> accounts = {
      for (var a in accountDatas)
        a.id: Account(
          id: a.id,
          name: a.name, 
          balance: a.balance,
          type: a.type,
          iconType: a.iconType,
          createdAt: a.createdAt,
          transactions: txnsByAccount[a.name] ?? []
        )
    };
    
    final Map<String, List<KhataTransaction>> itemsByKhata = {};
    for (var ki in khataItemDatas) {
      itemsByKhata.putIfAbsent(ki.khataId, () => []).add(KhataTransaction(
        id: ki.id.toString(),
        description: ki.itemName,
        amount: ki.price,
        type: KhataTransactionType.values.firstWhere((e) => e.name == ki.type, orElse: () => KhataTransactionType.cashOut),
        date: ki.date,
        paymentMethod: ki.paymentMethod,
      ));
    }

    final List<Khata> khatas = khataDatas.map((k) => Khata(
      id: k.id,
      personName: k.personName,
      openingBalance: k.openingBalance, // ✅ Map new field
      totalAmount: k.totalAmount,
      paidAmount: k.paidAmount,
      remainingBalance: k.remainingBalance,
      date: k.date,
      items: itemsByKhata[k.id] ?? <KhataTransaction>[],
    )).toList();

    PrinterSetting printerSetting = const PrinterSetting();
    if (printerSettingDatas.isNotEmpty) {
      final ps = printerSettingDatas.first;
      printerSetting = PrinterSetting(
        deviceName: ps.deviceName ?? '',
        deviceAddress: ps.deviceAddress ?? '',
        vendorId: ps.vendorId,
        productId: ps.productId,
        paperSize: ps.paperSize,
        connectionType: ps.connectionType,
        autoCut: ps.autoCut,
        autoPrint: ps.autoPrint,
      );
    }

    // STARTUP SANITIZATION: clamp any stale negative balances to 0.
    // This corrects data stored before the running-balance fix was applied.
    final List<Supplier> sanitizedSuppliers = [];
    for (final s in suppliers) {
      if (s.remainingBalance < 0) {
        final fixed = s.copyWith(remainingBalance: 0, advanceBalance: s.advanceBalance + s.remainingBalance.abs());
        sanitizedSuppliers.add(fixed);
        await (_db.update(_db.suppliers)..where((tbl) => tbl.id.equals(s.id))).write(SuppliersCompanion(remainingBalance: Value(0.0), advanceBalance: Value(fixed.advanceBalance)));
        // print('[SANITIZE] Supplier ${s.id}: clamped remainingBalance ${s.remainingBalance} → 0, advance → ${fixed.advanceBalance}');
      } else {
        sanitizedSuppliers.add(s);
      }
    }

    final List<Labour> sanitizedLabours = [];
    for (final l in labours) {
      if (l.remainingBalance < 0) {
        final fixed = l.copyWith(remainingBalance: 0);
        sanitizedLabours.add(fixed);
        await (_db.update(_db.labours)..where((tbl) => tbl.id.equals(l.id))).write(LaboursCompanion(remainingBalance: Value(0.0)));
        // print('[SANITIZE] Labour ${l.id}: clamped remainingBalance ${l.remainingBalance} → 0');
      } else {
        sanitizedLabours.add(l);
      }
    }

    emit(state.copyWith(
      trailas: trailas,
      suppliers: sanitizedSuppliers,
      labours: sanitizedLabours,
      buyers: buyers,
      sales: sales,
      invoiceList: invoiceList,
      products: products,
      khatas: khatas,
      accounts: accounts.isNotEmpty ? accounts : state.accounts,
      appProfile: () => appProfile,
      ownerName: appProfile?.ownerName ?? ownerName,
      ownerWhatsapp: appProfile?.whatsappNumber ?? ownerWhatsapp,
      ownerPhone: appProfile?.phoneNumber ?? '',
      ownerAddress: appProfile?.address ?? '',
      printerSetting: printerSetting,
      isLoading: false,
    ));
  }


  String _getAccountKey(String nameOrId) {
    if (state.accounts.containsKey(nameOrId)) return nameOrId;

    try {
      return state.accounts.values
          .firstWhere((a) => a.name.toLowerCase() == nameOrId.toLowerCase())
          .id;
    } catch (e) {
      return nameOrId.toLowerCase().replaceAll(' ', '_');
    }
  }

  Future<void> addAccount(Account account) async {
    // print('=== ADD ACCOUNT START ===');
    // print('Name: ${account.name}');
    // print('Type: ${account.type}');
    
    try {
      // The _db is final and initialized, so this check is technically unnecessary per linter
      /*
      if (_db == null) {
        // print('CRITICAL: Database instance is NULL');
        return;
      }
      */

      await _db.into(_db.accounts).insert(AccountData(
        id: account.id,
        name: account.name,
        balance: account.balance,
        type: account.type,
        iconType: account.iconType ?? '',
        createdAt: account.createdAt,
      ));
      
      // print('Insert successful for: ${account.name}');
      
      // ENSURE DATABASE REFRESH: Reload everything from the source of truth
      await loadData();
      
      // print('Total accounts after insert: ${state.accounts.length}');
// print('=== ADD ACCOUNT SUCCESS ===');
    } catch (e) {
      // print('=== ADD ACCOUNT ERROR ===');
// print('Error: $e');
// print(stackTrace);
      rethrow;
    }
  }

  // --- Auto ID Sequence Generators ---

  String getNextTrailaId() {
    return _generateNextSequentialId(state.trailas.map((t) => t.id), 'TRL');
  }

  String getNextBuyerId() {
    return _generateNextSequentialId(state.buyers.map((b) => b.id), 'CUST');
  }

  String getNextSupplierId() {
    return _generateNextSequentialId(state.suppliers.map((s) => s.id), 'SUP');
  }

  String getNextLabourId() {
    return _generateNextSequentialId(state.labours.map((l) => l.id), 'LBR');
  }

  static String _generateNextSequentialId(Iterable<String> existingIds, String prefix) {
    int maxNumber = 0;
    final numPattern = RegExp(r'\d+');
    final idSet = existingIds.toSet();
    for (final id in idSet) {
      for (final m in numPattern.allMatches(id)) {
        final val = int.tryParse(m.group(0) ?? '');
        // Exclude epoch/timestamp-sized integers so we get clean, human-readable numbers like 001, 002
        if (val != null && val > maxNumber && val < 10000000) {
          maxNumber = val;
        }
      }
    }
    int nextNum = maxNumber + 1;
    String candidate = '$prefix-${nextNum.toString().padLeft(3, '0')}';
    while (idSet.contains(candidate)) {
      nextNum++;
      candidate = '$prefix-${nextNum.toString().padLeft(3, '0')}';
    }
    return candidate;
  }

  // --- Traila Logic ---

  Future<void> addTraila(String id, String name) async {
    final cleanId = id.trim().isEmpty ? getNextTrailaId() : id.trim();
    final newTraila = Traila(
      id: cleanId,
      name: name,
      registrationDate: DateTime.now(),
      status: TrailaStatus.pending,
    );
    emit(state.copyWith(trailas: [...state.trailas, newTraila]));
    await _db.into(_db.trailas).insert(TrailaData(
      id: cleanId,
      name: name,
      registrationDate: newTraila.registrationDate,
      status: newTraila.status.name,
      totalManufacturingCost: 0,
      createdAt: DateTime.now(),
    ));
    await loadData();
  }

  Future<void> updateTrailaStatus(String id, TrailaStatus status) async {
    try {
      final updatedTrailas = state.trailas.map((t) {
        if (t.id == id) return t.copyWith(status: status);
        return t;
      }).toList();
      emit(state.copyWith(trailas: updatedTrailas));
      await (_db.update(_db.trailas)..where((t) => t.id.equals(id))).write(TrailasCompanion(
        status: Value(status.name),
      ));
    } catch (e) {
      debugPrint('Database Error in updateTrailaStatus: $e');
    }
  }

  Future<void> updateTraila(String oldId, {required String newId, required String name, required DateTime registrationDate}) async {
    try {
      await _db.transaction(() async {
        // If ID changed, we need to update references in other tables
        if (oldId != newId) {
          // 1. Update Invoices
          await (_db.update(_db.invoices)..where((t) => t.trailaId.equals(oldId))).write(InvoicesCompanion(
            trailaId: Value(newId),
          ));
          // 2. Update Labour Work Entries
          await (_db.update(_db.labourWorkEntries)..where((t) => t.trailaId.equals(oldId))).write(LabourWorkEntriesCompanion(
            trailaId: Value(newId),
          ));
          // 3. Update Traila Expenses
          await (_db.update(_db.trailaExpenses)..where((t) => t.trailaId.equals(oldId))).write(TrailaExpensesCompanion(
            trailaId: Value(newId),
          ));
          // 4. Update Sales
          await (_db.update(_db.sales)..where((t) => t.trailaId.equals(oldId))).write(SalesCompanion(
            trailaId: Value(newId),
          ));
        }

        // Update the Traila itself
        await (_db.update(_db.trailas)..where((t) => t.id.equals(oldId))).write(TrailasCompanion(
          id: Value(newId),
          name: Value(name),
          registrationDate: Value(registrationDate),
        ));
      });
      await loadData();
    } catch (e) {
      debugPrint('Database Error in updateTraila: $e');
    }
  }

  Future<void> deleteTraila(String id) async {
    try {
      await _db.transaction(() async {
        // 1. Delete associated Sales (enforced by cascade in v10, but explicit for safety)
        await (_db.delete(_db.sales)..where((t) => t.trailaId.equals(id))).go();
        
        // 2. Delete associated TrailaExpenses
        await (_db.delete(_db.trailaExpenses)..where((t) => t.trailaId.equals(id))).go();
        
        // 3. Nullify TrailaId in Invoices and LabourWorkEntries (should be auto-handled, but for safety)
        await (_db.update(_db.invoices)..where((t) => t.trailaId.equals(id))).write(const InvoicesCompanion(trailaId: Value(null)));
        await (_db.update(_db.labourWorkEntries)..where((t) => t.trailaId.equals(id))).write(const LabourWorkEntriesCompanion(trailaId: Value(null)));

        // 4. Finally delete the Traila itself
        await (_db.delete(_db.trailas)..where((t) => t.id.equals(id))).go();
      });
      await loadData();
    } catch (e) {
      debugPrint('Database Error in deleteTraila: $e');
      rethrow;
    }
  }

  Future<void> addTrailaExpense(String? trailaId, TrailaExpense expense) async {
    try {
      await _db.transaction(() async {
        await _db.into(_db.trailaExpenses).insert(TrailaExpensesCompanion.insert(
          id: expense.id,
          trailaId: Value(trailaId),
          type: expense.type,
          description: expense.description,
          amount: expense.amount,
          date: expense.date,
          supplierId: Value(expense.supplierId),
          labourId: Value(expense.labourId),
          createdAt: Value(DateTime.now()),
        ));

        if (trailaId != null) {
          await _syncTrailaTotalCost(trailaId);
        }
      });
      await loadData();
    } catch (e) {
      debugPrint('Database Error in addTrailaExpense: $e');
    }
  }

  Future<void> deleteTrailaExpense(String expenseId, String trailaId) async {
    try {
      await _db.transaction(() async {
        // Find if it's linked to a Supplier/Labour record
        final expense = await (_db.select(_db.trailaExpenses)..where((t) => t.id.equals(expenseId))).getSingleOrNull();
        if (expense == null) return;

        if (expense.supplierId != null) {
          // It's a supplier purchase. We should ideally use the existing deleteSupplierPurchase logic.
          // But we don't have the purchaseId (Invoice ID) here. 
          // Heuristic: Find invoice with same owner, amount, date, and trailaId
          final inv = await (_db.select(_db.invoices)..where((t) => t.ownerId.equals(expense.supplierId!) & t.amount.equals(expense.amount) & t.trailaId.equals(trailaId))).getSingleOrNull();
          if (inv != null) {
            await deleteSupplierPurchase(inv.id);
            return; // deleteSupplierPurchase already handles syncing
          }
        } else if (expense.labourId != null) {
          // Heuristic for labour work
          final inv = await (_db.select(_db.invoices)..where((t) => t.ownerId.equals(expense.labourId!) & t.amount.equals(expense.amount) & t.trailaId.equals(trailaId))).getSingleOrNull();
          if (inv != null) {
            await deleteLabourWork(inv.id);
            return;
          }
        }

        // If not linked or heuristic failed, just delete the expense record
        await (_db.delete(_db.trailaExpenses)..where((t) => t.id.equals(expenseId))).go();
        await _syncTrailaTotalCost(trailaId);
      });
      await loadData();
    } catch (e) {
      debugPrint('Database Error in deleteTrailaExpense: $e');
    }
  }

  Future<void> updateTrailaExpense(String expenseId, String trailaId, {required double amount, required String description, required DateTime date}) async {
    try {
      await _db.transaction(() async {
        final expense = await (_db.select(_db.trailaExpenses)..where((t) => t.id.equals(expenseId))).getSingleOrNull();
        if (expense == null) return;

        if (expense.supplierId != null) {
          final inv = await (_db.select(_db.invoices)..where((t) => t.ownerId.equals(expense.supplierId!) & t.amount.equals(expense.amount) & t.trailaId.equals(trailaId))).getSingleOrNull();
          if (inv != null) {
            await updateSupplierPurchase(inv.id, amount: amount, description: description, date: date);
            return;
          }
        } else if (expense.labourId != null) {
          final inv = await (_db.select(_db.invoices)..where((t) => t.ownerId.equals(expense.labourId!) & t.amount.equals(expense.amount) & t.trailaId.equals(trailaId))).getSingleOrNull();
          if (inv != null) {
            await updateLabourWork(inv.id, cost: amount, description: description, date: date);
            return;
          }
        }

        // Fallback for manual expenses
        await (_db.update(_db.trailaExpenses)..where((t) => t.id.equals(expenseId))).write(TrailaExpensesCompanion(
          amount: Value(amount),
          description: Value(description),
          date: Value(date),
        ));
        await _syncTrailaTotalCost(trailaId);
      });
      await loadData();
    } catch (e) {
      debugPrint('Database Error in updateTrailaExpense: $e');
    }
  }

  Future<void> _syncTrailaTotalCost(String trailaId) async {
    final expenses = await (_db.select(_db.trailaExpenses)..where((t) => t.trailaId.equals(trailaId))).get();
    final totalCost = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    await (_db.update(_db.trailas)..where((t) => t.id.equals(trailaId))).write(TrailasCompanion(
      totalManufacturingCost: Value(totalCost),
    ));
  }

  // --- Supplier Logic ---

  Future<void> addSupplier(Supplier supplier) async {
    // Generate a clean sequential ID if not provided or taken
    String finalId = supplier.id.trim();
    if (finalId.isEmpty) {
      finalId = getNextSupplierId();
    } else if (state.suppliers.any((s) => s.id == finalId)) {
      finalId = '${finalId}_${getNextSupplierId()}';
    }

    final newSupplier = supplier.copyWith(id: finalId);
    
    // Optimistic UI update
    emit(state.copyWith(suppliers: [...state.suppliers, newSupplier]));

    try {
      await _db.into(_db.suppliers).insert(SuppliersCompanion.insert(
        id: finalId,
        name: newSupplier.name,
        phone: Value(newSupplier.phone),
        shopName: Value(newSupplier.shopName),
        location: Value(newSupplier.location),
        whatsappNumber: Value(newSupplier.whatsappNumber),
        address: Value(newSupplier.address),
        registrationDate: newSupplier.registrationDate,
        openingBalance: Value(newSupplier.openingBalance),
        totalAmount: Value(newSupplier.totalAmount),
        totalPaid: Value(newSupplier.totalPaid),
        remainingBalance: Value(newSupplier.remainingBalance > 0 ? newSupplier.remainingBalance : newSupplier.openingBalance), 
        advanceBalance: Value(newSupplier.advanceBalance),
        createdAt: Value(DateTime.now()),
      ), mode: InsertMode.insertOrReplace);

      // If opening balance > 0, record it as a transaction (Invoice)
      if (newSupplier.openingBalance > 0) {
        await _db.into(_db.invoices).insert(InvoicesCompanion.insert(
          id: 'SOB-$finalId-${DateTime.now().millisecondsSinceEpoch}',
          invoiceNumber: 'OPEN-BAL',
          date: newSupplier.registrationDate,
          type: InvoiceType.purchase.name,
          ownerId: finalId,
          ownerName: newSupplier.name,
          ownerType: 'supplier',
          trailaId: const Value(null),
          amount: newSupplier.openingBalance,
          previousBalance: 0.0,
          remainingBalance: newSupplier.openingBalance,
          paymentMethod: 'Credit',
          ownerNameDisplay: state.ownerName,
        ));
      }

      await loadData();
    } catch (e) {
      debugPrint('[DB] addSupplier error: $e');
    }
  }

  Future<void> updateSupplier(Supplier supplier) async {
    final oldSupplier = state.suppliers.firstWhere((s) => s.id == supplier.id);
    final openingBalanceDelta = supplier.openingBalance - oldSupplier.openingBalance;

    await (_db.update(_db.suppliers)..where((t) => t.id.equals(supplier.id))).write(SuppliersCompanion(
      name: Value(supplier.name),
      phone: Value(supplier.phone),
      shopName: Value(supplier.shopName),
      location: Value(supplier.location),
      whatsappNumber: Value(supplier.whatsappNumber),
      openingBalance: Value(supplier.openingBalance),
      // Automatically adjust the running balance if the starting baseline changes
      remainingBalance: Value(oldSupplier.remainingBalance + openingBalanceDelta),
    ));
    
    emit(state.copyWith(
      suppliers: state.suppliers.map((s) => s.id == supplier.id 
        ? supplier.copyWith(remainingBalance: s.remainingBalance + openingBalanceDelta) 
        : s).toList(),
    ));
  }

  Future<SupplierPurchase?> addSupplierPurchase(String supplierId, SupplierPurchase purchase, {double? paymentAmount, String? paymentMethod}) async {
    try {
      SupplierPurchase? finalPurchase;
      await _db.transaction(() async {
        // 1. SNAPSHOT the supplier's current balance FROM DB before any changes.
        final dbSupplier = await (_db.select(_db.suppliers)..where((t) => t.id.equals(supplierId))).getSingleOrNull();
        
        // Unified Balance: Net = Debt - Credit
        double currentNetBalance = (dbSupplier?.remainingBalance ?? 0.0) - (dbSupplier?.advanceBalance ?? 0.0);
        
        // Robust snapshot: If net is 0 but opening balance exists and no activity yet, use opening balance.
        if (currentNetBalance.abs() < 0.01 && (dbSupplier?.openingBalance ?? 0) > 0.01 && (dbSupplier?.totalAmount ?? 0) < 0.01) {
          currentNetBalance = dbSupplier!.openingBalance;
        }
        
        final previousBalanceDisplay = currentNetBalance > 0 ? currentNetBalance : 0.0;
        final newNetBalance = currentNetBalance + purchase.totalAmount;

        // 2. INSERT INVOICE immediately with snapshotted previousBalance.
        //    This guarantees the invoice always stores the correct "before" value.
        final billNumber = purchase.billNumber == 'N/A' ? _generateSupplierPurchaseInvoiceNumber() : purchase.billNumber;
        await _db.into(_db.invoices).insert(InvoicesCompanion.insert(
          id: purchase.id,
          invoiceNumber: billNumber,
          date: purchase.date,
          type: InvoiceType.purchase.name,
          ownerId: supplierId,
          ownerName: dbSupplier?.name ?? purchase.id,
          ownerType: 'supplier',
          trailaId: Value(purchase.trailaId),
          amount: purchase.totalAmount,
          previousBalance: previousBalanceDisplay, 
          remainingBalance: (newNetBalance - (paymentAmount ?? 0.0)) > 0 ? (newNetBalance - (paymentAmount ?? 0.0)) : 0.0,
          paymentMethod: (paymentAmount != null && paymentAmount > 0) ? (paymentMethod ?? 'Unknown') : 'Credit', 
          ownerNameDisplay: state.ownerName,
        ));

        // Update Traila Cost if linked
        if (purchase.trailaId != null) {
          await _syncTrailaTotalCost(purchase.trailaId!);
        }

        // 3. Insert invoice line items.
        for (var it in purchase.items) {
          await _db.into(_db.invoiceItems).insert(InvoiceItemsCompanion.insert(
            invoiceId: purchase.id,
            productName: it.name,
            quantity: it.quantity.toDouble(),
            unitPrice: it.unitPrice,
            lineTotal: it.total,
          ));
        }

        // 4. Save expense against the traila and update its manufacturing cost.
        await _db.into(_db.trailaExpenses).insert(TrailaExpensesCompanion.insert(
          id: 'PUR-${DateTime.now().millisecondsSinceEpoch}',
          trailaId: Value(purchase.trailaId),
          type: 'Material',
          description: 'Purchase from Supplier $supplierId',
          amount: purchase.totalAmount,
          date: purchase.date,
          supplierId: Value(supplierId),
          createdAt: Value(DateTime.now()),
        ));

        if (purchase.trailaId != null) {
          final traila = state.trailas.where((t) => t.id == purchase.trailaId).firstOrNull;
          if (traila != null) {
            final newTotalCost = traila.totalManufacturingCost + purchase.totalAmount;
            await (_db.update(_db.trailas)..where((t) => t.id.equals(purchase.trailaId!))).write(TrailasCompanion(
              totalManufacturingCost: Value(newTotalCost),
            ));
          }
        }

        // 5. UPDATE SUPPLIER BALANCE — resolving Debt vs Advance
        final newTotalAmount = (dbSupplier?.totalAmount ?? 0.0) + purchase.totalAmount;
        final resolvedRemaining = newNetBalance > 0 ? newNetBalance : 0.0;
        final resolvedAdvance = newNetBalance < 0 ? -newNetBalance : 0.0;

        await (_db.update(_db.suppliers)..where((t) => t.id.equals(supplierId))).write(SuppliersCompanion(
          totalAmount: Value(newTotalAmount),
          remainingBalance: Value(resolvedRemaining),
          advanceBalance: Value(resolvedAdvance),
        ));

        // 6. Handle optional upfront payment.
        if (paymentAmount != null && paymentAmount > 0 && paymentMethod != null) {
          await _addSupplierPaymentInternal(supplierId, paymentAmount, paymentMethod, purchase.date);
        }

        finalPurchase = purchase.copyWith(
          billNumber: billNumber,
          previousOutstanding: previousBalanceDisplay,
          paymentAmount: paymentAmount ?? 0.0,
          updatedBalance: (newNetBalance - (paymentAmount ?? 0.0)) > 0 ? (newNetBalance - (paymentAmount ?? 0.0)) : 0.0,
          paymentMethod: (paymentAmount != null && paymentAmount > 0) ? paymentMethod : 'Credit',
        );
      });

      await loadData();
      return finalPurchase;
    } catch (e) {
      // print('=== SUPPLIER PURCHASE SAVE ERROR ===');
// print(e);
      rethrow;
    }
  }

  Future<Payment?> addSupplierPayment(String supplierId, Payment payment) async {
    final result = await _addSupplierPaymentInternal(supplierId, payment.amount, payment.method, payment.date, splitDetails: payment.splitDetails);
    await loadData();
    return result;
  }

  Future<Payment> _addSupplierPaymentInternal(String supplierId, double amount, String method, DateTime date, {List<SplitDetail>? splitDetails}) async {
    // 1. FRESH DB FETCH to avoid stale state in transactions
    final dbSupplier = await (_db.select(_db.suppliers)..where((t) => t.id.equals(supplierId))).getSingleOrNull();
    final name = dbSupplier?.name ?? 'Unknown';

    // Unified Balance Logic: Net = Debt - Credit
    final double currentRemaining = dbSupplier?.remainingBalance ?? 0.0;
    final double currentAdvance = dbSupplier?.advanceBalance ?? 0.0;
    final double currentNet = currentRemaining - currentAdvance;
    
    final double newNet = currentNet - amount;
    final double resolvedRemaining = newNet > 0 ? newNet : 0.0;
    final double resolvedAdvance = newNet < 0 ? -newNet : 0.0;

    final newTotalPaid = (dbSupplier?.totalPaid ?? 0.0) + amount;

    final finalPayment = Payment(
      id: 'PAY-${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      date: date,
      method: method,
      receiptNumber: _generateSupplierPaymentInvoiceNumber(),
      previousBalance: currentRemaining, // Display current debt as previous
      updatedBalance: resolvedRemaining,  // Display new debt as updated
      splitDetails: splitDetails,
    );

    // 2. Update Supplier Table
    await (_db.update(_db.suppliers)..where((t) => t.id.equals(supplierId))).write(SuppliersCompanion(
      totalPaid: Value(newTotalPaid),
      remainingBalance: Value(resolvedRemaining),
      advanceBalance: Value(resolvedAdvance),
    ));

    // 3. Save Payment Record
    await _db.into(_db.payments).insert(PaymentsCompanion.insert(
      id: finalPayment.id,
      amount: finalPayment.amount,
      date: finalPayment.date,
      method: finalPayment.method,
      receiptNumber: Value(finalPayment.receiptNumber),
      ownerId: supplierId,
      ownerType: 'supplier',
      previousBalance: Value(finalPayment.previousBalance),
      updatedBalance: Value(finalPayment.updatedBalance),
      createdAt: Value(DateTime.now()),
    ));

    // 4. Handle Split Details
    if (finalPayment.splitDetails != null) {
      for (var split in finalPayment.splitDetails!) {
        await _db.into(_db.splitDetails).insert(SplitDetailsCompanion.insert(
          paymentId: finalPayment.id,
          method: split.method,
          amount: split.amount,
        ));
      }
    }

    // [NOTE] Cash Flow & Accounting Detached (as per user request)
    // Payments to suppliers no longer deduct from account balances automatically.

    // 6. Record Invoice for Ledger Visibility
    await _db.into(_db.invoices).insert(InvoicesCompanion.insert(
      id: finalPayment.id,
      invoiceNumber: finalPayment.receiptNumber!,
      date: date,
      type: InvoiceType.payment.name,
      ownerId: supplierId,
      ownerName: name,
      ownerType: 'supplier',
      trailaId: const Value(null),
      amount: amount,
      previousBalance: currentRemaining,
      remainingBalance: resolvedRemaining,
      paymentMethod: method,
      ownerNameDisplay: state.ownerName,
    ));

    return finalPayment;
  }

  // --- Labour Logic ---

  Future<WorkEntry?> addLabourWork(String labourId, WorkEntry work, {double? paymentAmount, String? paymentMethod}) async {
    try {
      WorkEntry? finalWork;
      await _db.transaction(() async {
        final dbLabour = await (_db.select(_db.labours)..where((t) => t.id.equals(labourId))).getSingleOrNull();
        final traila = work.trailaId != null ? state.trailas.where((t) => t.id == work.trailaId).firstOrNull : null;
        final entryNo = work.entryNumber == 'N/A' ? _generateLabourWorkInvoiceNumber() : work.entryNumber;
        
        // Robust snapshot: If remaining balance is 0 but opening balance exists and no work yet, use opening balance.
        double previousBalance = dbLabour?.remainingBalance ?? 0.0;
        if (previousBalance.abs() < 0.01 && (dbLabour?.totalPayable ?? 0) < 0.01) {
          previousBalance = dbLabour?.openingBalance ?? 0.0;
        }

        final newTotalPayable = (dbLabour?.totalPayable ?? 0.0) + work.cost;
        final newRemaining = previousBalance + work.cost;

        final updatedWork = work.copyWith(entryNumber: entryNo, previousOutstanding: previousBalance);
        
        // Update Labour
        await (_db.update(_db.labours)..where((t) => t.id.equals(labourId))).write(LaboursCompanion(
          totalPayable: Value(newTotalPayable),
          remainingBalance: Value(newRemaining),
        ));

        // Save Work Entry
        await _db.into(_db.labourWorkEntries).insert(LabourWorkEntriesCompanion.insert(
          id: updatedWork.id,
          labourId: labourId,
          trailaId: Value(updatedWork.trailaId),
          entryNumber: updatedWork.entryNumber,
          description: updatedWork.description,
          cost: updatedWork.cost,
          date: updatedWork.date,
          previousOutstanding: Value(updatedWork.previousOutstanding),
          createdAt: Value(DateTime.now()),
        ));

        // Save Expense to Traila (if selection is not empty)
        if (updatedWork.trailaId != null) {
          await _db.into(_db.trailaExpenses).insert(TrailaExpensesCompanion.insert(
            id: 'LWRK-${DateTime.now().millisecondsSinceEpoch}',
            trailaId: Value(updatedWork.trailaId),
            type: 'Labour',
            description: 'Labour Work: ${updatedWork.description} (${dbLabour?.name ?? labourId})',
            amount: updatedWork.cost,
            date: updatedWork.date,
            labourId: Value(labourId),
            createdAt: Value(DateTime.now()),
          ));

          if (traila != null) {
            final newTotalCost = traila.totalManufacturingCost + updatedWork.cost;
            await (_db.update(_db.trailas)..where((t) => t.id.equals(traila.id))).write(TrailasCompanion(
              totalManufacturingCost: Value(newTotalCost),
            ));
          }
        }

        // Save Invoice (InvoiceData)
        await _db.into(_db.invoices).insert(InvoicesCompanion.insert(
          id: updatedWork.id,
          invoiceNumber: updatedWork.entryNumber,
          date: updatedWork.date,
          type: InvoiceType.labourWork.name,
          ownerId: labourId,
          ownerName: dbLabour?.name ?? labourId,
          ownerType: 'labour',
          trailaId: Value(updatedWork.trailaId),
          amount: updatedWork.cost,
          previousBalance: previousBalance,
          remainingBalance: newRemaining - (paymentAmount ?? 0.0), // ✅ Final balance after upfront payment
          paymentMethod: 'Credit',
          ownerNameDisplay: state.ownerName,
        ));

        // Handle upfront payment
        if (paymentAmount != null && paymentAmount > 0 && paymentMethod != null) {
          final p = Payment(
            id: 'LPAY-${DateTime.now().millisecondsSinceEpoch}',
            amount: paymentAmount,
            date: updatedWork.date,
            method: paymentMethod,
            previousBalance: newRemaining,
            updatedBalance: newRemaining - paymentAmount,
          );
          await _addLabourPaymentInternal(labourId, p);
        }

        finalWork = updatedWork.copyWith(
          previousOutstanding: previousBalance,
          paymentAmount: paymentAmount ?? 0.0,
          updatedBalance: newRemaining - (paymentAmount ?? 0.0),
        );
      });

      await loadData();
      return finalWork;
    } catch (e) {
      // print('=== LABOUR WORK SAVE ERROR ===');
// print(e);
      rethrow;
    }
  }

  Future<Payment?> addLabourPayment(String labourId, Payment payment) async {
    final result = await _addLabourPaymentInternal(labourId, payment);
    await loadData();
    return result;
  }

  Future<Payment?> _addLabourPaymentInternal(String labourId, Payment payment) async {
    // 1. FRESH DB FETCH to avoid stale state in transactions
    final dbLabour = await (_db.select(_db.labours)..where((t) => t.id.equals(labourId))).getSingleOrNull();
    final name = dbLabour?.name ?? 'Unknown';

    final previousRemaining = dbLabour?.remainingBalance ?? 0.0;
    final newTotalPaid = (dbLabour?.totalPaid ?? 0.0) + payment.amount;
    final newRemaining = previousRemaining - payment.amount;
    
    final finalPayment = payment.copyWith(
      receiptNumber: payment.receiptNumber ?? _generateLabourPaymentInvoiceNumber(),
      previousBalance: previousRemaining,
      updatedBalance: newRemaining,
    );

    // 2. Update Labour Table
    await (_db.update(_db.labours)..where((t) => t.id.equals(labourId))).write(LaboursCompanion(
      totalPaid: Value(newTotalPaid),
      remainingBalance: Value(newRemaining),
    ));

    // Save Payment record
    await _db.into(_db.payments).insert(PaymentsCompanion.insert(
      id: finalPayment.id,
      amount: finalPayment.amount,
      date: finalPayment.date,
      method: finalPayment.method,
      receiptNumber: Value(finalPayment.receiptNumber),
      ownerId: labourId,
      ownerType: 'labour',
      previousBalance: Value(finalPayment.previousBalance),
      updatedBalance: Value(finalPayment.updatedBalance),
      createdAt: Value(DateTime.now()),
    ));

    if (finalPayment.splitDetails != null) {
      for (var split in finalPayment.splitDetails!) {
        await _db.into(_db.splitDetails).insert(SplitDetailsCompanion.insert(
          paymentId: finalPayment.id,
          method: split.method,
          amount: split.amount,
        ));
      }
    }

    // [NOTE] Cash Flow & Accounting Detached (as per user request)
    // Payments to labours no longer deduct from account balances automatically.

    // Invoice (General record for history/ledger)
    await _db.into(_db.invoices).insert(InvoicesCompanion.insert(
      id: finalPayment.id,
      invoiceNumber: finalPayment.receiptNumber ?? finalPayment.id,
      date: finalPayment.date,
      type: InvoiceType.payment.name,
      ownerId: labourId,
      ownerName: name,
      ownerType: 'labour',
      trailaId: const Value(null),
      amount: finalPayment.amount,
      previousBalance: finalPayment.previousBalance ?? previousRemaining,
      remainingBalance: finalPayment.updatedBalance ?? newRemaining,
      paymentMethod: finalPayment.method,
      ownerNameDisplay: state.ownerName,
    ));

    return finalPayment;
  }

  Future<void> addLabour(Labour labour) async {
    // Generate a clean sequential ID if not provided or taken
    String finalId = labour.id.trim();
    if (finalId.isEmpty) {
      finalId = getNextLabourId();
    } else if (state.labours.any((l) => l.id == finalId)) {
      finalId = '${finalId}_${getNextLabourId()}';
    }

    final newLabour = labour.copyWith(
      id: finalId,
      totalPayable: labour.openingBalance,
      remainingBalance: labour.openingBalance,
    );
    
    try {
      await _db.into(_db.labours).insert(LaboursCompanion.insert(
        id: finalId,
        name: newLabour.name,
        phone: Value(newLabour.phone),
        whatsappNumber: Value(newLabour.whatsappNumber),
        address: Value(newLabour.address),
        registrationDate: newLabour.registrationDate,
        openingBalance: Value(newLabour.openingBalance),
        totalPayable: Value(newLabour.openingBalance), 
        totalPaid: Value(newLabour.totalPaid),
        remainingBalance: Value(newLabour.openingBalance), 
      ), mode: InsertMode.insertOrReplace);

      // If opening balance > 0, record it as a transaction (Invoice)
      if (newLabour.openingBalance > 0) {
        await _db.into(_db.invoices).insert(InvoicesCompanion.insert(
          id: 'LOB-$finalId-${DateTime.now().millisecondsSinceEpoch}',
          invoiceNumber: 'OPEN-BAL',
          date: newLabour.registrationDate,
          type: InvoiceType.labourWork.name,
          ownerId: finalId,
          ownerName: newLabour.name,
          ownerType: 'labour',
          trailaId: const Value(null),
          amount: newLabour.openingBalance,
          previousBalance: 0.0,
          remainingBalance: newLabour.openingBalance,
          paymentMethod: 'Credit',
          ownerNameDisplay: state.ownerName,
        ));
      }

      await loadData();
    } catch (e) {
      debugPrint('[DB] addLabour error: $e');
    }
  }

  Future<void> updateLabour(Labour labour) async {
    await _db.transaction(() async {
      // 1. Update the Labour record (including openingBalance)
      await (_db.update(_db.labours)..where((t) => t.id.equals(labour.id))).write(LaboursCompanion(
        name: Value(labour.name),
        phone: Value(labour.phone),
        whatsappNumber: Value(labour.whatsappNumber),
        address: Value(labour.address),
        openingBalance: Value(labour.openingBalance),
      ));

      // 2. Find and update the OPEN-BAL invoice if it exists
      final existingOpenBal = await (_db.select(_db.invoices)
        ..where((t) => t.ownerId.equals(labour.id) & t.invoiceNumber.equals('OPEN-BAL')))
        .getSingleOrNull();

      if (existingOpenBal != null) {
        await (_db.update(_db.invoices)..where((t) => t.id.equals(existingOpenBal.id))).write(InvoicesCompanion(
          amount: Value(labour.openingBalance),
          remainingBalance: Value(labour.openingBalance),
        ));
      } else if (labour.openingBalance > 0) {
        // If it was 0 before and now has a value, create it
        await _db.into(_db.invoices).insert(InvoicesCompanion.insert(
          id: 'LOB-${labour.id}-${DateTime.now().millisecondsSinceEpoch}',
          invoiceNumber: 'OPEN-BAL',
          date: labour.registrationDate,
          type: InvoiceType.labourWork.name,
          ownerId: labour.id,
          ownerName: labour.name,
          ownerType: 'labour',
          trailaId: const Value(null),
          amount: labour.openingBalance,
          previousBalance: 0.0,
          remainingBalance: labour.openingBalance,
          paymentMethod: 'Credit',
          ownerNameDisplay: state.ownerName,
        ));
      }

      // 3. Sync balances to recalculate remaining balance correctly
      await _syncLabourBalances(labour.id);
    });

    await loadData();
  }

  // --- Sales Logic --- (DECOUPLED FROM CASH FLOW)

  Future<String?> sellTraila({
    required String trailaId,
    required Buyer buyer,
    required double salePrice,
    required DateTime saleDate,
    required double initialPayment,
    required String paymentMethod,
  }) async {
    try {
      final traila = state.trailas.firstWhere((t) => t.id == trailaId);
      // Ensure buyer has a clean sequential ID if not provided or legacy format
      String buyerId = buyer.id.trim();
      if (buyerId.isEmpty || buyerId.startsWith('B-')) {
        buyerId = getNextBuyerId();
      }
      final cleanBuyer = buyer.copyWith(id: buyerId);

      final saleId = 'S-${DateTime.now().millisecondsSinceEpoch}';
      final receiptNumber = _generateSaleReceiptNumber();
      
      final profit = salePrice - traila.totalManufacturingCost;
      final remaining = salePrice - initialPayment;

      final sale = Sale(
        id: saleId,
        trailaId: trailaId,
        buyerId: cleanBuyer.id,
        salePrice: salePrice,
        manufacturingCost: traila.totalManufacturingCost,
        profit: profit,
        saleDate: saleDate,
        totalPaid: initialPayment,
        remainingBalance: remaining,
        status: initialPayment >= salePrice ? SaleStatus.paid : (initialPayment > 0 ? SaleStatus.partial : SaleStatus.pending),
        receiptNumber: receiptNumber,
      );

      await _db.transaction(() async {
        // 1. Insert Buyer (insertOrReplace ensures existing customers aren't errored)
        await _db.into(_db.buyers).insert(BuyersCompanion.insert(
          id: cleanBuyer.id,
          name: cleanBuyer.name,
          phone: Value(cleanBuyer.phone),
          cnic: Value(cleanBuyer.cnic),
          address: Value(cleanBuyer.address),
          whatsappNumber: Value(cleanBuyer.whatsappNumber),
        ), mode: InsertMode.insertOrReplace);

        // calculate total outstanding balance for this buyer from all other sales
        final previousSales = state.sales.where((s) => s.buyerId == cleanBuyer.id);
        final double buyerPreviousBalance = previousSales.fold(0.0, (sum, s) => sum + s.remainingBalance);

        // 2. Insert Sale
        await _db.into(_db.sales).insert(SalesCompanion.insert(
          id: sale.id,
          trailaId: sale.trailaId,
          buyerId: cleanBuyer.id, 
          salePrice: sale.salePrice,
          manufacturingCost: Value(sale.manufacturingCost),
          profit: Value(sale.profit),
          saleDate: sale.saleDate,
          paidAmount: sale.totalPaid,
          remainingBalance: sale.remainingBalance,
          globalPreviousBalance: Value(buyerPreviousBalance), // ✅ Fix type mismatch
          receiptNumber: sale.receiptNumber ?? '', // ✅ Fix nullable String mismatch
          // createdAt: Value(DateTime.now()), // Removed as per instruction 3
        ));

        // 3. Update Traila Status
        await (_db.update(_db.trailas)..where((t) => t.id.equals(trailaId))).write(TrailasCompanion(
          status: const Value('sold'),
          salePrice: Value(salePrice),
        ));

        // 4. Invoices
        await _db.into(_db.invoices).insert(InvoicesCompanion.insert(
          id: saleId,
          invoiceNumber: receiptNumber,
          date: saleDate,
          type: InvoiceType.sale.name,
          ownerId: buyer.id,
          ownerName: buyer.name,
          ownerType: 'sale',
          trailaId: Value(trailaId),
          amount: salePrice,
          previousBalance: buyerPreviousBalance, // ✅ Capture buyer's existing debt
          remainingBalance: buyerPreviousBalance + remaining, // ✅ Global balance after this sale
          paymentMethod: paymentMethod,
          ownerNameDisplay: state.ownerName,
          // createdAt: Value(DateTime.now()), 
        ));

        // 5. Downpayment Transaction
        if (initialPayment > 0) {
          final key = _getAccountKey(paymentMethod);
          final account = state.accounts[key];
          if (account != null) {
            final newBalance = account.balance + initialPayment;
            await _db.into(_db.transactions).insert(TransactionsCompanion.insert( // Changed to TransactionsCompanion.insert
              id: 'TXN-$saleId', // Changed to match the original logic for txnId
              accountName: paymentMethod,
              type: TransactionType.add.name, // Changed to add.name for incoming payment
              amount: initialPayment,
              person: buyer.name,
              description: 'Downpayment for Sale $receiptNumber', // Changed description to match original
              date: saleDate,
              category: 'Sale Payment', // Changed category to match original
              // createdAt: Value(DateTime.now()), // Removed as per instruction 3
            ));

            await (_db.update(_db.accounts)..where((t) => t.name.equals(paymentMethod))).write(AccountsCompanion(
              balance: Value(newBalance),
            ));
          }

          // 6. Record Downpayment in Payments Table for history tracking
          final double grossTotal = salePrice + buyerPreviousBalance;
          await _db.into(_db.payments).insert(PaymentsCompanion.insert(
            id: 'DP-$saleId',
            amount: initialPayment,
            date: saleDate,
            method: paymentMethod,
            receiptNumber: Value(receiptNumber),
            ownerId: saleId,
            ownerType: 'sale',
            previousBalance: Value(grossTotal),
            updatedBalance: Value(grossTotal - initialPayment),
            createdAt: Value(DateTime.now()),
          ));
        }
      });

      await loadData();
      return saleId;
    } catch (e) {
      debugPrint('=== SALE SAVE ERROR ===');
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> addSalePayment(String saleId, Payment payment) async {
    try {
      await _db.transaction(() async {
        final saleObj = state.sales.firstWhere((s) => s.id == saleId);
        final buyer = state.buyers.firstWhere((b) => b.id == saleObj.buyerId);
        
        final currentPaid = saleObj.totalPaid;
        final currentRemaining = saleObj.remainingBalance;
        final salePrice = saleObj.salePrice;
        
        final newPaid = currentPaid + payment.amount;
        final newRemaining = salePrice - newPaid;

        // 1. Update Sale
        await (_db.update(_db.sales)..where((t) => t.id.equals(saleId))).write(SalesCompanion(
          paidAmount: Value(newPaid),
          remainingBalance: Value(newRemaining > 0 ? newRemaining : 0.0),
        ));

        // 2. Add to Payments table (MISSING IN ORIGINAL)
        await _db.into(_db.payments).insert(PaymentsCompanion.insert(
          id: payment.id,
          amount: payment.amount,
          date: payment.date,
          method: payment.method,
          receiptNumber: Value(payment.receiptNumber ?? 'SP-${DateTime.now().millisecondsSinceEpoch}'),
          ownerId: saleId,
          ownerType: 'sale',
          previousBalance: Value(currentRemaining),
          updatedBalance: Value(newRemaining),
          createdAt: Value(DateTime.now()),
        ));

        // 3. Add Transaction
        final key = _getAccountKey(payment.method);
        final account = state.accounts[key];
        if (account != null) {
          final newBalance = account.balance + payment.amount;
          await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
            id: 'TXN-${payment.id}',
            accountName: payment.method,
            type: TransactionType.add.name,
            amount: payment.amount,
            person: buyer.name,
            description: 'Payment for Sale ${saleObj.receiptNumber}',
            date: payment.date,
            category: 'Sale Payment',
            createdAt: Value(DateTime.now()),
          ));

          await (_db.update(_db.accounts)..where((t) => t.name.equals(payment.method))).write(AccountsCompanion(
            balance: Value(newBalance),
          ));
        }

        // 4. Invoice (Ledger Record)
        await _db.into(_db.invoices).insert(InvoicesCompanion.insert(
          id: 'INV-${payment.id}',
          invoiceNumber: payment.receiptNumber ?? 'SP-${DateTime.now().millisecondsSinceEpoch}',
          date: payment.date,
          type: InvoiceType.salePayment.name,
          ownerId: buyer.id,
          ownerName: buyer.name,
          ownerType: 'sale',
          trailaId: Value(saleObj.trailaId),
          amount: payment.amount,
          previousBalance: currentRemaining,
          remainingBalance: newRemaining,
          paymentMethod: payment.method,
          ownerNameDisplay: state.ownerName,
          createdAt: Value(DateTime.now()),
        ));
      });

      await loadData();
    } catch (e) {
      debugPrint('=== SALE PAYMENT SAVE ERROR ===');
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateSalePayment(String saleId, Payment oldPayment, Payment newPayment) async {
    try {
      await _db.transaction(() async {
        // 1. Update Payment Record
        await (_db.update(_db.payments)..where((t) => t.id.equals(oldPayment.id))).write(PaymentsCompanion(
          amount: Value(newPayment.amount),
          method: Value(newPayment.method),
          date: Value(newPayment.date),
        ));

        // 2. Update Transaction (Handle Account Balance Changes)
        final oldKey = _getAccountKey(oldPayment.method);
        final newKey = _getAccountKey(newPayment.method);
        
        if (oldKey == newKey) {
          // Same account, just adjust balance
          final account = state.accounts[oldKey];
          if (account != null) {
            final balanceAdjustment = newPayment.amount - oldPayment.amount;
            await (_db.update(_db.accounts)..where((t) => t.id.equals(oldKey))).write(AccountsCompanion(
              balance: Value(account.balance + balanceAdjustment),
            ));
          }
        } else {
          // Account changed: revert old, apply new
          final oldAccount = state.accounts[oldKey];
          if (oldAccount != null) {
            await (_db.update(_db.accounts)..where((t) => t.id.equals(oldKey))).write(AccountsCompanion(
              balance: Value(oldAccount.balance - oldPayment.amount),
            ));
          }
          final newAccount = state.accounts[newKey];
          if (newAccount != null) {
            await (_db.update(_db.accounts)..where((t) => t.id.equals(newKey))).write(AccountsCompanion(
              balance: Value(newAccount.balance + newPayment.amount),
            ));
          }
        }

        await (_db.update(_db.transactions)..where((t) => t.id.equals('TXN-${oldPayment.id}'))).write(TransactionsCompanion(
          amount: Value(newPayment.amount),
          accountName: Value(newPayment.method),
          date: Value(newPayment.date),
        ));

        // 3. Update Invoice
        await (_db.update(_db.invoices)..where((t) => t.id.equals('INV-${oldPayment.id}'))).write(InvoicesCompanion(
          amount: Value(newPayment.amount),
          paymentMethod: Value(newPayment.method),
          date: Value(newPayment.date),
        ));

        // 4. Recalculate Sale Balances
        await _syncSaleBalances(saleId);
      });
      await loadData();
    } catch (e) {
      debugPrint('Error updating sale payment: $e');
      rethrow;
    }
  }

  Future<void> deleteSalePayment(String saleId, Payment payment) async {
    try {
      await _db.transaction(() async {
        // 1. Revert Account Balance
        final key = _getAccountKey(payment.method);
        final account = state.accounts[key];
        if (account != null) {
          await (_db.update(_db.accounts)..where((t) => t.id.equals(key))).write(AccountsCompanion(
            balance: Value(account.balance - payment.amount),
          ));
        }

        // 2. Delete payment, transaction, and invoice
        await (_db.delete(_db.payments)..where((t) => t.id.equals(payment.id))).go();
        await (_db.delete(_db.transactions)..where((t) => t.id.equals('TXN-${payment.id}'))).go();
        await (_db.delete(_db.invoices)..where((t) => t.id.equals('INV-${payment.id}'))).go();

        // 3. Recalculate Sale Balances
        await _syncSaleBalances(saleId);
      });
      await loadData();
    } catch (e) {
      debugPrint('Error deleting sale payment: $e');
      rethrow;
    }
  }

  Future<void> _syncSaleBalances(String saleId) async {
    final allPayments = await (_db.select(_db.payments)..where((t) => t.ownerId.equals(saleId) & t.ownerType.equals('sale'))).get();
    final sale = await (_db.select(_db.sales)..where((t) => t.id.equals(saleId))).getSingle();
    
    final totalPaid = allPayments.fold<double>(0, (sum, p) => sum + p.amount);
    final newRemaining = sale.salePrice - totalPaid;

    await (_db.update(_db.sales)..where((t) => t.id.equals(saleId))).write(SalesCompanion(
      paidAmount: Value(totalPaid),
      remainingBalance: Value(newRemaining > 0 ? newRemaining : 0.0),
    ));
  }

  String _generateSaleReceiptNumber() {
    final count = state.sales.length + 1;
    return 'SALE-${count.toString().padLeft(5, '0')}';
  }

  String _generateSupplierPurchaseInvoiceNumber() {
    final count = state.suppliers.fold<int>(0, (sum, s) => sum + s.purchases.length) + 1;
    return 'INV-SP-${count.toString().padLeft(4, '0')}';
  }

  String _generateLabourWorkInvoiceNumber() {
    final count = state.labours.fold<int>(0, (sum, l) => sum + l.workEntries.length) + 1;
    return 'INV-LW-${count.toString().padLeft(4, '0')}';
  }

  String _generateSupplierPaymentInvoiceNumber() {
    final count = state.suppliers.fold<int>(0, (sum, s) => sum + s.payments.length) + 1;
    return 'INV-S-PAY-${count.toString().padLeft(5, '0')}';
  }

  String _generateLabourPaymentInvoiceNumber() {
    final count = state.labours.fold<int>(0, (sum, l) => sum + l.payments.length) + 1;
    return 'INV-L-PAY-${count.toString().padLeft(5, '0')}';
  }

  // --- Khata Logic ---

  Future<void> addKhata(Khata khata) async {
    try {
      await _db.transaction(() async {
        // 1. Check if person already exists
        final existingKhata = state.khatas.firstWhere(
          (k) => k.personName.toLowerCase() == khata.personName.toLowerCase(),
          orElse: () => Khata(
            id: '', 
            personName: '', 
            totalAmount: 0, 
            paidAmount: 0, 
            remainingBalance: khata.openingBalance, // ✅ Initialize new person with opening balance
            date: DateTime.now(), 
            items: const []
          ),
        );

        final String finalId = existingKhata.id.isNotEmpty ? existingKhata.id : khata.id;
        final double finalOpeningBalance = existingKhata.openingBalance > 0 ? existingKhata.openingBalance : khata.openingBalance;
        final double finalTotalAmount = existingKhata.totalAmount + khata.totalAmount;
        final double finalPaidAmount = existingKhata.paidAmount + khata.paidAmount;
        final double finalRemainingBalance = (finalOpeningBalance + finalTotalAmount) - finalPaidAmount;

        // 2. Save/Update Khata Header
        final khataCompanion = KhatasCompanion.insert(
          id: finalId,
          personName: khata.personName,
          openingBalance: Value(finalOpeningBalance),
          totalAmount: Value(finalTotalAmount),
          paidAmount: Value(finalPaidAmount),
          remainingBalance: Value(finalRemainingBalance),
          date: khata.date,
          createdAt: Value(DateTime.now()),
        );

        // 3. Save Khata Transactions and Update Account Ledgers
        final List<KhataItemsCompanion> itemCompanions = [];
        final Map<String, double> runningAccountBalances = {};
        
        for (var it in khata.items) {
          itemCompanions.add(KhataItemsCompanion.insert(
            khataId: finalId,
            itemName: Value(it.description ?? '-'),
            price: it.amount,
            type: Value(it.type.name),
            paymentMethod: Value(it.paymentMethod),
            date: Value(it.date),
            createdAt: Value(DateTime.now()),
          ));

          if (it.syncToAccount && it.paymentMethod != null) {
            final key = _getAccountKey(it.paymentMethod!);
            final account = state.accounts[key];
            
            if (account != null) {
              if (!runningAccountBalances.containsKey(account.name)) {
                runningAccountBalances[account.name] = account.balance;
              }

              final isOut = it.type == KhataTransactionType.cashOut;
              final balanceChange = isOut ? -it.amount : it.amount;
              final newBalance = runningAccountBalances[account.name]! + balanceChange;
              runningAccountBalances[account.name] = newBalance;
              
              final syncTxnId = 'TXN-KH-SYNC-${DateTime.now().millisecondsSinceEpoch}-${it.id}';
              await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
                id: syncTxnId,
                accountName: account.name,
                type: isOut ? TransactionType.take.name : TransactionType.add.name,
                amount: it.amount,
                person: khata.personName,
                description: '${isOut ? 'Cash Out to' : 'Cash In from'} ${khata.personName}: ${it.description ?? ''}',
                date: it.date,
                category: 'Khata Sync',
              ));

              await (_db.update(_db.accounts)..where((t) => t.name.equals(account.name))).write(AccountsCompanion(
                balance: Value(newBalance),
              ));
            }
          }
        }

        await _db.saveKhata(khataCompanion, itemCompanions);
      });

      await loadData();
    } catch (e) {
      debugPrint('=== KHATA SAVE ERROR ===');
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updateBuyer(Buyer buyer) async {
    try {
      await (_db.update(_db.buyers)..where((t) => t.id.equals(buyer.id))).write(BuyersCompanion(
        name: Value(buyer.name),
        phone: Value(buyer.phone),
        cnic: Value(buyer.cnic),
        address: Value(buyer.address),
      ));
      await loadData();
    } catch (e) {
      debugPrint('Error updating buyer: $e');
      rethrow;
    }
  }

  Future<void> updateKhataPerson(String oldName, String newName) async {
    try {
      // Khata personName is stored across all records. Update all records for this person.
      await (_db.update(_db.khatas)..where((t) => t.personName.equals(oldName))).write(KhatasCompanion(
        personName: Value(newName),
      ));
      await loadData();
    } catch (e) {
      debugPrint('Error updating khata person: $e');
      rethrow;
    }
  }

  Future<void> deleteSupplier(String id) async {
    try {
      await _db.transaction(() async {
        // 1. Delete associated Invoices (and cascade InvoiceItems)
        await (_db.delete(_db.invoices)..where((t) => t.ownerId.equals(id) & t.ownerType.equals('supplier'))).go();
        // 2. Delete associated Payments (and cascade SplitDetails)
        await (_db.delete(_db.payments)..where((t) => t.ownerId.equals(id) & t.ownerType.equals('supplier'))).go();
        // 3. Delete Traila Expenses
        await (_db.delete(_db.trailaExpenses)..where((t) => t.supplierId.equals(id))).go();
        // 4. Delete the Supplier
        await (_db.delete(_db.suppliers)..where((t) => t.id.equals(id))).go();
      });
      await loadData();
    } catch (e) {
      debugPrint('Error deleting supplier: $e');
      rethrow;
    }
  }

  Future<void> deleteLabour(String id) async {
    try {
      await _db.transaction(() async {
        // 1. Delete associated Invoices
        await (_db.delete(_db.invoices)..where((t) => t.ownerId.equals(id) & t.ownerType.equals('labour'))).go();
        // 2. Delete associated Payments
        await (_db.delete(_db.payments)..where((t) => t.ownerId.equals(id) & t.ownerType.equals('labour'))).go();
        // 3. Delete Work Entries (Cascade usually handles this if FK exists, but doing manually for safety)
        await (_db.delete(_db.labourWorkEntries)..where((t) => t.labourId.equals(id))).go();
        // 4. Delete Traila Expenses
        await (_db.delete(_db.trailaExpenses)..where((t) => t.labourId.equals(id))).go();
        // 5. Delete the Labourer
        await (_db.delete(_db.labours)..where((t) => t.id.equals(id))).go();
      });
      await loadData();
    } catch (e) {
      debugPrint('Error deleting labour: $e');
      rethrow;
    }
  }

  Future<void> deleteBuyer(String id) async {
    try {
      await _db.transaction(() async {
        // 1. Delete associated sales
        await (_db.delete(_db.sales)..where((t) => t.buyerId.equals(id))).go();
        // 2. Delete the buyer
        await (_db.delete(_db.buyers)..where((t) => t.id.equals(id))).go();
      });
      await loadData();
    } catch (e) {
      debugPrint('Error deleting buyer: $e');
      rethrow;
    }
  }

  Future<void> deleteKhata(String personName) async {
    try {
      await _db.transaction(() async {
        // Khata personName is the link. Find all khatas for this name.
        final personKhatas = await (_db.select(_db.khatas)..where((t) => t.personName.equals(personName))).get();
        for (var k in personKhatas) {
          // Delete items for each khata record
          await (_db.delete(_db.khataItems)..where((t) => t.khataId.equals(k.id))).go();
          // Delete the khata record itself
          await (_db.delete(_db.khatas)..where((t) => t.id.equals(k.id))).go();
        }
      });
      await loadData();
    } catch (e) {
      debugPrint('Error deleting khata: $e');
      rethrow;
    }
  }

  Future<void> deleteKhataTransaction(String itemId) async {
    try {
      await (_db.delete(_db.khataItems)..where((t) => t.id.equals(int.parse(itemId)))).go();
      await loadData();
    } catch (e) {
      debugPrint('Error deleting khata transaction: $e');
    }
  }

  Future<void> updateKhataTransaction(String itemId, {required double amount, required String description}) async {
    try {
      await (_db.update(_db.khataItems)..where((t) => t.id.equals(int.parse(itemId)))).write(KhataItemsCompanion(
        price: Value(amount),
        itemName: Value(description),
      ));
      await loadData();
    } catch (e) {
      debugPrint('Error updating khata transaction: $e');
    }
  }

  // --- Labour Record Management ---

  Future<void> deleteLabourWork(String workId) async {
    try {
      await _db.transaction(() async {
        final invoice = await (_db.select(_db.invoices)..where((t) => t.id.equals(workId))).getSingleOrNull();
        if (invoice == null) return;

        // 1. Delete Invoice & Items
        await (_db.delete(_db.invoices)..where((t) => t.id.equals(workId))).go();
        await (_db.delete(_db.invoiceItems)..where((t) => t.invoiceId.equals(workId))).go();

        // 2. Delete linked Traila Expense
        await (_db.delete(_db.trailaExpenses)..where((t) => t.labourId.equals(invoice.ownerId) & t.amount.equals(invoice.amount))).go();

        // 3. Recalculate Labour summary (totalPayable, remainingBalance)
        await _syncLabourBalances(invoice.ownerId);
      });
      await loadData();
    } catch (e) {
      debugPrint('Error deleting labour work: $e');
    }
  }

  Future<void> deleteLabourPayment(String paymentId) async {
    try {
      await _db.transaction(() async {
        final payment = await (_db.select(_db.payments)..where((t) => t.id.equals(paymentId))).getSingleOrNull();
        if (payment == null) return;

        // 1. Delete Payment record & Splits
        await (_db.delete(_db.payments)..where((t) => t.id.equals(paymentId))).go();
        await (_db.delete(_db.splitDetails)..where((t) => t.paymentId.equals(paymentId))).go();
        
        // 2. Delete associated Invoice (for ledger visibility)
        await (_db.delete(_db.invoices)..where((t) => t.id.equals(paymentId))).go();

        // 3. Recalculate Labour summary
        await _syncLabourBalances(payment.ownerId);
      });
      await loadData();
    } catch (e) {
      debugPrint('Error deleting labour payment: $e');
    }
  }

  Future<void> updateLabourWork(String workId, {required double cost, required String description, required DateTime date}) async {
    try {
      await _db.transaction(() async {
        final invoice = await (_db.select(_db.invoices)..where((t) => t.id.equals(workId))).getSingleOrNull();
        if (invoice == null) return;

        // 1. Update Invoice & Items
        await (_db.update(_db.invoices)..where((t) => t.id.equals(workId))).write(InvoicesCompanion(
          amount: Value(cost),
          date: Value(date),
        ));
        await (_db.update(_db.invoiceItems)..where((t) => t.invoiceId.equals(workId))).write(InvoiceItemsCompanion(
          productName: Value(description),
          unitPrice: Value(cost),
          lineTotal: Value(cost),
        ));

        // 2. Update linked Traila Expense (approximation by amount/id)
        await (_db.update(_db.trailaExpenses)..where((t) => t.labourId.equals(invoice.ownerId) & t.amount.equals(invoice.amount))).write(TrailaExpensesCompanion(
          amount: Value(cost),
          date: Value(date),
          description: Value('Work: $description'),
        ));

        // 3. Recalculate Labour summary
        await _syncLabourBalances(invoice.ownerId);
      });
      await loadData();
    } catch (e) {
      debugPrint('Error updating labour work: $e');
    }
  }

  Future<void> updateLabourPayment(String paymentId, {required double amount, required DateTime date}) async {
    try {
      await _db.transaction(() async {
        final payment = await (_db.select(_db.payments)..where((t) => t.id.equals(paymentId))).getSingleOrNull();
        if (payment == null) return;

        // 1. Update Payment record
        await (_db.update(_db.payments)..where((t) => t.id.equals(paymentId))).write(PaymentsCompanion(
          amount: Value(amount),
          date: Value(date),
        ));
        
        // 2. Update associated Invoice
        await (_db.update(_db.invoices)..where((t) => t.id.equals(paymentId))).write(InvoicesCompanion(
          amount: Value(amount),
          date: Value(date),
        ));

        // 3. Recalculate Labour summary
        await _syncLabourBalances(payment.ownerId);
      });
      await loadData();
    } catch (e) {
      debugPrint('Error updating labour payment: $e');
    }
  }

  Future<void> _syncLabourBalances(String labourId) async {
    final invoices = await (_db.select(_db.invoices)..where((t) => t.ownerId.equals(labourId) & t.ownerType.equals('labour'))).get();
    final labour = await (_db.select(_db.labours)..where((t) => t.id.equals(labourId))).getSingle();
    
    double totalPayable = 0;
    double totalPaid = 0;

    for (var inv in invoices) {
      if (inv.invoiceNumber == 'OPEN-BAL') continue; // ✅ Prevent double-counting as it's added from labour.openingBalance below
      if (inv.type == InvoiceType.labourWork.name) {
        totalPayable += inv.amount;
      } else if (inv.type == InvoiceType.payment.name) {
        totalPaid += inv.amount;
      }
    }

    final remaining = labour.openingBalance + totalPayable - totalPaid;

    await (_db.update(_db.labours)..where((t) => t.id.equals(labourId))).write(LaboursCompanion(
      totalPayable: Value(totalPayable),
      totalPaid: Value(totalPaid),
      remainingBalance: Value(remaining > 0 ? remaining : 0.0),
    ));
  }

  // --- Supplier Record Management ---

  Future<void> deleteSupplierPurchase(String purchaseId) async {
    try {
      await _db.transaction(() async {
        final invoice = await (_db.select(_db.invoices)..where((t) => t.id.equals(purchaseId))).getSingleOrNull();
        if (invoice == null) return;

        // 1. Delete Invoice & Items
        await (_db.delete(_db.invoices)..where((t) => t.id.equals(purchaseId))).go();
        await (_db.delete(_db.invoiceItems)..where((t) => t.invoiceId.equals(purchaseId))).go();

        // 2. Delete linked Traila Expense
        await (_db.delete(_db.trailaExpenses)..where((t) => t.supplierId.equals(invoice.ownerId) & t.amount.equals(invoice.amount))).go();

        // 3. Recalculate Supplier summary
        await _syncSupplierBalances(invoice.ownerId);
      });
      await loadData();
    } catch (e) {
      debugPrint('Error deleting supplier purchase: $e');
    }
  }

  Future<void> deleteSupplierPayment(String paymentId) async {
    try {
      await _db.transaction(() async {
        final payment = await (_db.select(_db.payments)..where((t) => t.id.equals(paymentId))).getSingleOrNull();
        if (payment == null) return;

        // 1. Delete Payment record & Splits
        await (_db.delete(_db.payments)..where((t) => t.id.equals(paymentId))).go();
        await (_db.delete(_db.splitDetails)..where((t) => t.paymentId.equals(paymentId))).go();
        
        // 2. Delete associated Invoice
        await (_db.delete(_db.invoices)..where((t) => t.id.equals(paymentId))).go();

        // 3. Recalculate Supplier summary
        await _syncSupplierBalances(payment.ownerId);
      });
      await loadData();
    } catch (e) {
      debugPrint('Error deleting supplier payment: $e');
    }
  }

  Future<void> updateSupplierPurchase(String purchaseId, {required double amount, required String description, required DateTime date}) async {
    try {
      await _db.transaction(() async {
        final invoice = await (_db.select(_db.invoices)..where((t) => t.id.equals(purchaseId))).getSingleOrNull();
        if (invoice == null) return;

        // 1. Update Invoice & Items
        await (_db.update(_db.invoices)..where((t) => t.id.equals(purchaseId))).write(InvoicesCompanion(
          amount: Value(amount),
          date: Value(date),
        ));
        await (_db.update(_db.invoiceItems)..where((t) => t.invoiceId.equals(purchaseId))).write(InvoiceItemsCompanion(
          productName: Value(description),
          unitPrice: Value(amount),
          lineTotal: Value(amount),
        ));

        // 2. Update linked Traila Expense
        await (_db.update(_db.trailaExpenses)..where((t) => t.supplierId.equals(invoice.ownerId) & t.amount.equals(invoice.amount))).write(TrailaExpensesCompanion(
          amount: Value(amount),
          date: Value(date),
          description: Value('Purchase: $description'),
        ));

        // 3. Recalculate Supplier summary
        await _syncSupplierBalances(invoice.ownerId);
      });
      await loadData();
    } catch (e) {
      debugPrint('Error updating supplier purchase: $e');
    }
  }

  Future<void> updateSupplierPayment(String paymentId, {required double amount, required DateTime date}) async {
    try {
      await _db.transaction(() async {
        final payment = await (_db.select(_db.payments)..where((t) => t.id.equals(paymentId))).getSingleOrNull();
        if (payment == null) return;

        // 1. Update Payment record
        await (_db.update(_db.payments)..where((t) => t.id.equals(paymentId))).write(PaymentsCompanion(
          amount: Value(amount),
          date: Value(date),
        ));
        
        // 2. Update associated Invoice
        await (_db.update(_db.invoices)..where((t) => t.id.equals(paymentId))).write(InvoicesCompanion(
          amount: Value(amount),
          date: Value(date),
        ));

        // 3. Recalculate Supplier summary
        await _syncSupplierBalances(payment.ownerId);
      });
      await loadData();
    } catch (e) {
      debugPrint('Error updating supplier payment: $e');
    }
  }

  Future<void> _syncSupplierBalances(String supplierId) async {
    final invoices = await (_db.select(_db.invoices)..where((t) => t.ownerId.equals(supplierId) & t.ownerType.equals('supplier'))).get();
    final supplier = await (_db.select(_db.suppliers)..where((t) => t.id.equals(supplierId))).getSingle();
    
    double totalAmount = 0;
    double totalPaid = 0;

    for (var inv in invoices) {
      if (inv.invoiceNumber == 'OPEN-BAL') continue; // ✅ Prevent double-counting as it's added from supplier.openingBalance below
      if (inv.type == InvoiceType.purchase.name) {
        totalAmount += inv.amount;
      } else if (inv.type == InvoiceType.payment.name) {
        totalPaid += inv.amount;
      }
    }

    final net = supplier.openingBalance + totalAmount - totalPaid;
    final remaining = net > 0 ? net : 0.0;
    final advance = net < 0 ? -net : 0.0;

    await (_db.update(_db.suppliers)..where((t) => t.id.equals(supplierId))).write(SuppliersCompanion(
      totalAmount: Value(totalAmount),
      totalPaid: Value(totalPaid),
      remainingBalance: Value(remaining),
      advanceBalance: Value(advance),
    ));
  }

  // --- General Transactions ---

  Future<void> addTransaction(Transaction txn) async {
    final updatedAccounts = Map<String, Account>.from(state.accounts);
    final key = _getAccountKey(txn.accountName);
    final account = updatedAccounts[key];
    if (account == null) return;

    final newBalance = txn.isCredit ? account.balance + txn.amount : account.balance - txn.amount;

    await _db.transaction(() async {
      await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
        id: txn.id,
        accountName: txn.accountName,
        type: txn.type.name,
        amount: txn.amount,
        person: txn.person,
        description: txn.description,
        date: txn.date,
        category: txn.category,
        linkedTransferId: Value(txn.linkedTransferId),
      ));

      await (_db.update(_db.accounts)..where((t) => t.name.equals(txn.accountName))).write(AccountsCompanion(
        balance: Value(newBalance),
      ));
    });

    updatedAccounts[key] = account.copyWith(
      balance: newBalance,
      transactions: [...account.transactions, txn],
    );
    emit(state.copyWith(accounts: updatedAccounts));
  }

  Future<void> transferMoney({
    required String fromKey,
    required String toKey,
    required double amount,
    required DateTime date,
    required String description,
  }) async {
    final fromAccount = state.accounts[fromKey];
    final toAccount = state.accounts[toKey];
    if (fromAccount == null || toAccount == null) return;

    final transferId = 'TRF-${DateTime.now().millisecondsSinceEpoch}';

    final debitTxn = Transaction(
      id: '$transferId-OUT',
      accountName: fromAccount.name,
      type: TransactionType.transfer,
      amount: amount,
      person: toAccount.name,
      description: 'Transfer OUT to ${toAccount.name}: $description',
      date: date,
      linkedTransferId: transferId,
      category: 'Transfer',
    );

    final creditTxn = Transaction(
      id: '$transferId-IN',
      accountName: toAccount.name,
      type: TransactionType.transfer,
      amount: amount,
      person: fromAccount.name,
      description: 'Transfer IN from ${fromAccount.name}: $description',
      date: date,
      linkedTransferId: transferId,
      category: 'Transfer',
    );

    final fromNewBal = fromAccount.balance - amount;
    final toNewBal = toAccount.balance + amount;

    await _db.transaction(() async {
      await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
        id: debitTxn.id,
        accountName: debitTxn.accountName,
        type: debitTxn.type.name,
        amount: debitTxn.amount,
        person: debitTxn.person,
        description: debitTxn.description,
        date: debitTxn.date,
        category: debitTxn.category,
        linkedTransferId: Value(transferId),
      ));

      await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
        id: creditTxn.id,
        accountName: creditTxn.accountName,
        type: creditTxn.type.name,
        amount: creditTxn.amount,
        person: creditTxn.person,
        description: creditTxn.description,
        date: creditTxn.date,
        category: creditTxn.category,
        linkedTransferId: Value(transferId),
      ));

      await (_db.update(_db.accounts)..where((t) => t.name.equals(fromAccount.name))).write(AccountsCompanion(
        balance: Value(fromNewBal),
      ));
      await (_db.update(_db.accounts)..where((t) => t.name.equals(toAccount.name))).write(AccountsCompanion(
        balance: Value(toNewBal),
      ));
    });

    final updatedAccounts = Map<String, Account>.from(state.accounts);
    updatedAccounts[fromKey] = fromAccount.copyWith(
      balance: fromNewBal,
      transactions: [...fromAccount.transactions, debitTxn],
    );
    updatedAccounts[toKey] = toAccount.copyWith(
      balance: toNewBal,
      transactions: [...toAccount.transactions, creditTxn],
    );
    emit(state.copyWith(accounts: updatedAccounts));
  }

  Future<void> deleteTransaction(String accountKey, String txnId) async {
    final updatedAccounts = Map<String, Account>.from(state.accounts);
    final account = updatedAccounts[accountKey];
    if (account == null) return;

    final txnToDelete = account.transactions.firstWhere((t) => t.id == txnId);
    final double balanceChange = (txnToDelete.type == TransactionType.add || (txnToDelete.type == TransactionType.transfer && txnToDelete.description.contains('IN'))) 
        ? -txnToDelete.amount 
        : txnToDelete.amount;

    await _db.transaction(() async {
      if (txnToDelete.type == TransactionType.transfer && txnToDelete.linkedTransferId != null) {
        final tid = txnToDelete.linkedTransferId!;
        await (_db.delete(_db.transactions)..where((t) => t.linkedTransferId.equals(tid))).go();
        
        // Find the other transaction to update its account balance
        Transaction? otherTxn;
        for (var acc in state.accounts.values) {
          final found = acc.transactions.firstWhere((t) => t.linkedTransferId == tid && t.id != txnId, orElse: () => Transaction(id: '', accountName: '', type: TransactionType.add, amount: 0, person: '', description: '', date: DateTime.now(), category: ''));
          if (found.id.isNotEmpty) {
            otherTxn = found;
            break;
          }
        }

        if (otherTxn != null) {
          final otherKey = _getAccountKey(otherTxn.accountName);
          final otherAcc = updatedAccounts[otherKey];
          if (otherAcc != null) {
            final otherBalChange = (otherTxn.type == TransactionType.add || otherTxn.description.contains('IN')) ? -otherTxn.amount : otherTxn.amount;
            final otherNewBal = otherAcc.balance + otherBalChange;
            await (_db.update(_db.accounts)..where((t) => t.name.equals(otherTxn!.accountName))).write(AccountsCompanion(
              balance: Value(otherNewBal),
            ));
            updatedAccounts[otherKey] = otherAcc.copyWith(
              balance: otherNewBal,
              transactions: otherAcc.transactions.where((t) => t.linkedTransferId != tid).toList(),
            );
          }
        }
      } else {
        await (_db.delete(_db.transactions)..where((t) => t.id.equals(txnId))).go();
      }

      final newBalance = account.balance + balanceChange;
      await (_db.update(_db.accounts)..where((t) => t.name.equals(account.name))).write(AccountsCompanion(
        balance: Value(newBalance),
      ));
      
      updatedAccounts[accountKey] = account.copyWith(
        balance: newBalance,
        transactions: account.transactions.where((t) => (txnToDelete.linkedTransferId != null && t.linkedTransferId != txnToDelete.linkedTransferId) || (txnToDelete.linkedTransferId == null && t.id != txnId)).toList(),
      );
    });

    emit(state.copyWith(accounts: updatedAccounts));
  }

  Future<void> updateTransaction(Transaction updatedTxn) async {
    try {
      await (_db.update(_db.transactions)..where((t) => t.id.equals(updatedTxn.id))).write(TransactionsCompanion(
        amount: Value(updatedTxn.amount),
        person: Value(updatedTxn.person),
        description: Value(updatedTxn.description),
        category: Value(updatedTxn.category),
        date: Value(updatedTxn.date),
      ));
      await loadData();
    } catch (e) {
      debugPrint('Database Error in updateTransaction: $e');
    }
  }

  Future<void> updateSaleDetails({required String saleId, required double price, required DateTime date}) async {
    try {
      await _db.transaction(() async {
        final sale = await (_db.select(_db.sales)..where((t) => t.id.equals(saleId))).getSingleOrNull();
        if (sale == null) return;

        final profit = price - sale.manufacturingCost;
        final remaining = price - sale.paidAmount;

        await (_db.update(_db.sales)..where((t) => t.id.equals(saleId))).write(SalesCompanion(
          salePrice: Value(price),
          saleDate: Value(date),
          profit: Value(profit),
          remainingBalance: Value(remaining > 0 ? remaining : 0.0),
        ));
      });
      await loadData();
    } catch (e) {
      debugPrint('Error updating sale details: $e');
    }
  }

  Future<void> deleteSale(String saleId) async {
    try {
      await _db.transaction(() async {
        // 1. Delete associated payments
        await (_db.delete(_db.payments)..where((t) => t.ownerId.equals(saleId) & t.ownerType.equals('sale'))).go();
        // 2. Delete associated invoices
        await (_db.delete(_db.invoices)..where((t) => t.id.equals(saleId))).go();
        // 3. Delete the sale itself
        await (_db.delete(_db.sales)..where((t) => t.id.equals(saleId))).go();
      });
      await loadData();
    } catch (e) {
      debugPrint('Error deleting sale: $e');
    }
  }

  double calculateBalance(String accountKey) {
    final account = state.accounts[accountKey];
    return account?.balance ?? 0.0;
  }

  Future<void> updatePrinterSettings(PrinterSetting settings) async {
    await _db.into(_db.printerSettings).insert(
      PrinterSettingData(
        id: 'default',
        deviceName: settings.deviceName,
        deviceAddress: settings.deviceAddress,
        vendorId: settings.vendorId,
        productId: settings.productId,
        paperSize: settings.paperSize,
        connectionType: settings.connectionType,
        autoCut: settings.autoCut,
        autoPrint: settings.autoPrint,
      ),
      mode: InsertMode.insertOrReplace,
    );
    emit(state.copyWith(printerSetting: settings));
  }
}
