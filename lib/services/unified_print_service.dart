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

  /// Processes the logo for thermal printing: Emblem Crop -> Grayscale -> Smart Polarity Inversion -> Smooth Anti-Aliasing
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

      // 3. Resize with high-quality cubic interpolation to 400px width for silky curves
      emblem = img.copyResize(emblem, width: 400, interpolation: img.Interpolation.cubic);

      // 4. Detect background polarity from corners
      final c1 = emblem.getPixel(2, 2);
      final c2 = emblem.getPixel(emblem.width - 3, 2);
      final double cornerLuma = (c1.r + c2.r) / (2.0 * 255.0);

      // If background is dark, invert so background stays clean white paper
      final bool invert = cornerLuma < 0.5;

      // 5. Smooth Hermite S-Curve Contrast Enhancement (keeps anti-aliased curves without jagged 1-bit noise)
      final output = img.Image(width: emblem.width, height: emblem.height);
      for (int y = 0; y < emblem.height; y++) {
        for (int x = 0; x < emblem.width; x++) {
          final p = emblem.getPixel(x, y);
          double l = (0.299 * p.r + 0.587 * p.g + 0.114 * p.b) / 255.0;
          if (invert) {
            l = 1.0 - l;
          }
          double val;
          if (l >= 0.58) {
            val = 1.0; // clean white paper
          } else if (l <= 0.28) {
            val = 0.0; // rich black linework
          } else {
            double t = (l - 0.28) / (0.58 - 0.28);
            val = t * t * (3.0 - 2.0 * t); // smooth Hermite curve
          }
          int byteVal = (val * 255.0).round().clamp(0, 255);
          output.setPixelRgb(x, y, byteVal, byteVal, byteVal);
        }
      }
      
      _cachedThermalLogo = pw.MemoryImage(Uint8List.fromList(img.encodePng(output)));
      return _cachedThermalLogo!;
    } catch (e) {
      final logoData = await rootBundle.load(logoPath);
      return pw.MemoryImage(logoData.buffer.asUint8List());
    }
  }

  // --- EXECUTIVE A4 PDF HEADER & FOOTER ---

  static Future<pw.Widget> buildPdfHeader(AppProfile? profile, String title) async {
    final logoData = await rootBundle.load(logoPath);
    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    final businessName = (profile?.businessName?.isNotEmpty == true 
        ? profile!.businessName! 
        : 'Amjid Trailer Makers').toUpperCase();
    final address = profile?.address?.isNotEmpty == true 
        ? profile!.address! 
        : 'Main Hazar Khwani, Ring Road Peshawar';
    final phone = profile?.phoneNumber.isNotEmpty == true 
        ? profile!.phoneNumber 
        : '0300-5824833 | 0316-7766798';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Top Corporate Duo-Tone Accent Bar
        pw.Container(
          height: 3.5,
          width: double.infinity,
          decoration: const pw.BoxDecoration(
            color: PdfColors.blue900,
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
          ),
        ),
        pw.SizedBox(height: 12),

        // Horizontal Executive Layout
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            // Left: Logo & Company Brand Cluster
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                  height: 65,
                  width: 65,
                  decoration: pw.BoxDecoration(
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                    border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
                  ),
                  child: pw.ClipRRect(
                    horizontalRadius: 6,
                    verticalRadius: 6,
                    child: pw.Image(logo, fit: pw.BoxFit.contain),
                  ),
                ),
                pw.SizedBox(width: 14),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      businessName,
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'INDUSTRIAL FLEET & HEAVY TRAILER MANUFACTURING',
                      style: pw.TextStyle(
                        fontSize: 7.5,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey700,
                        letterSpacing: 0.4,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      address,
                      style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800),
                    ),
                    pw.SizedBox(height: 1),
                    pw.Text(
                      'Contact: $phone',
                      style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
                    ),
                  ],
                ),
              ],
            ),

            // Right: Document Badge & Meta Pill
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.blue900,
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Text(
                    title.toUpperCase(),
                    style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800),
                ),
                pw.Text(
                  'OFFICIAL BUSINESS DOCUMENT',
                  style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Divider(thickness: 1, color: PdfColors.blue900),
        pw.SizedBox(height: 10),
      ],
    );
  }

  static pw.Widget buildPdfFooter() {
    return pw.Column(
      children: [
        pw.Divider(thickness: 0.5, color: PdfColors.grey400),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Generated by Master Trailers System • Authorized Copy', 
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
            pw.Text('Thank you for your business!', 
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.Text('Timestamp: ${DateFormat('dd-MMM-yyyy HH:mm').format(DateTime.now())}', 
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
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
          height: 1.2,
          color: PdfColors.black,
        ),
        pw.SizedBox(height: 1.2),
        pw.Container(
          width: double.infinity,
          height: 0.5,
          color: PdfColors.black,
        ),
        pw.SizedBox(height: 4),

        // Brand Emblem (Cropped smooth anti-aliased linework)
        pw.Center(
          child: pw.Image(logo, width: 58, fit: pw.BoxFit.contain),
        ),
        pw.SizedBox(height: 3),

        // Company Title
        pw.Text(
          businessName,
          style: pw.TextStyle(
            fontSize: 11.5,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 0.6,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 1),

        // Industrial Subtitle
        pw.Text(
          subtitle ?? 'INDUSTRIAL FLEET & TRAILER MANUFACTURING',
          style: pw.TextStyle(
            fontSize: 6.8,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 0.3,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 1.5),

        // Address & Contacts
        pw.Text(
          address,
          style: const pw.TextStyle(fontSize: 7.5),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 1),
        pw.Text(
          'Tel: $phone',
          style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 4),

        // Executive Framed Document Title Banner (Clean double horizontal borders, no heavy black ink block)
        pw.Container(
          width: double.infinity,
          margin: const pw.EdgeInsets.symmetric(vertical: 2),
          padding: const pw.EdgeInsets.symmetric(vertical: 3.5, horizontal: 4),
          decoration: const pw.BoxDecoration(
            border: pw.Border.symmetric(
              horizontal: pw.BorderSide(color: PdfColors.black, width: 1.0),
            ),
          ),
          child: pw.Column(
            children: [
              pw.Text(
                title.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
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
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        pw.SizedBox(height: 5),
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
