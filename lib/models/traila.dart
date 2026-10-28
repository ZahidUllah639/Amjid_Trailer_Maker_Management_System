enum TrailaStatus {
  pending,
  ready,
  sold;

  String toJson() => name;
  static TrailaStatus fromJson(String json) => TrailaStatus.values.byName(json);
}

class Traila {
  final String id;
  final String name;
  final DateTime registrationDate;
  final TrailaStatus status;
  final List<TrailaExpense> expenses;
  final double totalManufacturingCost;
  final SaleInfo? saleInfo;

  Traila({
    required this.id,
    required this.name,
    required this.registrationDate,
    required this.status,
    this.expenses = const [],
    this.totalManufacturingCost = 0.0,
    this.saleInfo,
  });

  Traila copyWith({
    String? id,
    String? name,
    DateTime? registrationDate,
    TrailaStatus? status,
    List<TrailaExpense>? expenses,
    double? totalManufacturingCost,
    SaleInfo? saleInfo,
  }) {
    return Traila(
      id: id ?? this.id,
      name: name ?? this.name,
      registrationDate: registrationDate ?? this.registrationDate,
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      totalManufacturingCost: totalManufacturingCost ?? this.totalManufacturingCost,
      saleInfo: saleInfo ?? this.saleInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'registrationDate': registrationDate.toIso8601String(),
      'status': status.toJson(),
      'totalManufacturingCost': totalManufacturingCost,
      'buyerName': saleInfo?.buyerName,
      'buyerPhone': saleInfo?.buyerPhone,
      'salePrice': saleInfo?.salePrice,
      'saleDate': saleInfo?.saleDate.toIso8601String(),
      'profit': saleInfo?.profit,
      'paymentMethod': saleInfo?.paymentMethod,
    };
  }

  factory Traila.fromMap(Map<String, dynamic> map, {List<TrailaExpense> expenses = const []}) {
    SaleInfo? saleInfo;
    if (map['salePrice'] != null) {
      saleInfo = SaleInfo(
        buyerName: map['buyerName'] ?? '',
        buyerPhone: map['buyerPhone'] ?? '',
        salePrice: (map['salePrice'] as num).toDouble(),
        saleDate: DateTime.parse(map['saleDate']),
        profit: (map['profit'] as num).toDouble(),
        paymentMethod: map['paymentMethod'] ?? '',
      );
    }

    return Traila(
      id: map['id'],
      name: map['name'],
      registrationDate: DateTime.parse(map['registrationDate']),
      status: TrailaStatus.fromJson(map['status']),
      expenses: expenses,
      totalManufacturingCost: (map['totalManufacturingCost'] as num).toDouble(),
      saleInfo: saleInfo,
    );
  }
}

class TrailaExpense {
  final String id;
  final String type; // 'supplier', 'labour', 'additional'
  final String description;
  final double amount;
  final DateTime date;
  final String? supplierId;
  final String? labourId;

  TrailaExpense({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
    this.supplierId,
    this.labourId,
  });

  Map<String, dynamic> toMap(String trailaId) {
    return {
      'id': id,
      'trailaId': trailaId,
      'type': type,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'supplierId': supplierId,
      'labourId': labourId,
    };
  }

  factory TrailaExpense.fromMap(Map<String, dynamic> map) {
    return TrailaExpense(
      id: map['id'],
      type: map['type'],
      description: map['description'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      supplierId: map['supplierId'],
      labourId: map['labourId'],
    );
  }
}

class SaleInfo {
  final String buyerName;
  final String buyerPhone;
  final double salePrice;
  final DateTime saleDate;
  final double profit;
  final String paymentMethod;

  SaleInfo({
    required this.buyerName,
    required this.buyerPhone,
    required this.salePrice,
    required this.saleDate,
    required this.profit,
    required this.paymentMethod,
  });
}
