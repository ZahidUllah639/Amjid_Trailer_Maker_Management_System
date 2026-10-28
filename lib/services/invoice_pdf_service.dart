import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'unified_print_service.dart';
import '../models/app_profile.dart';
import '../models/khata.dart';
import '../models/sale.dart';
import '../models/buyer.dart';
import '../models/supplier.dart';
import '../models/labour.dart';
import '../models/account.dart';
import '../models/payment.dart';

class InvoicePdfService {

  static Future<Uint8List> generateSupplierPurchasePdf({
    required String supplierName,
    required String date,
    required List<dynamic> items,
    required double previousBalance,
    required double paymentAmount,
    required double newBalance,
    String? paymentMethod, // ✅ New optional parameter
    required AppProfile? profile,
  }) async {
    final pdf = pw.Document();
    final header = await UnifiedPrintService.buildPdfHeader(profile, "PURCHASE INVOICE");
    final footer = UnifiedPrintService.buildPdfFooter();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(21.6),
        build: (context) => [
          ...UnifiedPrintService.wrapCarbonCopy([
            header,
            pw.SizedBox(height: 10),
            _buildInfoRow("Supplier:", supplierName, "Date:", date),
            pw.SizedBox(height: 20),
            _buildPurchaseTable(items),
            pw.SizedBox(height: 10),
            _buildSummary(previousBalance, _calcTotal(items), newBalance, 
              paymentAmount: paymentAmount,
              isCredit: false, 
              paymentMethod: paymentMethod, // ✅ Pass payment method
              labelCurr: "Invoice Total"),
            pw.Spacer(),
            footer,
          ], false),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateSupplierPaymentPdf({
    required String supplierName,
    required String date,
    required String paymentMethod,
    required double paidAmount,
    required double previousBalance,
    required double newBalance,
    required AppProfile? profile,
  }) async {
    final pdf = pw.Document();
    final header = await UnifiedPrintService.buildPdfHeader(profile, "PAYMENT RECEIPT");
    final footer = UnifiedPrintService.buildPdfFooter();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(21.6),
        build: (context) => [
          ...UnifiedPrintService.wrapCarbonCopy([
            header,
            pw.SizedBox(height: 10),
            _buildInfoRow("Supplier:", supplierName, "Date:", date),
            pw.SizedBox(height: 10),
            _buildInfoRow("Method:", paymentMethod, "", ""),
            pw.SizedBox(height: 20),
            _buildPaymentTable(paidAmount),
            pw.SizedBox(height: 20),
            _buildSummary(previousBalance, paidAmount, newBalance, 
              isCredit: true,
              labelCurr: "Payment Amount",
              paymentMethod: paymentMethod),
            pw.Spacer(),
            footer,
          ], false),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateLabourWorkPdf({
    required String labourName,
    required String date,
    String? trailaId,
    required double workPrice,
    required double previousBalance,
    required double newBalance,
    required AppProfile? profile,
  }) async {
    final pdf = pw.Document();
    final header = await UnifiedPrintService.buildPdfHeader(profile, "WORK INVOICE");
    final footer = UnifiedPrintService.buildPdfFooter();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(21.6),
        build: (context) => [
          ...UnifiedPrintService.wrapCarbonCopy([
            header,
            pw.SizedBox(height: 10),
            _buildInfoRow("Labour:", labourName, "Date:", date),
            pw.SizedBox(height: 10),
            _buildInfoRow("Traila:", trailaId ?? "General", "", ""),
            pw.SizedBox(height: 20),
            _buildWorkTable(workPrice),
            pw.SizedBox(height: 20),
            _buildSummary(previousBalance, workPrice, newBalance, 
              isCredit: false,
              labelCurr: "Work Charges"),
            pw.Spacer(),
            footer,
          ], false),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateLabourPaymentPdf({
    required String labourName,
    required String date,
    required String paymentMethod,
    required double paidAmount,
    required double previousBalance,
    required double newBalance,
    required AppProfile? profile,
  }) async {
    final pdf = pw.Document();
    final header = await UnifiedPrintService.buildPdfHeader(profile, "LABOUR PAYMENT");
    final footer = UnifiedPrintService.buildPdfFooter();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(21.6),
        build: (context) => [
          ...UnifiedPrintService.wrapCarbonCopy([
            header,
            pw.SizedBox(height: 10),
            _buildInfoRow("Labour:", labourName, "Date:", date),
            pw.SizedBox(height: 10),
            _buildInfoRow("Method:", paymentMethod, "", ""),
            pw.SizedBox(height: 20),
            _buildPaymentTable(paidAmount),
            pw.SizedBox(height: 20),
            _buildSummary(previousBalance, paidAmount, newBalance, 
              isCredit: true,
              labelCurr: "Payment Amount",
              paymentMethod: paymentMethod),
            pw.Spacer(),
            footer,
          ], false),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateSalePdf({
    required Sale sale,
    required Buyer buyer,
    required String trailaName,
    required AppProfile? profile,
  }) async {
    final pdf = pw.Document();
    final header = await UnifiedPrintService.buildPdfHeader(profile, "SALE INVOICE");
    final footer = UnifiedPrintService.buildPdfFooter();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(21.6),
        build: (context) => [
          ...(() {
            final netInvoice = sale.salePrice - sale.totalPaid;
            final totalRemaining = sale.globalPreviousBalance + netInvoice;

            return UnifiedPrintService.wrapCarbonCopy([
              header,
              pw.SizedBox(height: 10),
              _buildInfoRow("Customer:", buyer.name, "Inv #:", sale.receiptNumber ?? 'N/A'),
              _buildInfoRow("Date:", DateFormat('dd-MM-yyyy').format(sale.saleDate), "Traila:", trailaName),
              pw.SizedBox(height: 20),
              _buildSaleTable(trailaName, sale.salePrice),
              pw.SizedBox(height: 10),

              if (sale.payments.isNotEmpty) ...[
                pw.Text("INSTALLMENT HISTORY", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                pw.SizedBox(height: 5),
                _buildSalePaymentTable(sale.payments),
                pw.SizedBox(height: 10),
              ],
              
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  width: double.infinity,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _buildSummaryRow("Previous Balance:", sale.globalPreviousBalance),
                      _buildSummaryRow("Invoice Total:", sale.salePrice, prefix: "+"),
                      if (sale.totalPaid > 0.01)
                        _buildSummaryRow("Received Amount:", sale.totalPaid, prefix: "-"),
                      
                      pw.SizedBox(height: 5),
                      pw.Divider(color: PdfColors.grey400, thickness: 1, indent: 200),
                      _buildSummaryRow("TOTAL BALANCE:", totalRemaining, isBold: true),
                      
                      pw.SizedBox(height: 10),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(6),
                        decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              "Calculation Breakdown:",
                              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              "${sale.globalPreviousBalance.toStringAsFixed(0)} + ${sale.salePrice.toStringAsFixed(0)} ${sale.totalPaid > 0.01 ? '- ${sale.totalPaid.toStringAsFixed(0)}' : ''} = ${totalRemaining.toStringAsFixed(0)}",
                              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Spacer(),
              footer,
            ], false);
          })(),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateStatementPdf({
    required String personName,
    required String type,
    required String date,
    required double remainingBalance,
    required AppProfile? profile,
  }) async {
    final pdf = pw.Document();
    final header = await UnifiedPrintService.buildPdfHeader(profile, "STATEMENT OF ACCOUNT");
    final footer = UnifiedPrintService.buildPdfFooter();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(21.6),
        build: (context) => [
          ...UnifiedPrintService.wrapCarbonCopy([
            header,
            pw.SizedBox(height: 10),
            _buildInfoRow("$type Name:", personName, "Date:", date),
            pw.SizedBox(height: 30),
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: double.infinity,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    _buildSummaryRow("REMAINING BALANCE:", remainingBalance, isBold: true),
                    pw.SizedBox(height: 5),
                    pw.Divider(color: PdfColors.blue900, thickness: 1.5, indent: 200),
                  ],
                ),
              ),
            ),
            pw.Spacer(),
            footer,
          ], false),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSaleTable(String name, double price) {
    final headers = ['Item Description', 'Quantity', 'Amount'];
    final data = [[name, '1', price.toStringAsFixed(0)]];

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  static Future<Uint8List> generateKhataPdf({
    required Khata khata,
    required AppProfile? profile,
  }) async {
    final pdf = pw.Document();
    final header = await UnifiedPrintService.buildPdfHeader(profile, "KHATA LEDGER");
    final footer = UnifiedPrintService.buildPdfFooter();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(21.6),
        build: (context) => [
          ...UnifiedPrintService.wrapCarbonCopy([
            header,
            pw.SizedBox(height: 10),
            _buildInfoRow("Person:", khata.personName, "Date:", DateFormat('dd-MM-yyyy').format(khata.date)),
            pw.SizedBox(height: 20),
            _buildKhataTable(khata.items),
            pw.SizedBox(height: 20),
            _buildKhataSummary(khata),
            pw.Spacer(),
            footer,
          ], false),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateFinancialReportPdf({
    required double totalRevenue,
    required double totalExpenses,
    required double netProfit,
    required List<dynamic> sales,
    required List<dynamic> expenses,
    required String filterType,
    required AppProfile? profile,
  }) async {
    final pdf = pw.Document();
    final header = await UnifiedPrintService.buildPdfHeader(profile, "FINANCIAL REPORT");
    final footer = UnifiedPrintService.buildPdfFooter();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(21.6),
        build: (context) => [
          header,
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Period: $filterType", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text("Generated on: ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}"),
            ],
          ),
          pw.SizedBox(height: 20),
          
          // Summary Section
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _buildReportSummaryItem("TOTAL REVENUE", totalRevenue, PdfColors.green),
                _buildReportSummaryItem("TOTAL EXPENSES", totalExpenses, PdfColors.red),
                _buildReportSummaryItem("NET PROFIT", netProfit, netProfit >= 0 ? PdfColors.blue : PdfColors.orange),
              ],
            ),
          ),
          pw.SizedBox(height: 30),

          pw.Text("RECENT REVENUE TRANSACTIONS", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
          pw.SizedBox(height: 10),
          _buildFinancialTable(sales, "Revenue"),
          
          pw.SizedBox(height: 30),
          pw.Text("RECENT EXPENSE TRANSACTIONS", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
          pw.SizedBox(height: 10),
          _buildFinancialTable(expenses, "Expense"),

          pw.Spacer(),
          footer,
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildReportSummaryItem(String label, double value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text("Rs. ${value.toStringAsFixed(0)}", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: color)),
      ],
    );
  }

  static pw.Widget _buildFinancialTable(List<dynamic> items, String type) {
    final headers = ['Date', 'Description', 'Amount'];
    final data = items.take(15).map((item) {
      if (type == "Revenue") {
        return [
          DateFormat('dd-MM-yyyy').format(item.saleDate),
          "Sale Invoice: ${item.receiptNumber}",
          item.salePrice.toStringAsFixed(0),
        ];
      } else {
        return [
          DateFormat('dd-MM-yyyy').format(item.expense.date),
          "${item.expense.description} (${item.trailaName})",
          item.expense.amount.toStringAsFixed(0),
        ];
      }
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  static Future<Uint8List> generateCashFlowReportPdf({
    required double totalCash,
    required List<dynamic> accounts,
    required AppProfile? profile,
  }) async {
    final pdf = pw.Document();
    final header = await UnifiedPrintService.buildPdfHeader(profile, "CASH FLOW REPORT");
    final footer = UnifiedPrintService.buildPdfFooter();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(21.6),
        build: (context) => [
          header,
          pw.SizedBox(height: 20),
          pw.Center(
            child: pw.Column(
              children: [
                pw.Text("TOTAL AVAILABLE LIQUID CASH", style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                pw.SizedBox(height: 8),
                pw.Text("Rs. ${totalCash.toStringAsFixed(0)}", style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
              ],
            ),
          ),
          pw.SizedBox(height: 40),
          pw.Text("ACCOUNT BALANCES", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ['Account Name', 'Type', 'Current Balance'],
            data: accounts.map((a) => [
              a.name,
              a.type.toUpperCase(),
              "Rs. ${a.balance.toStringAsFixed(0)}",
            ]).toList(),
            border: pw.TableBorder.all(color: PdfColors.grey300),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.Spacer(),
          footer,
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildInfoRow(String label1, String value1, String label2, String value2) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 3,
          child: pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(text: "$label1 ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.TextSpan(text: value1),
              ],
            ),
          ),
        ),
        if (label2.isNotEmpty)
          pw.Expanded(
            flex: 2,
            child: pw.RichText(
              textAlign: pw.TextAlign.right,
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(text: "$label2 ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.TextSpan(text: value2),
                ],
              ),
            ),
          ),
      ],
    );
  }

  static pw.Widget _buildPurchaseTable(List<dynamic> items) {
    final headers = ['Item Name', 'Quantity', 'Unit Price', 'Total'];
    final data = items.map((item) => [
      item.name,
      item.quantity.toString(),
      "Rs. ${_currencyFormat.format(item.unitPrice)}",
      "Rs. ${_currencyFormat.format(item.quantity * item.unitPrice)}",
    ]).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 9.5),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.centerLeft,
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(1.5),
      },
    );
  }

  static pw.Widget _buildKhataTable(List<KhataTransaction> items) {
    final headers = ['Date', 'Description', 'Type', 'Amount'];
    final data = items.map((item) => [
      DateFormat('dd-MM-yyyy').format(item.date),
      item.description ?? 'Payment',
      item.type == KhataTransactionType.cashIn ? 'IN' : 'OUT',
      "Rs. ${_currencyFormat.format(item.amount)}",
    ]).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 9.5),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  static pw.Widget _buildSalePaymentTable(List<Payment> payments) {
    final headers = ['Date', 'Method', 'Paid Amount', 'Updated Balance'];
    final List<List<dynamic>> data = payments.map((p) => [
      DateFormat('dd-MM-yyyy').format(p.date),
      p.method,
      "Rs. ${_currencyFormat.format(p.amount)}",
      "Rs. ${_currencyFormat.format(p.updatedBalance ?? 0.0)}",
    ]).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8.5),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue700),
      cellStyle: const pw.TextStyle(fontSize: 8.5),
      cellAlignment: pw.Alignment.centerLeft,
      columnWidths: {
        0: const pw.FlexColumnWidth(1.2),
        1: const pw.FlexColumnWidth(1.8),
        2: const pw.FlexColumnWidth(1.2),
        3: const pw.FlexColumnWidth(1.2),
      },
    );
  }

  static pw.Widget _buildKhataSummary(Khata khata) {
     return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: double.infinity,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            _buildSummaryRow("Total Cash Out (Debt):", khata.totalAmount, prefix: "+"),
            _buildSummaryRow("Total Cash In (Paid):", khata.paidAmount, prefix: "-"),
            pw.SizedBox(height: 5),
            pw.Divider(color: PdfColors.grey400, thickness: 1, indent: 200),
            _buildSummaryRow("REMAINING BALANCE:", khata.remainingBalance, isBold: true),
            pw.SizedBox(height: 5),
            pw.Divider(color: PdfColors.blue900, thickness: 1.5, indent: 200),
            pw.SizedBox(height: 10),
            pw.Text(
              "Calculation: ${_currencyFormat.format(khata.totalAmount)} - ${_currencyFormat.format(khata.paidAmount)} = ${_currencyFormat.format(khata.remainingBalance)}",
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildPaymentTable(double amount) {
    final headers = ['Description', 'Amount'];
    final data = [['Payment Received', "Rs. ${_currencyFormat.format(amount)}"]];

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 9.5),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  static pw.Widget _buildWorkTable(double amount) {
    final headers = ['Description', 'Amount'];
    final data = [['Work Charges', "Rs. ${_currencyFormat.format(amount)}"]];

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 9.5),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  static pw.Widget _buildSummary(
    double previousBalance, 
    double invoiceBalance, 
    double finalBalance, 
    {
      double paymentAmount = 0, 
      String? paymentMethod,
      required bool isCredit, 
      String? labelPrev, 
      String? labelCurr
    }
  ) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: double.infinity,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            _buildSummaryRow(labelPrev ?? "Previous Balance:", previousBalance),
            _buildSummaryRow("${labelCurr ?? (isCredit ? "Payment Amount" : "Invoice Balance")}:", invoiceBalance, prefix: isCredit ? "-" : "+"),
            
            if (paymentAmount > 0.01) ...[
              pw.SizedBox(height: 5),
              _buildSummaryRow("Paid by ${paymentMethod ?? 'Account'}:", paymentAmount, prefix: "-"),
            ],

            pw.SizedBox(height: 5),
            pw.Divider(color: PdfColors.grey400, thickness: 1, indent: 200),
            _buildSummaryRow("TOTAL BALANCE:", finalBalance, isBold: true),
            
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(6),
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    "Calculation Breakdown:",
                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    "${_currencyFormat.format(previousBalance)} ${isCredit ? '-' : '+'} ${_currencyFormat.format(invoiceBalance)} ${paymentAmount > 0.01 ? '- ${_currencyFormat.format(paymentAmount)}' : ''} = ${_currencyFormat.format(finalBalance)}",
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- THERMAL / POS PDF GENERATORS ---

  static final DateFormat _thermalDateFormat = DateFormat('dd-MMM-yyyy');
  static final DateFormat _thermalDateTimeFormat = DateFormat('dd-MMM-yyyy  hh:mm a');
  static final NumberFormat _currencyFormat = NumberFormat('#,##0');

  static String _formatRs(double amount) {
    if (amount < 0) {
      return "Rs. (${_currencyFormat.format(amount.abs())})";
    }
    return "Rs. ${_currencyFormat.format(amount)}";
  }

  static PdfPageFormat _getThermalFormat(String paperSize, [double estimatedHeightMm = 180.0]) {
    // 58mm = 164.4pt (standard 2-inch roll), 80mm = 226.8pt (standard 3-inch roll)
    final width = (paperSize == '80mm' ? 80.0 : 58.0) * PdfPageFormat.mm;
    // Calculate realistic physical roll height based on contents (minimum 140mm)
    final heightMm = estimatedHeightMm < 140.0 ? 140.0 : estimatedHeightMm;
    return PdfPageFormat(width, heightMm * PdfPageFormat.mm, marginAll: 0.0);
  }

  static pw.Widget _buildThermalMetaBox(List<MapEntry<String, String>> entries) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(bottom: 5),
      padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2.5),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.black, width: 0.6),
          bottom: pw.BorderSide(color: PdfColors.black, width: 0.6),
        ),
      ),
      child: pw.Column(
        children: entries.map((e) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 0.8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(e.key, style: const pw.TextStyle(fontSize: 7.8)),
              pw.SizedBox(width: 4),
              pw.Expanded(
                child: pw.Text(
                  e.value,
                  style: pw.TextStyle(fontSize: 8.2, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  static pw.Widget _buildThermalAuditBox(String formula) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(top: 3, bottom: 4),
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
      ),
      child: pw.Text(
        "Audit: $formula",
        style: pw.TextStyle(fontSize: 7.2, fontStyle: pw.FontStyle.italic),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildThermalSummaryItem(String label, double value, {bool isBold = false}) {
    String displayLabel = label;
    String displayVal;

    if (label.toUpperCase().contains('BALANCE') || label.toUpperCase().contains('TOTAL') || label.toUpperCase().contains('REMAINING') || label.toUpperCase().contains('DUE')) {
      if (value < -0.01) {
        displayLabel = "ADVANCE CREDIT:";
        displayVal = "Rs. ${_currencyFormat.format(value.abs())}";
      } else if (value.abs() < 0.01) {
        displayLabel = label;
        displayVal = "Rs. 0";
      } else {
        displayVal = "Rs. ${_currencyFormat.format(value)}";
      }
    } else {
      displayVal = "Rs. ${_currencyFormat.format(value)}";
    }

    if (isBold) {
      return pw.Container(
        width: double.infinity,
        margin: const pw.EdgeInsets.symmetric(vertical: 3.5),
        padding: const pw.EdgeInsets.symmetric(horizontal: 4.5, vertical: 3.5),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.black, width: 1.0),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(
              child: pw.Text(
                displayLabel,
                style: pw.TextStyle(fontSize: 8.2, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(width: 4),
            pw.Text(
              displayVal,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1.2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Text(displayLabel, style: const pw.TextStyle(fontSize: 8)),
          ),
          pw.SizedBox(width: 4),
          pw.Text(displayVal, style: pw.TextStyle(fontSize: 8.2, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static Future<Uint8List> generateThermalSalePdf({
    required Sale sale,
    required Buyer buyer,
    required String trailaName,
    required AppProfile? profile,
    required String paperSize,
    bool isDuplicate = false,
  }) async {
    final pdf = pw.Document();
    final docNum = sale.receiptNumber ?? "SAL-${sale.id.length > 6 ? sale.id.substring(sale.id.length - 6) : sale.id}";
    final header = await UnifiedPrintService.buildThermalPdfHeader(
      profile, 
      "Sale Invoice",
      docNumber: "#$docNum",
    );
    final footer = UnifiedPrintService.buildThermalPdfFooter(isDuplicate, barcodeValue: docNum);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: _getThermalFormat(paperSize, 180.0),
        margin: pw.EdgeInsets.zero,
        build: (context) {
          final netInvoice = sale.salePrice - sale.totalPaid;
          final totalRemaining = sale.globalPreviousBalance + netInvoice;

          return [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  header,
                  _buildThermalMetaBox([
                    MapEntry("CUSTOMER:", buyer.name),
                    MapEntry("DATE:", _thermalDateTimeFormat.format(sale.saleDate)),
                    MapEntry("TRAILA UNIT:", trailaName),
                  ]),
                  
                  // Item Table
                  pw.Table(
                    border: const pw.TableBorder(
                      top: pw.BorderSide(color: PdfColors.black, width: 0.8),
                      bottom: pw.BorderSide(color: PdfColors.black, width: 0.8),
                    ),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(3),
                      1: const pw.FlexColumnWidth(1.2),
                    },
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            child: pw.Text("DESCRIPTION", style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            child: pw.Text("AMOUNT", style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(trailaName, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                                pw.Text("Trailer Manufacturing Unit", style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700)),
                              ],
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                            child: pw.Text(_formatRs(sale.salePrice), 
                                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 4),

                  _buildThermalSummaryItem("Previous Balance:", sale.globalPreviousBalance),
                  _buildThermalSummaryItem("(+) Invoice Total:", sale.salePrice),
                  if (sale.totalPaid > 0.01)
                    _buildThermalSummaryItem("(-) Total Paid:", sale.totalPaid),
                  
                  _buildThermalSummaryItem("TOTAL OUTSTANDING:", totalRemaining, isBold: true),
                  
                  _buildThermalAuditBox(
                    "${_currencyFormat.format(sale.globalPreviousBalance)} + ${_currencyFormat.format(sale.salePrice)} ${sale.totalPaid > 0.01 ? '- ${_currencyFormat.format(sale.totalPaid)}' : ''} = ${_currencyFormat.format(totalRemaining)}"
                  ),

                  if (sale.payments.isNotEmpty) ...[
                    pw.SizedBox(height: 6),
                    pw.Text("PAYMENT AUDIT LOG", style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                    pw.Divider(color: PdfColors.black, thickness: 0.5),
                    pw.Table(
                      columnWidths: {
                        0: const pw.FlexColumnWidth(2),
                        1: const pw.FlexColumnWidth(2.5),
                        2: const pw.FlexColumnWidth(2),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Text("Date", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                            pw.Text("Method", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                            pw.Text("Amount", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                          ],
                        ),
                        ...sale.payments.map((p) => pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(vertical: 1),
                              child: pw.Text(DateFormat('dd-MMM').format(p.date), style: const pw.TextStyle(fontSize: 7.8)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(vertical: 1),
                              child: pw.Text(p.method, style: const pw.TextStyle(fontSize: 7.8)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(vertical: 1),
                              child: pw.Text(_formatRs(p.amount), style: const pw.TextStyle(fontSize: 7.8), textAlign: pw.TextAlign.right),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ],
                  
                  footer,
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateThermalPurchasePdf({
    required Supplier supplier,
    required SupplierPurchase purchase,
    required AppProfile? profile,
    required String paperSize,
    bool isDuplicate = false,
  }) async {
    final pdf = pw.Document();
    final docNum = "PUR-${purchase.id.length > 6 ? purchase.id.substring(purchase.id.length - 6) : purchase.id}";
    final header = await UnifiedPrintService.buildThermalPdfHeader(
      profile, 
      "Purchase Invoice",
      docNumber: "#$docNum",
    );
    final footer = UnifiedPrintService.buildThermalPdfFooter(isDuplicate, barcodeValue: docNum);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: _getThermalFormat(paperSize, 145.0 + (purchase.items.length * 10.0)),
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  header,
                  _buildThermalMetaBox([
                    MapEntry("SUPPLIER:", supplier.name),
                    MapEntry("DATE:", _thermalDateFormat.format(purchase.date)),
                    MapEntry("METHOD:", purchase.paymentMethod ?? 'Cash Settlement'),
                  ]),
                  
                  pw.Table(
                    border: const pw.TableBorder(
                      top: pw.BorderSide(color: PdfColors.black, width: 0.8),
                      bottom: pw.BorderSide(color: PdfColors.black, width: 0.8),
                    ),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(3),
                      1: const pw.FlexColumnWidth(1.2),
                    },
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            child: pw.Text("ITEM / DESCRIPTION", style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            child: pw.Text("TOTAL", style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                          ),
                        ],
                      ),
                      ...purchase.items.map((it) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2.5, horizontal: 2),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(it.name, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                                pw.Text("${it.quantity} x Rs. ${_currencyFormat.format(it.unitPrice)}", 
                                    style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700)),
                              ],
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2.5, horizontal: 2),
                            child: pw.Text(_formatRs(it.total), 
                                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                          ),
                        ],
                      )),
                    ],
                  ),
                  pw.SizedBox(height: 4),

                  _buildThermalSummaryItem("Previous Balance:", purchase.previousOutstanding),
                  _buildThermalSummaryItem("(+) Invoice Total:", purchase.totalAmount),
                  if (purchase.paymentAmount > 0.01)
                    _buildThermalSummaryItem("(-) Paid (${purchase.paymentMethod ?? 'Cash'}):", purchase.paymentAmount),
                  
                  _buildThermalSummaryItem("TOTAL BALANCE:", purchase.updatedBalance, isBold: true),
                  
                  _buildThermalAuditBox(
                    "${_currencyFormat.format(purchase.previousOutstanding)} + ${_currencyFormat.format(purchase.totalAmount)} ${purchase.paymentAmount > 0.01 ? '- ${_currencyFormat.format(purchase.paymentAmount)}' : ''} = ${_currencyFormat.format(purchase.updatedBalance)}"
                  ),

                  footer,
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateThermalPaymentPdf({
    required String personName,
    required String type, // 'Supplier' or 'Labour'
    required double amount,
    required String method,
    required double prevBalance,
    required double newBalance,
    required DateTime date,
    required AppProfile? profile,
    required String paperSize,
    bool isDuplicate = false,
  }) async {
    final pdf = pw.Document();
    final docNum = "PAY-${DateFormat('yyMMddHHmm').format(date)}";
    final header = await UnifiedPrintService.buildThermalPdfHeader(
      profile, 
      "$type Payment Voucher",
      docNumber: "#$docNum",
    );
    final footer = UnifiedPrintService.buildThermalPdfFooter(isDuplicate, barcodeValue: docNum);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: _getThermalFormat(paperSize, 150.0),
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  header,
                  _buildThermalMetaBox([
                    MapEntry("$type:", personName),
                    MapEntry("DATE:", _thermalDateFormat.format(date)),
                    MapEntry("METHOD:", method),
                  ]),

                  // Prominent Amount Box
                  pw.Container(
                    width: double.infinity,
                    margin: const pw.EdgeInsets.symmetric(vertical: 2.5),
                    padding: const pw.EdgeInsets.symmetric(vertical: 3.5, horizontal: 5),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Expanded(
                          child: pw.Text("AMOUNT PAID:", style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.SizedBox(width: 4),
                        pw.Text(_formatRs(amount), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),

                  _buildThermalSummaryItem("Previous Balance:", prevBalance),
                  _buildThermalSummaryItem("(-) Paid Amount:", amount),
                  _buildThermalSummaryItem("UPDATED BALANCE:", newBalance, isBold: true),
                  
                  _buildThermalAuditBox(
                    "${_currencyFormat.format(prevBalance)} - ${_currencyFormat.format(amount)} = ${_currencyFormat.format(newBalance)}"
                  ),

                  footer,
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateThermalSalePaymentPdf({
    required Sale sale,
    required Buyer buyer,
    required Payment payment,
    required String trailaName,
    required AppProfile? profile,
    required String paperSize,
    bool isDuplicate = false,
  }) async {
    final pdf = pw.Document();
    final docNum = payment.receiptNumber ?? "REC-${payment.id.length > 6 ? payment.id.substring(payment.id.length - 6) : payment.id}";
    final header = await UnifiedPrintService.buildThermalPdfHeader(
      profile, 
      "Installment Receipt",
      docNumber: "#$docNum",
    );
    final footer = UnifiedPrintService.buildThermalPdfFooter(isDuplicate, barcodeValue: docNum);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: _getThermalFormat(paperSize, 170.0),
        margin: pw.EdgeInsets.zero,
        build: (context) {
          final prevBal = payment.previousBalance ?? (sale.remainingBalance + payment.amount);
          final newBal = payment.updatedBalance ?? (prevBal - payment.amount);
          final totalPaidSoFar = (sale.salePrice + sale.globalPreviousBalance) - newBal;

          return [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  header,
                  _buildThermalMetaBox([
                    MapEntry("CUSTOMER:", buyer.name),
                    MapEntry("TRAILA:", trailaName),
                    MapEntry("DATE:", _thermalDateTimeFormat.format(payment.date)),
                    MapEntry("PAY METHOD:", payment.method),
                  ]),

                  // Prominent Received Amount Box
                  pw.Container(
                    width: double.infinity,
                    margin: const pw.EdgeInsets.symmetric(vertical: 2.5),
                    padding: const pw.EdgeInsets.symmetric(vertical: 3.5, horizontal: 5),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Expanded(
                          child: pw.Text("AMOUNT RECEIVED:", style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.SizedBox(width: 4),
                        pw.Text(_formatRs(payment.amount), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                  
                  _buildThermalSummaryItem("Initial Account Bal:", sale.globalPreviousBalance),
                  _buildThermalSummaryItem("(+) Traila Price:", sale.salePrice),
                  _buildThermalSummaryItem("(-) Total Paid So Far:", totalPaidSoFar),
                  _buildThermalSummaryItem("CURRENT BALANCE:", newBal, isBold: true),
                  
                  _buildThermalAuditBox(
                    "${_currencyFormat.format(sale.globalPreviousBalance)} + ${_currencyFormat.format(sale.salePrice)} - ${_currencyFormat.format(totalPaidSoFar)} = ${_currencyFormat.format(newBal)}"
                  ),

                  if (sale.payments.isNotEmpty) ...[
                    pw.SizedBox(height: 6),
                    pw.Text("RECENT INSTALLMENTS", style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                    pw.Divider(color: PdfColors.black, thickness: 0.5),
                    pw.Table(
                      columnWidths: {
                        0: const pw.FlexColumnWidth(2),
                        1: const pw.FlexColumnWidth(2.5),
                        2: const pw.FlexColumnWidth(2),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Text("Date", style: pw.TextStyle(fontSize: 7.8, fontWeight: pw.FontWeight.bold)),
                            pw.Text("Method", style: pw.TextStyle(fontSize: 7.8, fontWeight: pw.FontWeight.bold)),
                            pw.Text("Amount", style: pw.TextStyle(fontSize: 7.8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                          ],
                        ),
                        ...sale.payments.map((p) => pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(vertical: 1),
                              child: pw.Text(DateFormat('dd-MMM').format(p.date), style: const pw.TextStyle(fontSize: 7.5)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(vertical: 1),
                              child: pw.Text(p.method, style: const pw.TextStyle(fontSize: 7.5)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(vertical: 1),
                              child: pw.Text(_formatRs(p.amount), style: const pw.TextStyle(fontSize: 7.5), textAlign: pw.TextAlign.right),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ],
                  
                  footer,
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateThermalWorkPdf({
    required Labour labour,
    required WorkEntry work,
    required AppProfile? profile,
    required String paperSize,
    bool isDuplicate = false,
  }) async {
    final pdf = pw.Document();
    final docNum = "WRK-${work.id.length > 6 ? work.id.substring(work.id.length - 6) : work.id}";
    final header = await UnifiedPrintService.buildThermalPdfHeader(
      profile, 
      "Labour Work Ticket",
      docNumber: "#$docNum",
    );
    final footer = UnifiedPrintService.buildThermalPdfFooter(isDuplicate, barcodeValue: docNum);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: _getThermalFormat(paperSize, 150.0),
        margin: pw.EdgeInsets.zero,
        build: (context) {
          final total = work.previousOutstanding + work.cost;
          return [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  header,
                  _buildThermalMetaBox([
                    MapEntry("LABOUR:", labour.name),
                    MapEntry("DATE:", _thermalDateFormat.format(work.date)),
                    MapEntry("TRAILA:", work.trailaId ?? 'N/A'),
                  ]),

                  // Work Charge Box
                  pw.Container(
                    width: double.infinity,
                    margin: const pw.EdgeInsets.symmetric(vertical: 2.5),
                    padding: const pw.EdgeInsets.symmetric(vertical: 3.5, horizontal: 5),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Expanded(
                          child: pw.Text("WORK CHARGES:", style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.SizedBox(width: 4),
                        pw.Text(_formatRs(work.cost), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),

                  _buildThermalSummaryItem("Previous Balance:", work.previousOutstanding),
                  _buildThermalSummaryItem("(+) Work Added:", work.cost),
                  _buildThermalSummaryItem("TOTAL LABOUR DUE:", total, isBold: true),
                  
                  _buildThermalAuditBox(
                    "${_currencyFormat.format(work.previousOutstanding)} + ${_currencyFormat.format(work.cost)} = ${_currencyFormat.format(total)}"
                  ),

                  footer,
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateThermalKhataPdf({
    required Khata khata,
    required AppProfile? profile,
    required String paperSize,
    bool isDuplicate = false,
  }) async {
    final pdf = pw.Document();
    final docNum = "KHT-${khata.id.length > 6 ? khata.id.substring(khata.id.length - 6) : khata.id}";
    final header = await UnifiedPrintService.buildThermalPdfHeader(
      profile, 
      "Khata Ledger Receipt",
      docNumber: "#$docNum",
    );
    final footer = UnifiedPrintService.buildThermalPdfFooter(isDuplicate, barcodeValue: docNum);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: _getThermalFormat(paperSize, 145.0 + (khata.items.length * 10.0)),
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  header,
                  _buildThermalMetaBox([
                    MapEntry("ACCOUNT / PERSON:", khata.personName),
                    MapEntry("DATE:", _thermalDateFormat.format(khata.date)),
                    MapEntry("ENTRIES:", "${khata.items.length} Transactions"),
                  ]),
                  
                  pw.Table(
                    border: const pw.TableBorder(
                      top: pw.BorderSide(color: PdfColors.black, width: 0.8),
                      bottom: pw.BorderSide(color: PdfColors.black, width: 0.8),
                    ),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(2.5),
                      1: const pw.FlexColumnWidth(1),
                      2: const pw.FlexColumnWidth(1.5),
                    },
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            child: pw.Text("DESCRIPTION", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            child: pw.Text("FLOW", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            child: pw.Text("AMOUNT", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                          ),
                        ],
                      ),
                      ...khata.items.map((it) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            child: pw.Text(it.description ?? 'Transaction', style: const pw.TextStyle(fontSize: 8)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            child: pw.Text(
                              it.type == KhataTransactionType.cashIn ? '[IN]' : '[OUT]', 
                              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), 
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            child: pw.Text(_formatRs(it.amount), 
                                style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                          ),
                        ],
                      )),
                    ],
                  ),
                  pw.SizedBox(height: 4),

                  _buildThermalSummaryItem("Total Debit (OUT):", khata.totalAmount),
                  _buildThermalSummaryItem("Total Credit (IN):", khata.paidAmount),
                  _buildThermalSummaryItem("OUTSTANDING BALANCE:", khata.remainingBalance, isBold: true),
                  footer,
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSummaryRow(String label, double value, {bool isBold = false, String prefix = ""}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 9.5, fontWeight: isBold ? pw.FontWeight.bold : null)),
          pw.Text("$prefix ${_formatRs(value)}", 
              style: pw.TextStyle(fontSize: 9.5, fontWeight: isBold ? pw.FontWeight.bold : null, color: PdfColors.black)),
        ],
      ),
    );
  }

  static Future<Uint8List> generateThermalSummaryPdf({
    required String title,
    required String period,
    required Map<String, double> rows,
    required AppProfile? profile,
    required String paperSize,
  }) async {
    final pdf = pw.Document();
    final header = await UnifiedPrintService.buildThermalPdfHeader(profile, title);
    final footer = UnifiedPrintService.buildThermalPdfFooter(false);
    final format = _getThermalFormat(paperSize, 140.0 + (rows.length * 8.0));

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        margin: pw.EdgeInsets.zero,
        build: (context) => pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
          child: pw.Column(
            children: [
              header,
              _buildThermalMetaBox([
                MapEntry("AUDIT PERIOD:", period),
                MapEntry("GENERATED:", _thermalDateTimeFormat.format(DateTime.now())),
              ]),
              pw.SizedBox(height: 4),
              ...rows.entries.map((e) => _buildThermalSummaryItem(
                e.key, 
                e.value, 
                isBold: e.key.toUpperCase().contains('TOTAL') || e.key.toUpperCase().contains('NET'),
              )),
              footer,
            ],
          ),
        ),
      ),
    );
    return pdf.save();
  }

  static Future<Uint8List> generateThermalStatementPdf({
    required String personName,
    required String type,
    required String date,
    required double remainingBalance,
    required AppProfile? profile,
    required String paperSize,
    bool isDuplicate = false,
  }) async {
    final pdf = pw.Document();
    final header = await UnifiedPrintService.buildThermalPdfHeader(profile, "Account Statement");
    final footer = UnifiedPrintService.buildThermalPdfFooter(isDuplicate);
    final format = _getThermalFormat(paperSize, 150.0);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        margin: pw.EdgeInsets.zero,
        build: (context) => pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              header,
              _buildThermalMetaBox([
                MapEntry("$type:", personName),
                MapEntry("STATEMENT DATE:", date),
              ]),
              pw.SizedBox(height: 6),
              _buildThermalSummaryItem("NET REMAINING BALANCE:", remainingBalance, isBold: true),
              pw.SizedBox(height: 8),
              footer,
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateThermalTransactionPdf({
    required Transaction transaction,
    required AppProfile? profile,
    required String paperSize,
    bool isDuplicate = false,
  }) async {
    final pdf = pw.Document();
    final header = await UnifiedPrintService.buildThermalPdfHeader(profile, "Cash Transaction");
    final footer = UnifiedPrintService.buildThermalPdfFooter(isDuplicate);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: _getThermalFormat(paperSize, 150.0),
        margin: pw.EdgeInsets.zero,
        build: (context) {
          final isCredit = transaction.type == TransactionType.add;
          return [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  header,
                  _buildThermalMetaBox([
                    MapEntry("VAULT / ACCOUNT:", transaction.accountName),
                    MapEntry("FLOW TYPE:", isCredit ? 'CASH IN (ADD)' : 'CASH OUT (WITHDRAW)'),
                    MapEntry("BENEFICIARY / PERSON:", transaction.person),
                    MapEntry("TIMESTAMP:", _thermalDateTimeFormat.format(transaction.date)),
                  ]),

                  // Amount Box
                  pw.Container(
                    width: double.infinity,
                    margin: const pw.EdgeInsets.symmetric(vertical: 2.5),
                    padding: const pw.EdgeInsets.symmetric(vertical: 3.5, horizontal: 5),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Expanded(
                          child: pw.Text("TRANSACTION AMOUNT:", style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.SizedBox(width: 4),
                        pw.Text(_formatRs(transaction.amount), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),

                  if (transaction.description.isNotEmpty) ...[
                    pw.SizedBox(height: 2),
                    pw.Text("Memo / Note:", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    pw.Text(transaction.description, style: const pw.TextStyle(fontSize: 8)),
                  ],
                  
                  footer,
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static double _calcTotal(List<dynamic> items) {
    return items.fold(0, (sum, item) => sum + (item.quantity * item.unitPrice));
  }
}
