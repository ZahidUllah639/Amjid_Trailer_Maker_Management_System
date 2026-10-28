import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sidebar.dart';
import 'header.dart';
import '../cubits/erp_cubit.dart';
import '../screens/dashboard_screen.dart';
import '../screens/traila_register_screen.dart';
import '../screens/supplier_management_screen.dart';
import '../screens/labour_management_screen.dart';
import '../screens/sales_management_screen.dart';
import '../screens/expense_revenue_screen.dart';
import '../screens/cash_flow_screen.dart';
import '../screens/app_profile_screen.dart';
import '../screens/settings/printer_settings_screen.dart';
import '../screens/khata_management_screen.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  bool isSidebarCollapsed = false;
  late PageController _pageController;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const TrailaRegisterScreen(),
    const SupplierManagementScreen(),
    const LabourManagementScreen(),
    const KhataManagementScreen(),
    const SalesManagementScreen(),
    const ExpenseRevenueScreen(),
    const CashFlowScreen(),
    const AppProfileScreen(),
    const PrinterSettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final initialIndex = context.read<ERPCubit>().state.currentModuleIndex;
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onIndexChanged(int index) {
    context.read<ERPCubit>().setModuleIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ERPCubit, ERPState>(
      listenWhen: (prev, curr) => prev.currentModuleIndex != curr.currentModuleIndex,
      listener: (context, state) {
        _pageController.animateToPage(
          state.currentModuleIndex,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic,
        );
      },
      child: BlocBuilder<ERPCubit, ERPState>(
        buildWhen: (prev, curr) => prev.currentModuleIndex != curr.currentModuleIndex,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            body: Row(
              children: [
                Sidebar(
                  isCollapsed: isSidebarCollapsed,
                  onToggle: () => setState(() => isSidebarCollapsed = !isSidebarCollapsed),
                  selectedIndex: state.currentModuleIndex,
                  onIndexChanged: _onIndexChanged,
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Header(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: _screens,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

