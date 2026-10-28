import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/account.dart';
import '../services/thermal_printer_service.dart';

class AccountLedgerScreen extends StatefulWidget {
  final String accountKey;
  const AccountLedgerScreen({super.key, required this.accountKey});

  @override
  State<AccountLedgerScreen> createState() => _AccountLedgerScreenState();
}

class _AccountLedgerScreenState extends State<AccountLedgerScreen> {
  TransactionType? _filterType;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0');
    final dateFormat = DateFormat('dd MMM yyyy');

    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final account = state.accounts[widget.accountKey];
        if (account == null) {
          return const Scaffold(body: Center(child: Text('Account not found')));
        }

        final allTransactions = account.transactions;
        final balance = context.read<ERPCubit>().calculateBalance(widget.accountKey);

        // Calculate totals
        final totalIn = allTransactions
            .where((t) => t.isCredit || (t.type == TransactionType.transfer && t.description.contains('IN')))
            .fold<double>(0, (sum, t) => sum + t.amount);
        final totalOut = allTransactions
            .where((t) => t.isDebit || (t.type == TransactionType.transfer && !t.description.contains('IN')))
            .fold<double>(0, (sum, t) => sum + t.amount);

        // Filter transactions
        final filteredTransactions = allTransactions.where((t) {
          final query = state.searchQuery.toLowerCase().trim();
          final matchesSearch = query.isEmpty ||
              t.person.toLowerCase().contains(query) ||
              t.description.toLowerCase().contains(query);
          final matchesType = _filterType == null || t.type == _filterType;
          return matchesSearch && matchesType;
        }).toList().reversed.toList();

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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF4F46E5), size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      '${account.type.toUpperCase()} ACCOUNT LEDGER',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final success = await ThermalPrinterService.printAccountLedger(
                      context,
                      account: account,
                      profile: state.appProfile,
                      settings: state.printerSetting,
                      currentBalance: balance,
                    );
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to print ledger.')),
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
                icon: const Icon(Icons.print_rounded, size: 16, color: Color(0xFF0284C7)),
                label: const Text('Print Ledger', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () => _showTransferDialog(context),
                icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                label: const Text('Transfer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Balance Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
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
                                'CURRENT ACCOUNT BALANCE',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Rs. ${currencyFormat.format(balance)}',
                                style: TextStyle(
                                  color: balance >= 0 ? const Color(0xFF34D399) : const Color(0xFFF87171),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 10,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => _showOpeningBalanceDialog(context),
                                icon: const Icon(Icons.edit_note_rounded, size: 16, color: Colors.white70),
                                label: const Text('Opening Balance', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _showEntryDialog(context, TransactionType.add),
                                icon: const Icon(Icons.add_rounded, size: 18),
                                label: const Text('Add Cash', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _showEntryDialog(context, TransactionType.take),
                                icon: const Icon(Icons.remove_rounded, size: 18),
                                label: const Text('Take Cash', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _MetricItem(
                                label: 'Total Inflow (Credits)',
                                amount: totalIn,
                                color: const Color(0xFF34D399),
                                icon: Icons.arrow_downward_rounded,
                              ),
                            ),
                            Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.1)),
                            Expanded(
                              child: _MetricItem(
                                label: 'Total Outflow (Debits)',
                                amount: totalOut,
                                color: const Color(0xFFF87171),
                                icon: Icons.arrow_upward_rounded,
                              ),
                            ),
                            Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.1)),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Transactions', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${allTransactions.length} Recorded',
                                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. Filter Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        _FilterChip(
                          label: 'All (${allTransactions.length})',
                          isSelected: _filterType == null,
                          onTap: () => setState(() => _filterType = null),
                        ),
                        _FilterChip(
                          label: 'Money In (Add)',
                          isSelected: _filterType == TransactionType.add,
                          onTap: () => setState(() => _filterType = TransactionType.add),
                        ),
                        _FilterChip(
                          label: 'Money Out (Take)',
                          isSelected: _filterType == TransactionType.take,
                          onTap: () => setState(() => _filterType = TransactionType.take),
                        ),
                        _FilterChip(
                          label: 'Transfers',
                          isSelected: _filterType == TransactionType.transfer,
                          onTap: () => setState(() => _filterType = TransactionType.transfer),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 3. Transactions Table
                if (filteredTransactions.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long_rounded, size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text(
                            'No transactions found for this account',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Use "Add Cash" or "Take Cash" to create entries.',
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
                    clipBehavior: Clip.antiAlias,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                        headingRowHeight: 48,
                        dataRowMinHeight: 52,
                        dataRowMaxHeight: 56,
                        horizontalMargin: 20,
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(label: Text('DATE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFF64748B)))),
                          DataColumn(label: Text('TYPE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFF64748B)))),
                          DataColumn(label: Text('PERSON / PARTY', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFF64748B)))),
                          DataColumn(label: Text('DESCRIPTION', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFF64748B)))),
                          DataColumn(label: Text('OUT (DEBIT)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFF64748B)))),
                          DataColumn(label: Text('IN (CREDIT)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFF64748B)))),
                          DataColumn(label: Text('RUNNING BALANCE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFF64748B)))),
                          DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFF64748B)))),
                        ],
                        rows: _buildRows(allTransactions, filteredTransactions, dateFormat, currencyFormat),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<DataRow> _buildRows(
    List<Transaction> all,
    List<Transaction> filtered,
    DateFormat dateFormat,
    NumberFormat currencyFormat,
  ) {
    // Running balance across all chronological transactions
    double currentRunning = 0;
    final Map<String, double> runningBalances = {};

    for (var txn in all) {
      if (txn.isCredit) {
        currentRunning += txn.amount;
      } else if (txn.isDebit) {
        currentRunning -= txn.amount;
      } else if (txn.type == TransactionType.transfer) {
        if (txn.description.contains('IN')) {
          currentRunning += txn.amount;
        } else {
          currentRunning -= txn.amount;
        }
      }
      runningBalances[txn.id] = currentRunning;
    }

    return filtered.map((txn) {
      final rb = runningBalances[txn.id] ?? 0;
      final isCredit = txn.isCredit || (txn.type == TransactionType.transfer && txn.description.contains('IN'));
      final isDebit = txn.isDebit || (txn.type == TransactionType.transfer && !txn.description.contains('IN'));

      return DataRow(
        cells: [
          DataCell(
            Text(dateFormat.format(txn.date), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          DataCell(_buildTypeBadge(txn.type, txn.description)),
          DataCell(
            Text(txn.person.isEmpty ? '—' : txn.person, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          DataCell(
            Text(txn.description.isEmpty ? '—' : txn.description, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          ),
          DataCell(
            Text(
              isDebit ? 'Rs. ${currencyFormat.format(txn.amount)}' : '—',
              style: const TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
          DataCell(
            Text(
              isCredit ? 'Rs. ${currencyFormat.format(txn.amount)}' : '—',
              style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
          DataCell(
            Text(
              'Rs. ${currencyFormat.format(rb)}',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: rb >= 0 ? const Color(0xFF0F172A) : const Color(0xFFEF4444),
                fontSize: 13,
              ),
            ),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.print_rounded, size: 18, color: Color(0xFF0284C7)),
                  tooltip: 'Print Thermal Receipt',
                  onPressed: () {
                    final state = context.read<ERPCubit>().state;
                    ThermalPrinterService.printTransactionReceipt(
                      context,
                      transaction: txn,
                      profile: state.appProfile,
                      settings: state.printerSetting,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, size: 18, color: Color(0xFF4F46E5)),
                  tooltip: 'Edit Transaction',
                  onPressed: () => _showEditTransactionDialog(txn),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF4444)),
                  tooltip: 'Delete Transaction',
                  onPressed: () => _confirmDelete(txn),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildTypeBadge(TransactionType type, String desc) {
    Color bg;
    Color fg;
    String label;

    switch (type) {
      case TransactionType.add:
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF15803D);
        label = 'MONEY IN';
        break;
      case TransactionType.take:
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFB91C1C);
        label = 'MONEY OUT';
        break;
      case TransactionType.transfer:
        bg = const Color(0xFFEEF2FF);
        fg = const Color(0xFF4338CA);
        label = desc.contains('IN') ? 'TRANSFER IN' : 'TRANSFER OUT';
        break;
      case TransactionType.opening:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        label = 'OPENING';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
      ),
    );
  }

  void _confirmDelete(Transaction txn) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Transaction?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('Are you sure you want to delete this ${txn.type.name} entry? This will update the running balance.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<ERPCubit>().deleteTransaction(widget.accountKey, txn.id);
              Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditTransactionDialog(Transaction txn) {
    final personController = TextEditingController(text: txn.person);
    final descController = TextEditingController(text: txn.description);
    final amountController = TextEditingController(text: txn.amount.toStringAsFixed(0));
    DateTime selectedDate = txn.date;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text('Edit ${txn.type.name.toUpperCase()} Entry', style: const TextStyle(fontWeight: FontWeight.w800)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: personController,
                  decoration: InputDecoration(
                    labelText: 'Person / Party',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount (Rs.)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.currency_exchange_rounded),
                  ),
                ),
                const SizedBox(height: 14),
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
                      labelText: 'Date',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(DateFormat('dd MMMM yyyy').format(selectedDate)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final amt = double.tryParse(amountController.text.trim()) ?? 0;
                final updatedTxn = Transaction(
                  id: txn.id,
                  accountName: txn.accountName,
                  type: txn.type,
                  amount: amt,
                  person: personController.text.trim(),
                  description: descController.text.trim(),
                  date: selectedDate,
                  category: txn.category,
                  linkedTransferId: txn.linkedTransferId,
                );
                await context.read<ERPCubit>().updateTransaction(updatedTxn);
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

  void _showEntryDialog(BuildContext context, TransactionType type) {
    showDialog(
      context: context,
      builder: (_) => _AddTakeDialog(accountKey: widget.accountKey, type: type),
    );
  }

  void _showTransferDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _TransferDialog(fromKey: widget.accountKey),
    );
  }

  void _showOpeningBalanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _OpeningBalanceDialog(accountKey: widget.accountKey),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _MetricItem({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0');
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
                'Rs. ${currencyFormat.format(amount)}',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4F46E5) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

class _AddTakeDialog extends StatefulWidget {
  final String accountKey;
  final TransactionType type;
  const _AddTakeDialog({required this.accountKey, required this.type});

  @override
  State<_AddTakeDialog> createState() => _AddTakeDialogState();
}

class _AddTakeDialogState extends State<_AddTakeDialog> {
  final _amount = TextEditingController();
  final _person = TextEditingController();
  final _desc = TextEditingController();
  DateTime _date = DateTime.now();
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final title = widget.type == TransactionType.add ? 'Add Money (Inflow)' : 'Take Money (Outflow)';
    final color = widget.type == TransactionType.add ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(widget.type == TransactionType.add ? Icons.add_rounded : Icons.remove_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isSaved)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: Color(0xFF15803D), size: 20),
                      SizedBox(width: 8),
                      Text('Transaction Recorded Successfully!', style: TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              TextField(
                controller: _amount,
                keyboardType: TextInputType.number,
                autofocus: true,
                readOnly: _isSaved,
                decoration: InputDecoration(
                  labelText: 'Amount (Rs.) *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.currency_exchange_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _person,
                readOnly: _isSaved,
                decoration: InputDecoration(
                  labelText: 'Person / Receiver / Party',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _desc,
                readOnly: _isSaved,
                decoration: InputDecoration(
                  labelText: 'Description / Purpose',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: _isSaved
                    ? null
                    : () async {
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
                    labelText: 'Transaction Date',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.calendar_today_rounded),
                  ),
                  child: Text(DateFormat('dd MMMM yyyy').format(_date)),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close', style: TextStyle(color: Color(0xFF64748B))),
        ),
        if (_isSaved)
          ElevatedButton.icon(
            onPressed: () async {
              final amt = double.tryParse(_amount.text.trim()) ?? 0;
              final txn = Transaction(
                id: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
                accountName: context.read<ERPCubit>().state.accounts[widget.accountKey]!.name,
                type: widget.type,
                amount: amt,
                person: _person.text.trim(),
                description: _desc.text.trim(),
                date: _date,
              );
              final state = context.read<ERPCubit>().state;
              await ThermalPrinterService.printTransactionReceipt(
                context,
                transaction: txn,
                profile: state.appProfile,
                settings: state.printerSetting,
              );
              if (context.mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.print_rounded, size: 16),
            label: const Text('Print Receipt'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
            ),
          )
        else
          ElevatedButton(
            onPressed: () {
              final amt = double.tryParse(_amount.text.trim()) ?? 0;
              if (amt <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount')),
                );
                return;
              }
              final txn = Transaction(
                id: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
                accountName: context.read<ERPCubit>().state.accounts[widget.accountKey]!.name,
                type: widget.type,
                amount: amt,
                person: _person.text.trim(),
                description: _desc.text.trim(),
                date: _date,
              );
              context.read<ERPCubit>().addTransaction(txn);
              setState(() => _isSaved = true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            child: Text(widget.type == TransactionType.add ? 'Confirm Inflow' : 'Confirm Outflow'),
          ),
      ],
    );
  }
}

class _TransferDialog extends StatefulWidget {
  final String fromKey;
  const _TransferDialog({required this.fromKey});

  @override
  State<_TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends State<_TransferDialog> {
  final _amount = TextEditingController();
  final _desc = TextEditingController();
  String? _toKey;
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final accounts = context.read<ERPCubit>().state.accounts;
    final otherAccounts = accounts.entries.where((e) => e.key != widget.fromKey).toList();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text('Transfer Funds Between Accounts', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _toKey,
                decoration: InputDecoration(
                  labelText: 'Destination Account *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.account_balance_rounded),
                ),
                hint: const Text('Select target account'),
                items: otherAccounts
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value.name)))
                    .toList(),
                onChanged: (v) => setState(() => _toKey = v),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _amount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Transfer Amount (Rs.) *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.currency_exchange_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _desc,
                decoration: InputDecoration(
                  labelText: 'Transfer Note / Reference',
                  hintText: 'e.g. Counter to safe deposit',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.notes_rounded),
                ),
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
                    labelText: 'Transfer Date',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(DateFormat('dd MMMM yyyy').format(_date)),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
        ),
        ElevatedButton(
          onPressed: () {
            final amt = double.tryParse(_amount.text.trim()) ?? 0;
            if (amt <= 0 || _toKey == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select an account and valid amount')),
              );
              return;
            }
            context.read<ERPCubit>().transferMoney(
                  fromKey: widget.fromKey,
                  toKey: _toKey!,
                  amount: amt,
                  date: _date,
                  description: _desc.text.trim(),
                );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
          ),
          child: const Text('Confirm Transfer'),
        ),
      ],
    );
  }
}

class _OpeningBalanceDialog extends StatefulWidget {
  final String accountKey;
  const _OpeningBalanceDialog({required this.accountKey});

  @override
  State<_OpeningBalanceDialog> createState() => _OpeningBalanceDialogState();
}

class _OpeningBalanceDialogState extends State<_OpeningBalanceDialog> {
  final _amount = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text('Set Opening Balance', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Opening Amount (Rs.)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.currency_exchange_rounded),
              ),
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
                  labelText: 'Balance Date',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
            final amt = double.tryParse(_amount.text.trim()) ?? 0;
            final txn = Transaction(
              id: 'OPEN-${widget.accountKey}',
              accountName: context.read<ERPCubit>().state.accounts[widget.accountKey]!.name,
              type: TransactionType.opening,
              amount: amt,
              person: 'System',
              description: 'Opening Balance Entry',
              date: _date,
            );
            context.read<ERPCubit>().addTransaction(txn);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
          ),
          child: const Text('Set Balance'),
        ),
      ],
    );
  }
}
