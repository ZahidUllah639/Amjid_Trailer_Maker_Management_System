import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:window_manager/window_manager.dart';
import '../cubits/erp_cubit.dart';
import 'backup_restore_dialog.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _moduleTitles = [
    {'title': 'Operations Dashboard', 'subtitle': 'Real-time production & workshop metrics'},
    {'title': 'Traila Fleet Register', 'subtitle': 'Unit manufacturing & build records'},
    {'title': 'Supplier Management', 'subtitle': 'Raw materials, bills & payment ledgers'},
    {'title': 'Labour & Wages', 'subtitle': 'Workforce attendance & piece-rate payout'},
    {'title': 'Khata Accounts', 'subtitle': 'Multi-entity business ledgers & records'},
    {'title': 'Sales & Invoices', 'subtitle': 'Customer orders, receivables & receipts'},
    {'title': 'Expense & Revenue', 'subtitle': 'Operating overheads & income tracking'},
    {'title': 'Cash & Bank Flow', 'subtitle': 'Liquidity balances & internal transfers'},
    {'title': 'Workshop Profile', 'subtitle': 'Business identity & official headers'},
    {'title': 'Hardware & Printing', 'subtitle': 'Thermal POS 58/80mm & A4 laser setup'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final moduleIndex = state.currentModuleIndex;
        final info = (moduleIndex >= 0 && moduleIndex < _moduleTitles.length)
            ? _moduleTitles[moduleIndex]
            : {'title': 'Traila ERP', 'subtitle': 'Workshop Management System'};

        final totalLiquidity = state.accounts.keys.fold<double>(
          0,
          (sum, key) => sum + context.read<ERPCubit>().calculateBalance(key),
        );

        final todayStr = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());

        return Container(
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
          ),
          child: Row(
            children: [
              // Screen Title & Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    info['title']!,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    info['subtitle']!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Date Capsule
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 13, color: Color(0xFF64748B)),
                    const SizedBox(width: 6),
                    Text(
                      todayStr,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Live Liquidity Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded, size: 14, color: Color(0xFF059669)),
                    const SizedBox(width: 7),
                    Text(
                      'Rs. ${NumberFormat('#,##0').format(totalLiquidity)}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF047857),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Search Box
              Container(
                width: 260,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => context.read<ERPCubit>().setSearchQuery(value),
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search records...',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF94A3B8)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF94A3B8)),
                            onPressed: () {
                              _searchController.clear();
                              context.read<ERPCubit>().setSearchQuery('');
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 9),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Enterprise Backup Button
              InkWell(
                onTap: () => BackupRestoreDialog.show(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFC7D2FE)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_sync_rounded, size: 16, color: Color(0xFF4F46E5)),
                      SizedBox(width: 6),
                      Text(
                        'Backup',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4338CA),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Admin Avatar & Name
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state.ownerName.isNotEmpty ? state.ownerName : 'Admin',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),
              Container(width: 1, height: 26, color: const Color(0xFFE2E8F0)),
              const SizedBox(width: 10),

              // Desktop Window Corner Controls (Minimize, Maximize, Exit)
              const _WindowControlButtons(),
            ],
          ),
        );
      },
    );
  }
}

class _WindowControlButtons extends StatefulWidget {
  const _WindowControlButtons();

  @override
  State<_WindowControlButtons> createState() => _WindowControlButtonsState();
}

class _WindowControlButtonsState extends State<_WindowControlButtons> {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    _checkMaximizedState();
  }

  Future<void> _checkMaximizedState() async {
    try {
      final max = await windowManager.isMaximized();
      if (mounted) setState(() => _isMaximized = max);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Minimize Button
        _WindowHoverButton(
          icon: Icons.remove_rounded,
          tooltip: 'Minimize',
          onTap: () async => await windowManager.minimize(),
        ),
        const SizedBox(width: 2),

        // Maximize / Restore Button
        _WindowHoverButton(
          icon: _isMaximized ? Icons.filter_none_rounded : Icons.crop_square_rounded,
          tooltip: _isMaximized ? 'Restore Down' : 'Maximize',
          iconSize: _isMaximized ? 14 : 16,
          onTap: () async {
            final isMax = await windowManager.isMaximized();
            if (isMax) {
              await windowManager.unmaximize();
              if (mounted) setState(() => _isMaximized = false);
            } else {
              await windowManager.maximize();
              if (mounted) setState(() => _isMaximized = true);
            }
          },
        ),
        const SizedBox(width: 2),

        // Exit / Close Button (Windows style red hover)
        _WindowHoverButton(
          icon: Icons.close_rounded,
          tooltip: 'Close Application',
          isClose: true,
          onTap: () async => await windowManager.close(),
        ),
      ],
    );
  }
}

class _WindowHoverButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isClose;
  final double iconSize;

  const _WindowHoverButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isClose = false,
    this.iconSize = 16,
  });

  @override
  State<_WindowHoverButton> createState() => _WindowHoverButtonState();
}

class _WindowHoverButtonState extends State<_WindowHoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.transparent;
    Color iconColor = const Color(0xFF64748B);

    if (_isHovered) {
      if (widget.isClose) {
        bg = const Color(0xFFE11D48);
        iconColor = Colors.white;
      } else {
        bg = const Color(0xFFF1F5F9);
        iconColor = const Color(0xFF0F172A);
      }
    }

    return Tooltip(
      message: widget.tooltip,
      waitDuration: const Duration(milliseconds: 400),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            width: 34,
            height: 32,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


