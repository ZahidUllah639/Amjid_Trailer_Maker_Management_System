import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// --- Tables ---

@DataClassName('SupplierData')
class Suppliers extends Table {
  TextColumn get id => text()(); // Manual ID as PK
  TextColumn get name => text()();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get shopName => text().withDefault(const Constant(''))();
  TextColumn get location => text().withDefault(const Constant(''))();
  TextColumn get whatsappNumber => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  DateTimeColumn get registrationDate => dateTime()();
  RealColumn get openingBalance => real().withDefault(const Constant(0.0))();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  RealColumn get totalPaid => real().withDefault(const Constant(0.0))();
  RealColumn get remainingBalance => real().withDefault(const Constant(0.0))();
  RealColumn get advanceBalance => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LabourData')
class Labours extends Table {
  TextColumn get id => text()(); // Manual ID as PK
  TextColumn get name => text()();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get whatsappNumber => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  DateTimeColumn get registrationDate => dateTime()();
  RealColumn get openingBalance => real().withDefault(const Constant(0.0))();
  RealColumn get totalPayable => real().withDefault(const Constant(0.0))();
  RealColumn get totalPaid => real().withDefault(const Constant(0.0))();
  RealColumn get remainingBalance => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ProductData')
class Products extends Table {
  TextColumn get id => text()(); // Manual ID or UUID
  TextColumn get name => text()();
  RealColumn get defaultPrice => real().withDefault(const Constant(0.0))();
  TextColumn get unit => text().withDefault(const Constant('PCS'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('InvoiceData')
class Invoices extends Table {
  TextColumn get id => text()();
  TextColumn get invoiceNumber => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()(); // purchase, payment, labourWork, labourPayment, sale, salePayment
  TextColumn get ownerId => text()();
  TextColumn get ownerName => text()();
  TextColumn get ownerType => text()(); // 'supplier', 'labour', 'sale'
  TextColumn get trailaId => text().nullable().references(Trailas, #id, onDelete: KeyAction.setNull)();
  RealColumn get amount => real()();
  RealColumn get previousBalance => real()();
  RealColumn get remainingBalance => real()();
  TextColumn get paymentMethod => text()();
  TextColumn get ownerNameDisplay => text()(); // App Owner
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('InvoiceItemData')
class InvoiceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceId => text().references(Invoices, #id, onDelete: KeyAction.cascade)();
  TextColumn get productName => text()();
  RealColumn get quantity => real()();
  RealColumn get unitPrice => real()();
  RealColumn get lineTotal => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('PaymentData')
class Payments extends Table {
  TextColumn get id => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get method => text()();
  TextColumn get receiptNumber => text().nullable()();
  RealColumn get previousBalance => real().nullable()();
  RealColumn get updatedBalance => real().nullable()();
  TextColumn get ownerId => text()();
  TextColumn get ownerType => text()(); // 'supplier', 'labour'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SplitDetailData')
class SplitDetails extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get paymentId => text().references(Payments, #id, onDelete: KeyAction.cascade)();
  TextColumn get method => text()();
  RealColumn get amount => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('TransactionData')
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get accountName => text()();
  TextColumn get type => text()(); // add, take
  RealColumn get amount => real()();
  TextColumn get person => text()();
  TextColumn get description => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get category => text()();
  TextColumn get linkedTransferId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LabourWorkEntryData')
class LabourWorkEntries extends Table {
  TextColumn get id => text()();
  TextColumn get labourId => text().references(Labours, #id, onDelete: KeyAction.cascade)();
  TextColumn get trailaId => text().nullable().references(Trailas, #id, onDelete: KeyAction.setNull)();
  TextColumn get entryNumber => text()();
  TextColumn get description => text()();
  RealColumn get cost => real()();
  DateTimeColumn get date => dateTime()();
  RealColumn get previousOutstanding => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TrailaData')
class Trailas extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get registrationDate => dateTime()();
  TextColumn get status => text()(); // pending, ready, sold
  RealColumn get totalManufacturingCost => real().withDefault(const Constant(0.0))();
  RealColumn get salePrice => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TrailaExpenseData')
class TrailaExpenses extends Table {
  TextColumn get id => text()();
  TextColumn get trailaId => text().nullable().references(Trailas, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get supplierId => text().references(Suppliers, #id).nullable()();
  TextColumn get labourId => text().references(Labours, #id).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BuyerData')
class Buyers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get cnic => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get whatsappNumber => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SaleData')
class Sales extends Table {
  TextColumn get id => text()();
  TextColumn get trailaId => text().references(Trailas, #id, onDelete: KeyAction.cascade)();
  TextColumn get buyerId => text().references(Buyers, #id)();
  RealColumn get salePrice => real()();
  RealColumn get manufacturingCost => real().withDefault(const Constant(0.0))();
  RealColumn get profit => real().withDefault(const Constant(0.0))();
  DateTimeColumn get saleDate => dateTime()();
  RealColumn get paidAmount => real()();
  RealColumn get remainingBalance => real()();
  TextColumn get receiptNumber => text()();
  RealColumn get globalPreviousBalance => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AppSettingData')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('AppProfileData')
class AppProfiles extends Table {
  TextColumn get id => text()(); // Domain appProfile uses String ID
  TextColumn get businessName => text().nullable()();
  TextColumn get ownerName => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get address => text().nullable()();
  TextColumn get businessType => text().nullable()();
  TextColumn get whatsappNumber => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AccountData')
class Accounts extends Table {
  TextColumn get id => text()(); 
  TextColumn get name => text()();
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  TextColumn get type => text().withDefault(const Constant('other'))(); // cash, bank, wallet, other
  TextColumn get iconType => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PrinterSettingData')
class PrinterSettings extends Table {
  TextColumn get id => text().withDefault(const Constant('default'))();
  TextColumn get deviceName => text().nullable()();
  TextColumn get deviceAddress => text().nullable()(); // MAC for BT, VID/PID for USB
  TextColumn get vendorId => text().nullable()();
  TextColumn get productId => text().nullable()();
  TextColumn get paperSize => text().withDefault(const Constant('58mm'))(); // 58mm, 80mm
  TextColumn get connectionType => text().withDefault(const Constant('USB'))(); // USB, Bluetooth
  BoolColumn get autoCut => boolean().withDefault(const Constant(true))();
  BoolColumn get autoPrint => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('KhataData')
class Khatas extends Table {
  TextColumn get id => text()();
  TextColumn get personName => text()();
  RealColumn get openingBalance => real().withDefault(const Constant(0.0))();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();
  RealColumn get remainingBalance => real().withDefault(const Constant(0.0))();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('KhataItemData')
class KhataItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get khataId => text().references(Khatas, #id, onDelete: KeyAction.cascade)();
  TextColumn get itemName => text().nullable()(); // renamed to description in model, keeping DB name for now to simplify
  RealColumn get price => real()(); // renamed to amount in model
  TextColumn get type => text().withDefault(const Constant('cashOut'))(); // 'cashIn' or 'cashOut'
  TextColumn get paymentMethod => text().nullable()(); // Account used (nullable for legacy items)
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// --- Database ---

@DriftDatabase(tables: [
  Suppliers,
  Labours,
  Products,
  Invoices,
  InvoiceItems,
  Payments,
  SplitDetails,
  Transactions,
  Trailas,
  TrailaExpenses,
  LabourWorkEntries,
  Buyers,
  Sales,
  AppSettings,
  AppProfiles,
  Accounts,
  PrinterSettings,
  Khatas,
  KhataItems
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Safe incremental migration
      if (from < 4) {
        // In version 4, we add Khatas and KhataItems.
        for (final table in allTables) {
          await m.createTable(table);
        }
      }
      if (from < 5) {
        // In version 5, we add 'type' and 'date' to 'KhataItems'.
        await m.addColumn(khataItems, khataItems.type);
        await m.addColumn(khataItems, khataItems.date);
      }
      if (from < 6) {
        // In version 6, we add 'paymentMethod' to 'KhataItems'.
        await m.addColumn(khataItems, khataItems.paymentMethod);
      }
      if (from < 7) {
        // In version 7, we add 'openingBalance' to 'Khatas'.
        await m.addColumn(khatas, khatas.openingBalance);
      }
      if (from < 8) {
        // In version 8, we add 'openingBalance' to 'Labours'.
        await m.addColumn(labours, labours.openingBalance);
      }
      if (from < 10) {
        // In version 10, we make trailaId nullable and add cascade deletions.
        // Recreating these tables is the safest way to apply constraints and nullability.
        await m.alterTable(TableMigration(labourWorkEntries));
        await m.alterTable(TableMigration(trailaExpenses));
        await m.alterTable(TableMigration(sales));
      }
      if (from < 11) {
        // In version 11, we add whatsappNumber to Buyers.
        await m.addColumn(buyers, buyers.whatsappNumber);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // --- Queries ---

  // Suppliers
  Future<List<SupplierData>> getAllSuppliers() => select(suppliers).get();
  Future insertSupplier(Insertable<SupplierData> supplier) => into(suppliers).insert(supplier, mode: InsertMode.insertOrReplace);
  
  // Labours
  Future<List<LabourData>> getAllLabours() => select(labours).get();
  Future insertLabour(Insertable<LabourData> labour) => into(labours).insert(labour, mode: InsertMode.insertOrReplace);

  // Products
  Future<List<ProductData>> getAllProducts() => select(products).get();
  Future insertProduct(Insertable<ProductData> product) => into(products).insert(product, mode: InsertMode.insertOrReplace);

  // Invoices & Items (Relational Join)
  Future<List<InvoiceWithItems>> getInvoicesWithItems() async {
    final invoiceList = await select(invoices).get();
    final List<InvoiceWithItems> results = [];
    
    for (var inv in invoiceList) {
      final items = await (select(invoiceItems)..where((t) => t.invoiceId.equals(inv.id))).get();
      results.add(InvoiceWithItems(inv, items));
    }
    return results;
  }

  // Complex Transaction for Saving Invoice
  Future<void> saveInvoice(InvoiceData invoice, List<InvoiceItemData> items) async {
    await transaction(() async {
      await into(invoices).insert(invoice, mode: InsertMode.insertOrReplace);
      for (var item in items) {
        await into(invoiceItems).insert(InvoiceItemsCompanion.insert(
          invoiceId: item.invoiceId,
          productName: item.productName,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          lineTotal: item.lineTotal,
        ));
      }
    });
  }

  // Khatas
  Future<List<KhataData>> getAllKhatas() => select(khatas).get();
  Future<List<KhataItemData>> getKhataItems(String khataId) => 
    (select(khataItems)..where((t) => t.khataId.equals(khataId))).get();

  Future<void> saveKhata(KhatasCompanion khata, List<KhataItemsCompanion> items) async {
    await transaction(() async {
      await into(khatas).insertOnConflictUpdate(khata);
      for (var item in items) {
        await into(khataItems).insert(item);
      }
    });
  }
}

class InvoiceWithItems {
  final InvoiceData invoice;
  final List<InvoiceItemData> items;
  InvoiceWithItems(this.invoice, this.items);
}


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Use applicationSupportDirectory for robust Windows persistence.
    // This maps to AppData/Roaming/<app> which survives app updates.
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'traila.db'));
    return NativeDatabase(file, logStatements: false);
  });
}
