import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import './invoice_pdf_service.dart';
import '../models/app_profile.dart';
import '../utils/whatsapp_utils.dart';

class WhatsAppService {
  static bool get isSharingSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Helper to handle sharing or notifying based on platform
  static Future<void> _handlePdfSharing(Uint8List pdfBytes, String filename, String phone) async {
    if (isSharingSupported) {
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: filename,
      );
    } else if (!kIsWeb && Platform.isWindows) {
      // 1. Get Documents directory
      final documentsDir = Directory(
        '${Platform.environment['USERPROFILE']}\\Documents\\Traila\\Invoices',
      );
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final winFilename = 'Invoice_$timestamp.pdf';
      final filePath = '${documentsDir.path}\\$winFilename';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // 2. Trigger WhatsApp Automation
      await _sendWhatsAppWindows(phone, filePath);
    } else {
      throw 'Sharing is not supported on this platform.';
    }
  }

  /// Windows workflow:
  /// 1. Open WhatsApp Desktop via URL scheme
  /// 2. Open Windows Explorer and highlight the generated file
  static Future<void> _sendWhatsAppWindows(String phone, String filePath) async {
    final cleanPhone = formatWhatsAppNumber(phone);

    try {
      // 1. Open WhatsApp Desktop chat
      // Using 'whatsapp://' launches the desktop app directly
      final waUri = 'whatsapp://send?phone=$cleanPhone';
      await Process.run('cmd', ['/c', 'start', waUri]);

      // 2. Open folder and highlight file
      // 'explorer /select,"path"' selects the file in the window
      await Process.run('explorer.exe', ['/select,', filePath]);
    } catch (e) {
      // Fallback: just open the folder if something goes wrong
      await Process.run('explorer.exe', ['/select,', filePath]);
      throw 'Failed to open WhatsApp Desktop. Please ensure it is installed.\n'
          'We have opened the invoice folder for you.\nError: $e';
    }
  }

  /// 1. Supplier – New Purchase Invoice
  static Future<void> sendSupplierPurchaseReceipt({
    required String phone,
    required String supplierName,
    required String date,
    required List<dynamic> items,
    required double previousBalance,
    required double paymentAmount,
    required double newBalance,
    String? paymentMethod, // ✅ New optional parameter
    required AppProfile? profile,
  }) async {
    try {
      final pdfBytes = await InvoicePdfService.generateSupplierPurchasePdf(
        supplierName: supplierName,
        date: date,
        items: items,
        previousBalance: previousBalance,
        paymentAmount: paymentAmount,
        newBalance: newBalance,
        paymentMethod: paymentMethod, // ✅ Pass payment method
        profile: profile,
      );

      await _handlePdfSharing(pdfBytes, 'Purchase_Invoice_${date.replaceAll('-', '_')}.pdf', phone);
    } catch (e) {
      rethrow;
    }
  }

  /// 2. Supplier – Record Payment
  static Future<void> sendSupplierPaymentReceipt({
    required String phone,
    required String supplierName,
    required String date,
    required String paymentMethod,
    required double paidAmount,
    required double previousBalance,
    required double newBalance,
    required AppProfile? profile,
  }) async {
    try {
      final pdfBytes = await InvoicePdfService.generateSupplierPaymentPdf(
        supplierName: supplierName,
        date: date,
        paymentMethod: paymentMethod,
        paidAmount: paidAmount,
        previousBalance: previousBalance,
        newBalance: newBalance,
        profile: profile,
      );

      await _handlePdfSharing(pdfBytes, 'Payment_Receipt_${date.replaceAll('-', '_')}.pdf', phone);
    } catch (e) {
      rethrow;
    }
  }

  /// 3. Labour – Add Work
  static Future<void> sendLabourWorkReceipt({
    required String phone,
    required String labourName,
    required String date,
    required String trailaId,
    required double workPrice,
    required double previousBalance,
    required double newBalance,
    required AppProfile? profile,
  }) async {
    try {
      final pdfBytes = await InvoicePdfService.generateLabourWorkPdf(
        labourName: labourName,
        date: date,
        trailaId: trailaId,
        workPrice: workPrice,
        previousBalance: previousBalance,
        newBalance: newBalance,
        profile: profile,
      );

      await _handlePdfSharing(pdfBytes, 'Work_Invoice_${date.replaceAll('-', '_')}.pdf', phone);
    } catch (e) {
      rethrow;
    }
  }

  /// 4. Labour – Record Payment
  static Future<void> sendLabourPaymentReceipt({
    required String phone,
    required String labourName,
    required String date,
    required String paymentMethod,
    required double paidAmount,
    required double previousBalance,
    required double newBalance,
    required AppProfile? profile,
  }) async {
    try {
      final pdfBytes = await InvoicePdfService.generateLabourPaymentPdf(
        labourName: labourName,
        date: date,
        paymentMethod: paymentMethod,
        paidAmount: paidAmount,
        previousBalance: previousBalance,
        newBalance: newBalance,
        profile: profile,
      );

      await _handlePdfSharing(pdfBytes, 'Labour_Payment_${date.replaceAll('-', '_')}.pdf', phone);
    } catch (e) {
      rethrow;
    }
  }

  /// 5. Sale – Full Invoice
  static Future<void> sendSaleReceipt({
    required String phone,
    required String buyerName,
    required String date,
    required String trailaName,
    required dynamic sale,
    required dynamic buyer,
    required List<dynamic> payments,
    required AppProfile? profile,
  }) async {
    try {
      final pdfBytes = await InvoicePdfService.generateSalePdf(
        sale: sale,
        buyer: buyer, 
        trailaName: trailaName,
        profile: profile,
      );

      await _handlePdfSharing(pdfBytes, 'Sale_Invoice_${sale.receiptNumber}.pdf', phone);
    } catch (e) {
      rethrow;
    }
  }

  /// 6. Sale – Payment Receipt (Installment)
  static Future<void> sendSalePaymentReceipt({
    required String phone,
    required dynamic sale,
    required dynamic buyer,
    required dynamic payment,
    required String trailaName,
    required AppProfile? profile,
    String paperSize = '80mm',
  }) async {
    try {
      final pdfBytes = await InvoicePdfService.generateThermalSalePaymentPdf(
        sale: sale,
        buyer: buyer,
        payment: payment,
        trailaName: trailaName,
        profile: profile,
        paperSize: paperSize,
      );

      await _handlePdfSharing(pdfBytes, 'Payment_${payment.receiptNumber}.pdf', phone);
    } catch (e) {
      rethrow;
    }
  }

  /// 7. Khata – Statement
  static Future<void> sendKhataStatement({
    required String phone,
    required dynamic khata,
    required AppProfile? profile,
  }) async {
    try {
      final pdfBytes = await InvoicePdfService.generateKhataPdf(
        khata: khata,
        profile: profile,
      );
      await _handlePdfSharing(pdfBytes, 'Khata_Statement_${khata.personName}.pdf', phone);
    } catch (e) {
      rethrow;
    }
  }

  /// 8. Labour – Statement
  static Future<void> sendLabourStatement({
    required String phone,
    required String personName,
    required double remainingBalance,
    required AppProfile? profile,
  }) async {
    try {
      final pdfBytes = await InvoicePdfService.generateStatementPdf(
        personName: personName,
        type: 'Labour',
        date: DateTime.now().toIso8601String().substring(0, 10),
        remainingBalance: remainingBalance,
        profile: profile,
      );
      await _handlePdfSharing(pdfBytes, 'Labour_Statement_$personName.pdf', phone);
    } catch (e) {
      rethrow;
    }
  }
}
