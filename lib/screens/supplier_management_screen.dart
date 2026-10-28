import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/supplier.dart';
import 'supplier_profile_screen.dart';

class SupplierManagementScreen extends StatefulWidget {
  const SupplierManagementScreen({super.key});

  @override
  State<SupplierManagementScreen> createState() => _SupplierManagementScreenState();
}

class _SupplierManagementScreenState extends State<SupplierManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _manualIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _shopController = TextEditingController();
  final _locationController = TextEditingController();
  final _openingBalanceController = TextEditingController();
  final _whatsappController = TextEditingController();

  void _showAddSupplierDialog(BuildContext context) {
    final nextId = context.read<ERPCubit>().getNextSupplierId();
    _manualIdController.text = nextId;
    _nameController.clear();
    _phoneController.clear();
    _shopController.clear();
    _locationController.clear();
    _openingBalanceController.clear();
    _whatsappController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person_add_rounded, color: Color(0xFF4F46E5), size: 22),
            SizedBox(width: 10),
            Text('Add New Supplier Khata', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'A supplier identifier has been automatically assigned. Enter vendor details to register.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _manualIdController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Supplier ID / Code (Auto)',
                            prefixIcon: const Icon(Icons.tag_rounded, size: 20),
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFC7D2FE)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.auto_awesome_rounded, size: 14, color: Color(0xFF4F46E5)),
                                  SizedBox(width: 4),
                                  Text('AUTO', style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 11)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'Contact Person Name *',
                            hintText: 'e.g. Haji Aslam',
                            prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _shopController,
                          decoration: const InputDecoration(
                            labelText: 'Business / Shop Name',
                            hintText: 'e.g. Aslam Steel Mills',
                            prefixIcon: Icon(Icons.storefront_rounded, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'City / Workshop Area',
                            hintText: 'e.g. Peshawar Road, Rawalpindi',
                            prefixIcon: Icon(Icons.place_outlined, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Primary Phone',
                            hintText: '03001234567',
                            prefixIcon: Icon(Icons.phone_outlined, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          controller: _whatsappController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'WhatsApp Number',
                            hintText: '03001234567',
                            prefixIcon: Icon(Icons.chat_bubble_outline_rounded, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _openingBalanceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Opening Balance (Optional Payable)',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.account_balance_wallet_outlined, size: 20),
                      helperText: 'Positive value represents existing amount owed to this supplier',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final openingBal = double.tryParse(_openingBalanceController.text) ?? 0.0;
                final supplierId = _manualIdController.text.trim().isNotEmpty
                    ? _manualIdController.text.trim()
                    : context.read<ERPCubit>().getNextSupplierId();
                await context.read<ERPCubit>().addSupplier(Supplier(
                  id: supplierId,
                  name: _nameController.text.trim(),
                  phone: _phoneController.text.trim(),
                  shopName: _shopController.text.trim(),
                  location: _locationController.text.trim(),
                  openingBalance: openingBal,
                  remainingBalance: openingBal,
                  whatsappNumber: _whatsappController.text.trim(),
                  registrationDate: DateTime.now(),
                ));
                if (!context.mounted) return;
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.check_rounded, size: 18),
            label: const Text('Create Khata'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final totalPayable = state.suppliers.fold<double>(
          0,
          (sum, s) => sum + (s.remainingBalance > 0 ? s.remainingBalance : 0),
        );
        final totalSuppliers = state.suppliers.length;
        final clearedSuppliers = state.suppliers.where((s) => s.remainingBalance.abs() < 1.0).length;

        final query = state.searchQuery.toLowerCase();
        final filteredSuppliers = state.suppliers.where((s) {
          return query.isEmpty ||
              s.name.toLowerCase().contains(query) ||
              s.id.toLowerCase().contains(query) ||
              s.shopName.toLowerCase().contains(query);
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Row
            Row(
              children: [
                Expanded(
                  child: _SupplierStatCard(
                    title: 'Total Active Suppliers',
                    value: totalSuppliers.toString(),
                    icon: Icons.inventory_2_rounded,
                    color: const Color(0xFF4F46E5),
                    bg: const Color(0xFFEEF2FF),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SupplierStatCard(
                    title: 'Total Outstanding Payable',
                    value: 'Rs. ${NumberFormat('#,##0').format(totalPayable)}',
                    icon: Icons.receipt_long_rounded,
                    color: const Color(0xFFDC2626),
                    bg: const Color(0xFFFEE2E2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SupplierStatCard(
                    title: 'Settled / Cleared Accounts',
                    value: clearedSuppliers.toString(),
                    icon: Icons.check_circle_rounded,
                    color: const Color(0xFF059669),
                    bg: const Color(0xFFECFDF5),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _showAddSupplierDialog(context),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('New Supplier Khata'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Modern Table Card
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTableHeader(),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    Expanded(
                      child: filteredSuppliers.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade300),
                                  const SizedBox(height: 12),
                                  Text(
                                    state.searchQuery.isNotEmpty
                                        ? 'No suppliers match "${state.searchQuery}"'
                                        : 'No suppliers registered yet. Click "New Supplier Khata" to begin.',
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: filteredSuppliers.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                              itemBuilder: (context, index) => _SupplierRow(
                                supplier: filteredSuppliers[index],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 1, child: Text('SUPPLIER ID', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          Expanded(flex: 3, child: Text('CONTACT & SHOP INFO', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          Expanded(flex: 2, child: Text('LOCATION / PHONE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          Expanded(flex: 2, child: Text('OUTSTANDING BALANCE', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          SizedBox(width: 120, child: Text('ACTIONS', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
        ],
      ),
    );
  }
}

class _SupplierStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bg;

  const _SupplierStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.4),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SupplierRow extends StatefulWidget {
  final Supplier supplier;

  const _SupplierRow({required this.supplier});

  @override
  State<_SupplierRow> createState() => _SupplierRowState();
}

class _SupplierRowState extends State<_SupplierRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.supplier;
    final isPayable = s.remainingBalance > 0.01;
    final isClear = s.remainingBalance.abs() <= 0.01;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SupplierProfileScreen(supplierId: s.id)),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
          child: Row(
            children: [
              // Supplier Code Monospace
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFC7D2FE)),
                    ),
                    child: Text(
                      s.id,
                      style: const TextStyle(
                        color: Color(0xFF4338CA),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),

              // Name & Shop
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          s.name.isNotEmpty ? s.name[0].toUpperCase() : 'S',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.name,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Color(0xFF0F172A)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (s.shopName.isNotEmpty)
                            Text(
                              s.shopName,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Location & Phone
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (s.phone.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 13, color: Color(0xFF64748B)),
                          const SizedBox(width: 5),
                          Text(s.phone, style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155))),
                        ],
                      ),
                    if (s.location.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.place_outlined, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 5),
                          Text(s.location, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),
                  ],
                ),
              ),

              // Financial Status
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rs. ${NumberFormat('#,##0').format(s.remainingBalance.abs())}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isClear
                            ? const Color(0xFF059669)
                            : (isPayable ? const Color(0xFFDC2626) : const Color(0xFF2563EB)),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isClear
                            ? const Color(0xFFD1FAE5)
                            : (isPayable ? const Color(0xFFFEE2E2) : const Color(0xFFDBEAFE)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isClear ? 'SETTLED' : (isPayable ? 'PAYABLE' : 'ADVANCE'),
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: isClear
                              ? const Color(0xFF047857)
                              : (isPayable ? const Color(0xFFB91C1C) : const Color(0xFF1D4ED8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Open Profile Action
              SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SupplierProfileScreen(supplierId: s.id)),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Ledger', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 16),
                        ],
                      ),
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


