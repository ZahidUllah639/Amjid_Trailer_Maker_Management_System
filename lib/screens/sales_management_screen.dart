import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/traila.dart';
import '../models/buyer.dart';
import '../models/sale.dart';
import 'sale_detail_screen.dart';
import '../services/thermal_printer_service.dart';

class SalesManagementScreen extends StatefulWidget {
  const SalesManagementScreen({super.key});

  @override
  State<SalesManagementScreen> createState() => _SalesManagementScreenState();
}

class _SalesManagementScreenState extends State<SalesManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final readyUnits = state.trailas.where((t) => t.status == TrailaStatus.ready).length;
        final partialSales = state.sales.where((s) => s.status == SaleStatus.partial || s.status == SaleStatus.pending).length;
        final fullyPaidSales = state.sales.where((s) => s.status == SaleStatus.paid).length;

        final totalReceivable = state.sales.fold<double>(
          0,
          (sum, s) => sum + s.remainingBalance,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Row
            Row(
              children: [
                Expanded(
                  child: _SalesStatCard(
                    title: 'Available for Sale',
                    value: '$readyUnits Units',
                    subtitle: 'Ready in workshop lot',
                    icon: Icons.check_circle_rounded,
                    color: const Color(0xFF10B981),
                    bg: const Color(0xFFD1FAE5),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SalesStatCard(
                    title: 'Pending Client Dues',
                    value: 'Rs. ${NumberFormat('#,##0').format(totalReceivable)}',
                    subtitle: '$partialSales pending payment orders',
                    icon: Icons.pending_actions_rounded,
                    color: const Color(0xFFD97706),
                    bg: const Color(0xFFFEF3C7),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SalesStatCard(
                    title: 'Fully Paid Dispatches',
                    value: '$fullyPaidSales Delivered',
                    subtitle: '100% payments settled',
                    icon: Icons.task_alt_rounded,
                    color: const Color(0xFF4F46E5),
                    bg: const Color(0xFFEEF2FF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tab Bar with Rounded Container
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
                        const Text('Ready for Sale'),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(12)),
                          child: Text('$readyUnits', style: const TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Partial / Pending Dues'),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(12)),
                          child: Text('$partialSales', style: const TextStyle(fontSize: 11, color: Color(0xFFB45309), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Fully Paid Sales'),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
                          child: Text('$fullyPaidSales', style: const TextStyle(fontSize: 11, color: Color(0xFF4338CA), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _AvailableTrailasView(),
                  _SoldTrailasView(showFullyPaid: false),
                  _SoldTrailasView(showFullyPaid: true),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SalesStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bg;

  const _SalesStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
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
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailableTrailasView extends StatelessWidget {
  const _AvailableTrailasView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final query = state.searchQuery.toLowerCase();
        final readyTrailas = state.trailas.where((t) {
          return t.status == TrailaStatus.ready &&
              (query.isEmpty ||
                  t.name.toLowerCase().contains(query) ||
                  t.id.toLowerCase().contains(query));
        }).toList();

        if (readyTrailas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text(
                  state.searchQuery.isNotEmpty
                      ? 'No available trailers match "${state.searchQuery}"'
                      : 'No units marked "Ready for Sale". Fabricate units in Traila Register first.',
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                ),
              ],
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: readyTrailas.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
            itemBuilder: (context, index) {
              final t = readyTrailas[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Text(
                        t.id,
                        style: const TextStyle(
                          color: Color(0xFF047857),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF0F172A))),
                          Text(
                            'Mfg. Completed: ${DateFormat('dd MMM yyyy').format(t.registrationDate)}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Cost: Rs. ${NumberFormat('#,##0').format(t.totalManufacturingCost)}',
                        style: const TextStyle(
                          color: Color(0xFFDC2626),
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => SellTrailaDialog(traila: t),
                        );
                      },
                      icon: const Icon(Icons.point_of_sale_rounded, size: 18),
                      label: const Text('Sell Traila'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SoldTrailasView extends StatelessWidget {
  final bool showFullyPaid;
  const _SoldTrailasView({required this.showFullyPaid});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final query = state.searchQuery.toLowerCase();
        final sales = state.sales.where((s) {
          final matchesStatus = showFullyPaid
              ? s.status == SaleStatus.paid
              : (s.status == SaleStatus.partial || s.status == SaleStatus.pending);

          if (!matchesStatus) return false;

          final buyer = state.buyers.firstWhere(
            (b) => b.id == s.buyerId,
            orElse: () => Buyer(id: '?', name: 'Unknown', phone: '', cnic: '', address: ''),
          );

          return query.isEmpty ||
              s.id.toLowerCase().contains(query) ||
              s.trailaId.toLowerCase().contains(query) ||
              buyer.name.toLowerCase().contains(query);
        }).toList()
          ..sort((a, b) => b.saleDate.compareTo(a.saleDate));

        if (sales.isEmpty) {
          return Center(
            child: Text(
              state.searchQuery.isNotEmpty
                  ? 'No sales records match "${state.searchQuery}"'
                  : (showFullyPaid ? 'No fully paid sales records yet.' : 'No partial or pending receivables.'),
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: sales.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
            itemBuilder: (context, index) {
              final s = sales[index];
              final buyer = state.buyers.firstWhere(
                (b) => b.id == s.buyerId,
                orElse: () => Buyer(id: '?', name: 'Unknown', phone: '', cnic: '', address: ''),
              );
              final remaining = s.remainingBalance;

              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => SaleDetailScreen(saleId: s.id)),
                  );
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
                          s.trailaId,
                          style: const TextStyle(color: Color(0xFF4338CA), fontWeight: FontWeight.w800, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(buyer.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Color(0xFF0F172A))),
                            Text(
                              'Customer Code: ${buyer.id} • Phone: ${buyer.phone.isEmpty ? "—" : buyer.phone} • Date: ${DateFormat('dd MMM yyyy').format(s.saleDate)}',
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total: Rs. ${NumberFormat('#,##0').format(s.salePrice)}',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF0F172A)),
                            ),
                            Text(
                              'Paid: Rs. ${NumberFormat('#,##0').format(s.totalPaid)}',
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF059669), fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Due: Rs. ${NumberFormat('#,##0').format(remaining > 0 ? remaining : 0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: remaining > 0 ? const Color(0xFFDC2626) : const Color(0xFF059669),
                              ),
                            ),
                            const SizedBox(height: 2),
                            _StatusBadge(status: s.status),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Icon(Icons.arrow_forward_rounded, size: 18, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final SaleStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case SaleStatus.paid:
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF047857);
        label = 'PAID IN FULL';
        break;
      case SaleStatus.partial:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        label = 'PARTIAL PAYMENT';
        break;
      case SaleStatus.pending:
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFB91C1C);
        label = 'PAYMENT DUE';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 9.5, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class SellTrailaDialog extends StatefulWidget {
  final Traila traila;
  const SellTrailaDialog({super.key, required this.traila});

  @override
  State<SellTrailaDialog> createState() => _SellTrailaDialogState();
}

class _SellTrailaDialogState extends State<SellTrailaDialog> {
  final _buyerIdController = TextEditingController();
  final _buyerNameController = TextEditingController();
  final _buyerPhoneController = TextEditingController();
  final _buyerWhatsAppController = TextEditingController();
  final _buyerCnicController = TextEditingController();
  final _buyerAddressController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _initialPaymentController = TextEditingController();
  DateTime _saleDate = DateTime.now();
  String _paymentMethod = 'Cash';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _buyerIdController.text = context.read<ERPCubit>().getNextBuyerId();
  }

  @override
  void dispose() {
    _buyerIdController.dispose();
    _buyerNameController.dispose();
    _buyerPhoneController.dispose();
    _buyerWhatsAppController.dispose();
    _buyerCnicController.dispose();
    _buyerAddressController.dispose();
    _salePriceController.dispose();
    _initialPaymentController.dispose();
    super.dispose();
  }

  double get _profit {
    final price = double.tryParse(_salePriceController.text) ?? 0;
    return price - widget.traila.totalManufacturingCost;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.point_of_sale_rounded, color: Color(0xFF10B981), size: 22),
          const SizedBox(width: 10),
          Text('Complete Sale: ${widget.traila.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profit calculation card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Manufacturing Cost', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        Text(
                          'Rs. ${NumberFormat('#,##0').format(widget.traila.totalManufacturingCost)}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Net Profit Margin', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        Text(
                          'Rs. ${NumberFormat('#,##0').format(_profit)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _profit >= 0 ? const Color(0xFF059669) : const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Buyer & Client Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF334155))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFC7D2FE)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, size: 13, color: Color(0xFF4F46E5)),
                        const SizedBox(width: 4),
                        Text(
                          'ID: ${_buyerIdController.text}',
                          style: const TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 11.5, fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _buyerIdController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Customer Identifier / Code (Auto-Generated)',
                  prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFC7D2FE)),
                    ),
                    child: const Text('AUTO', style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _buyerNameController,
                      autofocus: true,
                      decoration: const InputDecoration(labelText: 'Buyer Full Name *', prefixIcon: Icon(Icons.person_outline_rounded, size: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _buyerPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Phone Number *', prefixIcon: Icon(Icons.phone_outlined, size: 20)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _buyerWhatsAppController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'WhatsApp Number', prefixIcon: Icon(Icons.chat_bubble_outline_rounded, size: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _buyerCnicController,
                      decoration: const InputDecoration(labelText: 'CNIC / ID Card', prefixIcon: Icon(Icons.credit_card_rounded, size: 20)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _buyerAddressController,
                decoration: const InputDecoration(labelText: 'Buyer Address / Destination', prefixIcon: Icon(Icons.place_outlined, size: 20)),
              ),
              const SizedBox(height: 18),

              const Text('Sale & Payment Terms', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF334155))),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _salePriceController,
                      decoration: const InputDecoration(labelText: 'Agreed Sale Price (Rs.) *', prefixIcon: Icon(Icons.payments_outlined, size: 20)),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _initialPaymentController,
                      decoration: const InputDecoration(labelText: 'Initial Downpayment (Rs.)', prefixIcon: Icon(Icons.account_balance_wallet_outlined, size: 20)),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _paymentMethod,
                      decoration: const InputDecoration(labelText: 'Payment Method', prefixIcon: Icon(Icons.account_balance_rounded, size: 20)),
                      items: context.read<ERPCubit>().state.accounts.values.map((a) => a.name)
                          .map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                      onChanged: (v) => setState(() => _paymentMethod = v ?? 'Cash'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _saleDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _saleDate = picked);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Sale Date', prefixIcon: Icon(Icons.calendar_today_rounded, size: 18)),
                        child: Text(DateFormat('yyyy-MM-dd').format(_saleDate)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
        ),
        ElevatedButton.icon(
          onPressed: _isLoading
              ? null
              : () async {
                  final salePrice = double.tryParse(_salePriceController.text) ?? 0;
                  final initialPayment = double.tryParse(_initialPaymentController.text) ?? 0;
                  if (salePrice <= 0 || _buyerNameController.text.trim().isEmpty) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter Buyer Name and Sale Price.')),
                    );
                    return;
                  }

                  setState(() => _isLoading = true);

                  final autoId = _buyerIdController.text.trim().isNotEmpty
                      ? _buyerIdController.text.trim()
                      : context.read<ERPCubit>().getNextBuyerId();
                  final buyer = Buyer(
                    id: autoId,
                    name: _buyerNameController.text.trim(),
                    phone: _buyerPhoneController.text.trim(),
                    whatsappNumber: _buyerWhatsAppController.text.trim(),
                    cnic: _buyerCnicController.text.trim(),
                    address: _buyerAddressController.text.trim(),
                  );

                  try {
                    final saleId = await context.read<ERPCubit>().sellTraila(
                          trailaId: widget.traila.id,
                          buyer: buyer,
                          salePrice: salePrice,
                          saleDate: _saleDate,
                          paymentMethod: _paymentMethod,
                          initialPayment: initialPayment,
                        );

                    if (saleId != null) {
                      if (!context.mounted) return;
                      final state = context.read<ERPCubit>().state;
                      final sale = state.sales.firstWhere((s) => s.id == saleId);
                      final buyerObj = state.buyers.firstWhere((b) => b.id == sale.buyerId);
                      final traila = state.trailas.firstWhere((t) => t.id == sale.trailaId);

                      try {
                        await ThermalPrinterService.printReceipt(
                          context,
                          sale: sale,
                          buyer: buyerObj,
                          traila: traila,
                          profile: state.appProfile,
                          settings: state.printerSetting,
                          printDuplicate: true,
                        );
                      } catch (_) {}

                      if (context.mounted) Navigator.pop(context);
                    } else {
                      if (context.mounted) setState(() => _isLoading = false);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
          icon: _isLoading
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.print_rounded, size: 18),
          label: const Text('Confirm Sale & Print'),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
        ),
      ],
    );
  }
}

