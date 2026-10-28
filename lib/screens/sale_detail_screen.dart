import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/sale.dart';
import '../models/buyer.dart';
import '../models/payment.dart';
import '../models/traila.dart';
import '../services/thermal_printer_service.dart';
import '../services/invoice_pdf_service.dart';
import '../services/whatsapp_service.dart';
import '../widgets/print_preview_dialog.dart';

class SaleDetailScreen extends StatelessWidget {
  final String saleId;
  const SaleDetailScreen({super.key, required this.saleId});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0');
    final dateFormat = DateFormat('dd MMM yyyy');

    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final sale = state.sales.firstWhere(
          (s) => s.id == saleId,
          orElse: () => Sale(
            id: '?',
            trailaId: '?',
            buyerId: '?',
            salePrice: 0,
            manufacturingCost: 0,
            profit: 0,
            saleDate: DateTime.now(),
            totalPaid: 0,
            remainingBalance: 0,
            status: SaleStatus.pending,
            receiptNumber: 'N/A',
          ),
        );

        if (sale.id == '?') {
          return const Scaffold(body: Center(child: Text('Sale record not found')));
        }

        final buyer = state.buyers.firstWhere(
          (b) => b.id == sale.buyerId,
          orElse: () => Buyer(id: '?', name: 'Unknown', phone: '', cnic: '', address: ''),
        );

        final traila = state.trailas.firstWhere(
          (t) => t.id == sale.trailaId,
          orElse: () => Traila(
            id: sale.trailaId,
            name: 'Traila #${sale.trailaId}',
            registrationDate: DateTime.now(),
            status: TrailaStatus.ready,
          ),
        );

        final isPaid = sale.status == SaleStatus.paid;
        final progress = sale.salePrice > 0 ? (sale.totalPaid / sale.salePrice).clamp(0.0, 1.0) : 0.0;
        final profitMargin = sale.salePrice > 0 ? ((sale.profit / sale.salePrice) * 100).toStringAsFixed(1) : '0';

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    sale.receiptNumber ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF4F46E5),
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice for ${buyer.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Sold on ${dateFormat.format(sale.saleDate)}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              _buildStatusPill(sale.status),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final s = context.read<ERPCubit>().state;
                  final pdfBytes = await InvoicePdfService.generateSalePdf(
                    sale: sale,
                    buyer: buyer,
                    trailaName: traila.name,
                    profile: s.appProfile,
                  );
                  if (context.mounted) {
                    await PrintPreviewDialog.show(
                      context,
                      pdfBytes,
                      'Invoice_${sale.receiptNumber}.pdf',
                    );
                  }
                },
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 16, color: Color(0xFFEF4444)),
                label: const Text('A4 PDF', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  final s = context.read<ERPCubit>().state;
                  try {
                    final success = await ThermalPrinterService.printReceipt(
                      context,
                      sale: sale,
                      buyer: buyer,
                      traila: traila,
                      profile: s.appProfile,
                      settings: s.printerSetting,
                      printDuplicate: true,
                    );
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to print receipt.')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.print_rounded, size: 16),
                label: const Text('POS Thermal', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF64748B)),
                onSelected: (val) {
                  if (val == 'edit') {
                    _showEditSaleDialog(context, sale);
                  } else if (val == 'delete') {
                    _showDeleteSaleConfirmation(context, sale);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 16, color: Color(0xFF4F46E5)),
                        SizedBox(width: 8),
                        Text('Edit Sale Details'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEF4444)),
                        SizedBox(width: 8),
                        Text('Delete Invoice'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Financial Overview Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TOTAL SALE CONTRACT VALUE',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Rs. ${currencyFormat.format(sale.salePrice)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 10,
                            children: [
                              if (!isPaid)
                                ElevatedButton.icon(
                                  onPressed: () => _showPaymentDialog(context, sale),
                                  icon: const Icon(Icons.add_card_rounded, size: 18),
                                  label: const Text('Collect Payment', style: TextStyle(fontWeight: FontWeight.w700)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    elevation: 0,
                                  ),
                                ),
                              OutlinedButton.icon(
                                onPressed: () async {
                                  final s = context.read<ERPCubit>().state;
                                  try {
                                    final success = await ThermalPrinterService.printSaleStatement(
                                      context,
                                      sale: sale,
                                      buyer: buyer,
                                      trailaName: traila.name,
                                      profile: s.appProfile,
                                      settings: s.printerSetting,
                                    );
                                    if (!success && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Failed to print statement.')),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.receipt_long_rounded, size: 16, color: Colors.white70),
                                label: const Text('Statement', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (buyer.whatsappNumber.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('No WhatsApp number saved for this buyer.')),
                                    );
                                    return;
                                  }
                                  final s = context.read<ERPCubit>().state;
                                  try {
                                    await WhatsAppService.sendSaleReceipt(
                                      phone: buyer.whatsappNumber,
                                      buyerName: buyer.name,
                                      date: DateFormat('dd-MM-yyyy').format(sale.saleDate),
                                      trailaName: traila.name,
                                      sale: sale,
                                      buyer: buyer,
                                      payments: sale.payments,
                                      profile: s.appProfile,
                                    );
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                    }
                                  }
                                },
                                icon: const Icon(Icons.chat_bubble_rounded, size: 16),
                                label: const Text('WhatsApp Invoice', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF059669),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Metric Strip
                      Row(
                        children: [
                          Expanded(
                            child: _BannerMetric(
                              label: 'Total Received',
                              amount: 'Rs. ${currencyFormat.format(sale.totalPaid)}',
                              color: const Color(0xFF34D399),
                              icon: Icons.check_circle_outline_rounded,
                            ),
                          ),
                          Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.1)),
                          Expanded(
                            child: _BannerMetric(
                              label: 'Remaining Receivable',
                              amount: 'Rs. ${currencyFormat.format(sale.remainingBalance)}',
                              color: sale.remainingBalance > 0 ? const Color(0xFFF87171) : const Color(0xFF94A3B8),
                              icon: Icons.pending_actions_rounded,
                            ),
                          ),
                          Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.1)),
                          Expanded(
                            child: _BannerMetric(
                              label: 'Payment Progress',
                              amount: '${(progress * 100).toStringAsFixed(0)}% Settled',
                              color: const Color(0xFF38BDF8),
                              icon: Icons.pie_chart_outline_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. Buyer Profile & Internal Profit Audit (Two Cards)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    return isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 5, child: _buildBuyerCard(context, buyer)),
                              const SizedBox(width: 24),
                              Expanded(flex: 5, child: _buildAuditCard(sale, traila, profitMargin)),
                            ],
                          )
                        : Column(
                            children: [
                              _buildBuyerCard(context, buyer),
                              const SizedBox(height: 20),
                              _buildAuditCard(sale, traila, profitMargin),
                            ],
                          );
                  },
                ),

                const SizedBox(height: 28),

                // 3. Payment History Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Installment & Payment History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${sale.payments.length} INSTALLMENTS',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!isPaid)
                      TextButton.icon(
                        onPressed: () => _showPaymentDialog(context, sale),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add Payment'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF10B981),
                          textStyle: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                if (sale.payments.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.payments_outlined, size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text(
                            'No payment installments recorded yet',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Click "Collect Payment" to record customer advance or partial payout.',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF64748B).withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sale.payments.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      itemBuilder: (context, index) {
                        final p = sale.payments[index];
                        return _PaymentTile(
                          payment: p,
                          sale: sale,
                          buyer: buyer,
                          traila: traila,
                          onEdit: () => _showEditPaymentDialog(context, sale.id, p),
                          onDelete: () => _showDeletePaymentConfirmation(context, sale.id, p),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusPill(SaleStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case SaleStatus.paid:
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF15803D);
        label = 'FULLY PAID';
        break;
      case SaleStatus.partial:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        label = 'PARTIAL BALANCE';
        break;
      case SaleStatus.pending:
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFB91C1C);
        label = 'UNPAID';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildBuyerCard(BuildContext context, Buyer buyer) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.person_rounded, color: Color(0xFF4F46E5), size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Buyer Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _showEditBuyerDialog(context, buyer),
                    icon: const Icon(Icons.edit_rounded, size: 18, color: Color(0xFF4F46E5)),
                    tooltip: 'Edit Buyer Profile',
                  ),
                  IconButton(
                    onPressed: () => _showDeleteBuyerConfirmation(context, buyer),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF4444)),
                    tooltip: 'Delete Buyer Profile',
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          _InfoLine(
            icon: Icons.qr_code_2_rounded,
            label: 'Customer ID / Code',
            value: buyer.id,
            isBold: true,
            isMonospace: true,
            color: const Color(0xFF4F46E5),
          ),
          const SizedBox(height: 10),
          _InfoLine(icon: Icons.person_outline_rounded, label: 'Full Name', value: buyer.name, isBold: true),
          const SizedBox(height: 10),
          _InfoLine(icon: Icons.phone_outlined, label: 'Phone Contact', value: buyer.phone.isEmpty ? '—' : buyer.phone),
          const SizedBox(height: 10),
          _InfoLine(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'WhatsApp',
            value: buyer.whatsappNumber.isEmpty ? 'Not Provided' : buyer.whatsappNumber,
            color: buyer.whatsappNumber.isNotEmpty ? const Color(0xFF059669) : null,
          ),
          const SizedBox(height: 10),
          _InfoLine(icon: Icons.badge_outlined, label: 'National CNIC', value: buyer.cnic.isEmpty ? 'Not Provided' : buyer.cnic),
          const SizedBox(height: 10),
          _InfoLine(icon: Icons.local_shipping_outlined, label: 'Delivery Address', value: buyer.address.isEmpty ? 'Not Provided' : buyer.address),
        ],
      ),
    );
  }

  Widget _buildAuditCard(Sale sale, dynamic traila, String profitMargin) {
    final currencyFormat = NumberFormat('#,##0');
    final dateFormat = DateFormat('dd MMM yyyy');
    final isProfitable = sale.profit >= 0;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.analytics_rounded, color: Color(0xFF10B981), size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Manufacturing & Profit Audit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isProfitable ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isProfitable ? '+$profitMargin% MARGIN' : '$profitMargin% LOSS',
                  style: TextStyle(
                    color: isProfitable ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _InfoLine(icon: Icons.tag_rounded, label: 'Traila Unit ID', value: sale.trailaId, isMonospace: true),
          const SizedBox(height: 10),
          _InfoLine(icon: Icons.precision_manufacturing_rounded, label: 'Unit Name / Spec', value: traila.name),
          const SizedBox(height: 10),
          _InfoLine(icon: Icons.calendar_today_rounded, label: 'Sale Date', value: dateFormat.format(sale.saleDate)),
          const SizedBox(height: 10),
          _InfoLine(
            icon: Icons.build_circle_outlined,
            label: 'Workshop Build Cost',
            value: 'Rs. ${currencyFormat.format(sale.manufacturingCost)}',
            color: const Color(0xFF64748B),
          ),
          const SizedBox(height: 10),
          _InfoLine(
            icon: Icons.monetization_on_outlined,
            label: 'Contract Sale Price',
            value: 'Rs. ${currencyFormat.format(sale.salePrice)}',
            isBold: true,
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Calculated Net Profit', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              Text(
                'Rs. ${currencyFormat.format(sale.profit)}',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                  color: isProfitable ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, Sale sale) {
    showDialog(context: context, builder: (context) => _SalePaymentDialog(sale: sale));
  }

  void _showEditBuyerDialog(BuildContext context, Buyer buyer) {
    showDialog(context: context, builder: (context) => _EditBuyerDialog(buyer: buyer));
  }

  void _showDeleteBuyerConfirmation(BuildContext context, Buyer buyer) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Buyer?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('This will delete ${buyer.name} and sales associated with them.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final cubit = context.read<ERPCubit>();
              Navigator.pop(dialogCtx);
              await cubit.deleteBuyer(buyer.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Buyer ${buyer.name} deleted')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  void _showDeleteSaleConfirmation(BuildContext context, Sale sale) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Sale Record?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          'This will permanently delete this sale record, all installments, and restore the Traila unit to "Ready for Sale".',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            onPressed: () async {
              await context.read<ERPCubit>().deleteSale(sale.id);
              if (!context.mounted) return;
              Navigator.pop(dialogCtx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sale record deleted successfully')),
              );
            },
            child: const Text('Delete Record'),
          ),
        ],
      ),
    );
  }

  void _showEditPaymentDialog(BuildContext context, String saleId, Payment payment) {
    showDialog(context: context, builder: (context) => _EditSalePaymentDialog(saleId: saleId, payment: payment));
  }

  void _showDeletePaymentConfirmation(BuildContext context, String saleId, Payment payment) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Payment?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('Delete this payment of Rs. ${payment.amount.toStringAsFixed(0)}? Balance will be restored.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await context.read<ERPCubit>().deleteSalePayment(saleId, payment);
              if (dialogCtx.mounted) Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditSaleDialog(BuildContext context, Sale sale) {
    final priceController = TextEditingController(text: sale.salePrice.toStringAsFixed(0));
    DateTime selectedDate = sale.saleDate;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('Edit Sale Details', style: TextStyle(fontWeight: FontWeight.w800)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Actual Sale Price (Rs.)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.currency_exchange_rounded),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: dialogCtx,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setDialogState(() => selectedDate = picked);
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Sale Date',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.calendar_today_rounded),
                  ),
                  child: Text(DateFormat('dd MMMM yyyy').format(selectedDate)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final price = double.tryParse(priceController.text.trim()) ?? 0;
                await context.read<ERPCubit>().updateSaleDetails(
                      saleId: sale.id,
                      price: price,
                      date: selectedDate,
                    );
                if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerMetric extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final IconData icon;

  const _BannerMetric({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(
                amount,
                style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isBold;
  final bool isMonospace;
  final IconData? icon;

  const _InfoLine({
    required this.label,
    required this.value,
    this.color,
    this.isBold = false,
    this.isMonospace = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: const Color(0xFF64748B)),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
              fontFamily: isMonospace ? 'Courier' : null,
              color: color ?? const Color(0xFF0F172A),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatefulWidget {
  final Payment payment;
  final Sale sale;
  final Buyer buyer;
  final dynamic traila;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PaymentTile({
    required this.payment,
    required this.sale,
    required this.buyer,
    required this.traila,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_PaymentTile> createState() => _PaymentTileState();
}

class _PaymentTileState extends State<_PaymentTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0');
    final dateFormat = DateFormat('dd MMM yyyy');

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: const Icon(Icons.arrow_downward_rounded, color: Color(0xFF15803D), size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Rs. ${currencyFormat.format(widget.payment.amount)}',
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF059669),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Text(
                          widget.payment.method.toUpperCase(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
                        ),
                      ),
                      if (widget.payment.receiptNumber != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.payment.receiptNumber!,
                            style: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Recorded on ${dateFormat.format(widget.payment.date)} • Payment Voucher Verified',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    final state = context.read<ERPCubit>().state;
                    try {
                      final success = await ThermalPrinterService.printSalePayment(
                        context,
                        sale: widget.sale,
                        buyer: widget.buyer,
                        payment: widget.payment,
                        trailaName: widget.traila.name,
                        profile: state.appProfile,
                        settings: state.printerSetting,
                      );
                      if (!success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to print payment receipt.')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.print_rounded, size: 17, color: Color(0xFF0284C7)),
                  tooltip: 'Print Thermal Receipt',
                ),
                IconButton(
                  onPressed: () async {
                    if (widget.buyer.whatsappNumber.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No WhatsApp number saved for this buyer.')),
                      );
                      return;
                    }
                    final state = context.read<ERPCubit>().state;
                    try {
                      await WhatsAppService.sendSalePaymentReceipt(
                        phone: widget.buyer.whatsappNumber,
                        sale: widget.sale,
                        buyer: widget.buyer,
                        payment: widget.payment,
                        trailaName: widget.traila.name,
                        profile: state.appProfile,
                        paperSize: state.printerSetting.paperSize,
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  icon: const Icon(Icons.chat_bubble_rounded, size: 17, color: Color(0xFF059669)),
                  tooltip: 'Send via WhatsApp',
                ),
                IconButton(
                  onPressed: widget.onEdit,
                  icon: const Icon(Icons.edit_rounded, size: 17, color: Color(0xFF4F46E5)),
                  tooltip: 'Edit Payment',
                ),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, size: 17, color: Color(0xFFEF4444)),
                  tooltip: 'Delete Payment',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditBuyerDialog extends StatefulWidget {
  final Buyer buyer;
  const _EditBuyerDialog({required this.buyer});
  @override
  State<_EditBuyerDialog> createState() => _EditBuyerDialogState();
}

class _EditBuyerDialogState extends State<_EditBuyerDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _cnicController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.buyer.name;
    _phoneController.text = widget.buyer.phone;
    _whatsappController.text = widget.buyer.whatsappNumber;
    _cnicController.text = widget.buyer.cnic;
    _addressController.text = widget.buyer.address;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _cnicController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text('Edit Buyer Profile', style: TextStyle(fontWeight: FontWeight.w800)),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: widget.buyer.id,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Customer Identifier / Code (Permanent)',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFC7D2FE)),
                    ),
                    child: const Text('AUTO', style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Customer Full Name *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _whatsappController,
                decoration: InputDecoration(
                  labelText: 'WhatsApp Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _cnicController,
                decoration: InputDecoration(
                  labelText: 'CNIC / National ID',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Delivery / Residence Address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final updated = widget.buyer.copyWith(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              whatsappNumber: _whatsappController.text.trim(),
              cnic: _cnicController.text.trim(),
              address: _addressController.text.trim(),
            );
            await context.read<ERPCubit>().updateBuyer(updated);
            if (context.mounted) Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
          ),
          child: const Text('Save Profile'),
        ),
      ],
    );
  }
}

class _SalePaymentDialog extends StatefulWidget {
  final Sale sale;
  const _SalePaymentDialog({required this.sale});
  @override
  State<_SalePaymentDialog> createState() => _SalePaymentDialogState();
}

class _SalePaymentDialogState extends State<_SalePaymentDialog> {
  final _amountController = TextEditingController();
  String _method = 'Cash';
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0');
    final accounts = context.read<ERPCubit>().state.accounts.values.toList();
    if (_method == 'Cash' && accounts.isNotEmpty && !accounts.any((a) => a.name == _method)) {
      _method = accounts.first.name;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text('Collect Sale Payment', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Remaining Receivable:', style: TextStyle(color: Color(0xFF991B1B), fontWeight: FontWeight.w600)),
                  Text(
                    'Rs. ${currencyFormat.format(widget.sale.remainingBalance)}',
                    style: const TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Amount Received (Rs.) *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.currency_exchange_rounded),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _method,
              decoration: InputDecoration(
                labelText: 'Deposit Destination / Account *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.account_balance_rounded),
              ),
              items: accounts
                  .map((a) => DropdownMenuItem(value: a.name, child: Text(a.name)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _method = v);
              },
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Payment Date',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.calendar_today_rounded),
                ),
                child: Text(DateFormat('dd MMMM yyyy').format(_date)),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(_amountController.text.trim()) ?? 0;
            if (amount <= 0 || amount > widget.sale.remainingBalance) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid amount not exceeding the balance')),
              );
              return;
            }

            final p = Payment(
              id: 'PAY-${DateTime.now().millisecondsSinceEpoch}',
              amount: amount,
              date: _date,
              method: _method,
            );
            context.read<ERPCubit>().addSalePayment(widget.sale.id, p);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
          ),
          child: const Text('Confirm Payment'),
        ),
      ],
    );
  }
}

class _EditSalePaymentDialog extends StatefulWidget {
  final String saleId;
  final Payment payment;
  const _EditSalePaymentDialog({required this.saleId, required this.payment});
  @override
  State<_EditSalePaymentDialog> createState() => _EditSalePaymentDialogState();
}

class _EditSalePaymentDialogState extends State<_EditSalePaymentDialog> {
  late TextEditingController _amountController;
  late String _method;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.payment.amount.toStringAsFixed(0));
    _method = widget.payment.method;
    _date = widget.payment.date;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accounts = context.read<ERPCubit>().state.accounts.values.toList();
    if (!accounts.any((a) => a.name == _method) && accounts.isNotEmpty) {
      _method = accounts.first.name;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text('Edit Sale Payment', style: TextStyle(fontWeight: FontWeight.w800)),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount Received (Rs.)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.currency_exchange_rounded),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _method,
              decoration: InputDecoration(
                labelText: 'Payment Account',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: accounts
                  .map((a) => DropdownMenuItem(value: a.name, child: Text(a.name)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _method = v);
              },
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Payment Date',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.calendar_today_rounded),
                ),
                child: Text(DateFormat('dd MMMM yyyy').format(_date)),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(_amountController.text.trim()) ?? 0;
            if (amount <= 0) return;

            final updated = widget.payment.copyWith(
              amount: amount,
              date: _date,
              method: _method,
            );
            context.read<ERPCubit>().updateSalePayment(widget.saleId, widget.payment, updated);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
          ),
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}
