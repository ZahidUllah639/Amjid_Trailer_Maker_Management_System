import 'payment.dart';

enum SaleStatus {
  paid,
  partial,
  pending;

  String toJson() => name;
  static SaleStatus fromJson(String json) => SaleStatus.values.byName(json);
}

class Sale {
  final String id;
  final String trailaId;
  final String buyerId;
  final double salePrice;
  final double manufacturingCost; // Internal only
  final double profit; // Internal only
  final DateTime saleDate;
  final double totalPaid;
  final double remainingBalance;
  final SaleStatus status;
  final String? receiptNumber; // SR-xxxxx
  final List<Payment> payments;
  final double globalPreviousBalance; // ✅ Added to track buyer's total debt

  Sale({
    required this.id,
    required this.trailaId,
    required this.buyerId,
    required this.salePrice,
    this.manufacturingCost = 0.0,
    this.profit = 0.0,
    required this.saleDate,
    this.totalPaid = 0.0,
    this.remainingBalance = 0.0,
    this.status = SaleStatus.pending,
    this.receiptNumber,
    this.payments = const [],
    this.globalPreviousBalance = 0.0,
  });

  Sale copyWith({
    String? id,
    String? trailaId,
    String? buyerId,
    double? salePrice,
    double? manufacturingCost,
    double? profit,
    DateTime? saleDate,
    double? totalPaid,
    double? remainingBalance,
    SaleStatus? status,
    String? receiptNumber,
    List<Payment>? payments,
  }) {
    return Sale(
      id: id ?? this.id,
      trailaId: trailaId ?? this.trailaId,
      buyerId: buyerId ?? this.buyerId,
      salePrice: salePrice ?? this.salePrice,
      manufacturingCost: manufacturingCost ?? this.manufacturingCost,
      profit: profit ?? this.profit,
      saleDate: saleDate ?? this.saleDate,
      totalPaid: totalPaid ?? this.totalPaid,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      status: status ?? this.status,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      payments: payments ?? this.payments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trailaId': trailaId,
      'buyerId': buyerId,
      'salePrice': salePrice,
      'manufacturingCost': manufacturingCost,
      'profit': profit,
      'saleDate': saleDate.toIso8601String(),
      'totalPaid': totalPaid,
      'remainingBalance': remainingBalance,
      'status': status.toJson(),
      'receiptNumber': receiptNumber,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map, {List<Payment> payments = const []}) {
    return Sale(
      id: map['id'],
      trailaId: map['trailaId'],
      buyerId: map['buyerId'],
      salePrice: (map['salePrice'] as num).toDouble(),
      manufacturingCost: (map['manufacturingCost'] as num).toDouble(),
      profit: (map['profit'] as num).toDouble(),
      saleDate: DateTime.parse(map['saleDate']),
      totalPaid: (map['totalPaid'] as num).toDouble(),
      remainingBalance: (map['remainingBalance'] as num).toDouble(),
      status: SaleStatus.fromJson(map['status']),
      receiptNumber: map['receiptNumber'],
      payments: payments,
    );
  }
}
