import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import '../models/app_profile.dart';

/// A utility to ensure consistent branding across PDF and Thermal POS prints.
class UnifiedPrintService {
  static const String logoPath = 'assets/images/Logo.png';

  // --- Image Processing ---

  static pw.MemoryImage? _cachedThermalLogo;

  /// Processes the logo for thermal printing: Emblem Crop -> Grayscale -> Smart Polarity Inversion -> Pure Monochrome
  static Future<pw.MemoryImage> _getThermalLogo() async {
    if (_cachedThermalLogo != null) return _cachedThermalLogo!;
    try {
      final logoData = await rootBundle.load(logoPath);
      final bytes = logoData.buffer.asUint8List();
      
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return pw.MemoryImage(bytes);

      // 1. Convert to Grayscale
      img.Image gray = img.grayscale(image);
      
      // 2. Crop the iconic shield & truck emblem to remove dark margins and tiny squished bottom text
      final cropX = (gray.width * 0.16).round();
      final cropY = (gray.height * 0.12).round();
      final cropW = (gray.width * 0.68).round();
      final cropH = (gray.height * 0.52).round();
      img.Image emblem = img.copyCrop(gray, x: cropX, y: cropY, width: cropW, height: cropH);

      // 3. Resize to optimal thermal print resolution (300px width)
      emblem = img.copyResize(emblem, width: 300, interpolation: img.Interpolation.linear);

      // 4. Detect background polarity from corners
      final c1 = emblem.getPixel(2, 2);
      final c2 = emblem.getPixel(emblem.width - 3, 2);
      final c3 = emblem.getPixel(2, emblem.height - 3);
      final c4 = emblem.getPixel(emblem.width - 3, emblem.height - 3);
      final double cornerLuma = (
        (0.299 * c1.r + 0.587 * c1.g + 0.114 * c1.b) +
        (0.299 * c2.r + 0.587 * c2.g + 0.114 * c2.b) +
        (0.299 * c3.r + 0.587 * c3.g + 0.114 * c3.b) +
        (0.299 * c4.r + 0.587 * c4.g + 0.114 * c4.b)
      ) / (4.0 * 255.0);

      // If background is dark, invert so background stays clean white paper
      final bool invert = cornerLuma < 0.5;

      // 5. Thresholding for pure High-Contrast Monochrome
      final output = img.Image(width: emblem.width, height: emblem.height);
      for (int y = 0; y < emblem.height; y++) {
        for (int x = 0; x < emblem.width; x++) {
          final p = emblem.getPixel(x, y);
          double l = (0.299 * p.r + 0.587 * p.g + 0.114 * p.b) / 255.0;
          if (invert) {
            l = 1.0 - l;
          }
          if (l < 0.48) {
            output.setPixelRgb(x, y, 0, 0, 0);
          } else {
            output.setPixelRgb(x, y, 255, 255, 255);
          }
        }
      }
      
      _cachedThermalLogo = pw.MemoryImage(Uint8List.fromList(img.encodePng(output)));
      return _cachedThermalLogo!;
    } catch (e) {
      final logoData = await rootBundle.load(logoPath);
      return pw.MemoryImage(logoData.buffer.asUint8List());
    }
  }

  // --- PDF Logic ---

  static Future<pw.Widget> buildPdfHeader(AppProfile? profile, String title) async {
    final logoData = await rootBundle.load(logoPath);
    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    return pw.Column(
      children: [
        // Center the Logo and make it large
        pw.Center(
          child: pw.Container(
            height: 180, 
            width: 180,
            child: pw.Image(logo, fit: pw.BoxFit.contain),
          ),
        ),
        pw.SizedBox(height: 15),
        
        // Center the Business Info
        pw.Center(
          child: pw.Column(
            children: [
              pw.Text('Amjid Trailer Makers', 
                  style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
              pw.SizedBox(height: 5),
              pw.Text('Main Hazar Khwani Ring Road Peshawar', 
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 2),
              pw.Text('03005824833 | 03167766798', 
                  style: const pw.TextStyle(fontSize: 12)),
            ],
          ),
        ),
        pw.SizedBox(height: 20),
        
        // Invoice Title
        pw.Center(
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: const pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Text(title.toUpperCase(), 
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 2, color: PdfColors.blue900),
        pw.SizedBox(height: 15),
      ],
    );
  }

  static pw.Widget buildPdfFooter() {
    return pw.Column(
      children: [
        pw.Divider(thickness: 0.5, color: PdfColors.grey400),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Computer Generated Invoice', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
            pw.Text('Thank you for choosing us!', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.Text('Date: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}', style: const pw.TextStyle(fontSize: 8)),
          ],
        ),
      ],
    );
  }

  // Carbon Copy Wrapper for PDF
  static List<pw.Widget> wrapCarbonCopy(List<pw.Widget> content, bool isDuplicate) {
    return [
      pw.Container(
        alignment: pw.Alignment.topRight,
        child: pw.Text(isDuplicate ? "DUPLICATE COPY" : "ORIGINAL COPY", 
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: isDuplicate ? PdfColors.orange : PdfColors.blue900)),
      ),
      ...content,
    ];
  }

  // --- EXECUTIVE POS-STYLE THERMAL RECEIPT WIDGETS ---

  static Future<pw.Widget> buildThermalPdfHeader(
    AppProfile? profile, 
    String title, {
    String? subtitle,
    String? docNumber,
  }) async {
    final logo = await _getThermalLogo();
    final businessName = (profile?.businessName?.isNotEmpty == true 
        ? profile!.businessName! 
        : 'Amjid Trailer Makers').toUpperCase();
    final address = profile?.address?.isNotEmpty == true 
        ? profile!.address! 
        : 'Main Hazar Khwani, Ring Road Peshawar';
    final phone = profile?.phoneNumber.isNotEmpty == true 
        ? profile!.phoneNumber 
        : '0300-5824833  |  0316-7766798';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Top decorative double hairline border
        pw.Container(
          width: double.infinity,
          height: 1.5,
          color: PdfColors.black,
        ),
        pw.SizedBox(height: 1.5),
        pw.Container(
          width: double.infinity,
          height: 0.5,
          color: PdfColors.black,
        ),
        pw.SizedBox(height: 5),

        // Brand Emblem (Cropped pure monochrome linework)
        pw.Center(
          child: pw.Image(logo, width: 68, fit: pw.BoxFit.contain),
        ),
        pw.SizedBox(height: 4),

        // Company Title
        pw.Text(
          businessName,
          style: pw.TextStyle(
            fontSize: 12.5,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 0.6,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 1.5),

        // Industrial Subtitle
        pw.Text(
          subtitle ?? 'INDUSTRIAL FLEET & TRAILER MANUFACTURING',
          style: pw.TextStyle(
            fontSize: 7.2,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 0.4,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 2),

        // Address & Contacts
        pw.Text(
          address,
          style: const pw.TextStyle(fontSize: 8),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 1),
        pw.Text(
          'Tel: $phone',
          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 5),

        // Executive Inverted Document Title Banner
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 3.5),
          decoration: const pw.BoxDecoration(
            color: PdfColors.black,
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
          ),
          child: pw.Column(
            children: [
              pw.Text(
                title.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 10.5,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                  letterSpacing: 1.2,
                ),
                textAlign: pw.TextAlign.center,
              ),
              if (docNumber != null && docNumber.isNotEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 1),
                  child: pw.Text(
                    docNumber,
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColors.white,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        pw.SizedBox(height: 6),
      ],
    );
  }

  static pw.Widget buildThermalPdfFooter(bool isDuplicate, {String? barcodeValue}) {
    final code = barcodeValue ?? 'ATM-${DateFormat('yyMMddHHmm').format(DateTime.now())}';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(height: 6),
        // Dashed divider
        pw.Divider(thickness: 0.8, borderStyle: pw.BorderStyle.dashed),
        pw.SizedBox(height: 3),

        // Crisp Code128 Barcode
        pw.Center(
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.code128(),
            data: code,
            height: 22,
            width: 130,
            drawText: true,
            textStyle: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 4),

        // Copy Stamp Pill
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.8),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
          ),
          child: pw.Text(
            isDuplicate ? "••• DUPLICATE AUDIT COPY •••" : "••• ORIGINAL CUSTOMER COPY •••",
            style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(height: 4),

        pw.Text(
          'Thank you for your business!',
          style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 1),
        pw.Text(
          'Goods once sold cannot be returned without invoice.',
          style: pw.TextStyle(fontSize: 6.8, fontStyle: pw.FontStyle.italic),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          'Printed: ${DateFormat('dd-MMM-yyyy  hh:mm a').format(DateTime.now())}',
          style: const pw.TextStyle(fontSize: 7.5),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 18), // Tear-off feed margin
      ],
    );
  }
}
