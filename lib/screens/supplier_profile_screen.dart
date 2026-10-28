import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/supplier.dart';
import '../models/payment.dart';
import '../models/traila.dart';
import '../services/thermal_printer_service.dart';
import '../services/invoice_pdf_service.dart';
import '../services/whatsapp_service.dart';
import '../widgets/print_preview_dialog.dart';

class SupplierProfileScreen extends StatelessWidget {
  final String supplierId;
  const SupplierProfileScreen({super.key, required this.supplierId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final supplier = state.suppliers.firstWhere(
          (s) => s.id == supplierId,
          orElse: () => Supplier(
            id: 'Error',
            name: 'Not Found',
            phone: '',
            shopName: '',
            location: '',
            registrationDate: DateTime.now(),
          ),
        );
        
        if (supplier.id == 'Error') {
          return const Scaffold(body: Center(child: Text('Supplier not found')));
        }
        
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: Text('Ledger: ${supplier.name} (${supplier.id})'),
            actions: [
              IconButton(
                onPressed: () => _showEditSupplierDialog(context, supplier),
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Profile',
              ),
              IconButton(
                onPressed: () async {
                  final state = context.read<ERPCubit>().state;
                  final pdfBytes = await InvoicePdfService.generateStatementPdf(
                    personName: supplier.name,
                    type: "Supplier",
                    date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                    remainingBalance: supplier.remainingBalance,
                    profile: state.appProfile,
                  );
                  if (!context.mounted) return;
                  await PrintPreviewDialog.show(
                    context, 
                    pdfBytes, 
                    'Statement_${supplier.name}.pdf',
                  );
                },
                icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.red),
                tooltip: 'Save Statement as PDF',
              ),
              IconButton(
                onPressed: () async {
                  final state = context.read<ERPCubit>().state;
                  try {
                    final success = await ThermalPrinterService.printSupplierStatement(
                      context,
                      supplier: supplier,
                      profile: state.appProfile,
                      settings: state.printerSetting,
                    );
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to print statement.')));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))));
                    }
                  }
                },
                icon: const Icon(Icons.print_outlined),
                tooltip: 'Print Statement',
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditSupplierDialog(context, supplier);
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context, supplier);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Edit Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Profile'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final bool isDesktop = constraints.maxWidth >= 950;

              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Panel: Supplier Profile & Financial Health Hub (Fixed width ~380)
                    SizedBox(
                      width: 380,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildSupplierIdentityCard(context, supplier),
                            const SizedBox(height: 16),
                            _buildFinancialKPIs(supplier),
                            const SizedBox(height: 16),
                            _buildActionHub(context, supplier),
                          ],
                        ),
                      ),
                    ),

                    // Vertical Divider
                    Container(width: 1, color: Colors.grey.shade200),

                    // Right Panel: Interactive Chronological Statement & Ledger
                    Expanded(
                      child: _UnifiedSupplierLedger(supplier: supplier),
                    ),
                  ],
                );
              }

              // Responsive Mobile/Compact Fallback
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSupplierIdentityCard(context, supplier),
                    const SizedBox(height: 16),
                    _buildFinancialKPIs(supplier),
                    const SizedBox(height: 16),
                    _buildActionHub(context, supplier),
                    const SizedBox(height: 20),
                    const Text(
                      'Statement & Ledger',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 600,
                      child: _UnifiedSupplierLedger(supplier: supplier),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showEditSupplierDialog(BuildContext context, Supplier supplier) {
    showDialog(
      context: context,
      builder: (context) => _EditSupplierDialog(supplier: supplier),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Supplier supplier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Supplier?'),
        content: Text('This will permanently delete ${supplier.name} and all their transaction history. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final cubit = context.read<ERPCubit>();
              Navigator.pop(context);
              await cubit.deleteSupplier(supplier.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Supplier ${supplier.name} deleted')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierIdentityCard(BuildContext context, Supplier s) {
    final initials = s.name.trim().isNotEmpty
        ? s.name.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase()
        : 'S';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'ID: ${s.id}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Contact Details
          if (s.shopName.isNotEmpty) ...[
            _buildContactRow(Icons.storefront_outlined, s.shopName, 'Shop / Company'),
            const SizedBox(height: 8),
          ],
          if (s.phone.isNotEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: _buildContactRow(Icons.phone_outlined, s.phone, 'Phone'),
                ),
                // WhatsApp Button
                InkWell(
                  onTap: () async {
                    try {
                      final waNum = s.whatsappNumber.isNotEmpty ? s.whatsappNumber : s.phone;
                      final state = context.read<ERPCubit>().state;
                      await WhatsAppService.sendSupplierPaymentReceipt(
                        phone: waNum,
                        supplierName: s.name,
                        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                        paymentMethod: 'Statement',
                        paidAmount: s.totalPaid,
                        previousBalance: s.remainingBalance,
                        newBalance: s.remainingBalance,
                        profile: state.appProfile,
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                      }
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 14, color: Color(0xFF25D366)),
                        SizedBox(width: 4),
                        Text(
                          'WhatsApp',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E7E34)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (s.location.isNotEmpty || s.address.isNotEmpty) ...[
            _buildContactRow(Icons.location_on_outlined, s.location.isNotEmpty ? s.location : s.address, 'Location'),
            const SizedBox(height: 8),
          ],
          _buildContactRow(Icons.calendar_today_outlined, DateFormat('dd MMM yyyy').format(s.registrationDate), 'Registered On'),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text, String tooltip) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialKPIs(Supplier s) {
    final bool hasAdvance = s.advanceBalance > 0.01;
    final bool hasDebt = s.remainingBalance > 0.01;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Financial Overview',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 12),

          // Row 1: Total Billed & Total Paid
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  title: 'Total Billed',
                  value: 'Rs. ${s.totalAmount.toStringAsFixed(0)}',
                  icon: Icons.inventory_2_outlined,
                  color: const Color(0xFF3B82F6),
                  bgColor: const Color(0xFFEFF6FF),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile(
                  title: 'Total Paid',
                  value: 'Rs. ${s.totalPaid.toStringAsFixed(0)}',
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF10B981),
                  bgColor: const Color(0xFFECFDF5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Primary Balance Status Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: hasDebt
                  ? const Color(0xFFFEF2F2)
                  : hasAdvance
                      ? const Color(0xFFF0FDF4)
                      : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasDebt
                    ? const Color(0xFFFECACA)
                    : hasAdvance
                        ? const Color(0xFFBBF7D0)
                        : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasDebt
                          ? 'NET DUE / PAYABLE'
                          : hasAdvance
                              ? 'ADVANCE CREDIT'
                              : 'BALANCE STATUS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: hasDebt
                            ? const Color(0xFFDC2626)
                            : hasAdvance
                                ? const Color(0xFF16A34A)
                                : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasDebt
                          ? 'Rs. ${s.remainingBalance.toStringAsFixed(0)}'
                          : hasAdvance
                              ? 'Rs. ${s.advanceBalance.toStringAsFixed(0)}'
                              : 'Rs. 0 (Nil)',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: hasDebt
                            ? const Color(0xFFDC2626)
                            : hasAdvance
                                ? const Color(0xFF16A34A)
                                : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: hasDebt
                        ? Colors.red.shade100
                        : hasAdvance
                            ? Colors.green.shade100
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    hasDebt
                        ? 'PAYABLE'
                        : hasAdvance
                            ? 'ADVANCE'
                            : 'CLEARED',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: hasDebt
                          ? Colors.red.shade800
                          : hasAdvance
                              ? Colors.green.shade800
                              : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionHub(BuildContext context, Supplier supplier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 12),

          // New Purchase Button
          ElevatedButton.icon(
            onPressed: () => _showPurchaseDialog(context, supplier),
            icon: const Icon(Icons.add_shopping_cart, size: 18),
            label: const Text('New Purchase Bill'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 10),

          // Record Payment Button
          ElevatedButton.icon(
            onPressed: () => _showPaymentDialog(context, supplier),
            icon: const Icon(Icons.payment, size: 18),
            label: const Text('Record Payment Voucher'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 12),

          // Statement Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final state = context.read<ERPCubit>().state;
                    await ThermalPrinterService.printSupplierStatement(
                      context,
                      supplier: supplier,
                      profile: state.appProfile,
                      settings: state.printerSetting,
                    );
                  },
                  icon: const Icon(Icons.print_outlined, size: 16),
                  label: const Text('Print POS'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF334155),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final state = context.read<ERPCubit>().state;
                    final pdfBytes = await InvoicePdfService.generateStatementPdf(
                      personName: supplier.name,
                      type: "Supplier",
                      date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                      remainingBalance: supplier.remainingBalance,
                      profile: state.appProfile,
                    );
                    if (!context.mounted) return;
                    await PrintPreviewDialog.show(
                      context, 
                      pdfBytes, 
                      'Statement_${supplier.name}.pdf',
                      isThermal: false,
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 16, color: Colors.red),
                  label: const Text('PDF Slip'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF334155),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, Supplier supplier) {
    showDialog(
      context: context,
      builder: (context) => _PurchaseDialog(supplier: supplier),
    );
  }

  void _showPaymentDialog(BuildContext context, Supplier supplier) {
    showDialog(
      context: context,
      builder: (context) => _PaymentDialog(supplier: supplier),
    );
  }
}

Widget _buildBalanceBadge(double balance, {double fontSize = 12}) {
  if (balance < -0.01) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA5D6A7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF2E7D32)),
          const SizedBox(width: 4),
          Text(
            'Advance Credit: Rs. ${NumberFormat('#,##0').format(balance.abs())}',
            style: TextStyle(
              color: const Color(0xFF1B5E20),
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  } else if (balance > 0.01) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCC80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pending_actions_rounded, size: 14, color: Color(0xFFE65100)),
          const SizedBox(width: 4),
          Text(
            'Net Payable: Rs. ${NumberFormat('#,##0').format(balance)}',
            style: TextStyle(
              color: const Color(0xFFB71C1C),
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  } else {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.done_all_rounded, size: 14, color: Color(0xFF475569)),
          const SizedBox(width: 4),
          Text(
            'Clear / Nil (Rs. 0)',
            style: TextStyle(
              color: const Color(0xFF334155),
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnifiedSupplierLedger extends StatefulWidget {
  final Supplier supplier;
  const _UnifiedSupplierLedger({required this.supplier});

  @override
  State<_UnifiedSupplierLedger> createState() => _UnifiedSupplierLedgerState();
}

class _UnifiedSupplierLedgerState extends State<_UnifiedSupplierLedger> {
  String _filter = 'all'; // 'all', 'purchases', 'payments'
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<_LedgerRowData> allItems = [];

    for (final p in widget.supplier.purchases) {
      allItems.add(_LedgerRowData(
        id: p.id,
        date: p.date,
        type: _LedgerType.purchase,
        refTitle: p.billNumber,
        subtitle: '${p.items.length} item(s) ${p.trailaId != null ? '• Traila #${p.trailaId}' : ''}',
        amount: p.totalAmount,
        previousBalance: p.previousOutstanding,
        runningBalance: p.updatedBalance,
        purchase: p,
      ));
    }

    for (final pay in widget.supplier.payments) {
      allItems.add(_LedgerRowData(
        id: pay.id,
        date: pay.date,
        type: _LedgerType.payment,
        refTitle: 'Payment (${pay.method})',
        subtitle: pay.splitDetails != null && pay.splitDetails!.isNotEmpty
            ? 'Split: ${pay.splitDetails!.map((s) => "${s.method}: Rs. ${s.amount.toStringAsFixed(0)}").join(", ")}'
            : 'Payment via ${pay.method}',
        amount: pay.amount,
        previousBalance: pay.previousBalance ?? 0.0,
        runningBalance: pay.updatedBalance ?? widget.supplier.remainingBalance,
        payment: pay,
      ));
    }

    // Sort newest first
    allItems.sort((a, b) => b.date.compareTo(a.date));

    // Filter by type
    var filtered = allItems.where((item) {
      if (_filter == 'purchases' && item.type != _LedgerType.purchase) return false;
      if (_filter == 'payments' && item.type != _LedgerType.payment) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesRef = item.refTitle.toLowerCase().contains(q);
        final matchesSub = item.subtitle.toLowerCase().contains(q);
        final matchesAmt = item.amount.toString().contains(q);
        return matchesRef || matchesSub || matchesAmt;
      }
      return true;
    }).toList();

    return Column(
      children: [
        // Filter bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v.trim()),
                    decoration: InputDecoration(
                      hintText: 'Search ledger by bill #, item, amount...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      prefixIcon: const Icon(Icons.search, size: 18),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'all', label: Text('All (${allItems.length})')),
                  ButtonSegment(value: 'purchases', label: Text('Purchases (${widget.supplier.purchases.length})')),
                  ButtonSegment(value: 'payments', label: Text('Payments (${widget.supplier.payments.length})')),
                ],
                selected: {_filter},
                onSelectionChanged: (newVal) => setState(() => _filter = newVal.first),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),

        // Ledger list
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        _searchQuery.isNotEmpty ? 'No transactions match "$_searchQuery"' : 'No transactions recorded yet',
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return _buildUnifiedCard(context, item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildUnifiedCard(BuildContext context, _LedgerRowData item) {
    return _ModernSupplierLedgerCard(
      item: item,
      supplier: widget.supplier,
      onDeletePurchase: (id) => _showDeletePurchaseDialog(context, id),
      onDeletePayment: (id) => _showDeletePaymentDialog(context, id),
    );
  }

  void _showDeletePurchaseDialog(BuildContext context, String purchaseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Purchase Invoice?'),
        content: const Text('This will delete the purchase from history and recalculate the supplier\'s balance. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await context.read<ERPCubit>().deleteSupplierPurchase(purchaseId);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeletePaymentDialog(BuildContext context, String paymentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Record?'),
        content: const Text('This will remove the payment and recalculate balance. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await context.read<ERPCubit>().deleteSupplierPayment(paymentId);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ModernSupplierLedgerCard extends StatefulWidget {
  final _LedgerRowData item;
  final Supplier supplier;
  final ValueChanged<String> onDeletePurchase;
  final ValueChanged<String> onDeletePayment;

  const _ModernSupplierLedgerCard({
    required this.item,
    required this.supplier,
    required this.onDeletePurchase,
    required this.onDeletePayment,
  });

  @override
  State<_ModernSupplierLedgerCard> createState() => _ModernSupplierLedgerCardState();
}

class _ModernSupplierLedgerCardState extends State<_ModernSupplierLedgerCard> {
  bool _isHovered = false;
  bool _showAllItems = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isPurchase = item.type == _LedgerType.purchase;
    final accentColor = isPurchase ? const Color(0xFF2563EB) : const Color(0xFF10B981);
    final borderColor = _isHovered
        ? accentColor.withValues(alpha: 0.45)
        : (isPurchase ? const Color(0xFFE2E8F0) : const Color(0xFFDCFCE7));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0.0, _isHovered ? -2.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: _isHovered ? 1.5 : 1.0),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? accentColor.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.025),
              blurRadius: _isHovered ? 14 : 6,
              offset: Offset(0, _isHovered ? 4 : 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Identity & Balance Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon Capsule
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isPurchase
                            ? [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)]
                            : [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isPurchase ? const Color(0xFFBFDBFE) : const Color(0xFFBBF7D0),
                      ),
                    ),
                    child: Icon(
                      isPurchase ? Icons.receipt_long_rounded : Icons.verified_rounded,
                      color: isPurchase ? const Color(0xFF1D4ED8) : const Color(0xFF15803D),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Header Titles & Reference
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isPurchase ? const Color(0xFFEFF6FF) : const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isPurchase ? const Color(0xFFBFDBFE) : const Color(0xFFBBF7D0),
                                ),
                              ),
                              child: Text(
                                isPurchase ? 'PURCHASE INVOICE' : 'SETTLEMENT PAYMENT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                  color: isPurchase ? const Color(0xFF1E40AF) : const Color(0xFF15803D),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              item.refTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (item.purchase?.trailaId != null && item.purchase!.trailaId!.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.local_shipping_outlined, size: 12, color: Color(0xFF475569)),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Traila #${item.purchase!.trailaId}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 13, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('dd MMM yyyy, hh:mm a').format(item.date),
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '• ${item.subtitle}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Amount & Running Balance Badge
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isPurchase ? "+" : "-"} Rs. ${NumberFormat("#,##0").format(item.amount)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: isPurchase ? const Color(0xFF0F172A) : const Color(0xFF16A34A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildBalanceBadge(item.runningBalance, fontSize: 11),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 2. Clear Itemized Breakdown or Settlement Timeline (No Ugly Dropdown!)
              if (isPurchase && item.purchase != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEEF2F6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PURCHASED LINE ITEMS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF64748B),
                              letterSpacing: 0.6,
                            ),
                          ),
                          Text(
                            '${item.purchase!.items.length} item(s)',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Display items as sleek chips / rows
                      ...() {
                        final itemsToShow = _showAllItems || item.purchase!.items.length <= 4
                            ? item.purchase!.items
                            : item.purchase!.items.take(3).toList();
                        return itemsToShow.map((it) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3B82F6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  it.name,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                                ),
                              ),
                              Text(
                                '${it.quantity} pcs  ×  Rs. ${NumberFormat("#,##0").format(it.unitPrice)}  ➔  ',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                              Text(
                                'Rs. ${NumberFormat("#,##0").format(it.total)}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                              ),
                            ],
                          ),
                        ));
                      }(),
                      if (item.purchase!.items.length > 4) ...[
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () => setState(() => _showAllItems = !_showAllItems),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              _showAllItems
                                  ? 'Show less'
                                  : '+ ${item.purchase!.items.length - 3} more items...',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (item.purchase!.paymentAmount > 0) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 15, color: Color(0xFF16A34A)),
                              const SizedBox(width: 8),
                              Text(
                                'Settled at time of purchase: Rs. ${NumberFormat("#,##0").format(item.purchase!.paymentAmount)} via ${item.purchase!.paymentMethod ?? "Cash"}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF15803D),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ] else if (!isPurchase && item.payment != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDCFCE7)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.history_rounded, size: 16, color: Color(0xFF16A34A)),
                          const SizedBox(width: 8),
                          Text(
                            'Previous Balance: Rs. ${NumberFormat("#,##0").format(item.previousBalance)}',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF16A34A)),
                          const SizedBox(width: 4),
                          Text(
                            'Paid: Rs. ${NumberFormat("#,##0").format(item.amount)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF15803D),
                            ),
                          ),
                        ],
                      ),
                      _buildBalanceBadge(item.runningBalance, fontSize: 12),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // 3. World-Class Action Toolbar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      final state = context.read<ERPCubit>().state;
                      try {
                        if (isPurchase && item.purchase != null) {
                          await ThermalPrinterService.printSupplierPurchase(
                            context,
                            supplier: widget.supplier,
                            purchase: item.purchase!,
                            profile: state.appProfile,
                            settings: state.printerSetting,
                            printDuplicate: true,
                          );
                        } else if (!isPurchase && item.payment != null) {
                          await ThermalPrinterService.printSupplierPayment(
                            context,
                            supplier: widget.supplier,
                            payment: item.payment!,
                            previousBalance: item.previousBalance,
                            newBalance: item.runningBalance,
                            profile: state.appProfile,
                            settings: state.printerSetting,
                            printDuplicate: true,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print error: $e')));
                        }
                      }
                    },
                    icon: const Icon(Icons.receipt_rounded, size: 15),
                    label: const Text('Thermal Receipt (58/80mm)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F172A),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final state = context.read<ERPCubit>().state;
                      if (isPurchase && item.purchase != null) {
                        final pdfBytes = await InvoicePdfService.generateSupplierPurchasePdf(
                          supplierName: widget.supplier.name,
                          date: DateFormat('dd-MM-yyyy').format(item.purchase!.date),
                          items: item.purchase!.items,
                          previousBalance: item.purchase!.previousOutstanding,
                          paymentAmount: item.purchase!.paymentAmount,
                          newBalance: item.purchase!.updatedBalance,
                          paymentMethod: item.purchase!.paymentMethod,
                          profile: state.appProfile,
                        );
                        if (!context.mounted) return;
                        await PrintPreviewDialog.show(
                          context,
                          pdfBytes,
                          'Purchase_Invoice_${item.purchase!.billNumber}.pdf',
                        );
                      } else if (!isPurchase && item.payment != null) {
                        final pdfBytes = await InvoicePdfService.generateSupplierPaymentPdf(
                          supplierName: widget.supplier.name,
                          date: DateFormat('dd-MM-yyyy').format(item.payment!.date),
                          paymentMethod: item.payment!.method,
                          paidAmount: item.payment!.amount,
                          previousBalance: item.previousBalance,
                          newBalance: item.runningBalance,
                          profile: state.appProfile,
                        );
                        if (!context.mounted) return;
                        await PrintPreviewDialog.show(
                          context,
                          pdfBytes,
                          'Payment_${widget.supplier.name}.pdf',
                        );
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 15, color: Color(0xFFEF4444)),
                    label: const Text('PDF Invoice', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFFCA5A5)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 19, color: Color(0xFFEF4444)),
                    tooltip: 'Delete entry',
                    style: IconButton.styleFrom(
                      hoverColor: const Color(0xFFFEE2E2),
                    ),
                    onPressed: () {
                      if (isPurchase && item.purchase != null) {
                        widget.onDeletePurchase(item.purchase!.id);
                      } else if (!isPurchase && item.payment != null) {
                        widget.onDeletePayment(item.payment!.id);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _LedgerType { purchase, payment }

class _LedgerRowData {
  final String id;
  final DateTime date;
  final _LedgerType type;
  final String refTitle;
  final String subtitle;
  final double amount;
  final double previousBalance;
  final double runningBalance;
  final SupplierPurchase? purchase;
  final Payment? payment;

  const _LedgerRowData({
    required this.id,
    required this.date,
    required this.type,
    required this.refTitle,
    required this.subtitle,
    required this.amount,
    required this.previousBalance,
    required this.runningBalance,
    this.purchase,
    this.payment,
  });
}

class _PurchaseDialog extends StatefulWidget {
  final Supplier supplier;
  const _PurchaseDialog({required this.supplier});
  @override
  _PurchaseDialogState createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<_PurchaseDialog> {
  String? _selectedTrailaId;
  DateTime _selectedDate = DateTime.now();
  final List<PurchaseItem> _items = [];
  final _itemNameController = TextEditingController();
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  final _paymentController = TextEditingController();
  String _paymentMethod = 'Cash';
  bool _isSaving = false;
  SupplierPurchase? _savedPurchase;

  void _addItem() {
    if (_itemNameController.text.isEmpty || _qtyController.text.isEmpty || _priceController.text.isEmpty) return;
    final qty = int.tryParse(_qtyController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;
    if (qty <= 0 || price <= 0) return;
    
    setState(() {
      _items.add(PurchaseItem(
        id: 'I-${DateTime.now().millisecondsSinceEpoch}',
        name: _itemNameController.text.trim(),
        quantity: qty,
        unitPrice: price,
        total: qty * price,
      ));
      _itemNameController.clear();
      _qtyController.clear();
      _priceController.clear();
    });
  }

  Future<void> _handleSave() async {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one item.')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final currentBillTotal = _items.fold<double>(0, (sum, item) => sum + item.total);
      final prevOutstanding = widget.supplier.remainingBalance;
      final paymentAmount = double.tryParse(_paymentController.text) ?? 0;

      final purchase = SupplierPurchase(
        id: 'P-${DateTime.now().millisecondsSinceEpoch}',
        billNumber: 'N/A',
        trailaId: _selectedTrailaId, // Optional
        items: List.from(_items),
        totalAmount: currentBillTotal,
        previousOutstanding: prevOutstanding,
        paymentAmount: paymentAmount,
        date: _selectedDate,
      );

      final result = await context.read<ERPCubit>().addSupplierPurchase(
        widget.supplier.id, 
        purchase,
        paymentAmount: paymentAmount,
        paymentMethod: paymentAmount > 0 ? _paymentMethod : null,
      );

      if (result != null) {
        setState(() => _savedPurchase = result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase Invoice saved successfully.')));
        }
      } else {
        throw Exception('Failed to save purchase in database.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ERPCubit>().state;
    final pendingTrailas = state.trailas.where((t) => t.status == TrailaStatus.pending).toList();
    final currentBillTotal = _items.fold<double>(0, (sum, item) => sum + item.total);
    final prevOutstanding = widget.supplier.remainingBalance;

    return AlertDialog(
      title: const Text('New Purchase Invoice'),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String?>(
                      initialValue: _selectedTrailaId,
                      decoration: const InputDecoration(labelText: 'Select Traila (Optional)', helperText: 'Leave empty for general purchase'),
                      items: [
                        const DropdownMenuItem<String?>(value: null, child: Text('None (General)')),
                        ...pendingTrailas.map((t) => DropdownMenuItem<String?>(value: t.id, child: Text('${t.id} - ${t.name}'))),
                      ],
                      onChanged: (_isSaving || _savedPurchase != null) ? null : (v) => setState(() => _selectedTrailaId = v),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: (_isSaving || _savedPurchase != null) ? null : () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _selectedDate = picked);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Invoice Date'),
                        child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              if (_savedPurchase == null) ...[
                Row(
                  children: [
                    Expanded(flex: 2, child: TextField(controller: _itemNameController, decoration: const InputDecoration(labelText: 'Item Name'), enabled: !_isSaving)),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(controller: _qtyController, decoration: const InputDecoration(labelText: 'Qty'), keyboardType: TextInputType.number, enabled: !_isSaving)),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number, enabled: !_isSaving)),
                    IconButton(onPressed: _isSaving ? null : _addItem, icon: const Icon(Icons.add_circle, color: Colors.blue)),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              if (_items.isNotEmpty) ...[
                const Divider(),
                ..._items.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  return ListTile(
                    dense: true,
                    title: Text(item.name),
                    subtitle: Text('${item.quantity} x Rs. ${item.unitPrice.toStringAsFixed(0)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Rs. ${item.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (!_isSaving && _savedPurchase == null)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                            onPressed: () => setState(() => _items.removeAt(idx)),
                          ),
                      ],
                    ),
                  );
                }),
              ],
              const Divider(height: 32),
              if (_savedPurchase == null) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _paymentController,
                        decoration: const InputDecoration(labelText: 'Payment Made (Rs.)'),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                        enabled: !_isSaving,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _paymentMethod,
                        decoration: const InputDecoration(
                          labelText: 'Payment Method',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.payment_outlined),
                        ),
                        items: context.read<ERPCubit>().state.accounts.values
                            .map((a) => DropdownMenuItem(value: a.name, child: Text(a.name)))
                            .toList(),
                        onChanged: (_isSaving || _savedPurchase != null) ? null : (v) => setState(() => _paymentMethod = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Builder(builder: (context) {
                      final afterPurchase = prevOutstanding + currentBillTotal;
                      final payAmt = double.tryParse(_paymentController.text) ?? 0;
                      double updatedBalance;
                      if (payAmt > afterPurchase) {
                        updatedBalance = 0;
                      } else {
                        updatedBalance = afterPurchase - payAmt;
                      }

                      return Column(
                        children: [
                          _MathRow(label: 'Previous Balance', value: prevOutstanding),
                          _MathRow(label: 'Invoice Balance', value: currentBillTotal, prefix: '+'),
                          const Divider(height: 16),
                          _MathRow(
                            label: 'Total', 
                            value: afterPurchase,
                            isBold: true,
                          ),
                          if (payAmt > 0) ...[
                            _MathRow(label: 'Paid ($_paymentMethod)', value: payAmt, prefix: '-'),
                            const Divider(height: 16),
                            _MathRow(
                              label: 'New Balance', 
                              value: updatedBalance,
                              isBold: true,
                              color: updatedBalance > 0.01 ? Colors.red.shade700 : Colors.green.shade700,
                            ),
                          ],
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _isSaving ? null : () => Navigator.pop(context), child: const Text('Close')),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: (_isSaving || _savedPurchase != null) ? null : _handleSave,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: _isSaving 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Save'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _savedPurchase == null ? null : () async {
                final state = context.read<ERPCubit>().state;
                try {
                  final success = await ThermalPrinterService.printSupplierPurchase(
                    context,
                    supplier: widget.supplier,
                    purchase: _savedPurchase!,
                    profile: state.appProfile,
                    settings: state.printerSetting,
                  );
                  if (!context.mounted) return;
                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to print.')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase Invoice printed successfully.')));
                  }
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              icon: const Icon(Icons.print),
              label: const Text('Print Invoice'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _savedPurchase == null ? null : () async {
                if (widget.supplier.whatsappNumber.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('WhatsApp Number Missing'),
                      content: const Text('Please add a WhatsApp number for this supplier in the management screen.'),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                    ),
                  );
                  return;
                }
                
                try {
                  await WhatsAppService.sendSupplierPurchaseReceipt(
                    phone: widget.supplier.whatsappNumber,
                    supplierName: widget.supplier.name,
                    date: DateFormat('dd-MM-yyyy').format(_savedPurchase!.date),
                    items: _savedPurchase!.items,
                    previousBalance: _savedPurchase!.previousOutstanding,
                    paymentAmount: _savedPurchase!.paymentAmount,
                    newBalance: _savedPurchase!.updatedBalance,
                    paymentMethod: _savedPurchase!.paymentMethod,
                    profile: state.appProfile,
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              icon: const Icon(Icons.send_outlined),
              label: const Text('Send WhatsApp'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

class _MathRow extends StatelessWidget {
  final String label;
  final double value;
  final String? prefix;
  final bool isBold;
  final Color? color;

  const _MathRow({
    required this.label, 
    required this.value, 
    this.prefix,
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label, 
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 14 : 13,
              )
            ),
          ),
          Text(
            '${prefix ?? ""} Rs. ${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? (prefix == '+' ? Colors.red : (prefix == '-' ? Colors.green : Colors.black87)),
              fontSize: isBold ? 15 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentDialog extends StatefulWidget {
  final Supplier supplier;
  const _PaymentDialog({required this.supplier});
  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  final _amountController = TextEditingController();
  final _splitAccountControllers = <String, TextEditingController>{};
  String _method = 'Cash';
  DateTime _paymentDate = DateTime.now();
  bool _isSaving = false;
  Payment? _savedPayment;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ERPCubit>().state;
    final accounts = state.accounts.values.toList();

    return AlertDialog(
      title: Text('Record Payment Invoice: ${widget.supplier.name}'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: (_isSaving || _savedPayment != null) ? null : () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _paymentDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _paymentDate = picked);
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Payment Invoice Date'),
                child: Text(DateFormat('yyyy-MM-dd').format(_paymentDate)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _method,
              decoration: const InputDecoration(labelText: 'Payment Method'),
                items: [...context.read<ERPCubit>().state.accounts.values.map((a) => a.name), 'Split']
                    .map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (_isSaving || _savedPayment != null) ? null : (v) => setState(() => _method = v!),
            ),
            const SizedBox(height: 16),
            if (_method != 'Split')
              TextField(
                controller: _amountController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Amount Paid (Rs.)',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                enabled: !_isSaving && _savedPayment == null,
              )
            else ...[
              const Text('Split Accounts', style: TextStyle(fontWeight: FontWeight.bold)),
              ...accounts.map((acc) {
                _splitAccountControllers.putIfAbsent(acc.id, () => TextEditingController());
                return TextField(
                  controller: _splitAccountControllers[acc.id],
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(labelText: '${acc.name} Account Amount'),
                  keyboardType: TextInputType.number,
                  enabled: !_isSaving && _savedPayment == null,
                );
              }),
            ],
            // Real-time calculation preview to prevent minus balance confusion
            Builder(
              builder: (context) {
                double entered = 0;
                if (_method == 'Split') {
                  _splitAccountControllers.forEach((_, c) => entered += double.tryParse(c.text) ?? 0);
                } else {
                  entered = double.tryParse(_amountController.text) ?? 0;
                }
                final cur = widget.supplier.remainingBalance;
                final proj = cur - entered;

                return Container(
                  margin: const EdgeInsets.only(top: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: proj < 0 ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: proj < 0 ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Current Balance:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            cur < 0
                                ? 'Advance: Rs. ${NumberFormat("#,##0").format(cur.abs())}'
                                : 'Due: Rs. ${NumberFormat("#,##0").format(cur)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: cur < 0 ? const Color(0xFF16A34A) : const Color(0xFFB91C1C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Payment To Deduct:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            '- Rs. ${NumberFormat("#,##0").format(entered)}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                          ),
                        ],
                      ),
                      const Divider(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('New Balance:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          _buildBalanceBadge(proj, fontSize: 11),
                        ],
                      ),
                      if (proj < 0) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, size: 14, color: Color(0xFF15803D)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Advance Credit: Paying more than due records Rs. ${NumberFormat("#,##0").format(proj.abs())} as advance credit for future purchases.',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF14532D)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: _isSaving ? null : () => Navigator.pop(context), child: const Text('Close')),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: (_isSaving || _savedPayment != null) ? null : () async {
                double total = 0;
                List<SplitDetail>? splits;
                if (_method == 'Split') {
                  splits = [];
                  _splitAccountControllers.forEach((acc, ctrl) {
                    final val = double.tryParse(ctrl.text) ?? 0;
                    if (val > 0) {
                      splits!.add(SplitDetail(method: acc, amount: val));
                      total += val;
                    }
                  });
                } else {
                  total = double.tryParse(_amountController.text) ?? 0;
                }

                if (total <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount.')));
                  return;
                }

                if (total > widget.supplier.remainingBalance) {
                  final proceed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Overpayment Verification'),
                      content: Text('You are paying Rs. ${total.toStringAsFixed(0)}, which exceeds the current balance of Rs. ${widget.supplier.remainingBalance.toStringAsFixed(0)}.\n\nThe extra Rs. ${(total - widget.supplier.remainingBalance).toStringAsFixed(0)} will be recorded as an ADVANCE payment.\n\nDo you want to continue?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No, Cancel')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes, Record Advance')),
                      ],
                    ),
                  );
                  if (proceed != true) return;
                  if (!context.mounted) return;
                }

                setState(() => _isSaving = true);
                try {
                  final result = await context.read<ERPCubit>().addSupplierPayment(widget.supplier.id, Payment(
                    id: 'PAY-${DateTime.now().millisecondsSinceEpoch}',
                    amount: total,
                    date: _paymentDate,
                    method: _method,
                    splitDetails: splits,
                  ));
                  
                  setState(() => _savedPayment = result);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Invoice saved successfully.')));
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                } finally {
                  if (mounted) setState(() => _isSaving = false);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: _isSaving 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Save'),
            ),
            const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _savedPayment == null ? null : () async {
                  final state = context.read<ERPCubit>().state;
                  final latestSupplier = state.suppliers.firstWhere((s) => s.id == widget.supplier.id);
                  final prev = _savedPayment!.previousBalance ?? 0.0;
                  final remaining = _savedPayment!.updatedBalance ?? latestSupplier.remainingBalance;
                  
                  try {
                    final success = await ThermalPrinterService.printSupplierPayment(
                      context,
                      supplier: latestSupplier,
                      payment: _savedPayment!,
                      previousBalance: prev,
                      newBalance: remaining,
                      profile: state.appProfile,
                      settings: state.printerSetting,
                    );
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to print payment invoice.')));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))));
                    }
                  }
                },
                icon: const Icon(Icons.print),
                label: const Text('Print Invoice'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _savedPayment == null ? null : () async {
                  if (widget.supplier.whatsappNumber.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('WhatsApp Number Missing'),
                        content: const Text('Please add a WhatsApp number for this supplier in the management screen.'),
                        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                      ),
                    );
                    return;
                  }

                  try {
                    await WhatsAppService.sendSupplierPaymentReceipt(
                      phone: widget.supplier.whatsappNumber,
                      supplierName: widget.supplier.name,
                      date: DateFormat('dd-MM-yyyy').format(_savedPayment!.date),
                      paymentMethod: _savedPayment!.method,
                      paidAmount: _savedPayment!.amount,
                      previousBalance: _savedPayment!.previousBalance ?? 0.0,
                      newBalance: _savedPayment!.updatedBalance ?? 0.0,
                      profile: state.appProfile,
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    String message = e.toString();
                    if (message.startsWith('Exception: ')) {
                      message = message.substring(11);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                  }
                },
                icon: const Icon(Icons.send_outlined),
                label: const Text('Send WhatsApp'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white),
              ),
            ],
          ),
      ],
    );
  }
}

class _EditSupplierDialog extends StatefulWidget {
  final Supplier supplier;
  const _EditSupplierDialog({required this.supplier});

  @override
  State<_EditSupplierDialog> createState() => _EditSupplierDialogState();
}

class _EditSupplierDialogState extends State<_EditSupplierDialog> {
  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _shopNameController;
  late TextEditingController _phoneController;
  late TextEditingController _whatsappController;
  late TextEditingController _locationController;
  late TextEditingController _openingBalanceController;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.supplier.id);
    _nameController = TextEditingController(text: widget.supplier.name);
    _shopNameController = TextEditingController(text: widget.supplier.shopName);
    _phoneController = TextEditingController(text: widget.supplier.phone);
    _whatsappController = TextEditingController(text: widget.supplier.whatsappNumber);
    _locationController = TextEditingController(text: widget.supplier.location);
    _openingBalanceController = TextEditingController(text: widget.supplier.openingBalance.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _shopNameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _locationController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Supplier Profile'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: widget.supplier.id,
                  decoration: const InputDecoration(
                    labelText: 'Supplier ID (Unique)', 
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Supplier Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                ),
                TextFormField(
                  controller: _shopNameController,
                  decoration: const InputDecoration(labelText: 'Shop / Company Name'),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                TextFormField(
                  controller: _whatsappController,
                  decoration: const InputDecoration(labelText: 'WhatsApp Number'),
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextFormField(
                  controller: _openingBalanceController,
                  decoration: const InputDecoration(
                    labelText: 'Opening Balance (Baseline)',
                    helperText: 'Initial debt/credit when the profile was created.',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, 
            foregroundColor: Colors.white,
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 20, 
                  height: 20, 
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Save Changes'),
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final updatedSupplier = widget.supplier.copyWith(
        name: _nameController.text.trim(),
        shopName: _shopNameController.text.trim(),
        phone: _phoneController.text.trim(),
        whatsappNumber: _whatsappController.text.trim(),
        location: _locationController.text.trim(),
        openingBalance: double.tryParse(_openingBalanceController.text) ?? 0.0,
      );

      await context.read<ERPCubit>().updateSupplier(updatedSupplier);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Supplier profile updated successfully'), 
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating supplier: $e'), 
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

