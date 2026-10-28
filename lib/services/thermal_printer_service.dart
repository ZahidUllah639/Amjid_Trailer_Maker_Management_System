import '../models/sale.dart';
import '../models/buyer.dart';
import '../models/traila.dart';
import '../models/printer_setting.dart';
import '../models/supplier.dart';
import '../models/labour.dart';
import '../models/payment.dart';
import '../models/account.dart';
import '../models/khata.dart';
import '../models/app_profile.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'invoice_pdf_service.dart';
import '../widgets/print_preview_dialog.dart';

class ThermalPrinterService {

  static Future<bool> printReceiptGeneric(
    BuildContext context, 
    Uint8List pdfBytes, 
    String name, {
    Future<Uint8List> Function(String paperSize)? pdfGenerator,
    String initialPaperSize = '58mm',
    bool isThermal = true,
  }) async {
    try {
      if (!context.mounted) return false;
      await PrintPreviewDialog.show(
        context, 
        pdfBytes, 
        '${name.replaceAll(' ', '_')}.pdf',
        pdfGenerator: pdfGenerator,
        initialPaperSize: initialPaperSize,
        isThermal: isThermal,
      );
      return true;
    } catch (e) {
      debugPrint('Print Dialog Error: $e');
      return false;
    }
  }

  static Future<bool> printReceipt(
    BuildContext context, {
    required Sale sale,
    required Buyer buyer,
    required Traila traila,
    required AppProfile? profile,
    required PrinterSetting settings,
    bool printDuplicate = true,
  }) async {
    final pdfBytes = await InvoicePdfService.generateThermalSalePdf(
      sale: sale,
      buyer: buyer,
      trailaName: traila.name,
      profile: profile,
      paperSize: settings.paperSize,
      isDuplicate: false,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Sale_${sale.receiptNumber}',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalSalePdf(
        sale: sale,
        buyer: buyer,
        trailaName: traila.name,
        profile: profile,
        paperSize: size,
        isDuplicate: false,
      ),
    );
  }

  static Future<bool> printSalePayment(
    BuildContext context, {
    required Sale sale,
    required Buyer buyer,
    required Payment payment,
    required String trailaName,
    required AppProfile? profile,
    required PrinterSetting settings,
    bool isDuplicate = false,
  }) async {
    final pdfBytes = await InvoicePdfService.generateThermalSalePaymentPdf(
      sale: sale,
      buyer: buyer,
      payment: payment,
      trailaName: trailaName,
      profile: profile,
      paperSize: settings.paperSize,
      isDuplicate: isDuplicate,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Payment_${payment.receiptNumber}',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalSalePaymentPdf(
        sale: sale,
        buyer: buyer,
        payment: payment,
        trailaName: trailaName,
        profile: profile,
        paperSize: size,
        isDuplicate: isDuplicate,
      ),
    );
  }

  static Future<bool> printSupplierPurchase(
    BuildContext context, {
    required Supplier supplier,
    required SupplierPurchase purchase,
    required AppProfile? profile,
    required PrinterSetting settings,
    bool printDuplicate = true,
  }) async {
    final pdfBytes = await InvoicePdfService.generateThermalPurchasePdf(
      supplier: supplier,
      purchase: purchase,
      profile: profile,
      paperSize: settings.paperSize,
      isDuplicate: false,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Purchase_${purchase.billNumber}',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalPurchasePdf(
        supplier: supplier,
        purchase: purchase,
        profile: profile,
        paperSize: size,
        isDuplicate: false,
      ),
    );
  }

  static Future<bool> printSupplierPayment(
    BuildContext context, {
    required Supplier supplier,
    required Payment payment,
    required double previousBalance,
    required double newBalance,
    required AppProfile? profile,
    required PrinterSetting settings,
    bool printDuplicate = true,
  }) async {
    final pdfBytes = await InvoicePdfService.generateThermalPaymentPdf(
      personName: supplier.name,
      type: 'Supplier',
      amount: payment.amount,
      method: payment.method,
      prevBalance: previousBalance,
      newBalance: newBalance,
      date: payment.date,
      profile: profile,
      paperSize: settings.paperSize,
      isDuplicate: false,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Payment_${supplier.name}',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalPaymentPdf(
        personName: supplier.name,
        type: 'Supplier',
        amount: payment.amount,
        method: payment.method,
        prevBalance: previousBalance,
        newBalance: newBalance,
        date: payment.date,
        profile: profile,
        paperSize: size,
        isDuplicate: false,
      ),
    );
  }

  static Future<bool> printLabourWork(
    BuildContext context, {
    required Labour labour,
    required WorkEntry work,
    required AppProfile? profile,
    required PrinterSetting settings,
    bool printDuplicate = true,
  }) async {
    final pdfBytes = await InvoicePdfService.generateThermalWorkPdf(
      labour: labour,
      work: work,
      profile: profile,
      paperSize: settings.paperSize,
      isDuplicate: false,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Work_${work.entryNumber}',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalWorkPdf(
        labour: labour,
        work: work,
        profile: profile,
        paperSize: size,
        isDuplicate: false,
      ),
    );
  }

  static Future<bool> printLabourPayment(
    BuildContext context, {
    required Labour labour,
    required Payment payment,
    required double previousBalance,
    required double newBalance,
    required AppProfile? profile,
    required PrinterSetting settings,
    bool printDuplicate = true,
  }) async {
    final pdfBytes = await InvoicePdfService.generateThermalPaymentPdf(
      personName: labour.name,
      type: 'Labour',
      amount: payment.amount,
      method: payment.method,
      prevBalance: previousBalance,
      newBalance: newBalance,
      date: payment.date,
      profile: profile,
      paperSize: settings.paperSize,
      isDuplicate: false,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Payment_${labour.name}',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalPaymentPdf(
        personName: labour.name,
        type: 'Labour',
        amount: payment.amount,
        method: payment.method,
        prevBalance: previousBalance,
        newBalance: newBalance,
        date: payment.date,
        profile: profile,
        paperSize: size,
        isDuplicate: false,
      ),
    );
  }

  static Future<bool> printKhataLedger(
    BuildContext context, {
    required Khata khata,
    required AppProfile? profile,
    required PrinterSetting settings,
    bool printDuplicate = true,
  }) async {
    final pdfBytes = await InvoicePdfService.generateThermalKhataPdf(
      khata: khata,
      profile: profile,
      paperSize: settings.paperSize,
      isDuplicate: false,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Khata_${khata.personName}',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalKhataPdf(
        khata: khata,
        profile: profile,
        paperSize: size,
        isDuplicate: false,
      ),
    );
  }

  static Future<bool> printSupplierStatement(
    BuildContext context, {
    required Supplier supplier,
    required AppProfile? profile,
    required PrinterSetting settings,
  }) async {
    final pdfBytes = await InvoicePdfService.generateThermalStatementPdf(
      personName: supplier.name,
      type: "Supplier",
      date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      remainingBalance: supplier.remainingBalance,
      profile: profile,
      paperSize: settings.paperSize,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Statement_${supplier.name}',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalStatementPdf(
        personName: supplier.name,
        type: "Supplier",
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        remainingBalance: supplier.remainingBalance,
        profile: profile,
        paperSize: size,
      ),
    );
  }

  static Future<bool> printLabourStatement(
    BuildContext context, {
    required Labour labour,
    required AppProfile? profile,
    required PrinterSetting settings,
  }) async {
    final pdfBytes = await InvoicePdfService.generateThermalStatementPdf(
      personName: labour.name,
      type: "Labour",
      date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      remainingBalance: labour.remainingBalance,
      profile: profile,
      paperSize: settings.paperSize,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Statement_${labour.name}',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalStatementPdf(
        personName: labour.name,
        type: "Labour",
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        remainingBalance: labour.remainingBalance,
        profile: profile,
        paperSize: size,
      ),
    );
  }

  static Future<bool> printAccountLedger(
    BuildContext context, {
    required Account account,
    required AppProfile? profile,
    required PrinterSetting settings,
    required double currentBalance,
  }) async {
    final pdfBytes = await InvoicePdfService.generateThermalStatementPdf(
      personName: account.name,
      type: "Account",
      date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      remainingBalance: currentBalance,
      profile: profile,
      paperSize: settings.paperSize,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Statement_${account.name}',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalStatementPdf(
        personName: account.name,
        type: "Account",
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        remainingBalance: currentBalance,
        profile: profile,
        paperSize: size,
      ),
    );
  }

  static Future<bool> printSaleStatement(
    BuildContext context, {
    required Sale sale,
    required Buyer buyer,
    required String trailaName,
    required AppProfile? profile,
    required PrinterSetting settings,
  }) async {
    final pdfBytes = await InvoicePdfService.generateSalePdf(
      sale: sale,
      buyer: buyer,
      trailaName: trailaName,
      profile: profile,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'SaleStatement_${sale.receiptNumber}',
      isThermal: false,
    );
  }

  static Future<bool> printFinancialSummary(
    BuildContext context, {
    required double totalRevenue,
    required double totalExpenses,
    required double netProfit,
    required String period,
    required AppProfile? profile,
    required PrinterSetting settings,
    bool printDuplicate = true,
  }) async {
    final pdfBytes = await InvoicePdfService.generateThermalSummaryPdf(
      title: 'Financial Summary',
      period: period,
      rows: {
        'TOTAL REVENUE': totalRevenue,
        'TOTAL EXPENSES': totalExpenses,
        'NET PROFIT': netProfit,
      },
      profile: profile,
      paperSize: settings.paperSize,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Financial_Summary',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalSummaryPdf(
        title: 'Financial Summary',
        period: period,
        rows: {
          'TOTAL REVENUE': totalRevenue,
          'TOTAL EXPENSES': totalExpenses,
          'NET PROFIT': netProfit,
        },
        profile: profile,
        paperSize: size,
      ),
    );
  }

  static Future<bool> printCashFlowSummary(
    BuildContext context, {
    required double totalCash,
    required List<Account> accounts,
    required AppProfile? profile,
    required PrinterSetting settings,
    bool printDuplicate = true,
  }) async {
    final rows = <String, double>{};
    for (var acc in accounts) {
      rows[acc.name] = acc.balance;
    }
    rows['TOTAL CASH'] = totalCash;

    final pdfBytes = await InvoicePdfService.generateThermalSummaryPdf(
      title: 'Cash Flow Summary',
      period: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      rows: rows,
      profile: profile,
      paperSize: settings.paperSize,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Cash_Flow',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalSummaryPdf(
        title: 'Cash Flow Summary',
        period: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        rows: rows,
        profile: profile,
        paperSize: size,
      ),
    );
  }

  static Future<bool> printTransactionReceipt(
    BuildContext context, {
    required Transaction transaction,
    required AppProfile? profile,
    required PrinterSetting settings,
    bool isDuplicate = false,
  }) async {
    final pdfBytes = await InvoicePdfService.generateThermalTransactionPdf(
      transaction: transaction,
      profile: profile,
      paperSize: settings.paperSize,
      isDuplicate: isDuplicate,
    );
    if (!context.mounted) return false;
    return await printReceiptGeneric(
      context, 
      pdfBytes, 
      'Transaction_${transaction.id}',
      initialPaperSize: settings.paperSize,
      pdfGenerator: (size) => InvoicePdfService.generateThermalTransactionPdf(
        transaction: transaction,
        profile: profile,
        paperSize: size,
        isDuplicate: isDuplicate,
      ),
    );
  }
}
