class Payment {
  final String id;
  final String? receiptNumber; // Professional sequence No
  final double amount;
  final DateTime date;
  final String method;
  final double? previousBalance;
  final double? updatedBalance;
  final List<SplitDetail>? splitDetails;

  Payment({
    required this.id,
    this.receiptNumber,
    required this.amount,
    required this.date,
    required this.method,
    this.previousBalance,
    this.updatedBalance,
    this.splitDetails,
  });

  Payment copyWith({
    String? id,
    String? receiptNumber,
    double? amount,
    DateTime? date,
    String? method,
    double? previousBalance,
    double? updatedBalance,
    List<SplitDetail>? splitDetails,
  }) {
    return Payment(
      id: id ?? this.id,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      method: method ?? this.method,
      previousBalance: previousBalance ?? this.previousBalance,
      updatedBalance: updatedBalance ?? this.updatedBalance,
      splitDetails: splitDetails ?? this.splitDetails,
    );
  }

  Map<String, dynamic> toMap(String ownerId, String ownerType) {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerType': ownerType,
      'receiptNumber': receiptNumber,
      'amount': amount,
      'date': date.toIso8601String(),
      'method': method,
      'previousBalance': previousBalance,
      'updatedBalance': updatedBalance,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map, {List<SplitDetail>? splitDetails}) {
    return Payment(
      id: map['id'],
      receiptNumber: map['receiptNumber'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      method: map['method'],
      previousBalance: (map['previousBalance'] as num?)?.toDouble(),
      updatedBalance: (map['updatedBalance'] as num?)?.toDouble(),
      splitDetails: splitDetails,
    );
  }
}

class SplitDetail {
  final String method;
  final double amount;

  SplitDetail({
    required this.method,
    required this.amount,
  });

  Map<String, dynamic> toMap(String paymentId) {
    return {
      'paymentId': paymentId,
      'method': method,
      'amount': amount,
    };
  }

  factory SplitDetail.fromMap(Map<String, dynamic> map) {
    return SplitDetail(
      method: map['method'],
      amount: (map['amount'] as num).toDouble(),
    );
  }
}
