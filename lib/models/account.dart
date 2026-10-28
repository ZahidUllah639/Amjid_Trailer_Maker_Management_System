class Account {
  final String id;
  final String name;
  final double balance;
  final String type; // cash, bank, wallet, other
  final String? iconType;
  final DateTime createdAt;
  final List<Transaction> transactions;

  Account({
    required this.id,
    required this.name,
    this.balance = 0.0,
    required this.type,
    this.iconType,
    DateTime? createdAt,
    this.transactions = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  Account copyWith({
    String? id,
    String? name,
    double? balance,
    String? type,
    String? iconType,
    DateTime? createdAt,
    List<Transaction>? transactions,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      type: type ?? this.type,
      iconType: iconType ?? this.iconType,
      createdAt: createdAt ?? this.createdAt,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'type': type,
      'iconType': iconType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Account.fromMap(Map<String, dynamic> map, {List<Transaction> transactions = const []}) {
    return Account(
      id: map['id'],
      name: map['name'],
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,
      type: map['type'] ?? 'other',
      iconType: map['iconType'],
      createdAt: DateTime.parse(map['createdAt']),
      transactions: transactions,
    );
  }
}

enum TransactionType {
  add,      // Credit
  take,     // Debit
  transfer, // Dual
  opening   // Seed
}

class Transaction {
  final String id;
  final String accountName;
  final TransactionType type;
  final double amount;
  final String person;
  final String description;
  final DateTime date;
  final String category; // Personal, Business, etc.
  final String? refNo;
  final String? linkedTransferId; // For transfers

  Transaction({
    required this.id,
    required this.accountName,
    required this.type,
    required this.amount,
    required this.person,
    required this.description,
    required this.date,
    this.category = 'Business',
    this.refNo,
    this.linkedTransferId,
  });

  bool get isCredit => type == TransactionType.add || type == TransactionType.opening;
  bool get isDebit => type == TransactionType.take;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountName': accountName,
      'type': type.name,
      'amount': amount,
      'person': person,
      'description': description,
      'date': date.toIso8601String(),
      'category': category,
      'refNo': refNo,
      'linkedTransferId': linkedTransferId,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      accountName: map['accountName'],
      type: TransactionType.values.byName(map['type']),
      amount: (map['amount'] as num).toDouble(),
      person: map['person'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
      category: map['category'] ?? 'Business',
      refNo: map['refNo'],
      linkedTransferId: map['linkedTransferId'],
    );
  }
}
