import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/traila.dart';
import '../models/buyer.dart';
import '../services/invoice_pdf_service.dart';
import '../services/thermal_printer_service.dart';
import '../widgets/print_preview_dialog.dart';

class ExpenseRevenueScreen extends StatefulWidget {
  const ExpenseRevenueScreen({super.key});

  @override
  State<ExpenseRevenueScreen> createState() => _ExpenseRevenueScreenState();
}

class _ExpenseRevenueScreenState extends State<ExpenseRevenueScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'All';
  DateTimeRange? _customRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _isInRange(DateTime date) {
    final now = DateTime.now();
    switch (_filterType) {
      case 'Monthly':
        return date.month == now.month && date.year == now.year;
      case 'Yearly':
        return date.year == now.year;
      case 'Custom':
        if (_customRange == null) return true;
        return date.isAfter(_customRange!.start.subtract(const Duration(days: 1))) &&
            date.isBefore(_customRange!.end.add(const Duration(days: 1)));
      default:
        return true;
    }
  }

  Future<void> _selectCustomRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      currentDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _filterType = 'Custom';
        _customRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final filteredTrailas = state.trailas.where((t) {
          if (t.status == TrailaStatus.sold) {
            final date = t.saleInfo?.saleDate ?? t.registrationDate;
            return _isInRange(date);
          }
          return _isInRange(t.registrationDate);
        }).toList();

        final filteredSales = state.sales.where((s) {
          if (!_isInRange(s.saleDate)) return false;
          final query = state.searchQuery.toLowerCase();
          if (query.isEmpty) return true;

          final buyer = state.buyers.firstWhere(
            (b) => b.id == s.buyerId,
            orElse: () => Buyer(id: '?', name: 'Unknown', phone: '', cnic: '', address: ''),
          );
          return s.trailaId.toLowerCase().contains(query) ||
              buyer.name.toLowerCase().contains(query);
        }).toList()
          ..sort((a, b) => b.saleDate.compareTo(a.saleDate));

        final totalRevenue = filteredSales.fold<double>(0, (sum, s) => sum + s.salePrice);
        final totalExpenses = filteredTrailas.fold<double>(0, (sum, t) => sum + t.totalManufacturingCost);
        final netProfit = totalRevenue - totalExpenses;

        final allExpenses = <_ExpenseItem>[];
        final query = state.searchQuery.toLowerCase();
        for (var t in filteredTrailas) {
          for (var e in t.expenses) {
            if (_isInRange(e.date)) {
              if (query.isEmpty ||
                  e.description.toLowerCase().contains(query) ||
                  t.name.toLowerCase().contains(query) ||
                  t.id.toLowerCase().contains(query)) {
                allExpenses.add(_ExpenseItem(expense: e, trailaName: t.name));
              }
            }
          }
        }
        allExpenses.sort((a, b) => b.expense.date.compareTo(a.expense.date));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Controls & Period Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: ['All', 'Monthly', 'Yearly', 'Custom'].map((type) {
                    final isSelected = _filterType == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          if (type == 'Custom') {
                            _selectCustomRange(context);
                          } else {
                            setState(() {
                              _filterType = type;
                              _customRange = null;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF4F46E5) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            type == 'Custom' && _customRange != null
                                ? '${DateFormat('dd MMM').format(_customRange!.start)} - ${DateFormat('dd MMM').format(_customRange!.end)}'
                                : type,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF475569),
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final st = context.read<ERPCubit>().state;
                        final pdfBytes = await InvoicePdfService.generateFinancialReportPdf(
                          totalRevenue: totalRevenue,
                          totalExpenses: totalExpenses,
                          netProfit: netProfit,
                          sales: filteredSales,
                          expenses: allExpenses,
                          filterType: _filterType,
                          profile: st.appProfile,
                        );
                        if (!context.mounted) return;
                        await PrintPreviewDialog.show(
                          context,
                          pdfBytes,
                          'FinancialReport_$_filterType.pdf',
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                      label: const Text('Export PDF Report'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final st = context.read<ERPCubit>().state;
                        try {
                          await ThermalPrinterService.printFinancialSummary(
                            context,
                            totalRevenue: totalRevenue,
                            totalExpenses: totalExpenses,
                            netProfit: netProfit,
                            period: _filterType,
                            profile: st.appProfile,
                            settings: st.printerSetting,
                          );
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Print Error: $e')));
                          }
                        }
                      },
                      icon: const Icon(Icons.print_rounded, size: 18),
                      label: const Text('Thermal Summary'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 3 KPI Financial Metric Cards
            Row(
              children: [
                Expanded(
                  child: _FinancialPillCard(
                    title: 'Gross Revenue (Sales Inflow)',
                    value: 'Rs. ${NumberFormat('#,##0').format(totalRevenue)}',
                    icon: Icons.trending_up_rounded,
                    gradient: const [Color(0xFF059669), Color(0xFF047857)],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _FinancialPillCard(
                    title: 'Total Fabrication Overheads',
                    value: 'Rs. ${NumberFormat('#,##0').format(totalExpenses)}',
                    icon: Icons.trending_down_rounded,
                    gradient: const [Color(0xFFDC2626), Color(0xFFB91C1C)],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _FinancialPillCard(
                    title: netProfit >= 0 ? 'Net Workshop Profit' : 'Operating Net Loss',
                    value: 'Rs. ${NumberFormat('#,##0').format(netProfit.abs())}',
                    icon: Icons.account_balance_rounded,
                    gradient: netProfit >= 0
                        ? const [Color(0xFF4F46E5), Color(0xFF3730A3)]
                        : const [Color(0xFFEA580C), Color(0xFFC2410C)],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tabs for Expense vs Revenue Breakdown
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF4F46E5),
                indicatorWeight: 3,
                labelColor: const Color(0xFF4F46E5),
                unselectedLabelColor: const Color(0xFF64748B),
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_downward_rounded, size: 16, color: Color(0xFFDC2626)),
                        const SizedBox(width: 8),
                        const Text('Expense Item Ledger'),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(12)),
                          child: Text('${allExpenses.length}', style: const TextStyle(fontSize: 11, color: Color(0xFFB91C1C), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_upward_rounded, size: 16, color: Color(0xFF059669)),
                        const SizedBox(width: 8),
                        const Text('Revenue Inflow Ledger'),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(12)),
                          child: Text('${filteredSales.length}', style: const TextStyle(fontSize: 11, color: Color(0xFF047857), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Views Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Expense Section
                    allExpenses.isEmpty
                        ? const Center(child: Text('No expense records found for this period.', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)))
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: allExpenses.length,
                            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            itemBuilder: (context, index) {
                              final item = allExpenses[index];
                              final e = item.expense;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(10)),
                                      child: const Icon(Icons.receipt_outlined, color: Color(0xFFDC2626), size: 20),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(e.description, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Color(0xFF0F172A))),
                                          Text('Category: ${e.type.toUpperCase()} • Unit: ${item.trailaName}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        DateFormat('dd MMM yyyy').format(e.date),
                                        style: const TextStyle(color: Color(0xFF475569), fontSize: 13),
                                      ),
                                    ),
                                    Text(
                                      'Rs. ${NumberFormat('#,##0').format(e.amount)}',
                                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFFDC2626)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                    // Revenue Section
                    filteredSales.isEmpty
                        ? const Center(child: Text('No revenue records found for this period.', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)))
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: filteredSales.length,
                            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            itemBuilder: (context, index) {
                              final s = filteredSales[index];
                              final buyer = state.buyers.firstWhere(
                                (b) => b.id == s.buyerId,
                                orElse: () => Buyer(id: '?', name: 'Unknown', phone: '', cnic: '', address: ''),
                              );
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(10)),
                                      child: const Icon(Icons.arrow_upward_rounded, color: Color(0xFF059669), size: 20),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Traila Unit: ${s.trailaId}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Color(0xFF0F172A))),
                                          Text('Client: ${buyer.name} • Inv #${s.receiptNumber}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        DateFormat('dd MMM yyyy').format(s.saleDate),
                                        style: const TextStyle(color: Color(0xFF475569), fontSize: 13),
                                      ),
                                    ),
                                    Text(
                                      'Rs. ${NumberFormat('#,##0').format(s.salePrice)}',
                                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF059669)),
                                    ),
                                  ],
                                ),
                              );
                            },
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
}

class _ExpenseItem {
  final TrailaExpense expense;
  final String trailaName;
  _ExpenseItem({required this.expense, required this.trailaName});
}

class _FinancialPillCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<Color> gradient;

  const _FinancialPillCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                title,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12.5, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.4),
          ),
        ],
      ),
    );
  }
}

