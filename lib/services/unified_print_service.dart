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

  /// Processes the logo for thermal printing: Grayscale -> Resize -> Monochrome Threshold
  static Future<pw.MemoryImage> _getThermalLogo() async {
    try {
      final logoData = await rootBundle.load(logoPath);
      final bytes = logoData.buffer.asUint8List();
      
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return pw.MemoryImage(bytes);

      // 1. Convert to Grayscale
      img.Image processed = img.grayscale(image);
      
      // 2. Resize to optimal thermal width (approx 300px for 203dpi heads)
      processed = img.copyResize(processed, width: 300, interpolation: img.Interpolation.linear);
      
      // 3. Thresholding for pure High-Contrast Monochrome
      for (final pixel in processed) {
        // Luminance thresholding
        final double l = (0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b) / 255.0;
        if (l > 0.6) { // Slightly conservative threshold to keep logo details
          pixel.r = 255; pixel.g = 255; pixel.b = 255;
        } else {
          pixel.r = 0; pixel.g = 0; pixel.b = 0;
        }
      }
      
      return pw.MemoryImage(Uint8List.fromList(img.encodePng(processed)));
    } catch (e) {
      // Fallback to original if processing fails
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

  // --- POS-STYLE PDF Widgets ---

  static Future<pw.Widget> buildThermalPdfHeader(AppProfile? profile, String title) async {
    final logo = await _getThermalLogo();

    return pw.Column(
      children: [
        pw.Center(
          child: pw.Image(logo, width: 80, fit: pw.BoxFit.contain), 
        ),
        pw.SizedBox(height: 3),
        pw.Text('Amjid Trailer Makers', 
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
        pw.SizedBox(height: 1),
        pw.Text('Main Hazar Khwani Ring Road Peshawar', 
            style: const pw.TextStyle(fontSize: 8.5), textAlign: pw.TextAlign.center),
        pw.SizedBox(height: 1),
        pw.Text('03005824833 | 03167766798', 
            style: const pw.TextStyle(fontSize: 8.5), textAlign: pw.TextAlign.center),
        pw.SizedBox(height: 4),
        pw.Text(title.toUpperCase(), 
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
      ],
    );
  }

  static pw.Widget buildThermalPdfFooter(bool isDuplicate) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 5),
        pw.Text(isDuplicate ? "--- DUPLICATE COPY ---" : "--- ORIGINAL COPY ---", 
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
        pw.Text('Thank you for your business!', style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),
        pw.Text(DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()), 
            style: const pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.center),
        pw.SizedBox(height: 20), // Tearing space
      ],
    );
  }
}
