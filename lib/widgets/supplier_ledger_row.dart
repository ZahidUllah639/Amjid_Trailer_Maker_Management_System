import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/supplier.dart';
import '../cubits/erp_cubit.dart';
import '../services/thermal_printer_service.dart';
import '../services/invoice_pdf_service.dart';
import 'print_preview_dialog.dart';

class SupplierLedgerRow extends StatefulWidget {
  final dynamic item;
  final Supplier supplier;
  final ValueChanged<String> onDeletePurchase;
  final ValueChanged<String> onDeletePayment;

  const SupplierLedgerRow({
    super.key,
    required this.item,
    required this.supplier,
    required this.onDeletePurchase,
    required this.onDeletePayment,
  });

  @override
  State<SupplierLedgerRow> createState() => _SupplierLedgerRowState();
}

class _SupplierLedgerRowState extends State<SupplierLedgerRow> {
  bool _isHovered = false;

  void _showDetailModal() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => SupplierRecordDetailModal(
        item: widget.item,
        supplier: widget.supplier,
        onDeletePurchase: widget.onDeletePurchase,
        onDeletePayment: widget.onDeletePayment,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isPurchase = item.purchase != null;
    final accentColor = isPurchase ? const Color(0xFF2563EB) : const Color(0xFF10B981);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: _showDetailModal,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isPurchase ? const Color(0xFFEFF6FF) : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isPurchase ? const Color(0xFFBFDBFE) : const Color(0xFFBBF7D0),
                  ),
                ),
                child: Icon(
                  isPurchase ? Icons.shopping_bag_outlined : Icons.payments_rounded,
                  color: accentColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),

              // 2. Type Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: isPurchase ? const Color(0xFFEFF6FF) : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isPurchase ? const Color(0xFFBFDBFE) : const Color(0xFFBBF7D0),
                  ),
                ),
                child: Text(
                  isPurchase ? 'PURCHASE' : 'PAYMENT',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: isPurchase ? const Color(0xFF1E40AF) : const Color(0xFF15803D),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Bill Number / Ref Title
              Text(
                item.refTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),

              if (item.purchase?.trailaId != null && item.purchase!.trailaId!.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_shipping_outlined, size: 11, color: Color(0xFF475569)),
                      const SizedBox(width: 3),
                      Text(
                        'Traila #${item.purchase!.trailaId}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(width: 14),

              // Date
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time_rounded, size: 12, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(item.date),
                    style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Summary
              Expanded(
                child: Text(
                  isPurchase && item.purchase != null
                      ? item.purchase!.items.map((i) => i.name).join(', ')
                      : item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Amount & Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${isPurchase ? "+" : "-"} Rs. ${NumberFormat("#,##0").format(item.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: isPurchase ? const Color(0xFF0F172A) : const Color(0xFF16A34A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _buildBalancePill(item.runningBalance),
                ],
              ),
              const SizedBox(width: 12),

              // View Affordance
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: _isHovered ? const Color(0xFFEEF2FF) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _isHovered ? const Color(0xFFC7D2FE) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _isHovered ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: _isHovered ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalancePill(double balance) {
    final isAdvance = balance < -0.01;
    final isClear = balance.abs() <= 0.01;
    final bg = isClear ? const Color(0xFFF1F5F9) : (isAdvance ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE));
    final fg = isClear ? const Color(0xFF475569) : (isAdvance ? const Color(0xFF2E7D32) : const Color(0xFFC62828));
    final text = isClear
        ? 'Settled'
        : (isAdvance ? 'Adv: Rs. ${NumberFormat("#,##0").format(balance.abs())}' : 'Due: Rs. ${NumberFormat("#,##0").format(balance)}');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}

class SupplierRecordDetailModal extends StatefulWidget {
  final dynamic item;
  final Supplier supplier;
  final ValueChanged<String> onDeletePurchase;
  final ValueChanged<String> onDeletePayment;

  const SupplierRecordDetailModal({
    super.key,
    required this.item,
    required this.supplier,
    required this.onDeletePurchase,
    required this.onDeletePayment,
  });

  @override
  State<SupplierRecordDetailModal> createState() => _SupplierRecordDetailModalState();
}

class _SupplierRecordDetailModalState extends State<SupplierRecordDetailModal> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isPurchase = item.purchase != null;
    final accentColor = isPurchase ? const Color(0xFF2563EB) : const Color(0xFF10B981);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        width: _isExpanded ? 920 : 660,
        constraints: const BoxConstraints(maxHeight: 780),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 36,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Modal Titlebar with Window Controls
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: isPurchase ? const Color(0xFFF8FAFC) : const Color(0xFFF0FDF4),
                  border: Border(
                    bottom: BorderSide(color: isPurchase ? const Color(0xFFE2E8F0) : const Color(0xFFDCFCE7)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isPurchase ? const Color(0xFFEFF6FF) : const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isPurchase ? const Color(0xFFBFDBFE) : const Color(0xFF86EFAC),
                        ),
                      ),
                      child: Icon(
                        isPurchase ? Icons.shopping_bag_outlined : Icons.payments_rounded,
                        color: accentColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                isPurchase ? 'Purchase Bill Invoice' : 'Supplier Payment Voucher',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: accentColor.withValues(alpha: 0.25)),
                                ),
                                child: Text(
                                  item.refTitle,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('EEEE, dd MMM yyyy • hh:mm a').format(item.date),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Dedicated Window Controls (Minimize, Maximize, Close)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Minimize / Dismiss
                          Tooltip(
                            message: 'Minimize / Dismiss',
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                width: 30,
                                height: 26,
                                alignment: Alignment.center,
                                child: const Icon(Icons.remove_rounded, size: 16, color: Color(0xFF64748B)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),

                          // Maximize Toggle
                          Tooltip(
                            message: _isExpanded ? 'Restore View' : 'Maximize View',
                            child: InkWell(
                              onTap: () => setState(() => _isExpanded = !_isExpanded),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                width: 30,
                                height: 26,
                                alignment: Alignment.center,
                                child: Icon(
                                  _isExpanded ? Icons.filter_none_rounded : Icons.crop_square_rounded,
                                  size: _isExpanded ? 13 : 15,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),

                          // Close Cross
                          Tooltip(
                            message: 'Close',
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                width: 30,
                                height: 26,
                                alignment: Alignment.center,
                                child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF64748B)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Scrollable Modal Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Financial Card with 3-Stage Balance Audit Flow
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isPurchase
                                ? [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)]
                                : [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isPurchase ? const Color(0xFFBFDBFE) : const Color(0xFFBBF7D0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isPurchase ? 'PURCHASE BILL TOTAL' : 'PAYMENT DISBURSED TO SUPPLIER',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: accentColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${isPurchase ? "+" : "-"} Rs. ${NumberFormat("#,##0").format(item.amount)}',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.6,
                                        color: isPurchase ? const Color(0xFF0F172A) : const Color(0xFF15803D),
                                      ),
                                    ),
                                  ],
                                ),
                                _buildBalanceBadge(item.runningBalance),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1, color: Color(0x33000000)),
                            const SizedBox(height: 12),
                            // 3-Stage Balance Audit Flow
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Previous Balance', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Rs. ${NumberFormat("#,##0").format(item.previousBalance)}',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_rounded, size: 16, color: accentColor),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(isPurchase ? 'Bill Amount' : 'Amount Paid', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${isPurchase ? "+" : "-"} Rs. ${NumberFormat("#,##0").format(item.amount)}',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: accentColor),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_rounded, size: 16, color: accentColor),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Closing Balance', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Rs. ${NumberFormat("#,##0").format(item.runningBalance)}',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Key Parameters Matrix
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailCard(
                              icon: Icons.storefront_outlined,
                              label: 'Vendor / Supplier',
                              value: widget.supplier.name,
                              subValue: 'ID: ${widget.supplier.id}',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildDetailCard(
                              icon: Icons.local_shipping_outlined,
                              label: 'Associated Traila Unit',
                              value: (item.purchase?.trailaId != null && item.purchase!.trailaId!.isNotEmpty)
                                  ? 'Traila #${item.purchase!.trailaId}'
                                  : 'General Inventory Stock',
                              subValue: isPurchase ? 'Raw Materials / Parts' : (item.payment?.method ?? 'Cash'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // If Purchase: Itemized Goods Table
                      if (isPurchase && item.purchase != null) ...[
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                color: const Color(0xFFF8FAFC),
                                child: Row(
                                  children: [
                                    const Icon(Icons.list_alt_rounded, size: 16, color: Color(0xFF475569)),
                                    const SizedBox(width: 8),
                                    Text(
                                      'PURCHASED RAW MATERIALS (${item.purchase!.items.length} ITEMS)',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.6,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1, color: Color(0xFFE2E8F0)),
                              ...item.purchase!.items.map((it) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                                ),
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
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        it.name,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                                      ),
                                    ),
                                    Text(
                                      '${it.quantity} pcs  ×  Rs. ${NumberFormat("#,##0").format(it.unitPrice)}  ➔  ',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                    ),
                                    Text(
                                      'Rs. ${NumberFormat("#,##0").format(it.total)}',
                                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                                    ),
                                  ],
                                ),
                              )),
                              if (item.purchase!.paymentAmount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  color: const Color(0xFFF0FDF4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Paid on Spot via ${item.purchase!.paymentMethod}',
                                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF15803D)),
                                      ),
                                      Text(
                                        '- Rs. ${NumberFormat("#,##0").format(item.purchase!.paymentAmount)}',
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF15803D)),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],

                      // If Payment: Payment Remarks / Split Channels
                      if (!isPurchase && item.payment != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.notes_rounded, size: 16, color: Color(0xFF475569)),
                                  SizedBox(width: 8),
                                  Text(
                                    'PAYMENT DETAILS & DISBURSEMENT CHANNELS',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                      color: Color(0xFF475569),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item.subtitle,
                                style: const TextStyle(fontSize: 13.5, height: 1.5, color: Color(0xFF1E293B), fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // 3. Action Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  border: Border(
                    top: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
                child: Row(
                  children: [
                    // Delete Button
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        if (isPurchase && item.purchase != null) {
                          widget.onDeletePurchase(item.purchase!.id);
                        } else if (!isPurchase && item.payment != null) {
                          widget.onDeletePayment(item.payment!.id);
                        }
                      },
                      icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEF4444)),
                      label: const Text('Delete Entry', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w700, fontSize: 12.5)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFECACA)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const Spacer(),

                    // Thermal Receipt (58/80mm)
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
                      icon: const Icon(Icons.receipt_rounded, size: 16),
                      label: const Text('Thermal Receipt (58/80mm)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F172A),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // PDF Invoice
                    ElevatedButton.icon(
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
                      icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                      label: const Text('PDF Invoice', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Close
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF64748B),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceBadge(double balance) {
    final isAdvance = balance < -0.01;
    final isClear = balance.abs() <= 0.01;
    final bg = isClear ? const Color(0xFFF1F5F9) : (isAdvance ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE));
    final fg = isClear ? const Color(0xFF475569) : (isAdvance ? const Color(0xFF2E7D32) : const Color(0xFFC62828));
    final text = isClear
        ? 'Fully Settled'
        : (isAdvance ? 'Advance Credit: Rs. ${NumberFormat("#,##0").format(balance.abs())}' : 'Balance Due: Rs. ${NumberFormat("#,##0").format(balance)}');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    required String subValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Icon(icon, size: 17, color: const Color(0xFF475569)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                const SizedBox(height: 1),
                Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(subValue, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
