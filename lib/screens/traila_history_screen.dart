import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/traila.dart';

class TrailaHistoryScreen extends StatefulWidget {
  final String trailaId;
  const TrailaHistoryScreen({super.key, required this.trailaId});

  @override
  State<TrailaHistoryScreen> createState() => _TrailaHistoryScreenState();
}

class _TrailaHistoryScreenState extends State<TrailaHistoryScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0');
    final dateFormat = DateFormat('dd MMM yyyy');

    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final traila = state.trailas.firstWhere(
          (t) => t.id == widget.trailaId,
          orElse: () => Traila(
            id: widget.trailaId,
            name: 'Unknown Traila',
            registrationDate: DateTime.now(),
            status: TrailaStatus.pending,
          ),
        );

        // Expense calculations
        final totalCost = traila.totalManufacturingCost;
        final materialCost = traila.expenses
            .where((e) => e.type.toLowerCase() == 'material')
            .fold<double>(0, (sum, e) => sum + e.amount);
        final labourCost = traila.expenses
            .where((e) => e.type.toLowerCase() == 'labour')
            .fold<double>(0, (sum, e) => sum + e.amount);
        final miscCost = traila.expenses
            .where((e) => e.type.toLowerCase() != 'material' && e.type.toLowerCase() != 'labour')
            .fold<double>(0, (sum, e) => sum + e.amount);

        // Category filtering
        final filteredExpenses = traila.expenses.where((e) {
          if (_selectedCategory == 'All') return true;
          return e.type.toLowerCase() == _selectedCategory.toLowerCase();
        }).toList().reversed.toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
              onPressed: () {
                context.read<ERPCubit>().setTrailaHistoryId(null);
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
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
                    traila.id,
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF4F46E5),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        traila.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Registered: ${dateFormat.format(traila.registrationDate)}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              _buildStatusPill(traila.status),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showAddExpenseDialog(context, traila.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add Manual Expense', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Cost Overview Card
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL MANUFACTURING COST',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${traila.expenses.length} TOTAL EXPENSES',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rs. ${currencyFormat.format(totalCost)}',
                        style: const TextStyle(
                          color: Color(0xFFF87171),
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Segmented progress bar
                      if (totalCost > 0) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 10,
                            child: Row(
                              children: [
                                if (materialCost > 0)
                                  Flexible(
                                    flex: (materialCost * 100 ~/ totalCost).clamp(1, 100),
                                    child: Container(color: const Color(0xFFF59E0B)),
                                  ),
                                if (labourCost > 0)
                                  Flexible(
                                    flex: (labourCost * 100 ~/ totalCost).clamp(1, 100),
                                    child: Container(color: const Color(0xFF14B8A6)),
                                  ),
                                if (miscCost > 0)
                                  Flexible(
                                    flex: (miscCost * 100 ~/ totalCost).clamp(1, 100),
                                    child: Container(color: const Color(0xFF818CF8)),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Sub-cost breakdown
                      Row(
                        children: [
                          Expanded(
                            child: _CostSubPill(
                              label: 'Raw Materials',
                              amount: materialCost,
                              color: const Color(0xFFF59E0B),
                              icon: Icons.inventory_2_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _CostSubPill(
                              label: 'Craftsman Wages',
                              amount: labourCost,
                              color: const Color(0xFF14B8A6),
                              icon: Icons.engineering_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _CostSubPill(
                              label: 'Other / Overheads',
                              amount: miscCost,
                              color: const Color(0xFF818CF8),
                              icon: Icons.add_circle_outline_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // 2. Filter Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Expense Ledger Entries',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        _CategoryFilterChip(
                          label: 'All (${traila.expenses.length})',
                          isSelected: _selectedCategory == 'All',
                          onTap: () => setState(() => _selectedCategory = 'All'),
                        ),
                        _CategoryFilterChip(
                          label: 'Materials',
                          isSelected: _selectedCategory == 'material',
                          onTap: () => setState(() => _selectedCategory = 'material'),
                        ),
                        _CategoryFilterChip(
                          label: 'Labour',
                          isSelected: _selectedCategory == 'labour',
                          onTap: () => setState(() => _selectedCategory = 'labour'),
                        ),
                        _CategoryFilterChip(
                          label: 'Other',
                          isSelected: _selectedCategory == 'additional',
                          onTap: () => setState(() => _selectedCategory = 'additional'),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 3. Expenses List
                if (filteredExpenses.isEmpty)
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
                            'No expenses recorded in this category',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add items via Supplier Bills, Labour Tasks, or the manual button above.',
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
                      itemCount: filteredExpenses.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      itemBuilder: (context, index) {
                        final expense = filteredExpenses[index];
                        return _ExpenseItemRow(
                          expense: expense,
                          trailaId: traila.id,
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

  Widget _buildStatusPill(TrailaStatus status) {
    Color color;
    String label;
    switch (status) {
      case TrailaStatus.ready:
        color = const Color(0xFF10B981);
        label = 'READY FOR SALE';
        break;
      case TrailaStatus.sold:
        color = const Color(0xFF3B82F6);
        label = 'SOLD';
        break;
      case TrailaStatus.pending:
        color = const Color(0xFFF59E0B);
        label = 'IN WORKSHOP';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, String trailaId) {
    final descController = TextEditingController();
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          title: const Text('Add Manual Expense', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Expense Description *',
                    hintText: 'e.g. Paint primer, Transport charges, Bolts',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cost Amount (Rs.) *',
                    hintText: 'e.g. 15000',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.currency_exchange_rounded),
                  ),
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
                    if (picked != null) {
                      setDialogState(() => selectedDate = picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Expense Date',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.calendar_today_rounded),
                    ),
                    child: Text(DateFormat('dd MMMM yyyy').format(selectedDate)),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim()) ?? 0;
                final desc = descController.text.trim();
                if (desc.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an expense description')),
                  );
                  return;
                }
                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount')),
                  );
                  return;
                }

                context.read<ERPCubit>().addTrailaExpense(
                      trailaId,
                      TrailaExpense(
                        id: 'MAN-${DateTime.now().millisecondsSinceEpoch}',
                        type: 'Additional',
                        description: desc,
                        amount: amount,
                        date: selectedDate,
                      ),
                    );
                Navigator.pop(dialogCtx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Add Entry', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CostSubPill extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _CostSubPill({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rs. ${currencyFormat.format(amount)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryFilterChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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

class _ExpenseItemRow extends StatelessWidget {
  final TrailaExpense expense;
  final String trailaId;

  const _ExpenseItemRow({
    required this.expense,
    required this.trailaId,
  });

  IconData _getIcon() {
    switch (expense.type.toLowerCase()) {
      case 'material':
        return Icons.inventory_2_rounded;
      case 'labour':
        return Icons.engineering_rounded;
      default:
        return Icons.add_circle_outline_rounded;
    }
  }

  Color _getColor() {
    switch (expense.type.toLowerCase()) {
      case 'material':
        return const Color(0xFFF59E0B);
      case 'labour':
        return const Color(0xFF14B8A6);
      default:
        return const Color(0xFF818CF8);
    }
  }

  void _showExpenseDetailModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => _ExpenseDetailModal(
        expense: expense,
        trailaId: trailaId,
        onEdit: () {
          Navigator.pop(context);
          _showEditExpenseDialog(context);
        },
        onDelete: () {
          Navigator.pop(context);
          _showDeleteDialog(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final currencyFormat = NumberFormat('#,##0');
    final dateFormat = DateFormat('dd MMM yyyy');

    return InkWell(
      onTap: () => _showExpenseDetailModal(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getIcon(), color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          expense.type.toUpperCase(),
                          style: TextStyle(
                            color: color,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateFormat.format(expense.date),
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'Rs. ${currencyFormat.format(expense.amount)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('View', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                  SizedBox(width: 3),
                  Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Color(0xFF94A3B8)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (val) {
                if (val == 'edit') {
                  _showEditExpenseDialog(context);
                } else if (val == 'delete') {
                  _showDeleteDialog(context);
                }
              },
              icon: const Icon(Icons.more_vert_rounded, size: 18, color: Color(0xFF64748B)),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded, size: 16, color: Color(0xFF4F46E5)),
                      SizedBox(width: 8),
                      Text('Edit Item'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFEF4444)),
                      SizedBox(width: 8),
                      Text('Delete Item'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditExpenseDialog(BuildContext context) {
    final descController = TextEditingController(text: expense.description);
    final amountController = TextEditingController(text: expense.amount.toStringAsFixed(0));
    DateTime selectedDate = expense.date;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          title: const Text('Edit Expense Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (expense.supplierId != null || expense.labourId != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: Color(0xFFB45309), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This entry is linked to a party ledger. Updating will sync balances.',
                            style: TextStyle(color: Color(0xFF92400E), fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount (Rs.)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.currency_exchange_rounded),
                  ),
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
                    if (picked != null) {
                      setDialogState(() => selectedDate = picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.calendar_today_rounded),
                    ),
                    child: Text(DateFormat('dd MMMM yyyy').format(selectedDate)),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim()) ?? 0;
                if (amount > 0) {
                  context.read<ERPCubit>().updateTrailaExpense(
                        expense.id,
                        trailaId,
                        amount: amount,
                        description: descController.text.trim(),
                        date: selectedDate,
                      );
                  Navigator.pop(dialogCtx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Delete Expense Entry?'),
        content: const Text(
          'This will permanently remove this item from history and reduce the total cost of the Traila unit.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ERPCubit>().deleteTrailaExpense(expense.id, trailaId);
              Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete Entry'),
          ),
        ],
      ),
    );
  }
}

class _ExpenseDetailModal extends StatefulWidget {
  final TrailaExpense expense;
  final String trailaId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExpenseDetailModal({
    required this.expense,
    required this.trailaId,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ExpenseDetailModal> createState() => _ExpenseDetailModalState();
}

class _ExpenseDetailModalState extends State<_ExpenseDetailModal> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final expense = widget.expense;
    final currencyFormat = NumberFormat('#,##0');
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy');

    Color color;
    switch (expense.type.toLowerCase()) {
      case 'material':
        color = const Color(0xFFF59E0B);
        break;
      case 'labour':
        color = const Color(0xFF14B8A6);
        break;
      default:
        color = const Color(0xFF818CF8);
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        width: _isExpanded ? 880 : 580,
        constraints: const BoxConstraints(maxHeight: 720),
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
              // 1. Executive Modal Titlebar with Window Controls
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  border: Border(bottom: BorderSide(color: color.withValues(alpha: 0.2))),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: color.withValues(alpha: 0.3)),
                      ),
                      child: Icon(
                        expense.type.toLowerCase() == 'material'
                            ? Icons.inventory_2_rounded
                            : (expense.type.toLowerCase() == 'labour'
                                ? Icons.engineering_rounded
                                : Icons.add_circle_outline_rounded),
                        color: color,
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
                                '${expense.type.toUpperCase()} Expense Record',
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
                                  color: const Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFC7D2FE)),
                                ),
                                child: Text(
                                  'Traila #${widget.trailaId}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF4338CA),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dateFormat.format(expense.date),
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

              // 2. Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Amount Header Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFFEE2E2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'RECORDED EXPENSE AMOUNT',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.6,
                                    color: Color(0xFF991B1B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rs. ${currencyFormat.format(expense.amount)}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFDC2626),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFFECACA)),
                              ),
                              child: Text(
                                expense.type.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Specifications
                      const Text(
                        'EXPENSE SPECIFICATIONS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDetailCell(
                                    icon: Icons.local_shipping_outlined,
                                    label: 'Traila Unit',
                                    value: 'Traila #${widget.trailaId}',
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _buildDetailCell(
                                    icon: Icons.category_outlined,
                                    label: 'Cost Category',
                                    value: expense.type.toUpperCase(),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20, color: Color(0xFFF1F5F9)),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDetailCell(
                                    icon: Icons.calendar_today_rounded,
                                    label: 'Date Incurred',
                                    value: dateFormat.format(expense.date),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _buildDetailCell(
                                    icon: Icons.link_rounded,
                                    label: 'Ledger Link',
                                    value: (expense.supplierId != null || expense.labourId != null)
                                        ? 'Linked to Party Ledger'
                                        : 'Direct Traila Cost',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Description
                      const Text(
                        'DESCRIPTION & REMARKS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          expense.description.isNotEmpty ? expense.description : 'No remarks specified.',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF334155),
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Action Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFDC2626)),
                      label: const Text('Delete Entry', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w700)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFECACA)),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: widget.onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF475569)),
                      label: const Text('Edit Entry', style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w700)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w700)),
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

  Widget _buildDetailCell({required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF475569)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

