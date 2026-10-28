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

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final currencyFormat = NumberFormat('#,##0');
    final dateFormat = DateFormat('dd MMM yyyy');

    return Padding(
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
