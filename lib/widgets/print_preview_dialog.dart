import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

/// An enterprise-grade, realistic Thermal POS Receipt and Document Preview dialog.
/// Supports live switching between 58mm and 80mm thermal paper sizes with realistic
/// paper roll styling (serrated tear edges, paper texture, realistic width scaling).
class PrintPreviewDialog extends StatefulWidget {
  final Uint8List pdfBytes;
  final String fileName;
  final Future<Uint8List> Function(String paperSize)? pdfGenerator;
  final String initialPaperSize;
  final bool isThermal;

  const PrintPreviewDialog({
    super.key,
    required this.pdfBytes,
    required this.fileName,
    this.pdfGenerator,
    this.initialPaperSize = '58mm',
    this.isThermal = true,
  });

  static Future<void> show(
    BuildContext context, 
    Uint8List pdfBytes, 
    String fileName, {
    Future<Uint8List> Function(String paperSize)? pdfGenerator,
    String initialPaperSize = '58mm',
    bool? isThermal,
  }) async {
    final bool thermalMode = isThermal ?? (
      pdfGenerator != null || 
      fileName.toLowerCase().contains('purchase') ||
      fileName.toLowerCase().contains('payment') ||
      fileName.toLowerCase().contains('receipt') ||
      fileName.toLowerCase().contains('sale') ||
      fileName.toLowerCase().contains('work') ||
      fileName.toLowerCase().contains('khata') ||
      fileName.toLowerCase().contains('statement')
    );

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => PrintPreviewDialog(
        pdfBytes: pdfBytes,
        fileName: fileName,
        pdfGenerator: pdfGenerator,
        initialPaperSize: initialPaperSize,
        isThermal: thermalMode,
      ),
    );
  }

  @override
  State<PrintPreviewDialog> createState() => _PrintPreviewDialogState();
}

class _PrintPreviewDialogState extends State<PrintPreviewDialog> {
  late String _currentPaperSize;
  late Uint8List _currentBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentPaperSize = widget.initialPaperSize == '80mm' ? '80mm' : '58mm';
    _currentBytes = widget.pdfBytes;
  }

  Future<void> _changePaperSize(String newSize) async {
    if (_currentPaperSize == newSize) return;
    setState(() {
      _currentPaperSize = newSize;
    });

    if (widget.pdfGenerator != null) {
      setState(() => _isLoading = true);
      try {
        final newBytes = await widget.pdfGenerator!(newSize);
        if (mounted) {
          setState(() {
            _currentBytes = newBytes;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to reformat for $newSize: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Thermal roll simulated visual width
    final double rollWidth = _currentPaperSize == '80mm' ? 440.0 : 320.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Container(
        width: screenWidth > 1100 ? 1000 : screenWidth * 0.95,
        height: screenHeight * 0.92,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF1E293B), // Deep slate container
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Bar
            _buildHeader(),

            // Main Preview Workspace
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF0F172A), // Dark slate workbench
                child: _isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Color(0xFF3B82F6)),
                            SizedBox(height: 16),
                            Text(
                              'Reformatting POS Receipt...',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    : widget.isThermal
                        ? _buildRealisticThermalRoll(rollWidth)
                        : _buildStandardPdfViewer(),
              ),
            ),

            // Footer Bar
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(bottom: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.receipt_long, color: Color(0xFF60A5FA), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Thermal POS Live Preview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        _currentPaperSize.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF6EE7B7),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  widget.fileName,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 58mm vs 80mm Segmented Switcher
          if (widget.isThermal) ...[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPaperSizeTab('58mm', '58mm (2-Inch)'),
                  const SizedBox(width: 4),
                  _buildPaperSizeTab('80mm', '80mm (3-Inch)'),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Quick Print Button
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await Printing.layoutPdf(
                  onLayout: (format) => _currentBytes,
                  name: widget.fileName,
                );
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Print Error: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.print, size: 18),
            label: const Text('Direct Print'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
          const SizedBox(width: 10),

          // Save PDF Button
          OutlinedButton.icon(
            onPressed: () async {
              try {
                await Printing.sharePdf(bytes: _currentBytes, filename: widget.fileName);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Save Error: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Save PDF'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFE2E8F0),
              side: const BorderSide(color: Color(0xFF475569)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(width: 12),

          // Close Button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF334155),
              hoverColor: Colors.redAccent.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaperSizeTab(String size, String label) {
    final bool isSelected = _currentPaperSize == size;
    return InkWell(
      onTap: () => _changePaperSize(size),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              size == '58mm' ? Icons.receipt : Icons.receipt_long,
              size: 15,
              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealisticThermalRoll(double targetWidth) {
    final pageFormat = _currentPaperSize == '80mm'
        ? const PdfPageFormat(80 * PdfPageFormat.mm, 260 * PdfPageFormat.mm, marginAll: 0)
        : const PdfPageFormat(58 * PdfPageFormat.mm, 220 * PdfPageFormat.mm, marginAll: 0);

    return PdfPreview.builder(
      key: ValueKey('thermal_preview_${_currentPaperSize}_${_currentBytes.lengthInBytes}'),
      build: (format) => _currentBytes,
      initialPageFormat: pageFormat,
      maxPageWidth: targetWidth,
      allowPrinting: false,
      allowSharing: false,
      canChangePageFormat: false,
      canChangeOrientation: false,
      canDebug: false,
      useActions: false,
      pdfFileName: widget.fileName,
      loadingWidget: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF3B82F6)),
            const SizedBox(height: 16),
            Text(
              'Rasterizing ${_currentPaperSize.toUpperCase()} Receipt...',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
          ],
        ),
      ),
      onError: (context, error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
            const SizedBox(height: 12),
            Text(
              'Preview Error: $error',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      pagesBuilder: (context, pages) {
        if (pages.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6)));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Realistic POS Printer Feed Slit
                Container(
                  width: targetWidth + 40,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: const Color(0xFF475569), width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: targetWidth + 10,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // 2. Physical Thermal Paper Roll Container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  width: targetWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 25,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(-2, 0),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(2, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Serrated Cut
                      CustomPaint(
                        size: Size(targetWidth, 8),
                        painter: _SerratedTearPainter(isTop: true),
                      ),

                      // High-Res Rendered Receipt Pages
                      for (int i = 0; i < pages.length; i++) ...[
                        Image(
                          image: pages[i].image,
                          width: targetWidth,
                          fit: BoxFit.fitWidth,
                        ),
                        if (i < pages.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: List.generate(
                                (targetWidth / 8).floor(),
                                (idx) => Expanded(
                                  child: Container(
                                    height: 1,
                                    color: idx.isEven ? const Color(0xFFCBD5E1) : Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],

                      // Bottom Serrated Cut
                      CustomPaint(
                        size: Size(targetWidth, 8),
                        painter: _SerratedTearPainter(isTop: false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStandardPdfViewer() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 6)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: PdfPreview(
        build: (format) => _currentBytes,
        initialPageFormat: PdfPageFormat.a4,
        allowPrinting: false,
        allowSharing: false,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        pdfFileName: widget.fileName,
        loadingWidget: const Center(child: CircularProgressIndicator()),
        previewPageMargin: const EdgeInsets.all(16),
        useActions: false,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        border: Border(top: BorderSide(color: Color(0xFF334155))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.speed, size: 14, color: Color(0xFF94A3B8)),
              const SizedBox(width: 6),
              Text(
                'Simulated Hardware: ESC/POS Thermal Receipt (${_currentPaperSize == "80mm" ? "72mm printable width, 80mm roll" : "48mm printable width, 58mm roll"})',
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Auto-aligned 203 DPI ready',
                style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter that draws realistic zigzag/sawtooth serrated tear edges on thermal paper roll
class _SerratedTearPainter extends CustomPainter {
  final bool isTop;

  _SerratedTearPainter({required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F172A) // Matches the workbench background
      ..style = PaintingStyle.fill;

    final path = Path();
    const toothWidth = 8.0;
    final toothHeight = size.height;
    final count = (size.width / toothWidth).ceil();

    if (isTop) {
      path.moveTo(0, 0);
      for (int i = 0; i < count; i++) {
        final double x1 = i * toothWidth + (toothWidth / 2);
        final double x2 = (i + 1) * toothWidth;
        path.lineTo(x1, toothHeight);
        path.lineTo(x2, 0);
      }
      path.lineTo(size.width, 0);
      path.close();
    } else {
      path.moveTo(0, toothHeight);
      for (int i = 0; i < count; i++) {
        final double x1 = i * toothWidth + (toothWidth / 2);
        final double x2 = (i + 1) * toothWidth;
        path.lineTo(x1, 0);
        path.lineTo(x2, toothHeight);
      }
      path.lineTo(size.width, toothHeight);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SerratedTearPainter oldDelegate) => false;
}
