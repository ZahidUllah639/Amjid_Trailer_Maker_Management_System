import 'package:equatable/equatable.dart';

enum KhataTransactionType { cashIn, cashOut }

class KhataTransaction extends Equatable {
  final String id;
  final String? description;
  final double amount;
  final KhataTransactionType type;
  final DateTime date;
  final String? paymentMethod; // Account name used (e.g. Cash, EasyPaisa)
  final bool syncToAccount;   // Whether this should affect business accounts

  const KhataTransaction({
    required this.id,
    this.description,
    required this.amount,
    required this.type,
    required this.date,
    this.paymentMethod,
    this.syncToAccount = true,
  });

  @override
  List<Object?> get props => [id, description, amount, type, date, paymentMethod, syncToAccount];

  KhataTransaction copyWith({
    String? id,
    String? description,
    double? amount,
    KhataTransactionType? type,
    DateTime? date,
    String? paymentMethod,
    bool? syncToAccount,
  }) {
    return KhataTransaction(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      syncToAccount: syncToAccount ?? this.syncToAccount,
    );
  }
}

class Khata extends Equatable {
  final String id;
  final String personName; // ✅ Restored missing field
  final double openingBalance;
  final double totalAmount; // Total Cash Out
  final double paidAmount;  // Total Cash In
  final double remainingBalance;
  final DateTime date;
  final List<KhataTransaction> items;

  const Khata({
    required this.id,
    required this.personName,
    this.openingBalance = 0.0,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingBalance,
    required this.date,
    this.items = const [],
  });

  @override
  List<Object?> get props => [id, personName, openingBalance, totalAmount, paidAmount, remainingBalance, date, items];

  Khata copyWith({
    String? id,
    String? personName,
    double? openingBalance,
    double? totalAmount,
    double? paidAmount,
    double? remainingBalance,
    DateTime? date,
    List<KhataTransaction>? items,
  }) {
    return Khata(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      openingBalance: openingBalance ?? this.openingBalance,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      date: date ?? this.date,
      items: items ?? this.items,
    );
  }
}
