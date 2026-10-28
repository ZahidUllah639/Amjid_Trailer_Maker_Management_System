import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/erp_cubit.dart';
import '../../services/invoice_pdf_service.dart';
import '../../widgets/print_preview_dialog.dart';

class PrinterSettingsScreen extends StatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  State<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends State<PrinterSettingsScreen> {
  bool _isTestingPrint = false;

  Future<void> _handleTestPrint() async {
    setState(() => _isTestingPrint = true);
    final state = context.read<ERPCubit>().state;
    final paperSize = state.printerSetting.paperSize;

    try {
      final pdfBytes = await InvoicePdfService.generateCashFlowReportPdf(
        totalCash: 250000.0,
        accounts: state.accounts.values.toList(),
        profile: state.appProfile,
      );

      if (mounted) {
        await PrintPreviewDialog.show(
          context,
          pdfBytes,
          'Test_Print_$paperSize.pdf',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Test Print Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTestingPrint = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<ERPCubit>().state.printerSetting;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero Hardware Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: const Icon(
                    Icons.print_rounded,
                    color: Color(0xFF38BDF8),
                    size: 32,
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
                            'Thermal POS & Laser Hardware Configuration',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              settings.paperSize.toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF7DD3FC),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Select thermal paper dimensions, automatic invoice triggers, and manage Windows driver integration.',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isTestingPrint ? null : _handleTestPrint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: _isTestingPrint
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.speed_rounded, size: 18),
                  label: const Text('Test Print Slip', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // 2. Paper Size Selector
          const Text(
            'SELECT DEFAULT THERMAL ROLL SIZE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF64748B),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PaperSizeCard(
                  title: 'POS 58mm (2-Inch)',
                  subtitle: 'Compact Roll for Standard Workshop Slips',
                  description: 'Ideal for Xprinter XP-58, POS-58, and mini Bluetooth/USB receipt printers.',
                  icon: Icons.receipt_long_rounded,
                  isSelected: settings.paperSize == '58mm',
                  onSelect: () {
                    context.read<ERPCubit>().updatePrinterSettings(
                          settings.copyWith(paperSize: '58mm'),
                        );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _PaperSizeCard(
                  title: 'POS 80mm (3-Inch)',
                  subtitle: 'Wide Roll for Detailed Multi-Column Slips',
                  description: 'Ideal for Epson TM-T20, XP-80, Bixolon, and heavy industrial desktop thermal printers.',
                  icon: Icons.receipt_rounded,
                  isSelected: settings.paperSize == '80mm',
                  onSelect: () {
                    context.read<ERPCubit>().updatePrinterSettings(
                          settings.copyWith(paperSize: '80mm'),
                        );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 3. Automation & System Settings Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF64748B).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.tune_rounded, color: Color(0xFF4F46E5), size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Automation Preferences',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  secondary: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Color(0xFF4F46E5), size: 22),
                  ),
                  title: const Text(
                    'Auto-open Print Window on Transaction Confirmation',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'When generating a sale invoice, payment receipt, or wage disbursement, automatically open the Windows print queue.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  value: settings.autoPrint,
                  activeThumbColor: const Color(0xFF4F46E5),
                  onChanged: (val) {
                    context.read<ERPCubit>().updatePrinterSettings(
                          settings.copyWith(autoPrint: val),
                        );
                  },
                ),
                const Divider(height: 24),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  secondary: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.content_cut_rounded, color: Color(0xFF10B981), size: 22),
                  ),
                  title: const Text(
                    'Hardware Auto-Cutter Command',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Transmit paper cut commands to 80mm thermal hardware after printing finishes.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  value: settings.autoCut,
                  activeThumbColor: const Color(0xFF10B981),
                  onChanged: (val) {
                    context.read<ERPCubit>().updatePrinterSettings(
                          settings.copyWith(autoCut: val),
                        );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 4. Windows 10/11 Setup Guide Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.help_outline_rounded, color: Color(0xFF0284C7), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Windows Thermal Setup Guide',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildGuideStep('1', 'Connect your USB or Bluetooth POS thermal printer to your Windows PC.'),
                _buildGuideStep('2', 'In Windows Settings > Bluetooth & Devices > Printers & Scanners, ensure your printer driver is installed and shows as "Ready".'),
                _buildGuideStep('3', 'Click on your printer > Printing Preferences > Paper/Quality, and match the roll width (58mm or 80mm) chosen above.'),
                _buildGuideStep('4', 'Whenever you click "Print Receipt" in Traila ERP, select your POS printer and hit Print. That is all!'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideStep(String stepNumber, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: Text(
              stepNumber,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaperSizeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onSelect;

  const _PaperSizeCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? const Color(0xFF059669) : const Color(0xFF64748B),
                    size: 24,
                  ),
                ),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isSelected ? const Color(0xFF065F46) : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF047857) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? const Color(0xFF065F46).withValues(alpha: 0.8) : const Color(0xFF94A3B8),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
