import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/labour.dart';
import 'labour_profile_screen.dart';

class LabourManagementScreen extends StatefulWidget {
  const LabourManagementScreen({super.key});

  @override
  State<LabourManagementScreen> createState() => _LabourManagementScreenState();
}

class _LabourManagementScreenState extends State<LabourManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  final _openingBalanceController = TextEditingController();

  void _showAddLabourDialog(BuildContext context) {
    final nextId = context.read<ERPCubit>().getNextLabourId();
    _idController.text = nextId;
    _nameController.clear();
    _phoneController.clear();
    _whatsappController.clear();
    _addressController.clear();
    _openingBalanceController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.badge_rounded, color: Color(0xFF0D9488), size: 22),
            SizedBox(width: 10),
            Text('Register Workshop Labourer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'A craftsman identifier has been automatically assigned. Enter worker details to register.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _idController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Labour ID / Code (Auto)',
                            prefixIcon: const Icon(Icons.tag_rounded, size: 20),
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDFA),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFF99F6E4)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.auto_awesome_rounded, size: 14, color: Color(0xFF0D9488)),
                                  SizedBox(width: 4),
                                  Text('AUTO', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold, fontSize: 11)),
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
                            labelText: 'Craftsman / Worker Name',
                            hintText: 'e.g. Ustad Tariq Welder',
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
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Contact Phone',
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
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Residential Address / City',
                      hintText: 'e.g. Workshop Quarter #2, Industrial Zone',
                      prefixIcon: Icon(Icons.home_outlined, size: 20),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _openingBalanceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Opening Balance (Unpaid Wages if any)',
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.account_balance_wallet_outlined, size: 20),
                      helperText: 'Positive value represents existing wage payable to this worker',
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
                final labourId = _idController.text.trim().isNotEmpty
                    ? _idController.text.trim()
                    : context.read<ERPCubit>().getNextLabourId();
                final labour = Labour(
                  id: labourId,
                  name: _nameController.text.trim(),
                  phone: _phoneController.text.trim(),
                  whatsappNumber: _whatsappController.text.trim(),
                  address: _addressController.text.trim(),
                  openingBalance: double.tryParse(_openingBalanceController.text.trim()) ?? 0.0,
                  registrationDate: DateTime.now(),
                );
                await context.read<ERPCubit>().addLabour(labour);
                if (!context.mounted) return;
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.check_rounded, size: 18),
            label: const Text('Register Worker'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final totalPayable = state.labours.fold<double>(
          0,
          (sum, l) => sum + (l.remainingBalance > 0 ? l.remainingBalance : 0),
        );
        final totalLabours = state.labours.length;
        final settledCount = state.labours.where((l) => l.remainingBalance.abs() < 1.0).length;

        final query = state.searchQuery.toLowerCase();
        final filteredLabours = state.labours.where((l) {
          return query.isEmpty ||
              l.name.toLowerCase().contains(query) ||
              l.id.toLowerCase().contains(query) ||
              l.phone.toLowerCase().contains(query);
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Row
            Row(
              children: [
                Expanded(
                  child: _LabourStatCard(
                    title: 'Active Workforce',
                    value: '$totalLabours Craftsmen',
                    icon: Icons.groups_rounded,
                    color: const Color(0xFF0D9488),
                    bg: const Color(0xFFCCFBF1),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _LabourStatCard(
                    title: 'Outstanding Wages Due',
                    value: 'Rs. ${NumberFormat('#,##0').format(totalPayable)}',
                    icon: Icons.payments_rounded,
                    color: const Color(0xFFDC2626),
                    bg: const Color(0xFFFEE2E2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _LabourStatCard(
                    title: 'Settled Worker Accounts',
                    value: '$settledCount Workers',
                    icon: Icons.verified_user_rounded,
                    color: const Color(0xFF059669),
                    bg: const Color(0xFFECFDF5),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _showAddLabourDialog(context),
                  icon: const Icon(Icons.person_add_rounded, size: 20),
                  label: const Text('Register New Worker'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
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
                      child: filteredLabours.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.badge_outlined, size: 48, color: Colors.grey.shade300),
                                  const SizedBox(height: 12),
                                  Text(
                                    state.searchQuery.isNotEmpty
                                        ? 'No workers match "${state.searchQuery}"'
                                        : 'No labourers registered yet. Click "Register New Worker" to begin.',
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
                              itemCount: filteredLabours.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                              itemBuilder: (context, index) => _LabourRow(
                                labour: filteredLabours[index],
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
          Expanded(flex: 1, child: Text('WORKER ID', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          Expanded(flex: 3, child: Text('CRAFTSMAN / TECHNICIAN', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          Expanded(flex: 2, child: Text('CONTACT & RESIDENCE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          Expanded(flex: 2, child: Text('OUTSTANDING WAGES', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          SizedBox(width: 120, child: Text('ACTIONS', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
        ],
      ),
    );
  }
}

class _LabourStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bg;

  const _LabourStatCard({
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

class _LabourRow extends StatefulWidget {
  final Labour labour;

  const _LabourRow({required this.labour});

  @override
  State<_LabourRow> createState() => _LabourRowState();
}

class _LabourRowState extends State<_LabourRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l = widget.labour;
    final isPayable = l.remainingBalance > 0.01;
    final isClear = l.remainingBalance.abs() <= 0.01;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LabourProfileScreen(labourId: l.id)),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
          child: Row(
            children: [
              // Worker Monospace ID
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCCFBF1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF99F6E4)),
                    ),
                    child: Text(
                      l.id,
                      style: const TextStyle(
                        color: Color(0xFF0F766E),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),

              // Name with Teal Avatar
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          l.name.isNotEmpty ? l.name[0].toUpperCase() : 'L',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l.name,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Color(0xFF0F172A)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Phone & Address
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (l.phone.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 13, color: Color(0xFF64748B)),
                          const SizedBox(width: 5),
                          Text(l.phone, style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155))),
                        ],
                      ),
                    if (l.address.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.place_outlined, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 5),
                          Text(l.address, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),
                  ],
                ),
              ),

              // Wages Balance
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rs. ${NumberFormat('#,##0').format(l.remainingBalance.abs())}',
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

              // Ledger Button
              SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LabourProfileScreen(labourId: l.id)),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF0D9488),
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

