import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/khata.dart';
import '../widgets/add_khata_dialog.dart';
import '../cubits/erp_cubit.dart';
import '../services/invoice_pdf_service.dart';
import '../services/thermal_printer_service.dart';
import '../services/whatsapp_service.dart';
import '../widgets/print_preview_dialog.dart';

class KhataProfileScreen extends StatefulWidget {
  final String khataId;

  const KhataProfileScreen({super.key, required this.khataId});

  @override
  State<KhataProfileScreen> createState() => _KhataProfileScreenState();
}

class _KhataProfileScreenState extends State<KhataProfileScreen> {
  String _filter = 'all'; // 'all', 'in', 'out'
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final khata = state.khatas.firstWhere(
          (k) => k.id == widget.khataId,
          orElse: () => Khata(
            id: '',
            personName: 'Unknown',
            totalAmount: 0,
            paidAmount: 0,
            remainingBalance: 0,
            date: DateTime.now(),
            items: [],
          ),
        );

        if (khata.id.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Customer Not Found')),
            body: const Center(child: Text('This profile no longer exists.')),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: _buildAppBar(context, khata),
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
                            _buildIdentityCard(context, khata),
                            const SizedBox(height: 16),
                            _buildFinancialOverview(khata),
                            const SizedBox(height: 16),
                            _buildActionHub(context, khata),
                          ],
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                    // Right Expanded Panel: Unified Ledger Statement
                    Expanded(
                      child: _buildLedgerStatement(context, khata),
                    ),
                  ],
                );
              } else {
                // Mobile / Tablet Responsive Stack
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildIdentityCard(context, khata),
                      const SizedBox(height: 16),
                      _buildFinancialOverview(khata),
                      const SizedBox(height: 16),
                      _buildActionHub(context, khata),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 600,
                        child: _buildLedgerStatement(context, khata),
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

  PreferredSizeWidget _buildAppBar(BuildContext context, Khata khata) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF0F172A),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_pin_rounded, size: 14, color: Color(0xFF2563EB)),
                SizedBox(width: 4),
                Text('CUSTOMER KHATA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            khata.personName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Print Thermal Statement (58/80mm)',
          icon: const Icon(Icons.receipt_long_rounded, color: Color(0xFF0F172A)),
          onPressed: () => _printThermalStatement(context, khata),
        ),
        IconButton(
          tooltip: 'Save PDF Statement',
          icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.red),
          onPressed: () => _exportPdfStatement(context, khata),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (value) {
            if (value == 'edit') {
              _showEditNameDialog(context, khata.personName);
            } else if (value == 'delete') {
              _showDeleteConfirmation(context, khata.personName);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Rename Customer'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete Customer Record'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildIdentityCard(BuildContext context, Khata khata) {
    final initials = khata.personName.trim().isNotEmpty
        ? khata.personName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join('').toUpperCase()
        : 'KH';

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
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFEEF2FF),
                child: Text(
                  initials,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF4338CA)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      khata.personName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Account since ${DateFormat('MMM yyyy').format(khata.date)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF64748B)),
                onPressed: () => _showEditNameDialog(context, khata.personName),
                tooltip: 'Edit Name',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Transactions:', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              Text(
                '${khata.items.length} records',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          if (khata.openingBalance > 0) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Opening Balance:', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                Text(
                  'Rs. ${NumberFormat("#,##0").format(khata.openingBalance)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinancialOverview(Khata khata) {
    final balance = khata.remainingBalance;
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
            'FINANCIAL SUMMARY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          // Total Given & Total Got row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFEE2E2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_upward_rounded, size: 14, color: Colors.red.shade700),
                          const SizedBox(width: 4),
                          Text('Total Given', style: TextStyle(fontSize: 11, color: Colors.red.shade800, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rs. ${NumberFormat("#,##0").format(khata.totalAmount)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.red.shade900),
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
                      Row(
                        children: [
                          Icon(Icons.arrow_downward_rounded, size: 14, color: Colors.green.shade700),
                          const SizedBox(width: 4),
                          Text('Total Received', style: TextStyle(fontSize: 11, color: Colors.green.shade800, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rs. ${NumberFormat("#,##0").format(khata.paidAmount)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.green.shade900),
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
                  : (isDue ? const Color(0xFFFFFBEB) : const Color(0xFFF8FAFC)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isAdvance
                    ? const Color(0xFFA7F3D0)
                    : (isDue ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0)),
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
                          ? 'ADVANCE CREDIT'
                          : (isDue ? 'NET RECEIVABLE (YOU\'LL GET)' : 'ALL CLEAR / KHATA SETTLED'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: isAdvance
                            ? const Color(0xFF047857)
                            : (isDue ? const Color(0xFFB45309) : const Color(0xFF475569)),
                      ),
                    ),
                    Icon(
                      isAdvance
                          ? Icons.check_circle_rounded
                          : (isDue ? Icons.pending_actions_rounded : Icons.done_all_rounded),
                      size: 16,
                      color: isAdvance
                          ? const Color(0xFF047857)
                          : (isDue ? const Color(0xFFB45309) : const Color(0xFF475569)),
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
                        : (isDue ? const Color(0xFF92400E) : const Color(0xFF1E293B)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAdvance
                      ? 'Customer paid extra. You owe this credit or will deduct from future orders.'
                      : (isDue
                          ? 'Customer owes this balance to your business.'
                          : 'Zero remaining balance. Account is fully squared.'),
                  style: TextStyle(
                    fontSize: 11,
                    color: isAdvance
                        ? const Color(0xFF065F46)
                        : (isDue ? const Color(0xFF92400E) : const Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionHub(BuildContext context, Khata khata) {
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
            'RECORD TRANSACTIONS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => _showQuickTxnDialog(context, khata, KhataTransactionType.cashIn),
            icon: const Icon(Icons.arrow_downward_rounded, size: 18),
            label: const Text('Record Got (Payment In)'),
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
            onPressed: () => _showQuickTxnDialog(context, khata, KhataTransactionType.cashOut),
            icon: const Icon(Icons.arrow_upward_rounded, size: 18),
            label: const Text('Record Gave (Cash Out)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _showAddDialog(context, khata),
            icon: const Icon(Icons.playlist_add_rounded, size: 18),
            label: const Text('Multi-Item Entry Dialog'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF475569),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          const Text(
            'SHARE & PRINT',
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
                  onPressed: () => _printThermalStatement(context, khata),
                  icon: const Icon(Icons.receipt_rounded, size: 16),
                  label: const Text('Thermal POS'),
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
                  onPressed: () => _exportPdfStatement(context, khata),
                  icon: const Icon(Icons.picture_as_pdf, size: 16, color: Colors.red),
                  label: const Text('PDF'),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _showWhatsAppPrompt(context, khata),
            icon: const Icon(Icons.send_rounded, size: 16),
            label: const Text('Send Statement via WhatsApp'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 11),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerStatement(BuildContext context, Khata khata) {
    final sortedItems = List<KhataTransaction>.from(khata.items)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Calculate chronological running balances
    // Chronological order: oldest to newest
    final chronological = List<KhataTransaction>.from(khata.items)
      ..sort((a, b) => a.date.compareTo(b.date));

    final Map<String, double> runningBalances = {};
    double currentBal = khata.openingBalance;
    for (final it in chronological) {
      if (it.type == KhataTransactionType.cashOut) {
        currentBal += it.amount;
      } else {
        currentBal -= it.amount;
      }
      runningBalances[it.id] = currentBal;
    }

    final filtered = sortedItems.where((txn) {
      if (_filter == 'in' && txn.type != KhataTransactionType.cashIn) return false;
      if (_filter == 'out' && txn.type != KhataTransactionType.cashOut) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final desc = (txn.description ?? '').toLowerCase();
        final method = (txn.paymentMethod ?? '').toLowerCase();
        final amt = txn.amount.toString();
        return desc.contains(q) || method.contains(q) || amt.contains(q);
      }
      return true;
    }).toList();

    final countIn = khata.items.where((t) => t.type == KhataTransactionType.cashIn).length;
    final countOut = khata.items.where((t) => t.type == KhataTransactionType.cashOut).length;

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
                        hintText: 'Search by description, account, amount...',
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
                    ButtonSegment(value: 'all', label: Text('All (${khata.items.length})')),
                    ButtonSegment(value: 'in', label: Text('Got / In ($countIn)')),
                    ButtonSegment(value: 'out', label: Text('Gave / Out ($countOut)')),
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
                        Icon(Icons.history_toggle_off_rounded, size: 52, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No entries match "$_searchQuery"'
                              : 'No transaction history recorded yet',
                          style: TextStyle(fontSize: 15, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => _showQuickTxnDialog(context, khata, KhataTransactionType.cashIn),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Record First Entry'),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final txn = filtered[index];
                      final isOut = txn.type == KhataTransactionType.cashOut;
                      final runBal = runningBalances[txn.id] ?? 0.0;
                      return _buildTransactionCard(context, txn, isOut, runBal);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, KhataTransaction txn, bool isOut, double runningBalance) {
    final bgBadge = isOut ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4);
    final borderBadge = isOut ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7);
    final textColor = isOut ? const Color(0xFFDC2626) : const Color(0xFF16A34A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: bgBadge,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderBadge),
            ),
            child: Icon(
              isOut ? Icons.arrow_outward_rounded : Icons.arrow_downward_rounded,
              color: textColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: bgBadge,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isOut ? 'GAVE / OUT' : 'GOT / RECEIVED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: textColor,
                        ),
                      ),
                    ),
                    if (txn.paymentMethod != null && txn.paymentMethod!.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          txn.paymentMethod!,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  txn.description ?? (isOut ? 'Gave money / Debit' : 'Received payment / Credit'),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(txn.date),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isOut ? "+" : "-"} Rs. ${NumberFormat("#,##0").format(txn.amount)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              _buildKhataBalanceBadge(runningBalance),
            ],
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF3B82F6)),
                onPressed: () => _showEditTransactionDialog(context, txn),
                tooltip: 'Edit Record',
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF4444)),
                onPressed: () => _showDeleteTransactionConfirmation(context, txn),
                tooltip: 'Delete Record',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKhataBalanceBadge(double balance) {
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
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Text(
          'Due: Rs. ${NumberFormat("#,##0").format(balance)}',
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
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

  // --- Real-time Dynamic Transaction Dialog ---
  void _showQuickTxnDialog(BuildContext context, Khata khata, KhataTransactionType type) {
    final isCashIn = type == KhataTransactionType.cashIn;
    final amountController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedMethod = 'Cash';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final state = context.watch<ERPCubit>().state;
          final accounts = state.accounts.values.map((a) => a.name).toList();
          if (!accounts.contains(selectedMethod) && accounts.isNotEmpty) {
            selectedMethod = accounts.first;
          }

          final enteredAmt = double.tryParse(amountController.text.trim()) ?? 0.0;
          final currentBal = khata.remainingBalance;
          final projectedBal = isCashIn ? (currentBal - enteredAmt) : (currentBal + enteredAmt);

          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  isCashIn ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: isCashIn ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
                ),
                const SizedBox(width: 8),
                Text(isCashIn ? 'Record Got (Payment In)' : 'Record Gave (Cash Out)'),
              ],
            ),
            content: SizedBox(
              width: 440,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountController,
                      onChanged: (_) => setDialogState(() {}),
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Amount (Rs.)',
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: 'Description / Note',
                        hintText: isCashIn ? 'e.g. Received via Bank / Cash' : 'e.g. Material goods / advance given',
                        prefixIcon: const Icon(Icons.description_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: accounts.contains(selectedMethod) ? selectedMethod : null,
                            decoration: const InputDecoration(labelText: 'Account / Mode'),
                            items: accounts.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                            onChanged: (v) {
                              if (v != null) setDialogState(() => selectedMethod = v);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) setDialogState(() => selectedDate = picked);
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'Date'),
                              child: Text(DateFormat('dd-MM-yyyy').format(selectedDate)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Live Calculation Preview Box to eliminate negative balance confusion
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: projectedBal < 0 ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: projectedBal < 0 ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
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
                                currentBal < 0
                                    ? 'Advance: Rs. ${NumberFormat("#,##0").format(currentBal.abs())}'
                                    : 'Receivable: Rs. ${NumberFormat("#,##0").format(currentBal)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: currentBal < 0 ? const Color(0xFF16A34A) : const Color(0xFFB45309),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(isCashIn ? 'Receiving:' : 'Giving:', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(
                                '${isCashIn ? "-" : "+"} Rs. ${NumberFormat("#,##0").format(enteredAmt)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isCashIn ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Projected Result:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              _buildKhataBalanceBadge(projectedBal),
                            ],
                          ),
                          if (projectedBal < 0) ...[
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
                                      'Customer Advance Credit: The customer will have Rs. ${NumberFormat("#,##0").format(projectedBal.abs())} in advance credit.',
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF14532D)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final amt = double.tryParse(amountController.text.trim()) ?? 0;
                  if (amt <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount.')));
                    return;
                  }

                  final newTxn = KhataTransaction(
                    id: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
                    description: descController.text.trim().isEmpty ? null : descController.text.trim(),
                    amount: amt,
                    type: type,
                    date: selectedDate,
                    paymentMethod: selectedMethod,
                    syncToAccount: true,
                  );

                  final updatedItems = [...khata.items, newTxn];
                  final newTotalOut = isCashIn ? khata.totalAmount : (khata.totalAmount + amt);
                  final newTotalIn = isCashIn ? (khata.paidAmount + amt) : khata.paidAmount;
                  final newRemaining = (khata.openingBalance + newTotalOut) - newTotalIn;

                  final updatedKhata = khata.copyWith(
                    totalAmount: newTotalOut,
                    paidAmount: newTotalIn,
                    remainingBalance: newRemaining,
                    items: updatedItems,
                  );

                  await context.read<ERPCubit>().addKhata(updatedKhata);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaction recorded successfully'), backgroundColor: Colors.green),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCashIn ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Record'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Printing & Sharing
  Future<void> _printThermalStatement(BuildContext context, Khata khata) async {
    final cubit = context.read<ERPCubit>();
    try {
      await ThermalPrinterService.printKhataLedger(
        context,
        khata: khata,
        profile: cubit.state.appProfile,
        settings: cubit.state.printerSetting,
        printDuplicate: true,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Thermal print error: $e')));
      }
    }
  }

  Future<void> _exportPdfStatement(BuildContext context, Khata khata) async {
    final cubit = context.read<ERPCubit>();
    final pdfBytes = await InvoicePdfService.generateKhataPdf(
      khata: khata,
      profile: cubit.state.appProfile,
    );
    if (!context.mounted) return;
    await PrintPreviewDialog.show(
      context,
      pdfBytes,
      'Khata_Statement_${khata.personName}.pdf',
    );
  }

  void _showWhatsAppPrompt(BuildContext context, Khata khata) {
    final phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Statement via WhatsApp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter WhatsApp phone number for ${khata.personName}:', style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone (e.g. 03001234567 or 923001234567)',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton.icon(
            onPressed: () async {
              final phone = phoneController.text.trim();
              if (phone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter phone number.')));
                return;
              }
              Navigator.pop(context);
              final cubit = context.read<ERPCubit>();
              try {
                await WhatsAppService.sendKhataStatement(
                  phone: phone,
                  khata: khata,
                  profile: cubit.state.appProfile,
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('WhatsApp error: $e')));
                }
              }
            },
            icon: const Icon(Icons.send_rounded, size: 16),
            label: const Text('Send'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showEditTransactionDialog(BuildContext context, KhataTransaction txn) {
    final amountController = TextEditingController(text: txn.amount.toStringAsFixed(0));
    final descController = TextEditingController(text: txn.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount (Rs.)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final amt = double.tryParse(amountController.text) ?? 0;
              if (amt <= 0) return;
              await context.read<ERPCubit>().updateKhataTransaction(
                txn.id,
                amount: amt,
                description: descController.text.trim(),
              );
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteTransactionConfirmation(BuildContext context, KhataTransaction txn) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction?'),
        content: const Text('Are you sure you want to delete this transaction record? This will affect the current balance.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await context.read<ERPCubit>().deleteKhataTransaction(txn.id);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, Khata khata) {
    showDialog(
      context: context,
      builder: (context) => AddKhataDialog(
        initialPersonName: khata.personName,
        isNameLocked: true,
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Customer Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Person Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty || newName == currentName) {
                Navigator.pop(context);
                return;
              }
              await context.read<ERPCubit>().updateKhataPerson(currentName, newName);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String personName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Khata Customer?'),
        content: Text('This will permanently delete $personName and ALL their records. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final cubit = context.read<ERPCubit>();
              Navigator.pop(context);
              await cubit.deleteKhata(personName);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile for $personName deleted')),
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
}
