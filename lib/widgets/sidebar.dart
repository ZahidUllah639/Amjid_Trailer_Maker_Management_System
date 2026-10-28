import 'dart:ui';
import 'package:flutter/material.dart';
import 'add_khata_dialog.dart';

/// A world-class, glassmorphic desktop navigation sidebar for Amjid Trailer Makers ERP.
/// Features frosted acrylic blur, neon active capsule glows, smooth glide hover effects,
/// modern iconography, and professional enterprise section hierarchy.
class Sidebar extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback onToggle;
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const Sidebar({
    super.key,
    required this.isCollapsed,
    required this.onToggle,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOutCubic,
      width: isCollapsed ? 88 : 280,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xF50A101D), // Dark Translucent Obsidian Glass
                  Color(0xFA050811), // Deep Pitch Slate
                ],
              ),
              border: const Border(
                right: BorderSide(
                  color: Color(0x1F818CF8), // Ultra-fine glowing indigo glass edge
                  width: 1.2,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(4, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildGlassBrandHeader(context),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('MAIN NAVIGATION'),
                        _GlassSidebarItem(
                          icon: Icons.dashboard_rounded,
                          label: 'Dashboard',
                          subtitle: 'Live KPI & Overview',
                          isCollapsed: isCollapsed,
                          isActive: selectedIndex == 0,
                          onTap: () => onIndexChanged(0),
                        ),
                        _GlassSidebarItem(
                          icon: Icons.local_shipping_rounded,
                          label: 'Trailas',
                          subtitle: 'Fleet & Build Units',
                          isCollapsed: isCollapsed,
                          isActive: selectedIndex == 1,
                          onTap: () => onIndexChanged(1),
                        ),

                        const SizedBox(height: 16),
                        _buildSectionHeader('ACCOUNTS & PARTNERS'),
                        _GlassSidebarItem(
                          icon: Icons.storefront_rounded,
                          label: 'Suppliers',
                          subtitle: 'Vendors & Bills',
                          isCollapsed: isCollapsed,
                          isActive: selectedIndex == 2,
                          onTap: () => onIndexChanged(2),
                        ),
                        _GlassSidebarItem(
                          icon: Icons.engineering_rounded,
                          label: 'Labour',
                          subtitle: 'Workforce & Wages',
                          isCollapsed: isCollapsed,
                          isActive: selectedIndex == 3,
                          onTap: () => onIndexChanged(3),
                        ),
                        _GlassSidebarItem(
                          icon: Icons.menu_book_rounded,
                          label: 'Khata',
                          subtitle: 'Customer Accounts',
                          isCollapsed: isCollapsed,
                          isActive: selectedIndex == 4,
                          onTap: () => onIndexChanged(4),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle, size: 18, color: Color(0xFF38BDF8)),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const AddKhataDialog(),
                              );
                            },
                            tooltip: 'Quick Add Customer Khata',
                          ),
                        ),

                        const SizedBox(height: 16),
                        _buildSectionHeader('FINANCE & REVENUE'),
                        _GlassSidebarItem(
                          icon: Icons.receipt_long_rounded,
                          label: 'Sales',
                          subtitle: 'Invoices & Orders',
                          isCollapsed: isCollapsed,
                          isActive: selectedIndex == 5,
                          onTap: () => onIndexChanged(5),
                        ),
                        _GlassSidebarItem(
                          icon: Icons.insights_rounded,
                          label: 'Expense & Revenue',
                          subtitle: 'P&L & Cash Flow',
                          isCollapsed: isCollapsed,
                          isActive: selectedIndex == 6,
                          onTap: () => onIndexChanged(6),
                        ),
                        _GlassSidebarItem(
                          icon: Icons.account_balance_rounded,
                          label: 'Cash & Bank',
                          subtitle: 'Treasury & Vaults',
                          isCollapsed: isCollapsed,
                          isActive: selectedIndex == 7,
                          onTap: () => onIndexChanged(7),
                        ),

                        const SizedBox(height: 16),
                        _buildSectionHeader('CONFIGURATION'),
                        _GlassSidebarItem(
                          icon: Icons.badge_rounded,
                          label: 'App Profile',
                          subtitle: 'Business Identity',
                          isCollapsed: isCollapsed,
                          isActive: selectedIndex == 8,
                          onTap: () => onIndexChanged(8),
                        ),
                        _GlassSidebarItem(
                          icon: Icons.print_rounded,
                          label: 'Printer Settings',
                          subtitle: 'POS & Thermal Hardware',
                          isCollapsed: isCollapsed,
                          isActive: selectedIndex == 9,
                          onTap: () => onIndexChanged(9),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildGlassFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    if (isCollapsed) return const SizedBox(height: 6);
    return Padding(
      padding: const EdgeInsets.only(left: 14, top: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.3,
        ),
      ),
    );
  }

  Widget _buildGlassBrandHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: const Border(
          bottom: BorderSide(color: Color(0x1F334155), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          // Glass Floating Logo Capsule with Real AI-Generated Logo
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF818CF8).withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.5),
              child: Image.asset(
                'assets/images/Logo.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.local_shipping_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'AMJID TRAILER',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withValues(alpha: 0.6),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Industrial Suite v3.0',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGlassFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: const Border(
          top: BorderSide(color: Color(0x1F334155), width: 1),
        ),
      ),
      child: Column(
        children: [
          if (!isCollapsed)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.storage_rounded, size: 14, color: Color(0xFF38BDF8)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Drift SQLite Engine • Active',
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  isCollapsed ? Icons.keyboard_double_arrow_right_rounded : Icons.keyboard_double_arrow_left_rounded,
                  color: const Color(0xFF94A3B8),
                  size: 20,
                ),
                tooltip: isCollapsed ? 'Expand Sidebar' : 'Collapse Sidebar',
                onPressed: onToggle,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.04),
                  hoverColor: const Color(0xFF4F46E5).withValues(alpha: 0.2),
                ),
              ),
              if (!isCollapsed)
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Text(
                    'ERP v3.0 Pro',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlassSidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isCollapsed;
  final bool isActive;
  final VoidCallback onTap;
  final Widget? trailing;

  const _GlassSidebarItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isCollapsed,
    required this.isActive,
    required this.onTap,
    this.trailing,
  });

  @override
  State<_GlassSidebarItem> createState() => _GlassSidebarItemState();
}

class _GlassSidebarItemState extends State<_GlassSidebarItem> {
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
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(vertical: 3),
          transform: Matrix4.translationValues(_isHovered && !widget.isActive ? 4.0 : 0.0, 0.0, 0.0),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCollapsed ? 12 : 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            gradient: widget.isActive
                ? const LinearGradient(
                    colors: [
                      Color(0xFF4F46E5), // Electric Indigo
                      Color(0xFF7C3AED), // Violet
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : (_isHovered
                    ? LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.08),
                          Colors.white.withValues(alpha: 0.03),
                        ],
                      )
                    : null),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isActive
                  ? const Color(0xFF818CF8).withValues(alpha: 0.5)
                  : (_isHovered ? Colors.white.withValues(alpha: 0.12) : Colors.transparent),
              width: 1,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.45),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: widget.isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              // Icon with indicator glow
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? Colors.white.withValues(alpha: 0.2)
                      : (_isHovered ? const Color(0xFF6366F1).withValues(alpha: 0.15) : Colors.transparent),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.isActive
                      ? Colors.white
                      : (_isHovered ? const Color(0xFF38BDF8) : const Color(0xFF94A3B8)),
                  size: 20,
                ),
              ),
              if (!widget.isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: widget.isActive
                              ? Colors.white
                              : (_isHovered ? Colors.white : const Color(0xFFE2E8F0)),
                          fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w600,
                          fontSize: 13,
                          letterSpacing: 0.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          color: widget.isActive
                              ? const Color(0xFFE0E7FF)
                              : const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (widget.trailing != null && !widget.isActive) widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
