import 'payment.dart';

class Labour {
  final String id; // Manual ID
  final String name;
  final String phone;
  final String whatsappNumber;
  final String address;
  final DateTime registrationDate;
  final List<WorkEntry> workEntries;
  final List<Payment> payments;
  final double openingBalance;
  final double totalPayable;
  final double totalPaid;
  final double remainingBalance;

  Labour({
    required this.id,
    required this.name,
    required this.phone,
    this.whatsappNumber = '',
    required this.address,
    required this.registrationDate,
    this.workEntries = const [],
    this.payments = const [],
    this.openingBalance = 0.0,
    this.totalPayable = 0.0,
    this.totalPaid = 0.0,
    this.remainingBalance = 0.0,
  });

  Labour copyWith({
    String? id,
    String? name,
    String? phone,
    String? whatsappNumber,
    String? address,
    DateTime? registrationDate,
    List<WorkEntry>? workEntries,
    List<Payment>? payments,
    double? totalPayable,
    double? totalPaid,
    double? remainingBalance,
    double? openingBalance,
  }) {
    return Labour(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      address: address ?? this.address,
      registrationDate: registrationDate ?? this.registrationDate,
      workEntries: workEntries ?? this.workEntries,
      payments: payments ?? this.payments,
      totalPayable: totalPayable ?? this.totalPayable,
      totalPaid: totalPaid ?? this.totalPaid,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      openingBalance: openingBalance ?? this.openingBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'whatsappNumber': whatsappNumber,
      'address': address,
      'registrationDate': registrationDate.toIso8601String(),
      'totalPayable': totalPayable,
      'totalPaid': totalPaid,
      'remainingBalance': remainingBalance,
    };
  }

  factory Labour.fromMap(Map<String, dynamic> map, {List<WorkEntry> workEntries = const [], List<Payment> payments = const []}) {
    return Labour(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      whatsappNumber: map['whatsappNumber'] ?? '',
      address: map['address'],
      registrationDate: DateTime.parse(map['registrationDate']),
      workEntries: workEntries,
      payments: payments,
      totalPayable: (map['totalPayable'] as num).toDouble(),
      totalPaid: (map['totalPaid'] as num).toDouble(),
      remainingBalance: (map['remainingBalance'] as num).toDouble(),
    );
  }
}

class WorkEntry {
  final String id;
  final String entryNumber; // L-WORK-0001
  final String? trailaId;
  final String description;
  final double cost;
  final double previousOutstanding;
  final double paymentAmount;
  final double updatedBalance;
  final DateTime date;

  WorkEntry({
    required this.id,
    required this.entryNumber,
    this.trailaId,
    required this.description,
    required this.cost,
    required this.previousOutstanding,
    this.paymentAmount = 0.0,
    this.updatedBalance = 0.0,
    required this.date,
  });

  WorkEntry copyWith({
    String? id,
    String? entryNumber,
    String? trailaId,
    String? description,
    double? cost,
    double? previousOutstanding,
    double? paymentAmount,
    double? updatedBalance,
    DateTime? date,
  }) {
    return WorkEntry(
      id: id ?? this.id,
      entryNumber: entryNumber ?? this.entryNumber,
      trailaId: trailaId ?? this.trailaId,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      previousOutstanding: previousOutstanding ?? this.previousOutstanding,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      updatedBalance: updatedBalance ?? this.updatedBalance,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap(String labourId) {
    return {
      'id': id,
      'entryNumber': entryNumber,
      'labourId': labourId,
      'trailaId': trailaId,
      'description': description,
      'cost': cost,
      'previousOutstanding': previousOutstanding,
      'paymentAmount': paymentAmount,
      'updatedBalance': updatedBalance,
      'date': date.toIso8601String(),
    };
  }

  factory WorkEntry.fromMap(Map<String, dynamic> map) {
    return WorkEntry(
      id: map['id'],
      entryNumber: map['entryNumber'] ?? 'N/A',
      trailaId: map['trailaId'],
      description: map['description'],
      cost: (map['cost'] as num).toDouble(),
      previousOutstanding: (map['previousOutstanding'] as num?)?.toDouble() ?? 0.0,
      paymentAmount: (map['paymentAmount'] as num?)?.toDouble() ?? 0.0,
      updatedBalance: (map['updatedBalance'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.parse(map['date']),
    );
  }
}
