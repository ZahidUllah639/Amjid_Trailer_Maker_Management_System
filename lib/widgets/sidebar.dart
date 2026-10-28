import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'add_khata_dialog.dart';

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
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      width: isCollapsed ? 84 : 270,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F172A), // Slate 900
            Color(0xFF090D16), // Darker Obsidian
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBrandHeader(context),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('CORE'),
                  _SidebarItem(
                    icon: Icons.space_dashboard_rounded,
                    label: 'Dashboard',
                    isCollapsed: isCollapsed,
                    isActive: selectedIndex == 0,
                    onTap: () => onIndexChanged(0),
                  ),
                  _SidebarItem(
                    icon: Icons.local_shipping_rounded,
                    label: 'Traila Register',
                    isCollapsed: isCollapsed,
                    isActive: selectedIndex == 1,
                    onTap: () => onIndexChanged(1),
                  ),

                  const SizedBox(height: 14),
                  _buildSectionHeader('OPERATIONS'),
                  _SidebarItem(
                    icon: Icons.inventory_2_rounded,
                    label: 'Supplier Khata',
                    isCollapsed: isCollapsed,
                    isActive: selectedIndex == 2,
                    onTap: () => onIndexChanged(2),
                  ),
                  _SidebarItem(
                    icon: Icons.badge_rounded,
                    label: 'Labour Management',
                    isCollapsed: isCollapsed,
                    isActive: selectedIndex == 3,
                    onTap: () => onIndexChanged(3),
                  ),
                  _SidebarItem(
                    icon: Icons.menu_book_rounded,
                    label: 'General Khata',
                    isCollapsed: isCollapsed,
                    isActive: selectedIndex == 4,
                    onTap: () => onIndexChanged(4),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle, size: 18, color: Color(0xFF818CF8)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AddKhataDialog(),
                        );
                      },
                      tooltip: 'Add New Khata',
                    ),
                  ),

                  const SizedBox(height: 14),
                  _buildSectionHeader('FINANCE & SALES'),
                  _SidebarItem(
                    icon: Icons.point_of_sale_rounded,
                    label: 'Sales & Invoices',
                    isCollapsed: isCollapsed,
                    isActive: selectedIndex == 5,
                    onTap: () => onIndexChanged(5),
                  ),
                  _SidebarItem(
                    icon: Icons.pie_chart_rounded,
                    label: 'Expense & Revenue',
                    isCollapsed: isCollapsed,
                    isActive: selectedIndex == 6,
                    onTap: () => onIndexChanged(6),
                  ),
                  _SidebarItem(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Cash & Bank Flow',
                    isCollapsed: isCollapsed,
                    isActive: selectedIndex == 7,
                    onTap: () => onIndexChanged(7),
                  ),

                  const SizedBox(height: 14),
                  _buildSectionHeader('PREFERENCES'),
                  _SidebarItem(
                    icon: Icons.storefront_rounded,
                    label: 'Business Profile',
                    isCollapsed: isCollapsed,
                    isActive: selectedIndex == 8,
                    onTap: () => onIndexChanged(8),
                  ),
                  _SidebarItem(
                    icon: Icons.print_rounded,
                    label: 'Thermal & A4 Printer',
                    isCollapsed: isCollapsed,
                    isActive: selectedIndex == 9,
                    onTap: () => onIndexChanged(9),
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    if (isCollapsed) return const SizedBox(height: 8);
    return Padding(
      padding: const EdgeInsets.only(left: 14, top: 4, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildBrandHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.precision_manufacturing_rounded,
              color: Colors.white,
              size: 24,
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
                    'TRAILA ERP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Row(
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
                      const Text(
                        'Workshop v2.4',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
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

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      child: Column(
        children: [
          if (!isCollapsed)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.storage_rounded, size: 14, color: Color(0xFF10B981)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Local SQLite Active',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
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
              ),
              if (!isCollapsed)
                InkWell(
                  onTap: () async => await windowManager.close(),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.power_settings_new_rounded, size: 16, color: Color(0xFFF87171)),
                        SizedBox(width: 6),
                        Text(
                          'Exit',
                          style: TextStyle(
                            color: Color(0xFFF87171),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isCollapsed;
  final bool isActive;
  final VoidCallback onTap;
  final Widget? trailing;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isCollapsed,
    required this.isActive,
    required this.onTap,
    this.trailing,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeBg = const Color(0xFF4F46E5);
    final hoverBg = Colors.white.withValues(alpha: 0.05);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(vertical: 2.5),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCollapsed ? 12 : 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? activeBg
                : (_isHovered ? hoverBg : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: activeBg.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: widget.isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                widget.icon,
                color: widget.isActive
                    ? Colors.white
                    : (_isHovered ? Colors.white : const Color(0xFF94A3B8)),
                size: 20,
              ),
              if (!widget.isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.isActive
                          ? Colors.white
                          : (_isHovered ? const Color(0xFFF1F5F9) : const Color(0xFFCBD5E1)),
                      fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 13.5,
                      letterSpacing: 0.1,
                    ),
                    overflow: TextOverflow.ellipsis,
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

