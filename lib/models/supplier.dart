import 'payment.dart';

class Supplier {
  final String id; // This is the MANUAL ID
  final String name;
  final String phone;
  final String shopName;
  final String location;
  final DateTime registrationDate;
  final double openingBalance;
  final String whatsappNumber;
  final String address;
  final List<SupplierPurchase> purchases;
  final List<Payment> payments;
  final double totalAmount;
  final double totalPaid;
  final double remainingBalance;
  final double advanceBalance;

  Supplier({
    required this.id,
    required this.name,
    required this.phone,
    required this.shopName,
    required this.location,
    required this.registrationDate,
    this.address = '',
    this.openingBalance = 0.0,
    this.whatsappNumber = '',
    this.purchases = const [],
    this.payments = const [],
    this.totalAmount = 0.0,
    this.totalPaid = 0.0,
    this.remainingBalance = 0.0,
    this.advanceBalance = 0.0,
  });

  String get manualId => id; // For backward compatibility/consistency with prompt

  Supplier copyWith({
    String? id,
    String? name,
    String? phone,
    String? shopName,
    String? location,
    DateTime? registrationDate,
    double? openingBalance,
    String? whatsappNumber,
    String? address,
    List<SupplierPurchase>? purchases,
    List<Payment>? payments,
    double? totalAmount,
    double? totalPaid,
    double? remainingBalance,
    double? advanceBalance,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      shopName: shopName ?? this.shopName,
      location: location ?? this.location,
      registrationDate: registrationDate ?? this.registrationDate,
      address: address ?? this.address,
      openingBalance: openingBalance ?? this.openingBalance,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      purchases: purchases ?? this.purchases,
      payments: payments ?? this.payments,
      totalAmount: totalAmount ?? this.totalAmount,
      totalPaid: totalPaid ?? this.totalPaid,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      advanceBalance: advanceBalance ?? this.advanceBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'shopName': shopName,
      'location': location,
      'registrationDate': registrationDate.toIso8601String(),
      'openingBalance': openingBalance,
      'whatsappNumber': whatsappNumber,
      'address': address,
      'totalAmount': totalAmount,
      'totalPaid': totalPaid,
      'remainingBalance': remainingBalance,
      'advanceBalance': advanceBalance,
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map, {List<SupplierPurchase> purchases = const [], List<Payment> payments = const []}) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      shopName: map['shopName'],
      location: map['location'],
      registrationDate: DateTime.parse(map['registrationDate']),
      openingBalance: (map['openingBalance'] as num?)?.toDouble() ?? 0.0,
      whatsappNumber: (map['whatsappNumber'] as String?) ?? '',
      address: (map['address'] as String?) ?? '',
      purchases: purchases,
      payments: payments,
      totalAmount: (map['totalAmount'] as num).toDouble(),
      totalPaid: (map['totalPaid'] as num).toDouble(),
      remainingBalance: (map['remainingBalance'] as num).toDouble(),
      advanceBalance: (map['advanceBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SupplierPurchase {
  final String id;
  final String billNumber;
  final String? trailaId;
  final List<PurchaseItem> items;
  final double totalAmount;
  final double previousOutstanding;
  final double paymentAmount;
  final double updatedBalance; // Balance AFTER this purchase + payment
  final DateTime date;
  final String? paymentMethod; // ✅ Store method used for upfront payment
  final String description; // ✅ Added to support 'Opening Balance' label

  SupplierPurchase({
    required this.id,
    required this.billNumber,
    this.trailaId,
    required this.items,
    required this.totalAmount,
    required this.previousOutstanding,
    this.paymentAmount = 0.0,
    this.updatedBalance = 0.0,
    required this.date,
    this.paymentMethod,
    this.description = 'Purchase',
  });

  SupplierPurchase copyWith({
    String? id,
    String? billNumber,
    String? trailaId,
    List<PurchaseItem>? items,
    double? totalAmount,
    double? previousOutstanding,
    double? paymentAmount,
    double? updatedBalance,
    DateTime? date,
    String? paymentMethod,
    String? description,
  }) {
    return SupplierPurchase(
      id: id ?? this.id,
      billNumber: billNumber ?? this.billNumber,
      trailaId: trailaId ?? this.trailaId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      previousOutstanding: previousOutstanding ?? this.previousOutstanding,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      updatedBalance: updatedBalance ?? this.updatedBalance,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap(String supplierId) {
    return {
      'id': id,
      'supplierId': supplierId,
      'billNumber': billNumber,
      'trailaId': trailaId,
      'totalAmount': totalAmount,
      'previousOutstanding': previousOutstanding,
      'paymentAmount': paymentAmount,
      'updatedBalance': updatedBalance,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
      'description': description,
    };
  }

  factory SupplierPurchase.fromMap(Map<String, dynamic> map, List<PurchaseItem> items) {
    return SupplierPurchase(
      id: map['id'],
      billNumber: map['billNumber'] ?? 'N/A',
      trailaId: map['trailaId'],
      items: items,
      totalAmount: (map['totalAmount'] as num).toDouble(),
      previousOutstanding: (map['previousOutstanding'] as num?)?.toDouble() ?? 0.0,
      paymentAmount: (map['paymentAmount'] as num?)?.toDouble() ?? 0.0,
      updatedBalance: (map['updatedBalance'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.parse(map['date']),
      paymentMethod: map['paymentMethod'] as String?,
      description: map['description'] as String? ?? 'Purchase',
    );
  }
}

class PurchaseItem {
  final String id;
  final String name;
  final int quantity;
  final double unitPrice;
  final double total;

  PurchaseItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  Map<String, dynamic> toMap(String purchaseId) {
    return {
      'id': id,
      'purchaseId': purchaseId,
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'total': total,
    };
  }

  factory PurchaseItem.fromMap(Map<String, dynamic> map) {
    return PurchaseItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      unitPrice: (map['unitPrice'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
    );
  }
}
