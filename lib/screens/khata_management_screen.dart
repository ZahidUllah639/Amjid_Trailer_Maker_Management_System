import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/khata.dart';
import '../widgets/add_khata_dialog.dart';
import 'khata_profile_screen.dart';

class KhataManagementScreen extends StatefulWidget {
  const KhataManagementScreen({super.key});

  @override
  State<KhataManagementScreen> createState() => _KhataManagementScreenState();
}

class _KhataManagementScreenState extends State<KhataManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final query = state.searchQuery.toLowerCase();
        final filteredKhatas = state.khatas.where((k) {
          return query.isEmpty || k.personName.toLowerCase().contains(query);
        }).toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        // Calculate Receivables (positive) & Payables (negative)
        double totalReceivable = 0;
        double totalPayable = 0;
        for (var k in state.khatas) {
          if (k.remainingBalance > 0) {
            totalReceivable += k.remainingBalance;
          } else if (k.remainingBalance < 0) {
            totalPayable += k.remainingBalance.abs();
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Row
            Row(
              children: [
                Expanded(
                  child: _KhataStatCard(
                    title: "Total Receivable (You'll Get)",
                    value: 'Rs. ${NumberFormat('#,##0').format(totalReceivable)}',
                    icon: Icons.call_received_rounded,
                    color: const Color(0xFF059669),
                    bg: const Color(0xFFECFDF5),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _KhataStatCard(
                    title: "Total Payable (You'll Give)",
                    value: 'Rs. ${NumberFormat('#,##0').format(totalPayable)}',
                    icon: Icons.call_made_rounded,
                    color: const Color(0xFFDC2626),
                    bg: const Color(0xFFFEE2E2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _KhataStatCard(
                    title: 'Active Khata Accounts',
                    value: '${state.khatas.length} People',
                    icon: Icons.menu_book_rounded,
                    color: const Color(0xFF4F46E5),
                    bg: const Color(0xFFEEF2FF),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const AddKhataDialog(),
                  ),
                  icon: const Icon(Icons.person_add_rounded, size: 20),
                  label: const Text('New Khata Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Cashflow Accounts Pill Ribbon
            _buildAccountsRibbon(state),
            const SizedBox(height: 16),

            // Main Ledger Table Card
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
                      child: filteredKhatas.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person_search_rounded, size: 48, color: Colors.grey.shade300),
                                  const SizedBox(height: 12),
                                  Text(
                                    state.searchQuery.isNotEmpty
                                        ? 'No khata entries match "${state.searchQuery}"'
                                        : 'No personal khata ledgers found. Click "New Khata Account" to add.',
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
                              itemCount: filteredKhatas.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                              itemBuilder: (context, index) => _KhataRow(
                                khata: filteredKhatas[index],
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

  Widget _buildAccountsRibbon(ERPState state) {
    final accounts = state.accounts.values.toList();
    if (accounts.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        const Icon(Icons.account_balance_wallet_outlined, size: 16, color: Color(0xFF64748B)),
        const SizedBox(width: 8),
        const Text(
          'Liquid Reserves:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: accounts.map((acc) {
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        acc.name,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Rs. ${NumberFormat('#,##0').format(acc.balance)}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
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
          Expanded(flex: 3, child: Text('PERSON / PARTY NAME', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          Expanded(flex: 2, child: Text('LAST TRANSACTION DATE', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          Expanded(flex: 2, child: Text('NET BALANCE POSITION', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
          SizedBox(width: 130, child: Text('ACTIONS', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: Color(0xFF64748B), letterSpacing: 0.5))),
        ],
      ),
    );
  }
}

class _KhataStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bg;

  const _KhataStatCard({
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

class _KhataRow extends StatefulWidget {
  final Khata khata;

  const _KhataRow({required this.khata});

  @override
  State<_KhataRow> createState() => _KhataRowState();
}

class _KhataRowState extends State<_KhataRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final k = widget.khata;
    final balance = k.remainingBalance;
    final isGet = balance > 0.01;
    final isGive = balance < -0.01;
    final isSettled = balance.abs() <= 0.01;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KhataProfileScreen(khataId: k.id)),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
          child: Row(
            children: [
              // Person Name & Avatar
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isGet
                              ? [const Color(0xFF10B981), const Color(0xFF059669)]
                              : (isGive
                                  ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                                  : [const Color(0xFF64748B), const Color(0xFF475569)]),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          k.personName.isNotEmpty ? k.personName[0].toUpperCase() : 'K',
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
                            k.personName,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Color(0xFF0F172A)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Khata #${k.id}',
                            style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Date
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('dd MMM yyyy').format(k.date),
                      style: const TextStyle(color: Color(0xFF475569), fontSize: 13),
                    ),
                  ],
                ),
              ),

              // Balance
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rs. ${NumberFormat('#,##0').format(balance.abs())}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isSettled
                            ? const Color(0xFF64748B)
                            : (isGet ? const Color(0xFF059669) : const Color(0xFFDC2626)),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSettled
                            ? const Color(0xFFF1F5F9)
                            : (isGet ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isSettled
                            ? 'SETTLED'
                            : (isGet ? "YOU'LL GET" : "YOU'LL GIVE"),
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: isSettled
                              ? const Color(0xFF64748B)
                              : (isGet ? const Color(0xFF047857) : const Color(0xFFB91C1C)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Action
              SizedBox(
                width: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => KhataProfileScreen(khataId: k.id)),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Open Ledger', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
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

