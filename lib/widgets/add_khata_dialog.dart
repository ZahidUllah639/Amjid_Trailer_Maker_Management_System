import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/khata.dart';

class AddKhataDialog extends StatefulWidget {
  final String? initialPersonName;
  final bool isNameLocked;
  
  const AddKhataDialog({
    super.key, 
    this.initialPersonName,
    this.isNameLocked = false,
  });

  @override
  State<AddKhataDialog> createState() => _AddKhataDialogState();
}

class _AddKhataDialogState extends State<AddKhataDialog> {
  late final _nameController = TextEditingController(text: widget.initialPersonName);
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _openingBalanceController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  KhataTransactionType _selectedType = KhataTransactionType.cashOut;
  String _paymentMethod = 'Cash'; // Default account
  
  final List<KhataTransaction> _transactions = [];
  bool _isSaving = false;
  bool _syncToAccount = true; // Default to sync

  void _addTransaction() {
    if (_amountController.text.trim().isEmpty) return;
    
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) return;

    setState(() {
      _transactions.add(KhataTransaction(
        id: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        amount: amount,
        type: _selectedType,
        date: _selectedDate,
        paymentMethod: _paymentMethod,
        syncToAccount: _syncToAccount,
      ));
      _descriptionController.clear();
      _amountController.clear();
    });
  }

  void _removeTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
    });
  }

  double get _totalCashOut => _transactions.where((t) => t.type == KhataTransactionType.cashOut).fold(0, (sum, t) => sum + t.amount);
  double get _totalCashIn => _transactions.where((t) => t.type == KhataTransactionType.cashIn).fold(0, (sum, t) => sum + t.amount);

  Future<void> _handleSave() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter person name')));
      return;
    }
    if (_transactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one transaction')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final openingBal = double.tryParse(_openingBalanceController.text.trim()) ?? 0.0;
      final totalOut = _totalCashOut;
      final totalIn = _totalCashIn;
      final remaining = (openingBal + totalOut) - totalIn;
      
      final khataId = 'KH-${DateTime.now().millisecondsSinceEpoch}';
      
      final khata = Khata(
        id: khataId,
        personName: _nameController.text.trim(),
        openingBalance: openingBal,
        totalAmount: totalOut,
        paidAmount: totalIn,
        remainingBalance: remaining,
        date: _selectedDate,
        items: List.from(_transactions),
      );

      await context.read<ERPCubit>().addKhata(khata);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Khata created successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ERPCubit>().state;
    final accounts = state.accounts.values.toList();
    
    // Ensure _paymentMethod is valid if accounts list changed
    if (accounts.isNotEmpty && !accounts.any((a) => a.name == _paymentMethod)) {
      _paymentMethod = accounts.first.name;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.isNameLocked ? 'Add New Entry' : 'Register New Person', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                readOnly: widget.isNameLocked,
                decoration: const InputDecoration(
                  labelText: 'Person Name',
                  hintText: 'e.g. Zahid',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              if (!widget.isNameLocked) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _openingBalanceController,
                  decoration: const InputDecoration(
                    labelText: 'Opening Balance (Optional)',
                    hintText: 'Existing debt or credit',
                    border: OutlineInputBorder(),
                    prefixText: 'Rs. ',
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _selectedDate = picked);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(DateFormat('dd-MM-yyyy').format(_selectedDate)),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Add Transaction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SegmentedButton<KhataTransactionType>(
                            segments: const [
                              ButtonSegment(
                                value: KhataTransactionType.cashOut,
                                label: Text('Cash Out'),
                                icon: Icon(Icons.arrow_upward, size: 16),
                              ),
                              ButtonSegment(
                                value: KhataTransactionType.cashIn,
                                label: Text('Cash In'),
                                icon: Icon(Icons.arrow_downward, size: 16),
                              ),
                            ],
                            selected: {_selectedType},
                            onSelectionChanged: (set) {
                              setState(() => _selectedType = set.first);
                            },
                            style: SegmentedButton.styleFrom(
                              selectedBackgroundColor: _selectedType == KhataTransactionType.cashOut ? Colors.red.shade100 : Colors.green.shade100,
                              selectedForegroundColor: _selectedType == KhataTransactionType.cashOut ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            initialValue: _paymentMethod,
                            decoration: const InputDecoration(
                              labelText: 'Account',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: accounts.map((a) => DropdownMenuItem(value: a.name, child: Text(a.name))).toList(),
                            onChanged: (v) => setState(() => _paymentMethod = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: _syncToAccount,
                      onChanged: (v) => setState(() => _syncToAccount = v ?? true),
                      title: const Text('Record to Business Account', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: Text('If unticked, this stays in this ledger only.', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              border: OutlineInputBorder(),
                              prefixText: 'Rs. ',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description (Optional)',
                              hintText: 'What was this for?',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: _addTransaction,
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: _selectedType == KhataTransactionType.cashOut ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_transactions.isNotEmpty) ...[
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _transactions.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final txn = _transactions[index];
                        final isOut = txn.type == KhataTransactionType.cashOut;
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            isOut ? Icons.arrow_upward : Icons.arrow_downward,
                            color: isOut ? Colors.red : Colors.green,
                            size: 18,
                          ),
                          title: Row(
                            children: [
                              Text(txn.description ?? 'No Description'),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  txn.paymentMethod!,
                                  style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                txn.syncToAccount ? Icons.sync_alt : Icons.sync_disabled,
                                size: 14,
                                color: txn.syncToAccount ? Colors.blue : Colors.orange,
                              ),
                            ],
                          ),
                          subtitle: Text(DateFormat('dd-MM-yyyy').format(txn.date)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Rs. ${txn.amount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isOut ? Colors.red : Colors.green,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _removeTransaction(index),
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.grey, size: 20),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('Total Cash Out:', 'Rs. ${_totalCashOut.toStringAsFixed(0)}', Colors.red),
                    const SizedBox(height: 4),
                    _buildSummaryRow('Total Cash In:', 'Rs. ${_totalCashIn.toStringAsFixed(0)}', Colors.green),
                    const Divider(),
                    _buildSummaryRow(
                      'Net Balance:',
                      'Rs. ${(_totalCashOut - _totalCashIn).toStringAsFixed(0)}',
                      Colors.blue,
                      isBold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Ledger Entry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: isBold ? 18 : 14)),
      ],
    );
  }
}
