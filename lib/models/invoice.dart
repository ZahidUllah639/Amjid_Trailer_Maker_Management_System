import 'supplier.dart';

enum InvoiceType { 
  purchase, 
  payment, 
  labourWork, 
  labourPayment, 
  sale, 
  salePayment 
}

class Invoice {
  final String id;
  final String invoiceNumber;
  final DateTime date;
  final InvoiceType type;
  final String ownerId; // Supplier or Labour manual ID
  final String ownerName; // Supplier or Labour Name
  final String ownerType; // 'supplier', 'labour', 'sale'
  final String? trailaId;
  final List<PurchaseItem>? items;
  final double amount;
  final double previousBalance;
  final double remainingBalance;
  final String paymentMethod;
  final String ownerNameDisplay; // App Owner Name

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    required this.type,
    required this.ownerId,
    required this.ownerName,
    required this.ownerType,
    this.trailaId,
    this.items,
    required this.amount,
    required this.previousBalance,
    required this.remainingBalance,
    required this.paymentMethod,
    required this.ownerNameDisplay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'date': date.toIso8601String(),
      'type': type.name,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerType': ownerType,
      'trailaId': trailaId,
      'amount': amount,
      'previousBalance': previousBalance,
      'remainingBalance': remainingBalance,
      'paymentMethod': paymentMethod,
      'ownerNameDisplay': ownerNameDisplay,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map, {List<PurchaseItem>? items}) {
    return Invoice(
      id: map['id'],
      invoiceNumber: map['invoiceNumber'],
      date: DateTime.parse(map['date']),
      type: InvoiceType.values.firstWhere((e) => e.name == map['type']),
      ownerId: map['ownerId'],
      ownerName: map['ownerName'],
      ownerType: map['ownerType'] ?? 'supplier',
      trailaId: map['trailaId'],
      items: items,
      amount: (map['amount'] as num).toDouble(),
      previousBalance: (map['previousBalance'] as num).toDouble(),
      remainingBalance: (map['remainingBalance'] as num).toDouble(),
      paymentMethod: map['paymentMethod'],
      ownerNameDisplay: map['ownerNameDisplay'],
    );
  }
}
