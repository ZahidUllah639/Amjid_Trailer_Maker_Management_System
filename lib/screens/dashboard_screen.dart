import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/traila.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final pendingCount = state.trailas.where((t) => t.status == TrailaStatus.pending).length;
        final readyCount = state.trailas.where((t) => t.status == TrailaStatus.ready).length;
        final soldCount = state.trailas.where((t) => t.status == TrailaStatus.sold).length;
        final totalUnits = state.trailas.length;

        final totalBalance = state.accounts.keys.fold<double>(
          0,
          (sum, key) => sum + context.read<ERPCubit>().calculateBalance(key),
        );

        // Sort trailas by registrationDate descending for recent preview
        final recentTrailas = List<Traila>.from(state.trailas)
          ..sort((a, b) => b.registrationDate.compareTo(a.registrationDate));
        final topRecent = recentTrailas.take(5).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Welcome Banner
              _buildHeroBanner(context, state, pendingCount, totalUnits),
              const SizedBox(height: 24),

              // Production Pipeline Section Header
              const Text(
                'Manufacturing Pipeline',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 12),

              // Production Pipeline Cards
              Row(
                children: [
                  Expanded(
                    child: _PipelineCard(
                      title: 'Under Fabrication',
                      subtitle: 'Active workshop units',
                      value: pendingCount.toString(),
                      icon: Icons.precision_manufacturing_rounded,
                      color: const Color(0xFFF59E0B), // Amber
                      bgColor: const Color(0xFFFEF3C7),
                      onTap: () => context.read<ERPCubit>().setModuleIndex(1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PipelineCard(
                      title: 'Ready for Delivery',
                      subtitle: 'Tested & inspection passed',
                      value: readyCount.toString(),
                      icon: Icons.check_circle_rounded,
                      color: const Color(0xFF10B981), // Emerald
                      bgColor: const Color(0xFFD1FAE5),
                      onTap: () => context.read<ERPCubit>().setModuleIndex(1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PipelineCard(
                      title: 'Sold & Dispatched',
                      subtitle: 'Delivered to clients',
                      value: soldCount.toString(),
                      icon: Icons.local_shipping_rounded,
                      color: const Color(0xFF3B82F6), // Blue
                      bgColor: const Color(0xFFDBEAFE),
                      onTap: () => context.read<ERPCubit>().setModuleIndex(1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Financial & Operational Metrics
              Row(
                children: [
                  Expanded(
                    child: _VitalityCard(
                      title: 'Total Net Liquidity',
                      value: 'Rs. ${NumberFormat('#,##0').format(totalBalance)}',
                      subtitle: 'Available Cash & Bank Reserves',
                      icon: Icons.account_balance_wallet_rounded,
                      gradient: const [Color(0xFF4F46E5), Color(0xFF3730A3)],
                      onTap: () => context.read<ERPCubit>().setModuleIndex(7),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _VitalityCard(
                      title: 'Active Suppliers',
                      value: state.suppliers.length.toString(),
                      subtitle: 'Raw material khata ledgers',
                      icon: Icons.inventory_2_rounded,
                      gradient: const [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                      onTap: () => context.read<ERPCubit>().setModuleIndex(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _VitalityCard(
                      title: 'Labour Workforce',
                      value: state.labours.length.toString(),
                      subtitle: 'Active workshop technicians',
                      icon: Icons.groups_rounded,
                      gradient: const [Color(0xFF0D9488), Color(0xFF115E59)],
                      onTap: () => context.read<ERPCubit>().setModuleIndex(3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Quick Actions Bar
              const Text(
                'Quick Operations Dock',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      title: 'New Traila',
                      description: 'Add new chassis unit',
                      icon: Icons.add_circle_outline_rounded,
                      accentColor: const Color(0xFF4F46E5),
                      onTap: () => context.read<ERPCubit>().setModuleIndex(1),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _QuickActionCard(
                      title: 'Supplier Purchase',
                      description: 'Log steel & parts bill',
                      icon: Icons.add_shopping_cart_rounded,
                      accentColor: const Color(0xFFD97706),
                      onTap: () => context.read<ERPCubit>().setModuleIndex(2),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _QuickActionCard(
                      title: 'Labour Wage Entry',
                      description: 'Record work & payments',
                      icon: Icons.engineering_rounded,
                      accentColor: const Color(0xFF059669),
                      onTap: () => context.read<ERPCubit>().setModuleIndex(3),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _QuickActionCard(
                      title: 'Record Trailer Sale',
                      description: 'Invoice & client receipt',
                      icon: Icons.receipt_long_rounded,
                      accentColor: const Color(0xFF2563EB),
                      onTap: () => context.read<ERPCubit>().setModuleIndex(5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Recent Trailers Production Table
              _buildRecentProductionTable(context, topRecent),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroBanner(BuildContext context, ERPState state, int pending, int total) {
    final businessName = state.appProfile?.businessName ?? 'Traila Engineering Workshop';
    final ownerName = state.ownerName.isNotEmpty ? state.ownerName : 'Operations Manager';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt_rounded, size: 14, color: Color(0xFF818CF8)),
                          SizedBox(width: 4),
                          Text(
                            'LIVE WORKSHOP ENGINE',
                            style: TextStyle(
                              color: Color(0xFFC7D2FE),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Welcome, $ownerName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$businessName • $pending units currently in active fabrication pipeline out of $total total fleet records.',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton.icon(
            onPressed: () => context.read<ERPCubit>().setModuleIndex(1),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Register Unit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentProductionTable(BuildContext context, List<Traila> trailas) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.history_rounded, size: 20, color: Color(0xFF4F46E5)),
                    SizedBox(width: 10),
                    Text(
                      'Recent Workshop Activity',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.read<ERPCubit>().setModuleIndex(1),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All Fleet',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFF4F46E5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          if (trailas.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: Center(
                child: Text(
                  'No trailer records yet. Click "Register Unit" to begin.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trailas.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
              itemBuilder: (context, index) {
                final traila = trailas[index];
                return InkWell(
                  onTap: () {
                    context.read<ERPCubit>().setTrailaHistoryId(traila.id);
                    context.read<ERPCubit>().setModuleIndex(1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFC7D2FE)),
                          ),
                          child: Text(
                            traila.id,
                            style: const TextStyle(
                              color: Color(0xFF4338CA),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                traila.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.5,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                DateFormat('dd MMM yyyy').format(traila.registrationDate),
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Cost: Rs. ${NumberFormat('#,##0').format(traila.totalManufacturingCost)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ),
                        _buildStatusBadge(traila.status),
                        const SizedBox(width: 14),
                        const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF94A3B8)),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(TrailaStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case TrailaStatus.pending:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        label = 'IN WORKSHOP';
        break;
      case TrailaStatus.ready:
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF047857);
        label = 'READY';
        break;
      case TrailaStatus.sold:
        bg = const Color(0xFFDBEAFE);
        fg = const Color(0xFF1D4ED8);
        label = 'SOLD';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _PipelineCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _PipelineCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  State<_PipelineCard> createState() => _PipelineCardState();
}

class _PipelineCardState extends State<_PipelineCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered ? widget.color : const Color(0xFFE2E8F0),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? widget.color.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: _isHovered ? 12 : 6,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
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

class _VitalityCard extends StatefulWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _VitalityCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_VitalityCard> createState() => _VitalityCardState();
}

class _VitalityCardState extends State<_VitalityCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.first.withValues(alpha: _isHovered ? 0.45 : 0.25),
                blurRadius: _isHovered ? 16 : 10,
                offset: Offset(0, _isHovered ? 6 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon, color: Colors.white, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                widget.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered ? widget.accentColor : const Color(0xFFE2E8F0),
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? widget.accentColor.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: _isHovered ? 10 : 4,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: widget.accentColor, size: 22),
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

