import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/labour.dart';
import '../models/payment.dart';
import '../models/traila.dart';
import '../services/thermal_printer_service.dart';
import '../services/invoice_pdf_service.dart';
import '../services/whatsapp_service.dart';
import '../widgets/print_preview_dialog.dart';

class LabourProfileScreen extends StatelessWidget {
  final String labourId;
  const LabourProfileScreen({super.key, required this.labourId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final labour = state.labours.firstWhere(
          (l) => l.id == labourId,
          orElse: () => Labour(
            id: 'Error',
            name: 'Not Found',
            phone: '',
            address: '',
            registrationDate: DateTime.now(),
          ),
        );
        
        if (labour.id == 'Error') {
          return const Scaffold(body: Center(child: Text('Labourer not found')));
        }
        
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: Text('Labour Ledger: ${labour.name} (${labour.id})'),
            actions: [
              IconButton(
                onPressed: () => _showEditLabourDialog(context, labour),
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Profile',
              ),
              IconButton(
                onPressed: () async {
                  final state = context.read<ERPCubit>().state;
                  final pdfBytes = await InvoicePdfService.generateStatementPdf(
                    personName: labour.name,
                    type: "Labour",
                    date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                    remainingBalance: labour.remainingBalance,
                    profile: state.appProfile,
                  );
                  if (!context.mounted) return;
                  await PrintPreviewDialog.show(
                    context, 
                    pdfBytes, 
                    'Statement_${labour.name}.pdf',
                  );
                },
                icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.red),
                tooltip: 'Save Statement as PDF',
              ),
              IconButton(
                onPressed: () async {
                  final state = context.read<ERPCubit>().state;
                  try {
                    final success = await ThermalPrinterService.printLabourStatement(
                      context,
                      labour: labour,
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
                    _showEditLabourDialog(context, labour);
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context, labour);
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
              final isDesktop = constraints.maxWidth >= 960;

              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Fixed Panel: Identity, Financial Metrics, Action Hub
                    SizedBox(
                      width: 380,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildLabourIdentityCard(context, labour),
                            const SizedBox(height: 16),
                            _buildFinancialOverview(labour),
                            const SizedBox(height: 16),
                            _buildActionHub(context, labour),
                          ],
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                    // Right Expanded Panel: Unified Ledger Statement
                    Expanded(
                      child: _UnifiedLabourLedger(labour: labour),
                    ),
                  ],
                );
              } else {
                // Mobile / Tablet Responsive Stack
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildLabourIdentityCard(context, labour),
                      const SizedBox(height: 16),
                      _buildFinancialOverview(labour),
                      const SizedBox(height: 16),
                      _buildActionHub(context, labour),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 600,
                        child: _UnifiedLabourLedger(labour: labour),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildLabourIdentityCard(BuildContext context, Labour labour) {
    final initials = labour.name.trim().isNotEmpty
        ? labour.name.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join('').toUpperCase()
        : 'LB';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.02),
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
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFEFF6FF),
                child: Text(
                  initials,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1D4ED8)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labour.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'ID: ${labour.id}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF64748B)),
                onPressed: () => _showEditLabourDialog(context, labour),
                tooltip: 'Edit Profile',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          if (labour.phone.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 8),
                Text(labour.phone, style: const TextStyle(fontSize: 13, color: Color(0xFF334155))),
                const Spacer(),
                if (labour.whatsappNumber.isNotEmpty || labour.phone.isNotEmpty)
                  InkWell(
                    onTap: () async {
                      final wa = labour.whatsappNumber.isNotEmpty ? labour.whatsappNumber : labour.phone;
                      final state = context.read<ERPCubit>().state;
                      try {
                        await WhatsAppService.sendLabourStatement(
                          phone: wa,
                          personName: labour.name,
                          remainingBalance: labour.remainingBalance,
                          profile: state.appProfile,
                        );
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat, size: 12, color: Color(0xFF16A34A)),
                          SizedBox(width: 4),
                          Text('WhatsApp', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (labour.address.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(labour.address, style: const TextStyle(fontSize: 13, color: Color(0xFF334155))),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFinancialOverview(Labour labour) {
    final balance = labour.remainingBalance;
    final isAdvance = balance < -0.01;
    final isDue = balance > 0.01;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WAGE ACCOUNT SUMMARY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.engineering_outlined, size: 14, color: Color(0xFF475569)),
                          SizedBox(width: 4),
                          Text('Wages Earned', style: TextStyle(fontSize: 11, color: Color(0xFF475569), fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rs. ${NumberFormat("#,##0").format(labour.totalPayable)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDCFCE7)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle_outline_rounded, size: 14, color: Color(0xFF16A34A)),
                          SizedBox(width: 4),
                          Text('Wages Paid', style: TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rs. ${NumberFormat("#,##0").format(labour.totalPaid)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF166534)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Net Balance Spotlight Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isAdvance
                  ? const Color(0xFFECFDF5)
                  : (isDue ? const Color(0xFFFEF2F2) : const Color(0xFFF8FAFC)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isAdvance
                    ? const Color(0xFFA7F3D0)
                    : (isDue ? const Color(0xFFFECACA) : const Color(0xFFE2E8F0)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAdvance
                          ? 'ADVANCE WAGE PAID'
                          : (isDue ? 'NET WAGES PAYABLE (DUE)' : 'ALL WAGES SETTLED'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: isAdvance
                            ? const Color(0xFF047857)
                            : (isDue ? const Color(0xFFB91C1C) : const Color(0xFF475569)),
                      ),
                    ),
                    Icon(
                      isAdvance
                          ? Icons.check_circle_rounded
                          : (isDue ? Icons.pending_actions_rounded : Icons.done_all_rounded),
                      size: 16,
                      color: isAdvance
                          ? const Color(0xFF047857)
                          : (isDue ? const Color(0xFFB91C1C) : const Color(0xFF475569)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Rs. ${NumberFormat("#,##0").format(balance.abs())}',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: isAdvance
                        ? const Color(0xFF065F46)
                        : (isDue ? const Color(0xFF991B1B) : const Color(0xFF1E293B)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAdvance
                      ? 'Worker received advance wages. This credit will be deducted from future work charges.'
                      : (isDue
                          ? 'Wages owed to worker for completed fabrication and repairs.'
                          : 'Zero remaining wage balance. All payments up to date.'),
                  style: TextStyle(
                    fontSize: 11,
                    color: isAdvance
                        ? const Color(0xFF065F46)
                        : (isDue ? const Color(0xFF991B1B) : const Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionHub(BuildContext context, Labour labour) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ACTIONS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => _showPaymentDialog(context, labour),
            icon: const Icon(Icons.payments_outlined, size: 18),
            label: const Text('Record Wage Payment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => _showWorkDialog(context, labour),
            icon: const Icon(Icons.engineering_rounded, size: 18),
            label: const Text('Add Work Entry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          const Text(
            'PRINT & STATEMENTS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final state = context.read<ERPCubit>().state;
                    try {
                      await ThermalPrinterService.printLabourStatement(
                        context,
                        labour: labour,
                        profile: state.appProfile,
                        settings: state.printerSetting,
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print error: $e')));
                      }
                    }
                  },
                  icon: const Icon(Icons.receipt_rounded, size: 16),
                  label: const Text('Thermal POS (58/80mm)'),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: const Color(0xFF0F172A),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final state = context.read<ERPCubit>().state;
                    final pdfBytes = await InvoicePdfService.generateStatementPdf(
                      personName: labour.name,
                      type: 'Labour',
                      date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                      remainingBalance: labour.remainingBalance,
                      profile: state.appProfile,
                    );
                    if (!context.mounted) return;
                    await PrintPreviewDialog.show(
                      context,
                      pdfBytes,
                      'Statement_${labour.name}.pdf',
                      isThermal: false,
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf, size: 16, color: Colors.red),
                  label: const Text('PDF Slip'),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditLabourDialog(BuildContext context, Labour labour) {
    showDialog(
      context: context,
      builder: (context) => _EditLabourDialog(labour: labour),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Labour labour) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Labourer?'),
        content: Text('This will permanently delete ${labour.name} and all their work and payment history. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final cubit = context.read<ERPCubit>();
              Navigator.pop(context);
              await cubit.deleteLabour(labour.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Labourer ${labour.name} deleted')),
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

  void _showWorkDialog(BuildContext context, Labour labour) {
    showDialog(context: context, builder: (context) => _LabourWorkDialog(labour: labour));
  }

  void _showPaymentDialog(BuildContext context, Labour labour) {
    showDialog(context: context, builder: (context) => _LabourPaymentDialog(labour: labour));
  }
}

Widget _buildLabourBalanceBadge(double balance) {
  if (balance < -0.01) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Text(
        'Advance: Rs. ${NumberFormat("#,##0").format(balance.abs())}',
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF047857)),
      ),
    );
  } else if (balance > 0.01) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Text(
        'Due: Rs. ${NumberFormat("#,##0").format(balance)}',
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB91C1C)),
      ),
    );
  } else {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Settled (Rs. 0)',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
      ),
    );
  }
}

class _UnifiedLabourLedger extends StatefulWidget {
  final Labour labour;
  const _UnifiedLabourLedger({required this.labour});

  @override
  State<_UnifiedLabourLedger> createState() => _UnifiedLabourLedgerState();
}

class _UnifiedLabourLedgerState extends State<_UnifiedLabourLedger> {
  String _filter = 'all'; // 'all', 'work', 'payments'
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<_LabourLedgerRow> items = [];

    for (final w in widget.labour.workEntries) {
      items.add(_LabourLedgerRow(
        id: w.id,
        date: w.date,
        isWork: true,
        title: w.entryNumber,
        subtitle: '${w.trailaId != null ? "Traila #${w.trailaId} • " : ""}${w.description}',
        amount: w.cost,
        runningBalance: w.updatedBalance,
        work: w,
      ));
    }

    for (final p in widget.labour.payments) {
      items.add(_LabourLedgerRow(
        id: p.id,
        date: p.date,
        isWork: false,
        title: 'Payment (${p.method})',
        subtitle: 'Paid to ${widget.labour.name}',
        amount: p.amount,
        runningBalance: p.updatedBalance ?? widget.labour.remainingBalance,
        payment: p,
      ));
    }

    items.sort((a, b) => b.date.compareTo(a.date));

    final filtered = items.where((it) {
      if (_filter == 'work' && !it.isWork) return false;
      if (_filter == 'payments' && it.isWork) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return it.title.toLowerCase().contains(q) ||
            it.subtitle.toLowerCase().contains(q) ||
            it.amount.toString().contains(q);
      }
      return true;
    }).toList();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
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
                        hintText: 'Search work jobs, invoice #, amount...',
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'all', label: Text('All (${items.length})')),
                    ButtonSegment(value: 'work', label: Text('Work (${widget.labour.workEntries.length})')),
                    ButtonSegment(value: 'payments', label: Text('Payments (${widget.labour.payments.length})')),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (val) => setState(() => _filter = val.first),
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),

          // Ledger Table / Cards
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.engineering_outlined, size: 52, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No records match "$_searchQuery"'
                              : 'No work or payment history recorded yet',
                          style: TextStyle(fontSize: 15, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return _buildLedgerCard(context, item);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerCard(BuildContext context, _LabourLedgerRow item) {
    return _ModernLabourLedgerRow(
      item: item,
      labour: widget.labour,
      onDeleteWork: (id) => _showDeleteWorkDialog(context, id),
      onDeletePayment: (id) => _showDeletePaymentDialog(context, id),
    );
  }

  void _showDeleteWorkDialog(BuildContext context, String workId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Work Invoice?'),
        content: const Text('Deleting this work invoice will recalculate remaining wages. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await context.read<ERPCubit>().deleteLabourWork(workId);
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
        content: const Text('Deleting this payment record will recalculate remaining balance. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await context.read<ERPCubit>().deleteLabourPayment(paymentId);
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

class _ModernLabourLedgerRow extends StatefulWidget {
  final _LabourLedgerRow item;
  final Labour labour;
  final ValueChanged<String> onDeleteWork;
  final ValueChanged<String> onDeletePayment;

  const _ModernLabourLedgerRow({
    required this.item,
    required this.labour,
    required this.onDeleteWork,
    required this.onDeletePayment,
  });

  @override
  State<_ModernLabourLedgerRow> createState() => _ModernLabourLedgerRowState();
}

class _ModernLabourLedgerRowState extends State<_ModernLabourLedgerRow> {
  bool _isHovered = false;

  void _showDetailModal() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => _LabourRecordDetailModal(
        item: widget.item,
        labour: widget.labour,
        onDeleteWork: widget.onDeleteWork,
        onDeletePayment: widget.onDeletePayment,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isWork = item.isWork;
    final accentColor = isWork ? const Color(0xFF2563EB) : const Color(0xFF16A34A);

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
              // 1. Compact Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isWork ? const Color(0xFFEFF6FF) : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isWork ? const Color(0xFFBFDBFE) : const Color(0xFFBBF7D0),
                  ),
                ),
                child: Icon(
                  isWork ? Icons.engineering_rounded : Icons.payments_rounded,
                  color: accentColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 14),

              // 2. Type Pill & Title / Invoice Code
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: isWork ? const Color(0xFFEFF6FF) : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isWork ? const Color(0xFFBFDBFE) : const Color(0xFFBBF7D0),
                  ),
                ),
                child: Text(
                  isWork ? 'WORK LOG' : 'WAGE PAY',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: isWork ? const Color(0xFF1E40AF) : const Color(0xFF15803D),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Title (e.g. INV-LW-0002)
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),

              if (item.work?.trailaId != null && item.work!.trailaId!.isNotEmpty) ...[
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
                        'Traila #${item.work!.trailaId}',
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

              // Date & Time
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

              // Short Description / Subtitle
              Expanded(
                child: Text(
                  isWork
                      ? (item.work?.description.isNotEmpty == true ? item.work!.description : 'Labour Work')
                      : 'Wage payment via ${item.payment?.method ?? "Cash"}',
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
                    '${isWork ? "+" : "-"} Rs. ${NumberFormat("#,##0").format(item.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: isWork ? const Color(0xFF0F172A) : const Color(0xFF16A34A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _buildLabourBalanceBadge(item.runningBalance),
                ],
              ),
              const SizedBox(width: 12),

              // Tap affordance: View detail pill + chevron
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
}

class _LabourRecordDetailModal extends StatefulWidget {
  final _LabourLedgerRow item;
  final Labour labour;
  final ValueChanged<String> onDeleteWork;
  final ValueChanged<String> onDeletePayment;

  const _LabourRecordDetailModal({
    required this.item,
    required this.labour,
    required this.onDeleteWork,
    required this.onDeletePayment,
  });

  @override
  State<_LabourRecordDetailModal> createState() => _LabourRecordDetailModalState();
}

class _LabourRecordDetailModalState extends State<_LabourRecordDetailModal> {
  bool _isExpanded = false;
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isWork = item.isWork;
    final accentColor = isWork ? const Color(0xFF2563EB) : const Color(0xFF16A34A);
    final previousBalance = isWork
        ? (item.work?.previousOutstanding ?? (item.runningBalance - item.amount))
        : (item.payment?.previousBalance ?? (item.runningBalance + item.amount));

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        width: _isExpanded ? 900 : 640,
        constraints: const BoxConstraints(maxHeight: 760),
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
              // 1. Executive Modal Titlebar with Minimize, Maximize, and Close Buttons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: isWork ? const Color(0xFFF8FAFC) : const Color(0xFFF0FDF4),
                  border: Border(
                    bottom: BorderSide(color: isWork ? const Color(0xFFE2E8F0) : const Color(0xFFDCFCE7)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isWork ? const Color(0xFFEFF6FF) : const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isWork ? const Color(0xFFBFDBFE) : const Color(0xFF86EFAC),
                        ),
                      ),
                      child: Icon(
                        isWork ? Icons.engineering_rounded : Icons.payments_rounded,
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
                                isWork ? 'Labour Work Invoice' : 'Wage Payment Voucher',
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
                                  item.title,
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
                          // Minimize / Dismiss Button
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

                          // Maximize / Expand Toggle Button
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

                          // Close Cross Button
                          Tooltip(
                            message: 'Close',
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                width: 30,
                                height: 26,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                ),
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
                      // Hero Financial Card with Ledger Impact Flow
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isWork
                                ? [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)]
                                : [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isWork ? const Color(0xFFBFDBFE) : const Color(0xFFBBF7D0),
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
                                      isWork ? 'AMOUNT ADDED TO WAGES' : 'WAGE PAYMENT DISBURSED',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: accentColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${isWork ? "+" : "-"} Rs. ${NumberFormat("#,##0").format(item.amount)}',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.6,
                                        color: isWork ? const Color(0xFF0F172A) : const Color(0xFF15803D),
                                      ),
                                    ),
                                  ],
                                ),
                                _buildLabourBalanceBadge(item.runningBalance),
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
                                    const Text('Previous Due', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Rs. ${NumberFormat("#,##0").format(previousBalance)}',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_rounded, size: 16, color: accentColor),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(isWork ? 'Work Cost' : 'Amount Paid', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${isWork ? "+" : "-"} Rs. ${NumberFormat("#,##0").format(item.amount)}',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: accentColor),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_rounded, size: 16, color: accentColor),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Updated Balance', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
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
                              icon: Icons.person_outline_rounded,
                              label: 'Craftsman / Worker',
                              value: widget.labour.name,
                              subValue: 'ID: ${widget.labour.id}',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildDetailCard(
                              icon: Icons.local_shipping_outlined,
                              label: 'Traila Unit Build',
                              value: (item.work?.trailaId != null && item.work!.trailaId!.isNotEmpty)
                                  ? 'Traila #${item.work!.trailaId}'
                                  : 'General Workshop Unit',
                              subValue: isWork ? 'Manufacturing Work' : (item.payment?.method ?? 'Cash'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      if (!isWork && item.payment?.receiptNumber?.isNotEmpty == true) ...[
                        _buildDetailCard(
                          icon: Icons.tag_rounded,
                          label: 'Receipt / Reference Code',
                          value: item.payment!.receiptNumber!,
                          subValue: 'Disbursed via ${item.payment!.method}',
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Full Scope of Work / Notes Section
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isWork ? Icons.description_outlined : Icons.notes_rounded,
                                      size: 16,
                                      color: const Color(0xFF475569),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isWork ? 'SCOPE OF WORK & DESCRIPTION' : 'PAYMENT REMARKS & NOTES',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.6,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    final text = isWork
                                        ? (item.work?.description ?? '')
                                        : 'Wage payment of Rs. ${NumberFormat("#,##0").format(item.amount)} disbursed to ${widget.labour.name} via ${item.payment?.method ?? "Cash"}${item.payment?.receiptNumber != null ? " (Receipt #${item.payment!.receiptNumber})" : ""}';
                                    Clipboard.setData(ClipboardData(text: text));
                                    setState(() => _copied = true);
                                    Future.delayed(const Duration(seconds: 2), () {
                                      if (mounted) setState(() => _copied = false);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _copied ? Icons.check_rounded : Icons.copy_rounded,
                                          size: 13,
                                          color: _copied ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _copied ? 'Copied' : 'Copy',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: _copied ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              isWork
                                  ? (item.work?.description.isNotEmpty == true
                                      ? item.work!.description
                                      : 'No additional notes provided for this work log entry.')
                                  : 'Wage payment of Rs. ${NumberFormat("#,##0").format(item.amount)} disbursed to ${widget.labour.name} via ${item.payment?.method ?? "Cash"}${item.payment?.receiptNumber != null ? " (Receipt #${item.payment!.receiptNumber})" : ""}.',
                              style: const TextStyle(
                                fontSize: 13.5,
                                height: 1.5,
                                color: Color(0xFF1E293B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Bottom Action Footer Bar
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
                    // Delete Entry Button (with confirmation)
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        if (isWork && item.work != null) {
                          widget.onDeleteWork(item.work!.id);
                        } else if (!isWork && item.payment != null) {
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

                    // Thermal Receipt (58/80mm) Button
                    OutlinedButton.icon(
                      onPressed: () async {
                        final state = context.read<ERPCubit>().state;
                        try {
                          if (isWork && item.work != null) {
                            await ThermalPrinterService.printLabourWork(
                              context,
                              labour: widget.labour,
                              work: item.work!,
                              profile: state.appProfile,
                              settings: state.printerSetting,
                              printDuplicate: true,
                            );
                          } else if (!isWork && item.payment != null) {
                            await ThermalPrinterService.printLabourPayment(
                              context,
                              labour: widget.labour,
                              payment: item.payment!,
                              previousBalance: item.payment!.previousBalance ?? 0,
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

                    // PDF Invoice Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        final state = context.read<ERPCubit>().state;
                        if (isWork && item.work != null) {
                          final pdfBytes = await InvoicePdfService.generateLabourWorkPdf(
                            labourName: widget.labour.name,
                            date: DateFormat('dd-MM-yyyy').format(item.work!.date),
                            trailaId: item.work!.trailaId,
                            workPrice: item.work!.cost,
                            previousBalance: item.work!.previousOutstanding,
                            newBalance: item.runningBalance,
                            profile: state.appProfile,
                          );
                          if (!context.mounted) return;
                          await PrintPreviewDialog.show(
                            context,
                            pdfBytes,
                            'Work_${item.work!.entryNumber}.pdf',
                          );
                        } else if (!isWork && item.payment != null) {
                          final pdfBytes = await InvoicePdfService.generateLabourPaymentPdf(
                            labourName: widget.labour.name,
                            date: DateFormat('dd-MM-yyyy').format(item.payment!.date),
                            paymentMethod: item.payment!.method,
                            paidAmount: item.payment!.amount,
                            previousBalance: item.payment!.previousBalance ?? 0,
                            newBalance: item.runningBalance,
                            profile: state.appProfile,
                          );
                          if (!context.mounted) return;
                          await PrintPreviewDialog.show(
                            context,
                            pdfBytes,
                            'Payment_${widget.labour.name}.pdf',
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

                    // Close Button
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

class _LabourLedgerRow {
  final String id;
  final DateTime date;
  final bool isWork;
  final String title;
  final String subtitle;
  final double amount;
  final double runningBalance;
  final WorkEntry? work;
  final Payment? payment;

  const _LabourLedgerRow({
    required this.id,
    required this.date,
    required this.isWork,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.runningBalance,
    this.work,
    this.payment,
  });
}

class _LabourWorkDialog extends StatefulWidget {
  final Labour labour;
  const _LabourWorkDialog({required this.labour});
  @override
  State<_LabourWorkDialog> createState() => _LabourWorkDialogState();
}

class _LabourWorkDialogState extends State<_LabourWorkDialog> {
  final List<String> _workTypes = ['Structure', 'Flooring', 'Axle/Suspension', 'Welding', 'Painting', 'Electrical', 'Rim/Tyre', 'Custom'];
  String _selectedWorkType = 'Structure';
  String? _selectedTrailaId;
  String? _selectedPaymentMethod = 'Cash';
  DateTime _selectedDate = DateTime.now();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _paymentController = TextEditingController(text: '0');
  bool _isSaving = false;
  WorkEntry? _savedWork;

  Future<void> _handleSave() async {
    final cost = double.tryParse(_costController.text) ?? 0;
    final paid = double.tryParse(_paymentController.text) ?? 0;
    
    if (cost <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid cost')));
      return;
    }

    setState(() => _isSaving = true);
    try {
      final description = _selectedWorkType == 'Custom' 
          ? _descriptionController.text.trim()
          : '$_selectedWorkType${_descriptionController.text.isNotEmpty ? ': ${_descriptionController.text}' : ''}';

      final result = await context.read<ERPCubit>().addLabourWork(
        widget.labour.id,
        WorkEntry(
          id: 'LW-${DateTime.now().millisecondsSinceEpoch}',
          entryNumber: 'N/A',
          trailaId: _selectedTrailaId, // Now nullable
          description: description.isEmpty ? _selectedWorkType : description,
          cost: cost,
          previousOutstanding: widget.labour.remainingBalance,
          date: _selectedDate,
        ),
        paymentAmount: paid > 0 ? paid : null,
        paymentMethod: paid > 0 ? _selectedPaymentMethod : null,
      );

      setState(() => _savedWork = result);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Work Invoice Saved Successfully'), backgroundColor: Colors.green));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trailas = context.watch<ERPCubit>().state.trailas.where((t) => t.status == TrailaStatus.pending).toList();
    final cost = double.tryParse(_costController.text) ?? 0;
    final prevOutstanding = widget.labour.remainingBalance;

    return AlertDialog(
      title: const Text('New Work Invoice'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String?>(
              initialValue: _selectedTrailaId,
              decoration: const InputDecoration(labelText: 'Select Traila (Optional)', helperText: 'Leave empty for General Work'),
              items: [
                const DropdownMenuItem<String?>(value: null, child: Text('None (General Expense)')),
                ...trailas.map((t) => DropdownMenuItem<String?>(value: t.id, child: Text('${t.id} - ${t.name}'))),
              ],
              onChanged: _savedWork != null ? null : (v) => setState(() => _selectedTrailaId = v),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedWorkType,
              decoration: const InputDecoration(labelText: 'Work Type'),
              items: _workTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: _savedWork != null ? null : (v) => setState(() => _selectedWorkType = v!),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _savedWork != null ? null : () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Work Date'),
                child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              ),
            ),
            TextField(
              controller: _descriptionController,
              enabled: _savedWork == null,
              decoration: InputDecoration(
                labelText: _selectedWorkType == 'Custom' ? 'Work Description' : 'Additional Remarks (Optional)',
                hintText: _selectedWorkType == 'Custom' ? 'Enter what work was done' : 'e.g., extra material used',
              ),
            ),
            TextField(
              controller: _costController,
              enabled: _savedWork == null,
              decoration: const InputDecoration(labelText: 'Job Charge / Work Price (Rs.)'),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _paymentController,
                    enabled: _savedWork == null,
                    decoration: const InputDecoration(labelText: 'Paid Now (Upfront)'),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedPaymentMethod,
                    decoration: const InputDecoration(labelText: 'Method'),
                    items: ['Cash', 'Bank', 'Other'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: _savedWork != null ? null : (v) => setState(() => _selectedPaymentMethod = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  _MathRow(label: 'Prev Balance:', value: prevOutstanding),
                  _MathRow(label: 'Work Price:', value: cost, color: Colors.blue, prefix: '+'),
                  const Divider(),
                  _MathRow(label: 'TOTAL:', value: prevOutstanding + cost, isBold: true),
                  if (double.tryParse(_paymentController.text) != null && (double.tryParse(_paymentController.text)! > 0)) ...[
                    _MathRow(label: 'Paid Upfront:', value: double.tryParse(_paymentController.text)!, color: Colors.green, prefix: '-'),
                    const Divider(),
                    _MathRow(label: 'NEW REMAINING BAL:', value: (prevOutstanding + cost) - double.tryParse(_paymentController.text)!, color: Colors.red, isBold: true),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context), 
                    child: Text(_savedWork != null ? 'Close' : 'Cancel')
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (_savedWork == null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, 
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isSaving 
                        ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                        : const Text('Save'),
                    ),
                  ),
                if (_savedWork == null) const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _savedWork == null ? null : () async {
                      final state = context.read<ERPCubit>().state;
                      try {
                        final success = await ThermalPrinterService.printLabourWork(
                          context,
                          labour: widget.labour,
                          work: _savedWork!,
                          profile: state.appProfile,
                          settings: state.printerSetting,
                          printDuplicate: true,
                        );
                        if (!success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to print.')));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))));
                        }
                      }
                    },
                    icon: const Icon(Icons.print_outlined, size: 18),
                    label: const Text('Print', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, 
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _savedWork == null ? null : () {
                      final traila = context.read<ERPCubit>().state.trailas.firstWhere((t) => t.id == _savedWork!.trailaId);
                      _sendProfessionalWhatsAppInvoice(
                        context: context,
                        labour: widget.labour,
                        trailaName: traila.name,
                        description: _savedWork!.description,
                        currentAmount: _savedWork!.cost,
                        previousBalance: _savedWork!.previousOutstanding,
                        date: _savedWork!.date,
                      );
                    },
                    icon: const Icon(Icons.message_outlined, size: 18),
                    label: const Text('WhatsApp', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, 
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _LabourPaymentDialog extends StatefulWidget {
  final Labour labour;
  const _LabourPaymentDialog({required this.labour});
  @override
  State<_LabourPaymentDialog> createState() => _LabourPaymentDialogState();
}

class _LabourPaymentDialogState extends State<_LabourPaymentDialog> {
  final _amountController = TextEditingController();
  final _splitAccountControllers = <String, TextEditingController>{};
  String _method = 'Cash';
  DateTime _paymentDate = DateTime.now();
  bool _isSaving = false;
  Payment? _savedPayment;

  double get _total {
    if (_method != 'Split') {
      return double.tryParse(_amountController.text) ?? 0;
    }
    double t = 0;
    for (var ctrl in _splitAccountControllers.values) {
      t += double.tryParse(ctrl.text) ?? 0;
    }
    return t;
  }

  Future<void> _handleSave() async {
    double totalAmt = 0;
    List<SplitDetail>? splits;
    if (_method == 'Split') {
      splits = [];
      _splitAccountControllers.forEach((acc, ctrl) {
        final val = double.tryParse(ctrl.text) ?? 0;
        if (val > 0) {
          splits!.add(SplitDetail(method: acc, amount: val));
          totalAmt += val;
        }
      });
    } else {
      totalAmt = double.tryParse(_amountController.text) ?? 0;
    }

    if (totalAmt <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    setState(() => _isSaving = true);
    try {
      final result = await context.read<ERPCubit>().addLabourPayment(
            widget.labour.id,
            Payment(
              id: 'PAY-${DateTime.now().millisecondsSinceEpoch}',
              amount: totalAmt,
              date: _paymentDate,
              method: _method,
              splitDetails: splits,
            ),
          );

      setState(() => _savedPayment = result);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Invoice Saved Successfully'), backgroundColor: Colors.green));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      rethrow;
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ERPCubit>().state;

    return AlertDialog(
      title: const Text('New Payment Invoice'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _savedPayment != null ? null : () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _paymentDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _paymentDate = picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Payment Date'),
                  child: Text(DateFormat('yyyy-MM-dd').format(_paymentDate)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _method,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                items: [...context.read<ERPCubit>().state.accounts.values.map((a) => a.name), 'Split']
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: _savedPayment != null ? null : (v) => setState(() => _method = v!),
              ),
              const SizedBox(height: 16),
              if (_method != 'Split')
                TextField(
                  controller: _amountController,
                  enabled: _savedPayment == null,
                  decoration: const InputDecoration(labelText: 'Amount Paid (Rs.)'),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                )
              else ...[
                const Text('Split Accounts', style: TextStyle(fontWeight: FontWeight.bold)),
                ...state.accounts.values.map((acc) {
                  _splitAccountControllers.putIfAbsent(acc.id, () => TextEditingController());
                  return TextField(
                    controller: _splitAccountControllers[acc.id],
                    enabled: _savedPayment == null,
                    decoration: InputDecoration(labelText: '${acc.name} Account Amount'),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  );
                }),
              ],
              if (_savedPayment == null)
                Builder(
                  builder: (context) {
                    final cur = widget.labour.remainingBalance;
                    final proj = cur - _total;
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
                                '- Rs. ${NumberFormat("#,##0").format(_total)}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                              ),
                            ],
                          ),
                          const Divider(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('New Balance:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              _buildLabourBalanceBadge(proj),
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
                                      'Advance Wage Paid: Worker is receiving Rs. ${NumberFormat("#,##0").format(proj.abs())} in advance. This will deduct from upcoming work.',
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
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context), 
                    child: Text(_savedPayment != null ? 'Close' : 'Cancel')
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (_savedPayment == null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, 
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isSaving 
                        ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                        : const Text('Save'),
                    ),
                  ),
                if (_savedPayment == null) const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _savedPayment == null ? null : () async {
                      final prev = _savedPayment!.previousBalance ?? 0;
                      final remaining = _savedPayment!.updatedBalance ?? 0;

                      try {
                        final success = await ThermalPrinterService.printLabourPayment(
                          context,
                          labour: widget.labour,
                          payment: _savedPayment!,
                          previousBalance: prev,
                          newBalance: remaining,
                          profile: state.appProfile,
                          settings: state.printerSetting,
                          printDuplicate: true,
                        );
                        if (!success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to print payment.')));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))));
                        }
                      }
                    },
                    icon: const Icon(Icons.print_outlined, size: 18),
                    label: const Text('Print', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, 
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _savedPayment == null ? null : () {
                      _sendProfessionalWhatsAppPaymentInvoice(
                        context: context,
                        labour: widget.labour,
                        amount: _savedPayment!.amount,
                        method: _savedPayment!.method,
                        previousBalance: _savedPayment!.previousBalance ?? 0,
                        remainingBalance: _savedPayment!.updatedBalance ?? 0,
                        date: _savedPayment!.date,
                      );
                    },
                    icon: const Icon(Icons.message_outlined, size: 18),
                    label: const Text('WhatsApp', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, 
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _EditLabourDialog extends StatefulWidget {
  final Labour labour;
  const _EditLabourDialog({required this.labour});
  @override
  State<_EditLabourDialog> createState() => _EditLabourDialogState();
}

class _EditLabourDialogState extends State<_EditLabourDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  final _openingBalanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.labour.name;
    _phoneController.text = widget.labour.phone;
    _whatsappController.text = widget.labour.whatsappNumber;
    _addressController.text = widget.labour.address;
    _openingBalanceController.text = widget.labour.openingBalance.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Labourer Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone')),
          TextField(controller: _whatsappController, decoration: const InputDecoration(labelText: 'WhatsApp Number')),
          TextField(controller: _addressController, decoration: const InputDecoration(labelText: 'Address')),
          TextField(
            controller: _openingBalanceController, 
            decoration: const InputDecoration(labelText: 'Opening Balance', prefixText: 'Rs. '),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final updated = widget.labour.copyWith(
              name: _nameController.text,
              phone: _phoneController.text,
              whatsappNumber: _whatsappController.text,
              address: _addressController.text,
              openingBalance: double.tryParse(_openingBalanceController.text) ?? 0.0,
            );
            await context.read<ERPCubit>().updateLabour(updated);
            if (!context.mounted) return;
            Navigator.pop(context);
          },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}

void _sendProfessionalWhatsAppInvoice({
  required BuildContext context,
  required Labour labour,
  required String trailaName,
  required String description,
  required double currentAmount,
  required double previousBalance,
  required DateTime date,
}) async {
  final totalBalance = previousBalance + currentAmount;
  final formattedDate = DateFormat('dd-MM-yyyy').format(date);
  final profile = context.read<ERPCubit>().state.appProfile;
  
  try {
    await WhatsAppService.sendLabourWorkReceipt(
      phone: labour.whatsappNumber.isNotEmpty ? labour.whatsappNumber : labour.phone,
      labourName: labour.name,
      date: formattedDate,
      trailaId: trailaName, // Using trailaName as trailaId for display
      workPrice: currentAmount,
      previousBalance: previousBalance,
      newBalance: totalBalance,
      profile: profile,
    );
  } catch (e) {
    if (!context.mounted) return;
    String message = e.toString();
    if (message.startsWith('Exception: ')) {
      message = message.substring(11);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

void _sendProfessionalWhatsAppPaymentInvoice({
  required BuildContext context,
  required Labour labour,
  required double amount,
  required String method,
  required double previousBalance,
  required double remainingBalance,
  required DateTime date,
}) async {
  final formattedDate = DateFormat('dd-MM-yyyy').format(date);
  final profile = context.read<ERPCubit>().state.appProfile;
  
  try {
    await WhatsAppService.sendLabourPaymentReceipt(
      phone: labour.whatsappNumber.isNotEmpty ? labour.whatsappNumber : labour.phone,
      labourName: labour.name,
      date: formattedDate,
      paymentMethod: method,
      paidAmount: amount,
      previousBalance: previousBalance,
      newBalance: remainingBalance,
      profile: profile,
    );
  } catch (e) {
    if (!context.mounted) return;
    String message = e.toString();
    if (message.startsWith('Exception: ')) {
      message = message.substring(11);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _MathRow extends StatelessWidget {
  final String label;
  final double value;
  final String prefix;
  final bool isBold;
  final Color? color;

  const _MathRow({
    required this.label, 
    required this.value, 
    this.prefix = '', 
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : null,
                  fontSize: isBold ? 14 : 12,
                  color: isBold ? Colors.black87 : Colors.grey.shade700,
                )),
              ],
            ),
          ),
          Text(
            '$prefix Rs. ${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: isBold ? 14 : 12,
              color: color ?? (isBold ? Colors.blue.shade900 : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
