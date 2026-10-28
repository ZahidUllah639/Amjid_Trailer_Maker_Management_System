import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/erp_cubit.dart';
import '../models/account.dart';
import '../services/invoice_pdf_service.dart';
import '../services/thermal_printer_service.dart';
import '../widgets/print_preview_dialog.dart';
import 'account_ledger_screen.dart';

class CashFlowScreen extends StatefulWidget {
  const CashFlowScreen({super.key});

  @override
  State<CashFlowScreen> createState() => _CashFlowScreenState();
}

class _CashFlowScreenState extends State<CashFlowScreen> {
  String _selectedCategory = 'all'; // 'all', 'cash', 'bank', 'wallet'

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ERPCubit, ERPState>(
      builder: (context, state) {
        final accounts = state.accounts.values.toList();
        final totalCash = accounts.fold<double>(0, (sum, a) => sum + a.balance);
        final bankTotal = accounts
            .where((a) => a.type.toLowerCase() == 'bank')
            .fold<double>(0, (sum, a) => sum + a.balance);
        final cashTotal = accounts
            .where((a) => a.type.toLowerCase() == 'cash')
            .fold<double>(0, (sum, a) => sum + a.balance);
        final walletTotal = accounts
            .where((a) => a.type.toLowerCase() == 'wallet' || a.type.toLowerCase() == 'other')
            .fold<double>(0, (sum, a) => sum + a.balance);

        // Global search filtering
        final query = state.searchQuery.trim().toLowerCase();
        var displayAccounts = accounts;
        if (query.isNotEmpty) {
          displayAccounts = displayAccounts.where((a) =>
              a.name.toLowerCase().contains(query) ||
              a.type.toLowerCase().contains(query)).toList();
        }

        // Category tab filtering
        if (_selectedCategory != 'all') {
          displayAccounts = displayAccounts.where((a) {
            final t = a.type.toLowerCase();
            if (_selectedCategory == 'cash') return t == 'cash';
            if (_selectedCategory == 'bank') return t == 'bank';
            if (_selectedCategory == 'wallet') return t == 'wallet' || t == 'other';
            return true;
          }).toList();
        }

        final currencyFormat = NumberFormat('#,##0');

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. World-Class Glassmorphic Treasury Command Hero
              _buildTreasuryHero(
                context,
                totalCash: totalCash,
                cashTotal: cashTotal,
                bankTotal: bankTotal,
                walletTotal: walletTotal,
                currencyFormat: currencyFormat,
              ),

              const SizedBox(height: 28),

              // 2. Navigation & Vault Filter Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Treasury Vaults & Accounts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${displayAccounts.length} VAULTS',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF4F46E5),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Category Pills
                  Row(
                    children: [
                      _CategoryFilterChip(
                        label: 'All (${accounts.length})',
                        isSelected: _selectedCategory == 'all',
                        onTap: () => setState(() => _selectedCategory = 'all'),
                      ),
                      const SizedBox(width: 8),
                      _CategoryFilterChip(
                        label: 'Cash (${accounts.where((a) => a.type.toLowerCase() == 'cash').length})',
                        isSelected: _selectedCategory == 'cash',
                        onTap: () => setState(() => _selectedCategory = 'cash'),
                      ),
                      const SizedBox(width: 8),
                      _CategoryFilterChip(
                        label: 'Banks (${accounts.where((a) => a.type.toLowerCase() == 'bank').length})',
                        isSelected: _selectedCategory == 'bank',
                        onTap: () => setState(() => _selectedCategory = 'bank'),
                      ),
                      const SizedBox(width: 8),
                      _CategoryFilterChip(
                        label: 'Wallets (${accounts.where((a) => a.type.toLowerCase() == 'wallet' || a.type.toLowerCase() == 'other').length})',
                        isSelected: _selectedCategory == 'wallet',
                        onTap: () => setState(() => _selectedCategory = 'wallet'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 3. Vault Cards Deck (Apple Wallet / Stripe Metallic Style)
              if (displayAccounts.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.account_balance_wallet_rounded, size: 48, color: Colors.grey.shade400),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        query.isEmpty
                            ? 'No vaults configured in this category'
                            : 'No vaults match "$query"',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        query.isEmpty
                            ? 'Create physical cash drawers, enterprise bank accounts, or digital wallets.'
                            : 'Try adjusting your search criteria.',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton.icon(
                        onPressed: () => _showAddAccountDialog(context),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add First Vault Account'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayAccounts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final acc = displayAccounts[index];
                    return _LinedVaultStrip(
                      account: acc,
                      onDeposit: () => _showQuickTxnDialog(
                        context,
                        account: acc,
                        isCredit: true,
                      ),
                      onWithdraw: () => _showQuickTxnDialog(
                        context,
                        account: acc,
                        isCredit: false,
                      ),
                      onTransfer: () => _showTransferDialog(
                        context,
                        fromAccount: acc,
                      ),
                      onViewLedger: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountLedgerScreen(accountKey: acc.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              const SizedBox(height: 36),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTreasuryHero(
    BuildContext context, {
    required double totalCash,
    required double cashTotal,
    required double bankTotal,
    required double walletTotal,
    required NumberFormat currencyFormat,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF090D16),
            Color(0xFF0F172A),
            Color(0xFF1E1B4B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF090D16).withValues(alpha: 0.45),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background subtle ambient radial glow
          Positioned(
            right: -80,
            top: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6366F1).withValues(alpha: 0.22),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -50,
            bottom: -50,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF10B981).withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Glowing Icon Hub
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.45),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'TOTAL LIQUID CASH & ENTERPRISE RESERVES',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'SYNCHRONIZED',
                                      style: TextStyle(
                                        color: Color(0xFF34D399),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              const Text(
                                'Rs. ',
                                style: TextStyle(
                                  color: Color(0xFF818CF8),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                currencyFormat.format(totalCash),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Top Action Buttons
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        // Inter-Vault Transfer button
                        ElevatedButton.icon(
                          onPressed: () => _showTransferDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E293B),
                            foregroundColor: const Color(0xFF38BDF8),
                            side: BorderSide(color: const Color(0xFF38BDF8).withValues(alpha: 0.35)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                          label: const Text('Vault Transfer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final s = context.read<ERPCubit>().state;
                            final pdfBytes = await InvoicePdfService.generateCashFlowReportPdf(
                              totalCash: totalCash,
                              accounts: s.accounts.values.toList(),
                              profile: s.appProfile,
                            );
                            if (context.mounted) {
                              await PrintPreviewDialog.show(
                                context,
                                pdfBytes,
                                'TreasuryVaultReport.pdf',
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.picture_as_pdf_rounded, size: 18, color: Color(0xFFF87171)),
                          label: const Text('Export PDF', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final s = context.read<ERPCubit>().state;
                            try {
                              await ThermalPrinterService.printCashFlowSummary(
                                context,
                                totalCash: totalCash,
                                accounts: s.accounts.values.toList(),
                                profile: s.appProfile,
                                settings: s.printerSetting,
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Thermal summary sent to printer'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Print Error: $e')),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.print_rounded, size: 18, color: Color(0xFF38BDF8)),
                          label: const Text('Print POS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showAddAccountDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                          ),
                          icon: const Icon(Icons.add_card_rounded, size: 18),
                          label: const Text('New Account', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Glassmorphic Sub-Breakdown Strip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _LiquiditySubCard(
                          label: 'Physical Cash Drawers',
                          amount: cashTotal,
                          icon: Icons.payments_rounded,
                          color: const Color(0xFF10B981),
                          badge: 'SAFE VAULT',
                        ),
                      ),
                      Container(width: 1, height: 42, color: Colors.white.withValues(alpha: 0.12)),
                      Expanded(
                        child: _LiquiditySubCard(
                          label: 'Commercial Bank Accounts',
                          amount: bankTotal,
                          icon: Icons.account_balance_rounded,
                          color: const Color(0xFF38BDF8),
                          badge: 'BANKS',
                        ),
                      ),
                      Container(width: 1, height: 42, color: Colors.white.withValues(alpha: 0.12)),
                      Expanded(
                        child: _LiquiditySubCard(
                          label: 'Digital Wallets & Others',
                          amount: walletTotal,
                          icon: Icons.phone_android_rounded,
                          color: const Color(0xFFA855F7),
                          badge: 'DIGITAL',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dialog: Add Account
  void _showAddAccountDialog(BuildContext context) {
    final nameController = TextEditingController();
    final initialBalanceController = TextEditingController(text: '0');
    String selectedType = 'cash';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add_card_rounded, color: Color(0xFF4F46E5), size: 24),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add New Vault Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  Text('Register a physical drawer, commercial bank, or digital wallet',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                ],
              ),
            ],
          ),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('VAULT CLASSIFICATION',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B), letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _TypeSelectionChip(
                        label: 'Cash Drawer',
                        icon: Icons.payments_rounded,
                        isSelected: selectedType == 'cash',
                        onTap: () => setDialogState(() => selectedType = 'cash'),
                      ),
                      const SizedBox(width: 8),
                      _TypeSelectionChip(
                        label: 'Bank Account',
                        icon: Icons.account_balance_rounded,
                        isSelected: selectedType == 'bank',
                        onTap: () => setDialogState(() => selectedType = 'bank'),
                      ),
                      const SizedBox(width: 8),
                      _TypeSelectionChip(
                        label: 'Digital Wallet',
                        icon: Icons.phone_android_rounded,
                        isSelected: selectedType == 'wallet',
                        onTap: () => setDialogState(() => selectedType = 'wallet'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Account / Vault Name *',
                      hintText: selectedType == 'bank'
                          ? 'e.g. Meezan Bank, HBL, Bank Alfalah'
                          : (selectedType == 'wallet' ? 'e.g. JazzCash, EasyPaisa, SadaPay' : 'e.g. Workshop Safe Drawer, Counter Cash'),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.label_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: initialBalanceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Opening Balance (Rs.)',
                      hintText: '0',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.currency_exchange_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an account name')),
                  );
                  return;
                }

                final cubit = context.read<ERPCubit>();
                if (cubit.state.accounts.values.any((a) => a.name.toLowerCase() == name.toLowerCase())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account with this name already exists')),
                  );
                  return;
                }

                final openingBalance = double.tryParse(initialBalanceController.text.trim()) ?? 0.0;
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                final account = Account(
                  id: id,
                  name: name,
                  type: selectedType,
                  balance: 0.0,
                );

                try {
                  await cubit.addAccount(account);
                  if (openingBalance > 0) {
                    await cubit.addTransaction(
                      Transaction(
                        id: 'OPEN-$id',
                        accountName: name,
                        type: TransactionType.opening,
                        amount: openingBalance,
                        person: 'Self / Opening',
                        description: 'Initial Opening Balance',
                        date: DateTime.now(),
                      ),
                    );
                  }
                  if (dialogCtx.mounted) {
                    Navigator.pop(dialogCtx);
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Vault "$name" initialized successfully!'),
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding account: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Create Vault', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog: Quick Deposit / Withdraw
  void _showQuickTxnDialog(
    BuildContext context, {
    required Account account,
    required bool isCredit,
  }) {
    final amountController = TextEditingController();
    final personController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCredit ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                color: isCredit ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCredit ? 'Quick Deposit (Cash IN)' : 'Quick Withdrawal (Cash OUT)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text('Vault: ${account.name}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              TextField(
                controller: amountController,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (Rs.) *',
                  hintText: 'e.g. 50000',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.currency_exchange_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: personController,
                decoration: InputDecoration(
                  labelText: isCredit ? 'Received From (Person / Party)' : 'Paid To (Person / Party)',
                  hintText: 'e.g. Ahmad Khan / Counter Sale',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description / Purpose',
                  hintText: isCredit ? 'Deposit reason' : 'Withdrawal purpose',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.notes_rounded),
                ),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () async {
              final amt = double.tryParse(amountController.text.trim()) ?? 0;
              if (amt <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount')),
                );
                return;
              }

              final txn = Transaction(
                id: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
                accountName: account.name,
                type: isCredit ? TransactionType.add : TransactionType.take,
                amount: amt,
                person: personController.text.trim().isEmpty
                    ? (isCredit ? 'Cash In' : 'Cash Out')
                    : personController.text.trim(),
                description: descriptionController.text.trim().isEmpty
                    ? (isCredit ? 'Direct Vault Deposit' : 'Direct Vault Withdrawal')
                    : descriptionController.text.trim(),
                date: DateTime.now(),
              );

              try {
                await context.read<ERPCubit>().addTransaction(txn);
                if (dialogCtx.mounted) Navigator.pop(dialogCtx);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Rs. ${NumberFormat("#,##0").format(amt)} ${isCredit ? "deposited to" : "withdrawn from"} ${account.name}',
                      ),
                      backgroundColor: isCredit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCredit ? const Color(0xFF10B981) : const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(isCredit ? 'Confirm Deposit' : 'Confirm Withdrawal', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // Dialog: Inter-Vault Transfer
  void _showTransferDialog(BuildContext context, {Account? fromAccount}) {
    final cubit = context.read<ERPCubit>();
    final accounts = cubit.state.accounts.values.toList();
    if (accounts.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need at least 2 vault accounts to make a transfer.')),
      );
      return;
    }

    String selectedFromId = fromAccount?.id ?? accounts.first.id;
    String selectedToId = accounts.firstWhere((a) => a.id != selectedFromId).id;
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.swap_horiz_rounded, color: Color(0xFF4F46E5), size: 24),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Inter-Vault Fund Transfer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  Text('Move liquid funds between Cash, Banks, or Wallets',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                ],
              ),
            ],
          ),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedFromId,
                        decoration: InputDecoration(
                          labelText: 'Source Vault (FROM)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.outbox_rounded, color: Color(0xFFEF4444)),
                        ),
                        items: accounts.map((a) {
                          return DropdownMenuItem(
                            value: a.id,
                            child: Text(
                              '${a.name} (Rs. ${NumberFormat("#,##0").format(a.balance)})',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedFromId = val;
                              if (selectedToId == selectedFromId) {
                                selectedToId = accounts.firstWhere((a) => a.id != selectedFromId).id;
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedToId,
                        decoration: InputDecoration(
                          labelText: 'Destination Vault (TO)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.move_to_inbox_rounded, color: Color(0xFF10B981)),
                        ),
                        items: accounts.where((a) => a.id != selectedFromId).map((a) {
                          return DropdownMenuItem(
                            value: a.id,
                            child: Text(
                              '${a.name} (Rs. ${NumberFormat("#,##0").format(a.balance)})',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setDialogState(() => selectedToId = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: amountController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Transfer Amount (Rs.) *',
                    hintText: 'e.g. 100000',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.currency_exchange_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Transfer Memo / Reference',
                    hintText: 'e.g. Bank deposit for vendor cheque',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.description_outlined),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () async {
                final amt = double.tryParse(amountController.text.trim()) ?? 0;
                if (amt <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid transfer amount')),
                  );
                  return;
                }

                try {
                  await cubit.transferMoney(
                    fromKey: selectedFromId,
                    toKey: selectedToId,
                    amount: amt,
                    date: DateTime.now(),
                    description: descriptionController.text.trim().isEmpty
                        ? 'Inter-vault transfer'
                        : descriptionController.text.trim(),
                  );
                  if (dialogCtx.mounted) Navigator.pop(dialogCtx);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Rs. ${NumberFormat("#,##0").format(amt)} transferred successfully!',
                        ),
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transfer failed: $e')));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Execute Transfer', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFCBD5E1),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}

class _LiquiditySubCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final String badge;

  const _LiquiditySubCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: color,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                'Rs. ${currencyFormat.format(amount)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A World-Class Digital Obsidian / Sapphire / Amethyst Vault Card
class _LinedVaultStrip extends StatefulWidget {
  final Account account;
  final VoidCallback onDeposit;
  final VoidCallback onWithdraw;
  final VoidCallback onTransfer;
  final VoidCallback onViewLedger;

  const _LinedVaultStrip({
    required this.account,
    required this.onDeposit,
    required this.onWithdraw,
    required this.onTransfer,
    required this.onViewLedger,
  });

  @override
  State<_LinedVaultStrip> createState() => _LinedVaultStripState();
}

class _LinedVaultStripState extends State<_LinedVaultStrip> {
  bool _isHovered = false;

  bool get _isCash => widget.account.type.toLowerCase() == 'cash';
  bool get _isBank => widget.account.type.toLowerCase() == 'bank';

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0');
    final isNegative = widget.account.balance < 0;

    final Color badgeBg = _isCash
        ? const Color(0xFFECFDF5)
        : (_isBank ? const Color(0xFFEFF6FF) : const Color(0xFFFAF5FF));
    final Color badgeFg = _isCash
        ? const Color(0xFF059669)
        : (_isBank ? const Color(0xFF2563EB) : const Color(0xFF9333EA));
    final IconData badgeIcon = _isCash
        ? Icons.account_balance_wallet_rounded
        : (_isBank ? Icons.account_balance_rounded : Icons.phone_android_rounded);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? badgeFg.withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? badgeFg.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: _isHovered ? 16 : 6,
              offset: Offset(0, _isHovered ? 4 : 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onViewLedger,
            borderRadius: BorderRadius.circular(16),
            hoverColor: badgeBg.withValues(alpha: 0.25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  // Icon Badge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: badgeFg.withValues(alpha: 0.2)),
                    ),
                    child: Icon(badgeIcon, color: badgeFg, size: 24),
                  ),
                  const SizedBox(width: 16),

                  // Account Details
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.account.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                  letterSpacing: -0.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: badgeFg.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                widget.account.type.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: badgeFg,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${widget.account.transactions.length} transactions • Click to open account ledger',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Balance Column
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'AVAILABLE BALANCE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF94A3B8),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rs. ${currencyFormat.format(widget.account.balance)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: isNegative
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF0F172A),
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 24),

                  // Quick Action Buttons
                  Wrap(
                    spacing: 8,
                    children: [
                      _LinedActionButton(
                        icon: Icons.add_rounded,
                        label: 'In',
                        color: const Color(0xFF059669),
                        bgColor: const Color(0xFFECFDF5),
                        borderColor: const Color(0xFFA7F3D0),
                        tooltip: 'Deposit / Cash In',
                        onTap: widget.onDeposit,
                      ),
                      _LinedActionButton(
                        icon: Icons.remove_rounded,
                        label: 'Out',
                        color: const Color(0xFFDC2626),
                        bgColor: const Color(0xFFFEF2F2),
                        borderColor: const Color(0xFFFECACA),
                        tooltip: 'Withdraw / Cash Out',
                        onTap: widget.onWithdraw,
                      ),
                      _LinedActionButton(
                        icon: Icons.swap_horiz_rounded,
                        label: 'Transfer',
                        color: const Color(0xFF2563EB),
                        bgColor: const Color(0xFFEFF6FF),
                        borderColor: const Color(0xFFBFDBFE),
                        tooltip: 'Internal Vault Transfer',
                        onTap: widget.onTransfer,
                      ),
                      _LinedActionButton(
                        icon: Icons.receipt_long_rounded,
                        label: 'Ledger',
                        color: const Color(0xFF0F172A),
                        bgColor: const Color(0xFFF1F5F9),
                        borderColor: const Color(0xFFCBD5E1),
                        tooltip: 'Open Full Statement',
                        onTap: widget.onViewLedger,
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFCBD5E1)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LinedActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final String tooltip;
  final VoidCallback onTap;

  const _LinedActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.borderColor,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeSelectionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeSelectionChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
