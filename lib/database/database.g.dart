// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, SupplierData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _shopNameMeta = const VerificationMeta(
    'shopName',
  );
  @override
  late final GeneratedColumn<String> shopName = GeneratedColumn<String>(
    'shop_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _whatsappNumberMeta = const VerificationMeta(
    'whatsappNumber',
  );
  @override
  late final GeneratedColumn<String> whatsappNumber = GeneratedColumn<String>(
    'whatsapp_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _registrationDateMeta = const VerificationMeta(
    'registrationDate',
  );
  @override
  late final GeneratedColumn<DateTime> registrationDate =
      GeneratedColumn<DateTime>(
        'registration_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _openingBalanceMeta = const VerificationMeta(
    'openingBalance',
  );
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
    'opening_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalPaidMeta = const VerificationMeta(
    'totalPaid',
  );
  @override
  late final GeneratedColumn<double> totalPaid = GeneratedColumn<double>(
    'total_paid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _remainingBalanceMeta = const VerificationMeta(
    'remainingBalance',
  );
  @override
  late final GeneratedColumn<double> remainingBalance = GeneratedColumn<double>(
    'remaining_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _advanceBalanceMeta = const VerificationMeta(
    'advanceBalance',
  );
  @override
  late final GeneratedColumn<double> advanceBalance = GeneratedColumn<double>(
    'advance_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    shopName,
    location,
    whatsappNumber,
    address,
    registrationDate,
    openingBalance,
    totalAmount,
    totalPaid,
    remainingBalance,
    advanceBalance,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplierData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('shop_name')) {
      context.handle(
        _shopNameMeta,
        shopName.isAcceptableOrUnknown(data['shop_name']!, _shopNameMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('whatsapp_number')) {
      context.handle(
        _whatsappNumberMeta,
        whatsappNumber.isAcceptableOrUnknown(
          data['whatsapp_number']!,
          _whatsappNumberMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('registration_date')) {
      context.handle(
        _registrationDateMeta,
        registrationDate.isAcceptableOrUnknown(
          data['registration_date']!,
          _registrationDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registrationDateMeta);
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
        _openingBalanceMeta,
        openingBalance.isAcceptableOrUnknown(
          data['opening_balance']!,
          _openingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('total_paid')) {
      context.handle(
        _totalPaidMeta,
        totalPaid.isAcceptableOrUnknown(data['total_paid']!, _totalPaidMeta),
      );
    }
    if (data.containsKey('remaining_balance')) {
      context.handle(
        _remainingBalanceMeta,
        remainingBalance.isAcceptableOrUnknown(
          data['remaining_balance']!,
          _remainingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('advance_balance')) {
      context.handle(
        _advanceBalanceMeta,
        advanceBalance.isAcceptableOrUnknown(
          data['advance_balance']!,
          _advanceBalanceMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplierData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      shopName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_name'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      whatsappNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp_number'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      registrationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registration_date'],
      )!,
      openingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}opening_balance'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      totalPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_paid'],
      )!,
      remainingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}remaining_balance'],
      )!,
      advanceBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}advance_balance'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class SupplierData extends DataClass implements Insertable<SupplierData> {
  final String id;
  final String name;
  final String phone;
  final String shopName;
  final String location;
  final String whatsappNumber;
  final String address;
  final DateTime registrationDate;
  final double openingBalance;
  final double totalAmount;
  final double totalPaid;
  final double remainingBalance;
  final double advanceBalance;
  final DateTime createdAt;
  const SupplierData({
    required this.id,
    required this.name,
    required this.phone,
    required this.shopName,
    required this.location,
    required this.whatsappNumber,
    required this.address,
    required this.registrationDate,
    required this.openingBalance,
    required this.totalAmount,
    required this.totalPaid,
    required this.remainingBalance,
    required this.advanceBalance,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['shop_name'] = Variable<String>(shopName);
    map['location'] = Variable<String>(location);
    map['whatsapp_number'] = Variable<String>(whatsappNumber);
    map['address'] = Variable<String>(address);
    map['registration_date'] = Variable<DateTime>(registrationDate);
    map['opening_balance'] = Variable<double>(openingBalance);
    map['total_amount'] = Variable<double>(totalAmount);
    map['total_paid'] = Variable<double>(totalPaid);
    map['remaining_balance'] = Variable<double>(remainingBalance);
    map['advance_balance'] = Variable<double>(advanceBalance);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      shopName: Value(shopName),
      location: Value(location),
      whatsappNumber: Value(whatsappNumber),
      address: Value(address),
      registrationDate: Value(registrationDate),
      openingBalance: Value(openingBalance),
      totalAmount: Value(totalAmount),
      totalPaid: Value(totalPaid),
      remainingBalance: Value(remainingBalance),
      advanceBalance: Value(advanceBalance),
      createdAt: Value(createdAt),
    );
  }

  factory SupplierData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      shopName: serializer.fromJson<String>(json['shopName']),
      location: serializer.fromJson<String>(json['location']),
      whatsappNumber: serializer.fromJson<String>(json['whatsappNumber']),
      address: serializer.fromJson<String>(json['address']),
      registrationDate: serializer.fromJson<DateTime>(json['registrationDate']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      totalPaid: serializer.fromJson<double>(json['totalPaid']),
      remainingBalance: serializer.fromJson<double>(json['remainingBalance']),
      advanceBalance: serializer.fromJson<double>(json['advanceBalance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'shopName': serializer.toJson<String>(shopName),
      'location': serializer.toJson<String>(location),
      'whatsappNumber': serializer.toJson<String>(whatsappNumber),
      'address': serializer.toJson<String>(address),
      'registrationDate': serializer.toJson<DateTime>(registrationDate),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'totalPaid': serializer.toJson<double>(totalPaid),
      'remainingBalance': serializer.toJson<double>(remainingBalance),
      'advanceBalance': serializer.toJson<double>(advanceBalance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SupplierData copyWith({
    String? id,
    String? name,
    String? phone,
    String? shopName,
    String? location,
    String? whatsappNumber,
    String? address,
    DateTime? registrationDate,
    double? openingBalance,
    double? totalAmount,
    double? totalPaid,
    double? remainingBalance,
    double? advanceBalance,
    DateTime? createdAt,
  }) => SupplierData(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    shopName: shopName ?? this.shopName,
    location: location ?? this.location,
    whatsappNumber: whatsappNumber ?? this.whatsappNumber,
    address: address ?? this.address,
    registrationDate: registrationDate ?? this.registrationDate,
    openingBalance: openingBalance ?? this.openingBalance,
    totalAmount: totalAmount ?? this.totalAmount,
    totalPaid: totalPaid ?? this.totalPaid,
    remainingBalance: remainingBalance ?? this.remainingBalance,
    advanceBalance: advanceBalance ?? this.advanceBalance,
    createdAt: createdAt ?? this.createdAt,
  );
  SupplierData copyWithCompanion(SuppliersCompanion data) {
    return SupplierData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      shopName: data.shopName.present ? data.shopName.value : this.shopName,
      location: data.location.present ? data.location.value : this.location,
      whatsappNumber: data.whatsappNumber.present
          ? data.whatsappNumber.value
          : this.whatsappNumber,
      address: data.address.present ? data.address.value : this.address,
      registrationDate: data.registrationDate.present
          ? data.registrationDate.value
          : this.registrationDate,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      totalPaid: data.totalPaid.present ? data.totalPaid.value : this.totalPaid,
      remainingBalance: data.remainingBalance.present
          ? data.remainingBalance.value
          : this.remainingBalance,
      advanceBalance: data.advanceBalance.present
          ? data.advanceBalance.value
          : this.advanceBalance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('shopName: $shopName, ')
          ..write('location: $location, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('address: $address, ')
          ..write('registrationDate: $registrationDate, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalPaid: $totalPaid, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('advanceBalance: $advanceBalance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    shopName,
    location,
    whatsappNumber,
    address,
    registrationDate,
    openingBalance,
    totalAmount,
    totalPaid,
    remainingBalance,
    advanceBalance,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierData &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.shopName == this.shopName &&
          other.location == this.location &&
          other.whatsappNumber == this.whatsappNumber &&
          other.address == this.address &&
          other.registrationDate == this.registrationDate &&
          other.openingBalance == this.openingBalance &&
          other.totalAmount == this.totalAmount &&
          other.totalPaid == this.totalPaid &&
          other.remainingBalance == this.remainingBalance &&
          other.advanceBalance == this.advanceBalance &&
          other.createdAt == this.createdAt);
}

class SuppliersCompanion extends UpdateCompanion<SupplierData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> shopName;
  final Value<String> location;
  final Value<String> whatsappNumber;
  final Value<String> address;
  final Value<DateTime> registrationDate;
  final Value<double> openingBalance;
  final Value<double> totalAmount;
  final Value<double> totalPaid;
  final Value<double> remainingBalance;
  final Value<double> advanceBalance;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.shopName = const Value.absent(),
    this.location = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.address = const Value.absent(),
    this.registrationDate = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.totalPaid = const Value.absent(),
    this.remainingBalance = const Value.absent(),
    this.advanceBalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SuppliersCompanion.insert({
    required String id,
    required String name,
    this.phone = const Value.absent(),
    this.shopName = const Value.absent(),
    this.location = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.address = const Value.absent(),
    required DateTime registrationDate,
    this.openingBalance = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.totalPaid = const Value.absent(),
    this.remainingBalance = const Value.absent(),
    this.advanceBalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       registrationDate = Value(registrationDate);
  static Insertable<SupplierData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? shopName,
    Expression<String>? location,
    Expression<String>? whatsappNumber,
    Expression<String>? address,
    Expression<DateTime>? registrationDate,
    Expression<double>? openingBalance,
    Expression<double>? totalAmount,
    Expression<double>? totalPaid,
    Expression<double>? remainingBalance,
    Expression<double>? advanceBalance,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (shopName != null) 'shop_name': shopName,
      if (location != null) 'location': location,
      if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
      if (address != null) 'address': address,
      if (registrationDate != null) 'registration_date': registrationDate,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (totalPaid != null) 'total_paid': totalPaid,
      if (remainingBalance != null) 'remaining_balance': remainingBalance,
      if (advanceBalance != null) 'advance_balance': advanceBalance,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SuppliersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? shopName,
    Value<String>? location,
    Value<String>? whatsappNumber,
    Value<String>? address,
    Value<DateTime>? registrationDate,
    Value<double>? openingBalance,
    Value<double>? totalAmount,
    Value<double>? totalPaid,
    Value<double>? remainingBalance,
    Value<double>? advanceBalance,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      shopName: shopName ?? this.shopName,
      location: location ?? this.location,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      address: address ?? this.address,
      registrationDate: registrationDate ?? this.registrationDate,
      openingBalance: openingBalance ?? this.openingBalance,
      totalAmount: totalAmount ?? this.totalAmount,
      totalPaid: totalPaid ?? this.totalPaid,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      advanceBalance: advanceBalance ?? this.advanceBalance,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (shopName.present) {
      map['shop_name'] = Variable<String>(shopName.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (whatsappNumber.present) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (registrationDate.present) {
      map['registration_date'] = Variable<DateTime>(registrationDate.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (totalPaid.present) {
      map['total_paid'] = Variable<double>(totalPaid.value);
    }
    if (remainingBalance.present) {
      map['remaining_balance'] = Variable<double>(remainingBalance.value);
    }
    if (advanceBalance.present) {
      map['advance_balance'] = Variable<double>(advanceBalance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('shopName: $shopName, ')
          ..write('location: $location, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('address: $address, ')
          ..write('registrationDate: $registrationDate, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalPaid: $totalPaid, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('advanceBalance: $advanceBalance, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LaboursTable extends Labours with TableInfo<$LaboursTable, LabourData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LaboursTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _whatsappNumberMeta = const VerificationMeta(
    'whatsappNumber',
  );
  @override
  late final GeneratedColumn<String> whatsappNumber = GeneratedColumn<String>(
    'whatsapp_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _registrationDateMeta = const VerificationMeta(
    'registrationDate',
  );
  @override
  late final GeneratedColumn<DateTime> registrationDate =
      GeneratedColumn<DateTime>(
        'registration_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _openingBalanceMeta = const VerificationMeta(
    'openingBalance',
  );
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
    'opening_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalPayableMeta = const VerificationMeta(
    'totalPayable',
  );
  @override
  late final GeneratedColumn<double> totalPayable = GeneratedColumn<double>(
    'total_payable',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalPaidMeta = const VerificationMeta(
    'totalPaid',
  );
  @override
  late final GeneratedColumn<double> totalPaid = GeneratedColumn<double>(
    'total_paid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _remainingBalanceMeta = const VerificationMeta(
    'remainingBalance',
  );
  @override
  late final GeneratedColumn<double> remainingBalance = GeneratedColumn<double>(
    'remaining_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    whatsappNumber,
    address,
    registrationDate,
    openingBalance,
    totalPayable,
    totalPaid,
    remainingBalance,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'labours';
  @override
  VerificationContext validateIntegrity(
    Insertable<LabourData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('whatsapp_number')) {
      context.handle(
        _whatsappNumberMeta,
        whatsappNumber.isAcceptableOrUnknown(
          data['whatsapp_number']!,
          _whatsappNumberMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('registration_date')) {
      context.handle(
        _registrationDateMeta,
        registrationDate.isAcceptableOrUnknown(
          data['registration_date']!,
          _registrationDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registrationDateMeta);
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
        _openingBalanceMeta,
        openingBalance.isAcceptableOrUnknown(
          data['opening_balance']!,
          _openingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('total_payable')) {
      context.handle(
        _totalPayableMeta,
        totalPayable.isAcceptableOrUnknown(
          data['total_payable']!,
          _totalPayableMeta,
        ),
      );
    }
    if (data.containsKey('total_paid')) {
      context.handle(
        _totalPaidMeta,
        totalPaid.isAcceptableOrUnknown(data['total_paid']!, _totalPaidMeta),
      );
    }
    if (data.containsKey('remaining_balance')) {
      context.handle(
        _remainingBalanceMeta,
        remainingBalance.isAcceptableOrUnknown(
          data['remaining_balance']!,
          _remainingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LabourData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabourData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      whatsappNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp_number'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      registrationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registration_date'],
      )!,
      openingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}opening_balance'],
      )!,
      totalPayable: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_payable'],
      )!,
      totalPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_paid'],
      )!,
      remainingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}remaining_balance'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LaboursTable createAlias(String alias) {
    return $LaboursTable(attachedDatabase, alias);
  }
}

class LabourData extends DataClass implements Insertable<LabourData> {
  final String id;
  final String name;
  final String phone;
  final String whatsappNumber;
  final String address;
  final DateTime registrationDate;
  final double openingBalance;
  final double totalPayable;
  final double totalPaid;
  final double remainingBalance;
  final DateTime createdAt;
  const LabourData({
    required this.id,
    required this.name,
    required this.phone,
    required this.whatsappNumber,
    required this.address,
    required this.registrationDate,
    required this.openingBalance,
    required this.totalPayable,
    required this.totalPaid,
    required this.remainingBalance,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['whatsapp_number'] = Variable<String>(whatsappNumber);
    map['address'] = Variable<String>(address);
    map['registration_date'] = Variable<DateTime>(registrationDate);
    map['opening_balance'] = Variable<double>(openingBalance);
    map['total_payable'] = Variable<double>(totalPayable);
    map['total_paid'] = Variable<double>(totalPaid);
    map['remaining_balance'] = Variable<double>(remainingBalance);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LaboursCompanion toCompanion(bool nullToAbsent) {
    return LaboursCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      whatsappNumber: Value(whatsappNumber),
      address: Value(address),
      registrationDate: Value(registrationDate),
      openingBalance: Value(openingBalance),
      totalPayable: Value(totalPayable),
      totalPaid: Value(totalPaid),
      remainingBalance: Value(remainingBalance),
      createdAt: Value(createdAt),
    );
  }

  factory LabourData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabourData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      whatsappNumber: serializer.fromJson<String>(json['whatsappNumber']),
      address: serializer.fromJson<String>(json['address']),
      registrationDate: serializer.fromJson<DateTime>(json['registrationDate']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      totalPayable: serializer.fromJson<double>(json['totalPayable']),
      totalPaid: serializer.fromJson<double>(json['totalPaid']),
      remainingBalance: serializer.fromJson<double>(json['remainingBalance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'whatsappNumber': serializer.toJson<String>(whatsappNumber),
      'address': serializer.toJson<String>(address),
      'registrationDate': serializer.toJson<DateTime>(registrationDate),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'totalPayable': serializer.toJson<double>(totalPayable),
      'totalPaid': serializer.toJson<double>(totalPaid),
      'remainingBalance': serializer.toJson<double>(remainingBalance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LabourData copyWith({
    String? id,
    String? name,
    String? phone,
    String? whatsappNumber,
    String? address,
    DateTime? registrationDate,
    double? openingBalance,
    double? totalPayable,
    double? totalPaid,
    double? remainingBalance,
    DateTime? createdAt,
  }) => LabourData(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    whatsappNumber: whatsappNumber ?? this.whatsappNumber,
    address: address ?? this.address,
    registrationDate: registrationDate ?? this.registrationDate,
    openingBalance: openingBalance ?? this.openingBalance,
    totalPayable: totalPayable ?? this.totalPayable,
    totalPaid: totalPaid ?? this.totalPaid,
    remainingBalance: remainingBalance ?? this.remainingBalance,
    createdAt: createdAt ?? this.createdAt,
  );
  LabourData copyWithCompanion(LaboursCompanion data) {
    return LabourData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      whatsappNumber: data.whatsappNumber.present
          ? data.whatsappNumber.value
          : this.whatsappNumber,
      address: data.address.present ? data.address.value : this.address,
      registrationDate: data.registrationDate.present
          ? data.registrationDate.value
          : this.registrationDate,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      totalPayable: data.totalPayable.present
          ? data.totalPayable.value
          : this.totalPayable,
      totalPaid: data.totalPaid.present ? data.totalPaid.value : this.totalPaid,
      remainingBalance: data.remainingBalance.present
          ? data.remainingBalance.value
          : this.remainingBalance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LabourData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('address: $address, ')
          ..write('registrationDate: $registrationDate, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('totalPayable: $totalPayable, ')
          ..write('totalPaid: $totalPaid, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    whatsappNumber,
    address,
    registrationDate,
    openingBalance,
    totalPayable,
    totalPaid,
    remainingBalance,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabourData &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.whatsappNumber == this.whatsappNumber &&
          other.address == this.address &&
          other.registrationDate == this.registrationDate &&
          other.openingBalance == this.openingBalance &&
          other.totalPayable == this.totalPayable &&
          other.totalPaid == this.totalPaid &&
          other.remainingBalance == this.remainingBalance &&
          other.createdAt == this.createdAt);
}

class LaboursCompanion extends UpdateCompanion<LabourData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> whatsappNumber;
  final Value<String> address;
  final Value<DateTime> registrationDate;
  final Value<double> openingBalance;
  final Value<double> totalPayable;
  final Value<double> totalPaid;
  final Value<double> remainingBalance;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LaboursCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.address = const Value.absent(),
    this.registrationDate = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.totalPayable = const Value.absent(),
    this.totalPaid = const Value.absent(),
    this.remainingBalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LaboursCompanion.insert({
    required String id,
    required String name,
    this.phone = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.address = const Value.absent(),
    required DateTime registrationDate,
    this.openingBalance = const Value.absent(),
    this.totalPayable = const Value.absent(),
    this.totalPaid = const Value.absent(),
    this.remainingBalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       registrationDate = Value(registrationDate);
  static Insertable<LabourData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? whatsappNumber,
    Expression<String>? address,
    Expression<DateTime>? registrationDate,
    Expression<double>? openingBalance,
    Expression<double>? totalPayable,
    Expression<double>? totalPaid,
    Expression<double>? remainingBalance,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
      if (address != null) 'address': address,
      if (registrationDate != null) 'registration_date': registrationDate,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (totalPayable != null) 'total_payable': totalPayable,
      if (totalPaid != null) 'total_paid': totalPaid,
      if (remainingBalance != null) 'remaining_balance': remainingBalance,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LaboursCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? whatsappNumber,
    Value<String>? address,
    Value<DateTime>? registrationDate,
    Value<double>? openingBalance,
    Value<double>? totalPayable,
    Value<double>? totalPaid,
    Value<double>? remainingBalance,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LaboursCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      address: address ?? this.address,
      registrationDate: registrationDate ?? this.registrationDate,
      openingBalance: openingBalance ?? this.openingBalance,
      totalPayable: totalPayable ?? this.totalPayable,
      totalPaid: totalPaid ?? this.totalPaid,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (whatsappNumber.present) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (registrationDate.present) {
      map['registration_date'] = Variable<DateTime>(registrationDate.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (totalPayable.present) {
      map['total_payable'] = Variable<double>(totalPayable.value);
    }
    if (totalPaid.present) {
      map['total_paid'] = Variable<double>(totalPaid.value);
    }
    if (remainingBalance.present) {
      map['remaining_balance'] = Variable<double>(remainingBalance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LaboursCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('address: $address, ')
          ..write('registrationDate: $registrationDate, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('totalPayable: $totalPayable, ')
          ..write('totalPaid: $totalPaid, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products
    with TableInfo<$ProductsTable, ProductData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultPriceMeta = const VerificationMeta(
    'defaultPrice',
  );
  @override
  late final GeneratedColumn<double> defaultPrice = GeneratedColumn<double>(
    'default_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PCS'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    defaultPrice,
    unit,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_price')) {
      context.handle(
        _defaultPriceMeta,
        defaultPrice.isAcceptableOrUnknown(
          data['default_price']!,
          _defaultPriceMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      defaultPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_price'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class ProductData extends DataClass implements Insertable<ProductData> {
  final String id;
  final String name;
  final double defaultPrice;
  final String unit;
  final DateTime createdAt;
  const ProductData({
    required this.id,
    required this.name,
    required this.defaultPrice,
    required this.unit,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['default_price'] = Variable<double>(defaultPrice);
    map['unit'] = Variable<String>(unit);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      defaultPrice: Value(defaultPrice),
      unit: Value(unit),
      createdAt: Value(createdAt),
    );
  }

  factory ProductData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      defaultPrice: serializer.fromJson<double>(json['defaultPrice']),
      unit: serializer.fromJson<String>(json['unit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'defaultPrice': serializer.toJson<double>(defaultPrice),
      'unit': serializer.toJson<String>(unit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProductData copyWith({
    String? id,
    String? name,
    double? defaultPrice,
    String? unit,
    DateTime? createdAt,
  }) => ProductData(
    id: id ?? this.id,
    name: name ?? this.name,
    defaultPrice: defaultPrice ?? this.defaultPrice,
    unit: unit ?? this.unit,
    createdAt: createdAt ?? this.createdAt,
  );
  ProductData copyWithCompanion(ProductsCompanion data) {
    return ProductData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      defaultPrice: data.defaultPrice.present
          ? data.defaultPrice.value
          : this.defaultPrice,
      unit: data.unit.present ? data.unit.value : this.unit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('defaultPrice: $defaultPrice, ')
          ..write('unit: $unit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, defaultPrice, unit, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductData &&
          other.id == this.id &&
          other.name == this.name &&
          other.defaultPrice == this.defaultPrice &&
          other.unit == this.unit &&
          other.createdAt == this.createdAt);
}

class ProductsCompanion extends UpdateCompanion<ProductData> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> defaultPrice;
  final Value<String> unit;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultPrice = const Value.absent(),
    this.unit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    this.defaultPrice = const Value.absent(),
    this.unit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<ProductData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? defaultPrice,
    Expression<String>? unit,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (defaultPrice != null) 'default_price': defaultPrice,
      if (unit != null) 'unit': unit,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? defaultPrice,
    Value<String>? unit,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      defaultPrice: defaultPrice ?? this.defaultPrice,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultPrice.present) {
      map['default_price'] = Variable<double>(defaultPrice.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('defaultPrice: $defaultPrice, ')
          ..write('unit: $unit, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrailasTable extends Trailas with TableInfo<$TrailasTable, TrailaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrailasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registrationDateMeta = const VerificationMeta(
    'registrationDate',
  );
  @override
  late final GeneratedColumn<DateTime> registrationDate =
      GeneratedColumn<DateTime>(
        'registration_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalManufacturingCostMeta =
      const VerificationMeta('totalManufacturingCost');
  @override
  late final GeneratedColumn<double> totalManufacturingCost =
      GeneratedColumn<double>(
        'total_manufacturing_cost',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _salePriceMeta = const VerificationMeta(
    'salePrice',
  );
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
    'sale_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    registrationDate,
    status,
    totalManufacturingCost,
    salePrice,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trailas';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrailaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('registration_date')) {
      context.handle(
        _registrationDateMeta,
        registrationDate.isAcceptableOrUnknown(
          data['registration_date']!,
          _registrationDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registrationDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('total_manufacturing_cost')) {
      context.handle(
        _totalManufacturingCostMeta,
        totalManufacturingCost.isAcceptableOrUnknown(
          data['total_manufacturing_cost']!,
          _totalManufacturingCostMeta,
        ),
      );
    }
    if (data.containsKey('sale_price')) {
      context.handle(
        _salePriceMeta,
        salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrailaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrailaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      registrationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registration_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      totalManufacturingCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_manufacturing_cost'],
      )!,
      salePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sale_price'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TrailasTable createAlias(String alias) {
    return $TrailasTable(attachedDatabase, alias);
  }
}

class TrailaData extends DataClass implements Insertable<TrailaData> {
  final String id;
  final String name;
  final DateTime registrationDate;
  final String status;
  final double totalManufacturingCost;
  final double? salePrice;
  final DateTime createdAt;
  const TrailaData({
    required this.id,
    required this.name,
    required this.registrationDate,
    required this.status,
    required this.totalManufacturingCost,
    this.salePrice,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['registration_date'] = Variable<DateTime>(registrationDate);
    map['status'] = Variable<String>(status);
    map['total_manufacturing_cost'] = Variable<double>(totalManufacturingCost);
    if (!nullToAbsent || salePrice != null) {
      map['sale_price'] = Variable<double>(salePrice);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TrailasCompanion toCompanion(bool nullToAbsent) {
    return TrailasCompanion(
      id: Value(id),
      name: Value(name),
      registrationDate: Value(registrationDate),
      status: Value(status),
      totalManufacturingCost: Value(totalManufacturingCost),
      salePrice: salePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(salePrice),
      createdAt: Value(createdAt),
    );
  }

  factory TrailaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrailaData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      registrationDate: serializer.fromJson<DateTime>(json['registrationDate']),
      status: serializer.fromJson<String>(json['status']),
      totalManufacturingCost: serializer.fromJson<double>(
        json['totalManufacturingCost'],
      ),
      salePrice: serializer.fromJson<double?>(json['salePrice']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'registrationDate': serializer.toJson<DateTime>(registrationDate),
      'status': serializer.toJson<String>(status),
      'totalManufacturingCost': serializer.toJson<double>(
        totalManufacturingCost,
      ),
      'salePrice': serializer.toJson<double?>(salePrice),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TrailaData copyWith({
    String? id,
    String? name,
    DateTime? registrationDate,
    String? status,
    double? totalManufacturingCost,
    Value<double?> salePrice = const Value.absent(),
    DateTime? createdAt,
  }) => TrailaData(
    id: id ?? this.id,
    name: name ?? this.name,
    registrationDate: registrationDate ?? this.registrationDate,
    status: status ?? this.status,
    totalManufacturingCost:
        totalManufacturingCost ?? this.totalManufacturingCost,
    salePrice: salePrice.present ? salePrice.value : this.salePrice,
    createdAt: createdAt ?? this.createdAt,
  );
  TrailaData copyWithCompanion(TrailasCompanion data) {
    return TrailaData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      registrationDate: data.registrationDate.present
          ? data.registrationDate.value
          : this.registrationDate,
      status: data.status.present ? data.status.value : this.status,
      totalManufacturingCost: data.totalManufacturingCost.present
          ? data.totalManufacturingCost.value
          : this.totalManufacturingCost,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrailaData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('registrationDate: $registrationDate, ')
          ..write('status: $status, ')
          ..write('totalManufacturingCost: $totalManufacturingCost, ')
          ..write('salePrice: $salePrice, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    registrationDate,
    status,
    totalManufacturingCost,
    salePrice,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrailaData &&
          other.id == this.id &&
          other.name == this.name &&
          other.registrationDate == this.registrationDate &&
          other.status == this.status &&
          other.totalManufacturingCost == this.totalManufacturingCost &&
          other.salePrice == this.salePrice &&
          other.createdAt == this.createdAt);
}

class TrailasCompanion extends UpdateCompanion<TrailaData> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> registrationDate;
  final Value<String> status;
  final Value<double> totalManufacturingCost;
  final Value<double?> salePrice;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TrailasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.registrationDate = const Value.absent(),
    this.status = const Value.absent(),
    this.totalManufacturingCost = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrailasCompanion.insert({
    required String id,
    required String name,
    required DateTime registrationDate,
    required String status,
    this.totalManufacturingCost = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       registrationDate = Value(registrationDate),
       status = Value(status);
  static Insertable<TrailaData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? registrationDate,
    Expression<String>? status,
    Expression<double>? totalManufacturingCost,
    Expression<double>? salePrice,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (registrationDate != null) 'registration_date': registrationDate,
      if (status != null) 'status': status,
      if (totalManufacturingCost != null)
        'total_manufacturing_cost': totalManufacturingCost,
      if (salePrice != null) 'sale_price': salePrice,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrailasCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? registrationDate,
    Value<String>? status,
    Value<double>? totalManufacturingCost,
    Value<double?>? salePrice,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TrailasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      registrationDate: registrationDate ?? this.registrationDate,
      status: status ?? this.status,
      totalManufacturingCost:
          totalManufacturingCost ?? this.totalManufacturingCost,
      salePrice: salePrice ?? this.salePrice,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (registrationDate.present) {
      map['registration_date'] = Variable<DateTime>(registrationDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalManufacturingCost.present) {
      map['total_manufacturing_cost'] = Variable<double>(
        totalManufacturingCost.value,
      );
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrailasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('registrationDate: $registrationDate, ')
          ..write('status: $status, ')
          ..write('totalManufacturingCost: $totalManufacturingCost, ')
          ..write('salePrice: $salePrice, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices
    with TableInfo<$InvoicesTable, InvoiceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerNameMeta = const VerificationMeta(
    'ownerName',
  );
  @override
  late final GeneratedColumn<String> ownerName = GeneratedColumn<String>(
    'owner_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerTypeMeta = const VerificationMeta(
    'ownerType',
  );
  @override
  late final GeneratedColumn<String> ownerType = GeneratedColumn<String>(
    'owner_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trailaIdMeta = const VerificationMeta(
    'trailaId',
  );
  @override
  late final GeneratedColumn<String> trailaId = GeneratedColumn<String>(
    'traila_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trailas (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousBalanceMeta = const VerificationMeta(
    'previousBalance',
  );
  @override
  late final GeneratedColumn<double> previousBalance = GeneratedColumn<double>(
    'previous_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingBalanceMeta = const VerificationMeta(
    'remainingBalance',
  );
  @override
  late final GeneratedColumn<double> remainingBalance = GeneratedColumn<double>(
    'remaining_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerNameDisplayMeta = const VerificationMeta(
    'ownerNameDisplay',
  );
  @override
  late final GeneratedColumn<String> ownerNameDisplay = GeneratedColumn<String>(
    'owner_name_display',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceNumber,
    date,
    type,
    ownerId,
    ownerName,
    ownerType,
    trailaId,
    amount,
    previousBalance,
    remainingBalance,
    paymentMethod,
    ownerNameDisplay,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('owner_name')) {
      context.handle(
        _ownerNameMeta,
        ownerName.isAcceptableOrUnknown(data['owner_name']!, _ownerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerNameMeta);
    }
    if (data.containsKey('owner_type')) {
      context.handle(
        _ownerTypeMeta,
        ownerType.isAcceptableOrUnknown(data['owner_type']!, _ownerTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerTypeMeta);
    }
    if (data.containsKey('traila_id')) {
      context.handle(
        _trailaIdMeta,
        trailaId.isAcceptableOrUnknown(data['traila_id']!, _trailaIdMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('previous_balance')) {
      context.handle(
        _previousBalanceMeta,
        previousBalance.isAcceptableOrUnknown(
          data['previous_balance']!,
          _previousBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousBalanceMeta);
    }
    if (data.containsKey('remaining_balance')) {
      context.handle(
        _remainingBalanceMeta,
        remainingBalance.isAcceptableOrUnknown(
          data['remaining_balance']!,
          _remainingBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingBalanceMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('owner_name_display')) {
      context.handle(
        _ownerNameDisplayMeta,
        ownerNameDisplay.isAcceptableOrUnknown(
          data['owner_name_display']!,
          _ownerNameDisplayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerNameDisplayMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      ownerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_name'],
      )!,
      ownerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_type'],
      )!,
      trailaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}traila_id'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      previousBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}previous_balance'],
      )!,
      remainingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}remaining_balance'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      ownerNameDisplay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_name_display'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class InvoiceData extends DataClass implements Insertable<InvoiceData> {
  final String id;
  final String invoiceNumber;
  final DateTime date;
  final String type;
  final String ownerId;
  final String ownerName;
  final String ownerType;
  final String? trailaId;
  final double amount;
  final double previousBalance;
  final double remainingBalance;
  final String paymentMethod;
  final String ownerNameDisplay;
  final DateTime createdAt;
  const InvoiceData({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    required this.type,
    required this.ownerId,
    required this.ownerName,
    required this.ownerType,
    this.trailaId,
    required this.amount,
    required this.previousBalance,
    required this.remainingBalance,
    required this.paymentMethod,
    required this.ownerNameDisplay,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['owner_id'] = Variable<String>(ownerId);
    map['owner_name'] = Variable<String>(ownerName);
    map['owner_type'] = Variable<String>(ownerType);
    if (!nullToAbsent || trailaId != null) {
      map['traila_id'] = Variable<String>(trailaId);
    }
    map['amount'] = Variable<double>(amount);
    map['previous_balance'] = Variable<double>(previousBalance);
    map['remaining_balance'] = Variable<double>(remainingBalance);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['owner_name_display'] = Variable<String>(ownerNameDisplay);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      invoiceNumber: Value(invoiceNumber),
      date: Value(date),
      type: Value(type),
      ownerId: Value(ownerId),
      ownerName: Value(ownerName),
      ownerType: Value(ownerType),
      trailaId: trailaId == null && nullToAbsent
          ? const Value.absent()
          : Value(trailaId),
      amount: Value(amount),
      previousBalance: Value(previousBalance),
      remainingBalance: Value(remainingBalance),
      paymentMethod: Value(paymentMethod),
      ownerNameDisplay: Value(ownerNameDisplay),
      createdAt: Value(createdAt),
    );
  }

  factory InvoiceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceData(
      id: serializer.fromJson<String>(json['id']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      ownerName: serializer.fromJson<String>(json['ownerName']),
      ownerType: serializer.fromJson<String>(json['ownerType']),
      trailaId: serializer.fromJson<String?>(json['trailaId']),
      amount: serializer.fromJson<double>(json['amount']),
      previousBalance: serializer.fromJson<double>(json['previousBalance']),
      remainingBalance: serializer.fromJson<double>(json['remainingBalance']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      ownerNameDisplay: serializer.fromJson<String>(json['ownerNameDisplay']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'ownerId': serializer.toJson<String>(ownerId),
      'ownerName': serializer.toJson<String>(ownerName),
      'ownerType': serializer.toJson<String>(ownerType),
      'trailaId': serializer.toJson<String?>(trailaId),
      'amount': serializer.toJson<double>(amount),
      'previousBalance': serializer.toJson<double>(previousBalance),
      'remainingBalance': serializer.toJson<double>(remainingBalance),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'ownerNameDisplay': serializer.toJson<String>(ownerNameDisplay),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InvoiceData copyWith({
    String? id,
    String? invoiceNumber,
    DateTime? date,
    String? type,
    String? ownerId,
    String? ownerName,
    String? ownerType,
    Value<String?> trailaId = const Value.absent(),
    double? amount,
    double? previousBalance,
    double? remainingBalance,
    String? paymentMethod,
    String? ownerNameDisplay,
    DateTime? createdAt,
  }) => InvoiceData(
    id: id ?? this.id,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    date: date ?? this.date,
    type: type ?? this.type,
    ownerId: ownerId ?? this.ownerId,
    ownerName: ownerName ?? this.ownerName,
    ownerType: ownerType ?? this.ownerType,
    trailaId: trailaId.present ? trailaId.value : this.trailaId,
    amount: amount ?? this.amount,
    previousBalance: previousBalance ?? this.previousBalance,
    remainingBalance: remainingBalance ?? this.remainingBalance,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    ownerNameDisplay: ownerNameDisplay ?? this.ownerNameDisplay,
    createdAt: createdAt ?? this.createdAt,
  );
  InvoiceData copyWithCompanion(InvoicesCompanion data) {
    return InvoiceData(
      id: data.id.present ? data.id.value : this.id,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      ownerName: data.ownerName.present ? data.ownerName.value : this.ownerName,
      ownerType: data.ownerType.present ? data.ownerType.value : this.ownerType,
      trailaId: data.trailaId.present ? data.trailaId.value : this.trailaId,
      amount: data.amount.present ? data.amount.value : this.amount,
      previousBalance: data.previousBalance.present
          ? data.previousBalance.value
          : this.previousBalance,
      remainingBalance: data.remainingBalance.present
          ? data.remainingBalance.value
          : this.remainingBalance,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      ownerNameDisplay: data.ownerNameDisplay.present
          ? data.ownerNameDisplay.value
          : this.ownerNameDisplay,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceData(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('ownerId: $ownerId, ')
          ..write('ownerName: $ownerName, ')
          ..write('ownerType: $ownerType, ')
          ..write('trailaId: $trailaId, ')
          ..write('amount: $amount, ')
          ..write('previousBalance: $previousBalance, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('ownerNameDisplay: $ownerNameDisplay, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceNumber,
    date,
    type,
    ownerId,
    ownerName,
    ownerType,
    trailaId,
    amount,
    previousBalance,
    remainingBalance,
    paymentMethod,
    ownerNameDisplay,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceData &&
          other.id == this.id &&
          other.invoiceNumber == this.invoiceNumber &&
          other.date == this.date &&
          other.type == this.type &&
          other.ownerId == this.ownerId &&
          other.ownerName == this.ownerName &&
          other.ownerType == this.ownerType &&
          other.trailaId == this.trailaId &&
          other.amount == this.amount &&
          other.previousBalance == this.previousBalance &&
          other.remainingBalance == this.remainingBalance &&
          other.paymentMethod == this.paymentMethod &&
          other.ownerNameDisplay == this.ownerNameDisplay &&
          other.createdAt == this.createdAt);
}

class InvoicesCompanion extends UpdateCompanion<InvoiceData> {
  final Value<String> id;
  final Value<String> invoiceNumber;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<String> ownerId;
  final Value<String> ownerName;
  final Value<String> ownerType;
  final Value<String?> trailaId;
  final Value<double> amount;
  final Value<double> previousBalance;
  final Value<double> remainingBalance;
  final Value<String> paymentMethod;
  final Value<String> ownerNameDisplay;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.trailaId = const Value.absent(),
    this.amount = const Value.absent(),
    this.previousBalance = const Value.absent(),
    this.remainingBalance = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.ownerNameDisplay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoicesCompanion.insert({
    required String id,
    required String invoiceNumber,
    required DateTime date,
    required String type,
    required String ownerId,
    required String ownerName,
    required String ownerType,
    this.trailaId = const Value.absent(),
    required double amount,
    required double previousBalance,
    required double remainingBalance,
    required String paymentMethod,
    required String ownerNameDisplay,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       invoiceNumber = Value(invoiceNumber),
       date = Value(date),
       type = Value(type),
       ownerId = Value(ownerId),
       ownerName = Value(ownerName),
       ownerType = Value(ownerType),
       amount = Value(amount),
       previousBalance = Value(previousBalance),
       remainingBalance = Value(remainingBalance),
       paymentMethod = Value(paymentMethod),
       ownerNameDisplay = Value(ownerNameDisplay);
  static Insertable<InvoiceData> custom({
    Expression<String>? id,
    Expression<String>? invoiceNumber,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<String>? ownerId,
    Expression<String>? ownerName,
    Expression<String>? ownerType,
    Expression<String>? trailaId,
    Expression<double>? amount,
    Expression<double>? previousBalance,
    Expression<double>? remainingBalance,
    Expression<String>? paymentMethod,
    Expression<String>? ownerNameDisplay,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (ownerId != null) 'owner_id': ownerId,
      if (ownerName != null) 'owner_name': ownerName,
      if (ownerType != null) 'owner_type': ownerType,
      if (trailaId != null) 'traila_id': trailaId,
      if (amount != null) 'amount': amount,
      if (previousBalance != null) 'previous_balance': previousBalance,
      if (remainingBalance != null) 'remaining_balance': remainingBalance,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (ownerNameDisplay != null) 'owner_name_display': ownerNameDisplay,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoicesCompanion copyWith({
    Value<String>? id,
    Value<String>? invoiceNumber,
    Value<DateTime>? date,
    Value<String>? type,
    Value<String>? ownerId,
    Value<String>? ownerName,
    Value<String>? ownerType,
    Value<String?>? trailaId,
    Value<double>? amount,
    Value<double>? previousBalance,
    Value<double>? remainingBalance,
    Value<String>? paymentMethod,
    Value<String>? ownerNameDisplay,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      date: date ?? this.date,
      type: type ?? this.type,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerType: ownerType ?? this.ownerType,
      trailaId: trailaId ?? this.trailaId,
      amount: amount ?? this.amount,
      previousBalance: previousBalance ?? this.previousBalance,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      ownerNameDisplay: ownerNameDisplay ?? this.ownerNameDisplay,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (ownerName.present) {
      map['owner_name'] = Variable<String>(ownerName.value);
    }
    if (ownerType.present) {
      map['owner_type'] = Variable<String>(ownerType.value);
    }
    if (trailaId.present) {
      map['traila_id'] = Variable<String>(trailaId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (previousBalance.present) {
      map['previous_balance'] = Variable<double>(previousBalance.value);
    }
    if (remainingBalance.present) {
      map['remaining_balance'] = Variable<double>(remainingBalance.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (ownerNameDisplay.present) {
      map['owner_name_display'] = Variable<String>(ownerNameDisplay.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('ownerId: $ownerId, ')
          ..write('ownerName: $ownerName, ')
          ..write('ownerType: $ownerType, ')
          ..write('trailaId: $trailaId, ')
          ..write('amount: $amount, ')
          ..write('previousBalance: $previousBalance, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('ownerNameDisplay: $ownerNameDisplay, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoiceItemsTable extends InvoiceItems
    with TableInfo<$InvoiceItemsTable, InvoiceItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
    'line_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceId,
    productName,
    quantity,
    unitPrice,
    lineTotal,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceItemData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceItemData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_total'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InvoiceItemsTable createAlias(String alias) {
    return $InvoiceItemsTable(attachedDatabase, alias);
  }
}

class InvoiceItemData extends DataClass implements Insertable<InvoiceItemData> {
  final int id;
  final String invoiceId;
  final String productName;
  final double quantity;
  final double unitPrice;
  final double lineTotal;
  final DateTime createdAt;
  const InvoiceItemData({
    required this.id,
    required this.invoiceId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<String>(invoiceId);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<double>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['line_total'] = Variable<double>(lineTotal);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InvoiceItemsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceItemsCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      productName: Value(productName),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      lineTotal: Value(lineTotal),
      createdAt: Value(createdAt),
    );
  }

  factory InvoiceItemData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceItemData(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<String>(invoiceId),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<double>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'lineTotal': serializer.toJson<double>(lineTotal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InvoiceItemData copyWith({
    int? id,
    String? invoiceId,
    String? productName,
    double? quantity,
    double? unitPrice,
    double? lineTotal,
    DateTime? createdAt,
  }) => InvoiceItemData(
    id: id ?? this.id,
    invoiceId: invoiceId ?? this.invoiceId,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    lineTotal: lineTotal ?? this.lineTotal,
    createdAt: createdAt ?? this.createdAt,
  );
  InvoiceItemData copyWithCompanion(InvoiceItemsCompanion data) {
    return InvoiceItemData(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItemData(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceId,
    productName,
    quantity,
    unitPrice,
    lineTotal,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceItemData &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.lineTotal == this.lineTotal &&
          other.createdAt == this.createdAt);
}

class InvoiceItemsCompanion extends UpdateCompanion<InvoiceItemData> {
  final Value<int> id;
  final Value<String> invoiceId;
  final Value<String> productName;
  final Value<double> quantity;
  final Value<double> unitPrice;
  final Value<double> lineTotal;
  final Value<DateTime> createdAt;
  const InvoiceItemsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InvoiceItemsCompanion.insert({
    this.id = const Value.absent(),
    required String invoiceId,
    required String productName,
    required double quantity,
    required double unitPrice,
    required double lineTotal,
    this.createdAt = const Value.absent(),
  }) : invoiceId = Value(invoiceId),
       productName = Value(productName),
       quantity = Value(quantity),
       unitPrice = Value(unitPrice),
       lineTotal = Value(lineTotal);
  static Insertable<InvoiceItemData> custom({
    Expression<int>? id,
    Expression<String>? invoiceId,
    Expression<String>? productName,
    Expression<double>? quantity,
    Expression<double>? unitPrice,
    Expression<double>? lineTotal,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (lineTotal != null) 'line_total': lineTotal,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InvoiceItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? invoiceId,
    Value<String>? productName,
    Value<double>? quantity,
    Value<double>? unitPrice,
    Value<double>? lineTotal,
    Value<DateTime>? createdAt,
  }) {
    return InvoiceItemsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItemsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments
    with TableInfo<$PaymentsTable, PaymentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiptNumberMeta = const VerificationMeta(
    'receiptNumber',
  );
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
    'receipt_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _previousBalanceMeta = const VerificationMeta(
    'previousBalance',
  );
  @override
  late final GeneratedColumn<double> previousBalance = GeneratedColumn<double>(
    'previous_balance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedBalanceMeta = const VerificationMeta(
    'updatedBalance',
  );
  @override
  late final GeneratedColumn<double> updatedBalance = GeneratedColumn<double>(
    'updated_balance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerTypeMeta = const VerificationMeta(
    'ownerType',
  );
  @override
  late final GeneratedColumn<String> ownerType = GeneratedColumn<String>(
    'owner_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    date,
    method,
    receiptNumber,
    previousBalance,
    updatedBalance,
    ownerId,
    ownerType,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _receiptNumberMeta,
        receiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _receiptNumberMeta,
        ),
      );
    }
    if (data.containsKey('previous_balance')) {
      context.handle(
        _previousBalanceMeta,
        previousBalance.isAcceptableOrUnknown(
          data['previous_balance']!,
          _previousBalanceMeta,
        ),
      );
    }
    if (data.containsKey('updated_balance')) {
      context.handle(
        _updatedBalanceMeta,
        updatedBalance.isAcceptableOrUnknown(
          data['updated_balance']!,
          _updatedBalanceMeta,
        ),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('owner_type')) {
      context.handle(
        _ownerTypeMeta,
        ownerType.isAcceptableOrUnknown(data['owner_type']!, _ownerTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      receiptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_number'],
      ),
      previousBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}previous_balance'],
      ),
      updatedBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}updated_balance'],
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      ownerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class PaymentData extends DataClass implements Insertable<PaymentData> {
  final String id;
  final double amount;
  final DateTime date;
  final String method;
  final String? receiptNumber;
  final double? previousBalance;
  final double? updatedBalance;
  final String ownerId;
  final String ownerType;
  final DateTime createdAt;
  const PaymentData({
    required this.id,
    required this.amount,
    required this.date,
    required this.method,
    this.receiptNumber,
    this.previousBalance,
    this.updatedBalance,
    required this.ownerId,
    required this.ownerType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || receiptNumber != null) {
      map['receipt_number'] = Variable<String>(receiptNumber);
    }
    if (!nullToAbsent || previousBalance != null) {
      map['previous_balance'] = Variable<double>(previousBalance);
    }
    if (!nullToAbsent || updatedBalance != null) {
      map['updated_balance'] = Variable<double>(updatedBalance);
    }
    map['owner_id'] = Variable<String>(ownerId);
    map['owner_type'] = Variable<String>(ownerType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      amount: Value(amount),
      date: Value(date),
      method: Value(method),
      receiptNumber: receiptNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptNumber),
      previousBalance: previousBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(previousBalance),
      updatedBalance: updatedBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBalance),
      ownerId: Value(ownerId),
      ownerType: Value(ownerType),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentData(
      id: serializer.fromJson<String>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      method: serializer.fromJson<String>(json['method']),
      receiptNumber: serializer.fromJson<String?>(json['receiptNumber']),
      previousBalance: serializer.fromJson<double?>(json['previousBalance']),
      updatedBalance: serializer.fromJson<double?>(json['updatedBalance']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      ownerType: serializer.fromJson<String>(json['ownerType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'method': serializer.toJson<String>(method),
      'receiptNumber': serializer.toJson<String?>(receiptNumber),
      'previousBalance': serializer.toJson<double?>(previousBalance),
      'updatedBalance': serializer.toJson<double?>(updatedBalance),
      'ownerId': serializer.toJson<String>(ownerId),
      'ownerType': serializer.toJson<String>(ownerType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentData copyWith({
    String? id,
    double? amount,
    DateTime? date,
    String? method,
    Value<String?> receiptNumber = const Value.absent(),
    Value<double?> previousBalance = const Value.absent(),
    Value<double?> updatedBalance = const Value.absent(),
    String? ownerId,
    String? ownerType,
    DateTime? createdAt,
  }) => PaymentData(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    method: method ?? this.method,
    receiptNumber: receiptNumber.present
        ? receiptNumber.value
        : this.receiptNumber,
    previousBalance: previousBalance.present
        ? previousBalance.value
        : this.previousBalance,
    updatedBalance: updatedBalance.present
        ? updatedBalance.value
        : this.updatedBalance,
    ownerId: ownerId ?? this.ownerId,
    ownerType: ownerType ?? this.ownerType,
    createdAt: createdAt ?? this.createdAt,
  );
  PaymentData copyWithCompanion(PaymentsCompanion data) {
    return PaymentData(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      method: data.method.present ? data.method.value : this.method,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      previousBalance: data.previousBalance.present
          ? data.previousBalance.value
          : this.previousBalance,
      updatedBalance: data.updatedBalance.present
          ? data.updatedBalance.value
          : this.updatedBalance,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      ownerType: data.ownerType.present ? data.ownerType.value : this.ownerType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentData(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('previousBalance: $previousBalance, ')
          ..write('updatedBalance: $updatedBalance, ')
          ..write('ownerId: $ownerId, ')
          ..write('ownerType: $ownerType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    date,
    method,
    receiptNumber,
    previousBalance,
    updatedBalance,
    ownerId,
    ownerType,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentData &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.method == this.method &&
          other.receiptNumber == this.receiptNumber &&
          other.previousBalance == this.previousBalance &&
          other.updatedBalance == this.updatedBalance &&
          other.ownerId == this.ownerId &&
          other.ownerType == this.ownerType &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<PaymentData> {
  final Value<String> id;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> method;
  final Value<String?> receiptNumber;
  final Value<double?> previousBalance;
  final Value<double?> updatedBalance;
  final Value<String> ownerId;
  final Value<String> ownerType;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.method = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.previousBalance = const Value.absent(),
    this.updatedBalance = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String id,
    required double amount,
    required DateTime date,
    required String method,
    this.receiptNumber = const Value.absent(),
    this.previousBalance = const Value.absent(),
    this.updatedBalance = const Value.absent(),
    required String ownerId,
    required String ownerType,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       date = Value(date),
       method = Value(method),
       ownerId = Value(ownerId),
       ownerType = Value(ownerType);
  static Insertable<PaymentData> custom({
    Expression<String>? id,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? method,
    Expression<String>? receiptNumber,
    Expression<double>? previousBalance,
    Expression<double>? updatedBalance,
    Expression<String>? ownerId,
    Expression<String>? ownerType,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (method != null) 'method': method,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (previousBalance != null) 'previous_balance': previousBalance,
      if (updatedBalance != null) 'updated_balance': updatedBalance,
      if (ownerId != null) 'owner_id': ownerId,
      if (ownerType != null) 'owner_type': ownerType,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith({
    Value<String>? id,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<String>? method,
    Value<String?>? receiptNumber,
    Value<double?>? previousBalance,
    Value<double?>? updatedBalance,
    Value<String>? ownerId,
    Value<String>? ownerType,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      method: method ?? this.method,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      previousBalance: previousBalance ?? this.previousBalance,
      updatedBalance: updatedBalance ?? this.updatedBalance,
      ownerId: ownerId ?? this.ownerId,
      ownerType: ownerType ?? this.ownerType,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (previousBalance.present) {
      map['previous_balance'] = Variable<double>(previousBalance.value);
    }
    if (updatedBalance.present) {
      map['updated_balance'] = Variable<double>(updatedBalance.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (ownerType.present) {
      map['owner_type'] = Variable<String>(ownerType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('previousBalance: $previousBalance, ')
          ..write('updatedBalance: $updatedBalance, ')
          ..write('ownerId: $ownerId, ')
          ..write('ownerType: $ownerType, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SplitDetailsTable extends SplitDetails
    with TableInfo<$SplitDetailsTable, SplitDetailData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SplitDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _paymentIdMeta = const VerificationMeta(
    'paymentId',
  );
  @override
  late final GeneratedColumn<String> paymentId = GeneratedColumn<String>(
    'payment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES payments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    paymentId,
    method,
    amount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'split_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<SplitDetailData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('payment_id')) {
      context.handle(
        _paymentIdMeta,
        paymentId.isAcceptableOrUnknown(data['payment_id']!, _paymentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_paymentIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SplitDetailData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SplitDetailData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      paymentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_id'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SplitDetailsTable createAlias(String alias) {
    return $SplitDetailsTable(attachedDatabase, alias);
  }
}

class SplitDetailData extends DataClass implements Insertable<SplitDetailData> {
  final int id;
  final String paymentId;
  final String method;
  final double amount;
  final DateTime createdAt;
  const SplitDetailData({
    required this.id,
    required this.paymentId,
    required this.method,
    required this.amount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['payment_id'] = Variable<String>(paymentId);
    map['method'] = Variable<String>(method);
    map['amount'] = Variable<double>(amount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SplitDetailsCompanion toCompanion(bool nullToAbsent) {
    return SplitDetailsCompanion(
      id: Value(id),
      paymentId: Value(paymentId),
      method: Value(method),
      amount: Value(amount),
      createdAt: Value(createdAt),
    );
  }

  factory SplitDetailData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SplitDetailData(
      id: serializer.fromJson<int>(json['id']),
      paymentId: serializer.fromJson<String>(json['paymentId']),
      method: serializer.fromJson<String>(json['method']),
      amount: serializer.fromJson<double>(json['amount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'paymentId': serializer.toJson<String>(paymentId),
      'method': serializer.toJson<String>(method),
      'amount': serializer.toJson<double>(amount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SplitDetailData copyWith({
    int? id,
    String? paymentId,
    String? method,
    double? amount,
    DateTime? createdAt,
  }) => SplitDetailData(
    id: id ?? this.id,
    paymentId: paymentId ?? this.paymentId,
    method: method ?? this.method,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
  );
  SplitDetailData copyWithCompanion(SplitDetailsCompanion data) {
    return SplitDetailData(
      id: data.id.present ? data.id.value : this.id,
      paymentId: data.paymentId.present ? data.paymentId.value : this.paymentId,
      method: data.method.present ? data.method.value : this.method,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SplitDetailData(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, paymentId, method, amount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SplitDetailData &&
          other.id == this.id &&
          other.paymentId == this.paymentId &&
          other.method == this.method &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt);
}

class SplitDetailsCompanion extends UpdateCompanion<SplitDetailData> {
  final Value<int> id;
  final Value<String> paymentId;
  final Value<String> method;
  final Value<double> amount;
  final Value<DateTime> createdAt;
  const SplitDetailsCompanion({
    this.id = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.method = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SplitDetailsCompanion.insert({
    this.id = const Value.absent(),
    required String paymentId,
    required String method,
    required double amount,
    this.createdAt = const Value.absent(),
  }) : paymentId = Value(paymentId),
       method = Value(method),
       amount = Value(amount);
  static Insertable<SplitDetailData> custom({
    Expression<int>? id,
    Expression<String>? paymentId,
    Expression<String>? method,
    Expression<double>? amount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentId != null) 'payment_id': paymentId,
      if (method != null) 'method': method,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SplitDetailsCompanion copyWith({
    Value<int>? id,
    Value<String>? paymentId,
    Value<String>? method,
    Value<double>? amount,
    Value<DateTime>? createdAt,
  }) {
    return SplitDetailsCompanion(
      id: id ?? this.id,
      paymentId: paymentId ?? this.paymentId,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (paymentId.present) {
      map['payment_id'] = Variable<String>(paymentId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SplitDetailsCompanion(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountNameMeta = const VerificationMeta(
    'accountName',
  );
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
    'account_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personMeta = const VerificationMeta('person');
  @override
  late final GeneratedColumn<String> person = GeneratedColumn<String>(
    'person',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linkedTransferIdMeta = const VerificationMeta(
    'linkedTransferId',
  );
  @override
  late final GeneratedColumn<String> linkedTransferId = GeneratedColumn<String>(
    'linked_transfer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountName,
    type,
    amount,
    person,
    description,
    date,
    category,
    linkedTransferId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_name')) {
      context.handle(
        _accountNameMeta,
        accountName.isAcceptableOrUnknown(
          data['account_name']!,
          _accountNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountNameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('person')) {
      context.handle(
        _personMeta,
        person.isAcceptableOrUnknown(data['person']!, _personMeta),
      );
    } else if (isInserting) {
      context.missing(_personMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('linked_transfer_id')) {
      context.handle(
        _linkedTransferIdMeta,
        linkedTransferId.isAcceptableOrUnknown(
          data['linked_transfer_id']!,
          _linkedTransferIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      person: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      linkedTransferId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_transfer_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class TransactionData extends DataClass implements Insertable<TransactionData> {
  final String id;
  final String accountName;
  final String type;
  final double amount;
  final String person;
  final String description;
  final DateTime date;
  final String category;
  final String? linkedTransferId;
  final DateTime createdAt;
  const TransactionData({
    required this.id,
    required this.accountName,
    required this.type,
    required this.amount,
    required this.person,
    required this.description,
    required this.date,
    required this.category,
    this.linkedTransferId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_name'] = Variable<String>(accountName);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['person'] = Variable<String>(person);
    map['description'] = Variable<String>(description);
    map['date'] = Variable<DateTime>(date);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || linkedTransferId != null) {
      map['linked_transfer_id'] = Variable<String>(linkedTransferId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountName: Value(accountName),
      type: Value(type),
      amount: Value(amount),
      person: Value(person),
      description: Value(description),
      date: Value(date),
      category: Value(category),
      linkedTransferId: linkedTransferId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedTransferId),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionData(
      id: serializer.fromJson<String>(json['id']),
      accountName: serializer.fromJson<String>(json['accountName']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      person: serializer.fromJson<String>(json['person']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      linkedTransferId: serializer.fromJson<String?>(json['linkedTransferId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountName': serializer.toJson<String>(accountName),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'person': serializer.toJson<String>(person),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<String>(category),
      'linkedTransferId': serializer.toJson<String?>(linkedTransferId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransactionData copyWith({
    String? id,
    String? accountName,
    String? type,
    double? amount,
    String? person,
    String? description,
    DateTime? date,
    String? category,
    Value<String?> linkedTransferId = const Value.absent(),
    DateTime? createdAt,
  }) => TransactionData(
    id: id ?? this.id,
    accountName: accountName ?? this.accountName,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    person: person ?? this.person,
    description: description ?? this.description,
    date: date ?? this.date,
    category: category ?? this.category,
    linkedTransferId: linkedTransferId.present
        ? linkedTransferId.value
        : this.linkedTransferId,
    createdAt: createdAt ?? this.createdAt,
  );
  TransactionData copyWithCompanion(TransactionsCompanion data) {
    return TransactionData(
      id: data.id.present ? data.id.value : this.id,
      accountName: data.accountName.present
          ? data.accountName.value
          : this.accountName,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      person: data.person.present ? data.person.value : this.person,
      description: data.description.present
          ? data.description.value
          : this.description,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      linkedTransferId: data.linkedTransferId.present
          ? data.linkedTransferId.value
          : this.linkedTransferId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionData(')
          ..write('id: $id, ')
          ..write('accountName: $accountName, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('person: $person, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('linkedTransferId: $linkedTransferId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountName,
    type,
    amount,
    person,
    description,
    date,
    category,
    linkedTransferId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionData &&
          other.id == this.id &&
          other.accountName == this.accountName &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.person == this.person &&
          other.description == this.description &&
          other.date == this.date &&
          other.category == this.category &&
          other.linkedTransferId == this.linkedTransferId &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionData> {
  final Value<String> id;
  final Value<String> accountName;
  final Value<String> type;
  final Value<double> amount;
  final Value<String> person;
  final Value<String> description;
  final Value<DateTime> date;
  final Value<String> category;
  final Value<String?> linkedTransferId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountName = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.person = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.linkedTransferId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String accountName,
    required String type,
    required double amount,
    required String person,
    required String description,
    required DateTime date,
    required String category,
    this.linkedTransferId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountName = Value(accountName),
       type = Value(type),
       amount = Value(amount),
       person = Value(person),
       description = Value(description),
       date = Value(date),
       category = Value(category);
  static Insertable<TransactionData> custom({
    Expression<String>? id,
    Expression<String>? accountName,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<String>? person,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<String>? category,
    Expression<String>? linkedTransferId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountName != null) 'account_name': accountName,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (person != null) 'person': person,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (linkedTransferId != null) 'linked_transfer_id': linkedTransferId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountName,
    Value<String>? type,
    Value<double>? amount,
    Value<String>? person,
    Value<String>? description,
    Value<DateTime>? date,
    Value<String>? category,
    Value<String?>? linkedTransferId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountName: accountName ?? this.accountName,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      person: person ?? this.person,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      linkedTransferId: linkedTransferId ?? this.linkedTransferId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (person.present) {
      map['person'] = Variable<String>(person.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (linkedTransferId.present) {
      map['linked_transfer_id'] = Variable<String>(linkedTransferId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountName: $accountName, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('person: $person, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('linkedTransferId: $linkedTransferId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrailaExpensesTable extends TrailaExpenses
    with TableInfo<$TrailaExpensesTable, TrailaExpenseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrailaExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trailaIdMeta = const VerificationMeta(
    'trailaId',
  );
  @override
  late final GeneratedColumn<String> trailaId = GeneratedColumn<String>(
    'traila_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trailas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES suppliers (id)',
    ),
  );
  static const VerificationMeta _labourIdMeta = const VerificationMeta(
    'labourId',
  );
  @override
  late final GeneratedColumn<String> labourId = GeneratedColumn<String>(
    'labour_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES labours (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trailaId,
    type,
    description,
    amount,
    date,
    supplierId,
    labourId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'traila_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrailaExpenseData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('traila_id')) {
      context.handle(
        _trailaIdMeta,
        trailaId.isAcceptableOrUnknown(data['traila_id']!, _trailaIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('labour_id')) {
      context.handle(
        _labourIdMeta,
        labourId.isAcceptableOrUnknown(data['labour_id']!, _labourIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrailaExpenseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrailaExpenseData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trailaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}traila_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      labourId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}labour_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TrailaExpensesTable createAlias(String alias) {
    return $TrailaExpensesTable(attachedDatabase, alias);
  }
}

class TrailaExpenseData extends DataClass
    implements Insertable<TrailaExpenseData> {
  final String id;
  final String? trailaId;
  final String type;
  final String description;
  final double amount;
  final DateTime date;
  final String? supplierId;
  final String? labourId;
  final DateTime createdAt;
  const TrailaExpenseData({
    required this.id,
    this.trailaId,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
    this.supplierId,
    this.labourId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || trailaId != null) {
      map['traila_id'] = Variable<String>(trailaId);
    }
    map['type'] = Variable<String>(type);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    if (!nullToAbsent || labourId != null) {
      map['labour_id'] = Variable<String>(labourId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TrailaExpensesCompanion toCompanion(bool nullToAbsent) {
    return TrailaExpensesCompanion(
      id: Value(id),
      trailaId: trailaId == null && nullToAbsent
          ? const Value.absent()
          : Value(trailaId),
      type: Value(type),
      description: Value(description),
      amount: Value(amount),
      date: Value(date),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      labourId: labourId == null && nullToAbsent
          ? const Value.absent()
          : Value(labourId),
      createdAt: Value(createdAt),
    );
  }

  factory TrailaExpenseData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrailaExpenseData(
      id: serializer.fromJson<String>(json['id']),
      trailaId: serializer.fromJson<String?>(json['trailaId']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      labourId: serializer.fromJson<String?>(json['labourId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trailaId': serializer.toJson<String?>(trailaId),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'supplierId': serializer.toJson<String?>(supplierId),
      'labourId': serializer.toJson<String?>(labourId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TrailaExpenseData copyWith({
    String? id,
    Value<String?> trailaId = const Value.absent(),
    String? type,
    String? description,
    double? amount,
    DateTime? date,
    Value<String?> supplierId = const Value.absent(),
    Value<String?> labourId = const Value.absent(),
    DateTime? createdAt,
  }) => TrailaExpenseData(
    id: id ?? this.id,
    trailaId: trailaId.present ? trailaId.value : this.trailaId,
    type: type ?? this.type,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    labourId: labourId.present ? labourId.value : this.labourId,
    createdAt: createdAt ?? this.createdAt,
  );
  TrailaExpenseData copyWithCompanion(TrailaExpensesCompanion data) {
    return TrailaExpenseData(
      id: data.id.present ? data.id.value : this.id,
      trailaId: data.trailaId.present ? data.trailaId.value : this.trailaId,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      labourId: data.labourId.present ? data.labourId.value : this.labourId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrailaExpenseData(')
          ..write('id: $id, ')
          ..write('trailaId: $trailaId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('supplierId: $supplierId, ')
          ..write('labourId: $labourId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    trailaId,
    type,
    description,
    amount,
    date,
    supplierId,
    labourId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrailaExpenseData &&
          other.id == this.id &&
          other.trailaId == this.trailaId &&
          other.type == this.type &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.supplierId == this.supplierId &&
          other.labourId == this.labourId &&
          other.createdAt == this.createdAt);
}

class TrailaExpensesCompanion extends UpdateCompanion<TrailaExpenseData> {
  final Value<String> id;
  final Value<String?> trailaId;
  final Value<String> type;
  final Value<String> description;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String?> supplierId;
  final Value<String?> labourId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TrailaExpensesCompanion({
    this.id = const Value.absent(),
    this.trailaId = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.labourId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrailaExpensesCompanion.insert({
    required String id,
    this.trailaId = const Value.absent(),
    required String type,
    required String description,
    required double amount,
    required DateTime date,
    this.supplierId = const Value.absent(),
    this.labourId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       description = Value(description),
       amount = Value(amount),
       date = Value(date);
  static Insertable<TrailaExpenseData> custom({
    Expression<String>? id,
    Expression<String>? trailaId,
    Expression<String>? type,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? supplierId,
    Expression<String>? labourId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trailaId != null) 'traila_id': trailaId,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (supplierId != null) 'supplier_id': supplierId,
      if (labourId != null) 'labour_id': labourId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrailaExpensesCompanion copyWith({
    Value<String>? id,
    Value<String?>? trailaId,
    Value<String>? type,
    Value<String>? description,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<String?>? supplierId,
    Value<String?>? labourId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TrailaExpensesCompanion(
      id: id ?? this.id,
      trailaId: trailaId ?? this.trailaId,
      type: type ?? this.type,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      supplierId: supplierId ?? this.supplierId,
      labourId: labourId ?? this.labourId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trailaId.present) {
      map['traila_id'] = Variable<String>(trailaId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (labourId.present) {
      map['labour_id'] = Variable<String>(labourId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrailaExpensesCompanion(')
          ..write('id: $id, ')
          ..write('trailaId: $trailaId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('supplierId: $supplierId, ')
          ..write('labourId: $labourId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LabourWorkEntriesTable extends LabourWorkEntries
    with TableInfo<$LabourWorkEntriesTable, LabourWorkEntryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabourWorkEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labourIdMeta = const VerificationMeta(
    'labourId',
  );
  @override
  late final GeneratedColumn<String> labourId = GeneratedColumn<String>(
    'labour_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES labours (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _trailaIdMeta = const VerificationMeta(
    'trailaId',
  );
  @override
  late final GeneratedColumn<String> trailaId = GeneratedColumn<String>(
    'traila_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trailas (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _entryNumberMeta = const VerificationMeta(
    'entryNumber',
  );
  @override
  late final GeneratedColumn<String> entryNumber = GeneratedColumn<String>(
    'entry_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousOutstandingMeta =
      const VerificationMeta('previousOutstanding');
  @override
  late final GeneratedColumn<double> previousOutstanding =
      GeneratedColumn<double>(
        'previous_outstanding',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    labourId,
    trailaId,
    entryNumber,
    description,
    cost,
    date,
    previousOutstanding,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'labour_work_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LabourWorkEntryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('labour_id')) {
      context.handle(
        _labourIdMeta,
        labourId.isAcceptableOrUnknown(data['labour_id']!, _labourIdMeta),
      );
    } else if (isInserting) {
      context.missing(_labourIdMeta);
    }
    if (data.containsKey('traila_id')) {
      context.handle(
        _trailaIdMeta,
        trailaId.isAcceptableOrUnknown(data['traila_id']!, _trailaIdMeta),
      );
    }
    if (data.containsKey('entry_number')) {
      context.handle(
        _entryNumberMeta,
        entryNumber.isAcceptableOrUnknown(
          data['entry_number']!,
          _entryNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entryNumberMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('previous_outstanding')) {
      context.handle(
        _previousOutstandingMeta,
        previousOutstanding.isAcceptableOrUnknown(
          data['previous_outstanding']!,
          _previousOutstandingMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LabourWorkEntryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabourWorkEntryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      labourId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}labour_id'],
      )!,
      trailaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}traila_id'],
      ),
      entryNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_number'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      previousOutstanding: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}previous_outstanding'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LabourWorkEntriesTable createAlias(String alias) {
    return $LabourWorkEntriesTable(attachedDatabase, alias);
  }
}

class LabourWorkEntryData extends DataClass
    implements Insertable<LabourWorkEntryData> {
  final String id;
  final String labourId;
  final String? trailaId;
  final String entryNumber;
  final String description;
  final double cost;
  final DateTime date;
  final double previousOutstanding;
  final DateTime createdAt;
  const LabourWorkEntryData({
    required this.id,
    required this.labourId,
    this.trailaId,
    required this.entryNumber,
    required this.description,
    required this.cost,
    required this.date,
    required this.previousOutstanding,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['labour_id'] = Variable<String>(labourId);
    if (!nullToAbsent || trailaId != null) {
      map['traila_id'] = Variable<String>(trailaId);
    }
    map['entry_number'] = Variable<String>(entryNumber);
    map['description'] = Variable<String>(description);
    map['cost'] = Variable<double>(cost);
    map['date'] = Variable<DateTime>(date);
    map['previous_outstanding'] = Variable<double>(previousOutstanding);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LabourWorkEntriesCompanion toCompanion(bool nullToAbsent) {
    return LabourWorkEntriesCompanion(
      id: Value(id),
      labourId: Value(labourId),
      trailaId: trailaId == null && nullToAbsent
          ? const Value.absent()
          : Value(trailaId),
      entryNumber: Value(entryNumber),
      description: Value(description),
      cost: Value(cost),
      date: Value(date),
      previousOutstanding: Value(previousOutstanding),
      createdAt: Value(createdAt),
    );
  }

  factory LabourWorkEntryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabourWorkEntryData(
      id: serializer.fromJson<String>(json['id']),
      labourId: serializer.fromJson<String>(json['labourId']),
      trailaId: serializer.fromJson<String?>(json['trailaId']),
      entryNumber: serializer.fromJson<String>(json['entryNumber']),
      description: serializer.fromJson<String>(json['description']),
      cost: serializer.fromJson<double>(json['cost']),
      date: serializer.fromJson<DateTime>(json['date']),
      previousOutstanding: serializer.fromJson<double>(
        json['previousOutstanding'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'labourId': serializer.toJson<String>(labourId),
      'trailaId': serializer.toJson<String?>(trailaId),
      'entryNumber': serializer.toJson<String>(entryNumber),
      'description': serializer.toJson<String>(description),
      'cost': serializer.toJson<double>(cost),
      'date': serializer.toJson<DateTime>(date),
      'previousOutstanding': serializer.toJson<double>(previousOutstanding),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LabourWorkEntryData copyWith({
    String? id,
    String? labourId,
    Value<String?> trailaId = const Value.absent(),
    String? entryNumber,
    String? description,
    double? cost,
    DateTime? date,
    double? previousOutstanding,
    DateTime? createdAt,
  }) => LabourWorkEntryData(
    id: id ?? this.id,
    labourId: labourId ?? this.labourId,
    trailaId: trailaId.present ? trailaId.value : this.trailaId,
    entryNumber: entryNumber ?? this.entryNumber,
    description: description ?? this.description,
    cost: cost ?? this.cost,
    date: date ?? this.date,
    previousOutstanding: previousOutstanding ?? this.previousOutstanding,
    createdAt: createdAt ?? this.createdAt,
  );
  LabourWorkEntryData copyWithCompanion(LabourWorkEntriesCompanion data) {
    return LabourWorkEntryData(
      id: data.id.present ? data.id.value : this.id,
      labourId: data.labourId.present ? data.labourId.value : this.labourId,
      trailaId: data.trailaId.present ? data.trailaId.value : this.trailaId,
      entryNumber: data.entryNumber.present
          ? data.entryNumber.value
          : this.entryNumber,
      description: data.description.present
          ? data.description.value
          : this.description,
      cost: data.cost.present ? data.cost.value : this.cost,
      date: data.date.present ? data.date.value : this.date,
      previousOutstanding: data.previousOutstanding.present
          ? data.previousOutstanding.value
          : this.previousOutstanding,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LabourWorkEntryData(')
          ..write('id: $id, ')
          ..write('labourId: $labourId, ')
          ..write('trailaId: $trailaId, ')
          ..write('entryNumber: $entryNumber, ')
          ..write('description: $description, ')
          ..write('cost: $cost, ')
          ..write('date: $date, ')
          ..write('previousOutstanding: $previousOutstanding, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    labourId,
    trailaId,
    entryNumber,
    description,
    cost,
    date,
    previousOutstanding,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabourWorkEntryData &&
          other.id == this.id &&
          other.labourId == this.labourId &&
          other.trailaId == this.trailaId &&
          other.entryNumber == this.entryNumber &&
          other.description == this.description &&
          other.cost == this.cost &&
          other.date == this.date &&
          other.previousOutstanding == this.previousOutstanding &&
          other.createdAt == this.createdAt);
}

class LabourWorkEntriesCompanion extends UpdateCompanion<LabourWorkEntryData> {
  final Value<String> id;
  final Value<String> labourId;
  final Value<String?> trailaId;
  final Value<String> entryNumber;
  final Value<String> description;
  final Value<double> cost;
  final Value<DateTime> date;
  final Value<double> previousOutstanding;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LabourWorkEntriesCompanion({
    this.id = const Value.absent(),
    this.labourId = const Value.absent(),
    this.trailaId = const Value.absent(),
    this.entryNumber = const Value.absent(),
    this.description = const Value.absent(),
    this.cost = const Value.absent(),
    this.date = const Value.absent(),
    this.previousOutstanding = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LabourWorkEntriesCompanion.insert({
    required String id,
    required String labourId,
    this.trailaId = const Value.absent(),
    required String entryNumber,
    required String description,
    required double cost,
    required DateTime date,
    this.previousOutstanding = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       labourId = Value(labourId),
       entryNumber = Value(entryNumber),
       description = Value(description),
       cost = Value(cost),
       date = Value(date);
  static Insertable<LabourWorkEntryData> custom({
    Expression<String>? id,
    Expression<String>? labourId,
    Expression<String>? trailaId,
    Expression<String>? entryNumber,
    Expression<String>? description,
    Expression<double>? cost,
    Expression<DateTime>? date,
    Expression<double>? previousOutstanding,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (labourId != null) 'labour_id': labourId,
      if (trailaId != null) 'traila_id': trailaId,
      if (entryNumber != null) 'entry_number': entryNumber,
      if (description != null) 'description': description,
      if (cost != null) 'cost': cost,
      if (date != null) 'date': date,
      if (previousOutstanding != null)
        'previous_outstanding': previousOutstanding,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LabourWorkEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? labourId,
    Value<String?>? trailaId,
    Value<String>? entryNumber,
    Value<String>? description,
    Value<double>? cost,
    Value<DateTime>? date,
    Value<double>? previousOutstanding,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LabourWorkEntriesCompanion(
      id: id ?? this.id,
      labourId: labourId ?? this.labourId,
      trailaId: trailaId ?? this.trailaId,
      entryNumber: entryNumber ?? this.entryNumber,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      date: date ?? this.date,
      previousOutstanding: previousOutstanding ?? this.previousOutstanding,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (labourId.present) {
      map['labour_id'] = Variable<String>(labourId.value);
    }
    if (trailaId.present) {
      map['traila_id'] = Variable<String>(trailaId.value);
    }
    if (entryNumber.present) {
      map['entry_number'] = Variable<String>(entryNumber.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (previousOutstanding.present) {
      map['previous_outstanding'] = Variable<double>(previousOutstanding.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabourWorkEntriesCompanion(')
          ..write('id: $id, ')
          ..write('labourId: $labourId, ')
          ..write('trailaId: $trailaId, ')
          ..write('entryNumber: $entryNumber, ')
          ..write('description: $description, ')
          ..write('cost: $cost, ')
          ..write('date: $date, ')
          ..write('previousOutstanding: $previousOutstanding, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BuyersTable extends Buyers with TableInfo<$BuyersTable, BuyerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BuyersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cnicMeta = const VerificationMeta('cnic');
  @override
  late final GeneratedColumn<String> cnic = GeneratedColumn<String>(
    'cnic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _whatsappNumberMeta = const VerificationMeta(
    'whatsappNumber',
  );
  @override
  late final GeneratedColumn<String> whatsappNumber = GeneratedColumn<String>(
    'whatsapp_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    cnic,
    address,
    whatsappNumber,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'buyers';
  @override
  VerificationContext validateIntegrity(
    Insertable<BuyerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('cnic')) {
      context.handle(
        _cnicMeta,
        cnic.isAcceptableOrUnknown(data['cnic']!, _cnicMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('whatsapp_number')) {
      context.handle(
        _whatsappNumberMeta,
        whatsappNumber.isAcceptableOrUnknown(
          data['whatsapp_number']!,
          _whatsappNumberMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BuyerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BuyerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      cnic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cnic'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      whatsappNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp_number'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BuyersTable createAlias(String alias) {
    return $BuyersTable(attachedDatabase, alias);
  }
}

class BuyerData extends DataClass implements Insertable<BuyerData> {
  final String id;
  final String name;
  final String? phone;
  final String? cnic;
  final String? address;
  final String? whatsappNumber;
  final DateTime createdAt;
  const BuyerData({
    required this.id,
    required this.name,
    this.phone,
    this.cnic,
    this.address,
    this.whatsappNumber,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || cnic != null) {
      map['cnic'] = Variable<String>(cnic);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || whatsappNumber != null) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BuyersCompanion toCompanion(bool nullToAbsent) {
    return BuyersCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      cnic: cnic == null && nullToAbsent ? const Value.absent() : Value(cnic),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      whatsappNumber: whatsappNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsappNumber),
      createdAt: Value(createdAt),
    );
  }

  factory BuyerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BuyerData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      cnic: serializer.fromJson<String?>(json['cnic']),
      address: serializer.fromJson<String?>(json['address']),
      whatsappNumber: serializer.fromJson<String?>(json['whatsappNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'cnic': serializer.toJson<String?>(cnic),
      'address': serializer.toJson<String?>(address),
      'whatsappNumber': serializer.toJson<String?>(whatsappNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BuyerData copyWith({
    String? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> cnic = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> whatsappNumber = const Value.absent(),
    DateTime? createdAt,
  }) => BuyerData(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    cnic: cnic.present ? cnic.value : this.cnic,
    address: address.present ? address.value : this.address,
    whatsappNumber: whatsappNumber.present
        ? whatsappNumber.value
        : this.whatsappNumber,
    createdAt: createdAt ?? this.createdAt,
  );
  BuyerData copyWithCompanion(BuyersCompanion data) {
    return BuyerData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      cnic: data.cnic.present ? data.cnic.value : this.cnic,
      address: data.address.present ? data.address.value : this.address,
      whatsappNumber: data.whatsappNumber.present
          ? data.whatsappNumber.value
          : this.whatsappNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BuyerData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('cnic: $cnic, ')
          ..write('address: $address, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, cnic, address, whatsappNumber, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BuyerData &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.cnic == this.cnic &&
          other.address == this.address &&
          other.whatsappNumber == this.whatsappNumber &&
          other.createdAt == this.createdAt);
}

class BuyersCompanion extends UpdateCompanion<BuyerData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> cnic;
  final Value<String?> address;
  final Value<String?> whatsappNumber;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BuyersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.cnic = const Value.absent(),
    this.address = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BuyersCompanion.insert({
    required String id,
    required String name,
    this.phone = const Value.absent(),
    this.cnic = const Value.absent(),
    this.address = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<BuyerData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? cnic,
    Expression<String>? address,
    Expression<String>? whatsappNumber,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (cnic != null) 'cnic': cnic,
      if (address != null) 'address': address,
      if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BuyersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? cnic,
    Value<String?>? address,
    Value<String?>? whatsappNumber,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BuyersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      cnic: cnic ?? this.cnic,
      address: address ?? this.address,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (cnic.present) {
      map['cnic'] = Variable<String>(cnic.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (whatsappNumber.present) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuyersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('cnic: $cnic, ')
          ..write('address: $address, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, SaleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trailaIdMeta = const VerificationMeta(
    'trailaId',
  );
  @override
  late final GeneratedColumn<String> trailaId = GeneratedColumn<String>(
    'traila_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES trailas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _buyerIdMeta = const VerificationMeta(
    'buyerId',
  );
  @override
  late final GeneratedColumn<String> buyerId = GeneratedColumn<String>(
    'buyer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES buyers (id)',
    ),
  );
  static const VerificationMeta _salePriceMeta = const VerificationMeta(
    'salePrice',
  );
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
    'sale_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manufacturingCostMeta = const VerificationMeta(
    'manufacturingCost',
  );
  @override
  late final GeneratedColumn<double> manufacturingCost =
      GeneratedColumn<double>(
        'manufacturing_cost',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _profitMeta = const VerificationMeta('profit');
  @override
  late final GeneratedColumn<double> profit = GeneratedColumn<double>(
    'profit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _saleDateMeta = const VerificationMeta(
    'saleDate',
  );
  @override
  late final GeneratedColumn<DateTime> saleDate = GeneratedColumn<DateTime>(
    'sale_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingBalanceMeta = const VerificationMeta(
    'remainingBalance',
  );
  @override
  late final GeneratedColumn<double> remainingBalance = GeneratedColumn<double>(
    'remaining_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiptNumberMeta = const VerificationMeta(
    'receiptNumber',
  );
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
    'receipt_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _globalPreviousBalanceMeta =
      const VerificationMeta('globalPreviousBalance');
  @override
  late final GeneratedColumn<double> globalPreviousBalance =
      GeneratedColumn<double>(
        'global_previous_balance',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trailaId,
    buyerId,
    salePrice,
    manufacturingCost,
    profit,
    saleDate,
    paidAmount,
    remainingBalance,
    receiptNumber,
    globalPreviousBalance,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('traila_id')) {
      context.handle(
        _trailaIdMeta,
        trailaId.isAcceptableOrUnknown(data['traila_id']!, _trailaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trailaIdMeta);
    }
    if (data.containsKey('buyer_id')) {
      context.handle(
        _buyerIdMeta,
        buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_buyerIdMeta);
    }
    if (data.containsKey('sale_price')) {
      context.handle(
        _salePriceMeta,
        salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta),
      );
    } else if (isInserting) {
      context.missing(_salePriceMeta);
    }
    if (data.containsKey('manufacturing_cost')) {
      context.handle(
        _manufacturingCostMeta,
        manufacturingCost.isAcceptableOrUnknown(
          data['manufacturing_cost']!,
          _manufacturingCostMeta,
        ),
      );
    }
    if (data.containsKey('profit')) {
      context.handle(
        _profitMeta,
        profit.isAcceptableOrUnknown(data['profit']!, _profitMeta),
      );
    }
    if (data.containsKey('sale_date')) {
      context.handle(
        _saleDateMeta,
        saleDate.isAcceptableOrUnknown(data['sale_date']!, _saleDateMeta),
      );
    } else if (isInserting) {
      context.missing(_saleDateMeta);
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAmountMeta);
    }
    if (data.containsKey('remaining_balance')) {
      context.handle(
        _remainingBalanceMeta,
        remainingBalance.isAcceptableOrUnknown(
          data['remaining_balance']!,
          _remainingBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingBalanceMeta);
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _receiptNumberMeta,
        receiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _receiptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptNumberMeta);
    }
    if (data.containsKey('global_previous_balance')) {
      context.handle(
        _globalPreviousBalanceMeta,
        globalPreviousBalance.isAcceptableOrUnknown(
          data['global_previous_balance']!,
          _globalPreviousBalanceMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trailaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}traila_id'],
      )!,
      buyerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}buyer_id'],
      )!,
      salePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sale_price'],
      )!,
      manufacturingCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}manufacturing_cost'],
      )!,
      profit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}profit'],
      )!,
      saleDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sale_date'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paid_amount'],
      )!,
      remainingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}remaining_balance'],
      )!,
      receiptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_number'],
      )!,
      globalPreviousBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}global_previous_balance'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class SaleData extends DataClass implements Insertable<SaleData> {
  final String id;
  final String trailaId;
  final String buyerId;
  final double salePrice;
  final double manufacturingCost;
  final double profit;
  final DateTime saleDate;
  final double paidAmount;
  final double remainingBalance;
  final String receiptNumber;
  final double globalPreviousBalance;
  final DateTime createdAt;
  const SaleData({
    required this.id,
    required this.trailaId,
    required this.buyerId,
    required this.salePrice,
    required this.manufacturingCost,
    required this.profit,
    required this.saleDate,
    required this.paidAmount,
    required this.remainingBalance,
    required this.receiptNumber,
    required this.globalPreviousBalance,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['traila_id'] = Variable<String>(trailaId);
    map['buyer_id'] = Variable<String>(buyerId);
    map['sale_price'] = Variable<double>(salePrice);
    map['manufacturing_cost'] = Variable<double>(manufacturingCost);
    map['profit'] = Variable<double>(profit);
    map['sale_date'] = Variable<DateTime>(saleDate);
    map['paid_amount'] = Variable<double>(paidAmount);
    map['remaining_balance'] = Variable<double>(remainingBalance);
    map['receipt_number'] = Variable<String>(receiptNumber);
    map['global_previous_balance'] = Variable<double>(globalPreviousBalance);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      trailaId: Value(trailaId),
      buyerId: Value(buyerId),
      salePrice: Value(salePrice),
      manufacturingCost: Value(manufacturingCost),
      profit: Value(profit),
      saleDate: Value(saleDate),
      paidAmount: Value(paidAmount),
      remainingBalance: Value(remainingBalance),
      receiptNumber: Value(receiptNumber),
      globalPreviousBalance: Value(globalPreviousBalance),
      createdAt: Value(createdAt),
    );
  }

  factory SaleData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleData(
      id: serializer.fromJson<String>(json['id']),
      trailaId: serializer.fromJson<String>(json['trailaId']),
      buyerId: serializer.fromJson<String>(json['buyerId']),
      salePrice: serializer.fromJson<double>(json['salePrice']),
      manufacturingCost: serializer.fromJson<double>(json['manufacturingCost']),
      profit: serializer.fromJson<double>(json['profit']),
      saleDate: serializer.fromJson<DateTime>(json['saleDate']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      remainingBalance: serializer.fromJson<double>(json['remainingBalance']),
      receiptNumber: serializer.fromJson<String>(json['receiptNumber']),
      globalPreviousBalance: serializer.fromJson<double>(
        json['globalPreviousBalance'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trailaId': serializer.toJson<String>(trailaId),
      'buyerId': serializer.toJson<String>(buyerId),
      'salePrice': serializer.toJson<double>(salePrice),
      'manufacturingCost': serializer.toJson<double>(manufacturingCost),
      'profit': serializer.toJson<double>(profit),
      'saleDate': serializer.toJson<DateTime>(saleDate),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'remainingBalance': serializer.toJson<double>(remainingBalance),
      'receiptNumber': serializer.toJson<String>(receiptNumber),
      'globalPreviousBalance': serializer.toJson<double>(globalPreviousBalance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SaleData copyWith({
    String? id,
    String? trailaId,
    String? buyerId,
    double? salePrice,
    double? manufacturingCost,
    double? profit,
    DateTime? saleDate,
    double? paidAmount,
    double? remainingBalance,
    String? receiptNumber,
    double? globalPreviousBalance,
    DateTime? createdAt,
  }) => SaleData(
    id: id ?? this.id,
    trailaId: trailaId ?? this.trailaId,
    buyerId: buyerId ?? this.buyerId,
    salePrice: salePrice ?? this.salePrice,
    manufacturingCost: manufacturingCost ?? this.manufacturingCost,
    profit: profit ?? this.profit,
    saleDate: saleDate ?? this.saleDate,
    paidAmount: paidAmount ?? this.paidAmount,
    remainingBalance: remainingBalance ?? this.remainingBalance,
    receiptNumber: receiptNumber ?? this.receiptNumber,
    globalPreviousBalance: globalPreviousBalance ?? this.globalPreviousBalance,
    createdAt: createdAt ?? this.createdAt,
  );
  SaleData copyWithCompanion(SalesCompanion data) {
    return SaleData(
      id: data.id.present ? data.id.value : this.id,
      trailaId: data.trailaId.present ? data.trailaId.value : this.trailaId,
      buyerId: data.buyerId.present ? data.buyerId.value : this.buyerId,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      manufacturingCost: data.manufacturingCost.present
          ? data.manufacturingCost.value
          : this.manufacturingCost,
      profit: data.profit.present ? data.profit.value : this.profit,
      saleDate: data.saleDate.present ? data.saleDate.value : this.saleDate,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      remainingBalance: data.remainingBalance.present
          ? data.remainingBalance.value
          : this.remainingBalance,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      globalPreviousBalance: data.globalPreviousBalance.present
          ? data.globalPreviousBalance.value
          : this.globalPreviousBalance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleData(')
          ..write('id: $id, ')
          ..write('trailaId: $trailaId, ')
          ..write('buyerId: $buyerId, ')
          ..write('salePrice: $salePrice, ')
          ..write('manufacturingCost: $manufacturingCost, ')
          ..write('profit: $profit, ')
          ..write('saleDate: $saleDate, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('globalPreviousBalance: $globalPreviousBalance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    trailaId,
    buyerId,
    salePrice,
    manufacturingCost,
    profit,
    saleDate,
    paidAmount,
    remainingBalance,
    receiptNumber,
    globalPreviousBalance,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleData &&
          other.id == this.id &&
          other.trailaId == this.trailaId &&
          other.buyerId == this.buyerId &&
          other.salePrice == this.salePrice &&
          other.manufacturingCost == this.manufacturingCost &&
          other.profit == this.profit &&
          other.saleDate == this.saleDate &&
          other.paidAmount == this.paidAmount &&
          other.remainingBalance == this.remainingBalance &&
          other.receiptNumber == this.receiptNumber &&
          other.globalPreviousBalance == this.globalPreviousBalance &&
          other.createdAt == this.createdAt);
}

class SalesCompanion extends UpdateCompanion<SaleData> {
  final Value<String> id;
  final Value<String> trailaId;
  final Value<String> buyerId;
  final Value<double> salePrice;
  final Value<double> manufacturingCost;
  final Value<double> profit;
  final Value<DateTime> saleDate;
  final Value<double> paidAmount;
  final Value<double> remainingBalance;
  final Value<String> receiptNumber;
  final Value<double> globalPreviousBalance;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.trailaId = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.manufacturingCost = const Value.absent(),
    this.profit = const Value.absent(),
    this.saleDate = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainingBalance = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.globalPreviousBalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String id,
    required String trailaId,
    required String buyerId,
    required double salePrice,
    this.manufacturingCost = const Value.absent(),
    this.profit = const Value.absent(),
    required DateTime saleDate,
    required double paidAmount,
    required double remainingBalance,
    required String receiptNumber,
    this.globalPreviousBalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       trailaId = Value(trailaId),
       buyerId = Value(buyerId),
       salePrice = Value(salePrice),
       saleDate = Value(saleDate),
       paidAmount = Value(paidAmount),
       remainingBalance = Value(remainingBalance),
       receiptNumber = Value(receiptNumber);
  static Insertable<SaleData> custom({
    Expression<String>? id,
    Expression<String>? trailaId,
    Expression<String>? buyerId,
    Expression<double>? salePrice,
    Expression<double>? manufacturingCost,
    Expression<double>? profit,
    Expression<DateTime>? saleDate,
    Expression<double>? paidAmount,
    Expression<double>? remainingBalance,
    Expression<String>? receiptNumber,
    Expression<double>? globalPreviousBalance,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trailaId != null) 'traila_id': trailaId,
      if (buyerId != null) 'buyer_id': buyerId,
      if (salePrice != null) 'sale_price': salePrice,
      if (manufacturingCost != null) 'manufacturing_cost': manufacturingCost,
      if (profit != null) 'profit': profit,
      if (saleDate != null) 'sale_date': saleDate,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (remainingBalance != null) 'remaining_balance': remainingBalance,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (globalPreviousBalance != null)
        'global_previous_balance': globalPreviousBalance,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith({
    Value<String>? id,
    Value<String>? trailaId,
    Value<String>? buyerId,
    Value<double>? salePrice,
    Value<double>? manufacturingCost,
    Value<double>? profit,
    Value<DateTime>? saleDate,
    Value<double>? paidAmount,
    Value<double>? remainingBalance,
    Value<String>? receiptNumber,
    Value<double>? globalPreviousBalance,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      trailaId: trailaId ?? this.trailaId,
      buyerId: buyerId ?? this.buyerId,
      salePrice: salePrice ?? this.salePrice,
      manufacturingCost: manufacturingCost ?? this.manufacturingCost,
      profit: profit ?? this.profit,
      saleDate: saleDate ?? this.saleDate,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      globalPreviousBalance:
          globalPreviousBalance ?? this.globalPreviousBalance,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trailaId.present) {
      map['traila_id'] = Variable<String>(trailaId.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<String>(buyerId.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (manufacturingCost.present) {
      map['manufacturing_cost'] = Variable<double>(manufacturingCost.value);
    }
    if (profit.present) {
      map['profit'] = Variable<double>(profit.value);
    }
    if (saleDate.present) {
      map['sale_date'] = Variable<DateTime>(saleDate.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (remainingBalance.present) {
      map['remaining_balance'] = Variable<double>(remainingBalance.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (globalPreviousBalance.present) {
      map['global_previous_balance'] = Variable<double>(
        globalPreviousBalance.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('trailaId: $trailaId, ')
          ..write('buyerId: $buyerId, ')
          ..write('salePrice: $salePrice, ')
          ..write('manufacturingCost: $manufacturingCost, ')
          ..write('profit: $profit, ')
          ..write('saleDate: $saleDate, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('globalPreviousBalance: $globalPreviousBalance, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingData extends DataClass implements Insertable<AppSettingData> {
  final String key;
  final String value;
  const AppSettingData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSettingData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingData copyWith({String? key, String? value}) =>
      AppSettingData(key: key ?? this.key, value: value ?? this.value);
  AppSettingData copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingData &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSettingData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppProfilesTable extends AppProfiles
    with TableInfo<$AppProfilesTable, AppProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessNameMeta = const VerificationMeta(
    'businessName',
  );
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
    'business_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerNameMeta = const VerificationMeta(
    'ownerName',
  );
  @override
  late final GeneratedColumn<String> ownerName = GeneratedColumn<String>(
    'owner_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _businessTypeMeta = const VerificationMeta(
    'businessType',
  );
  @override
  late final GeneratedColumn<String> businessType = GeneratedColumn<String>(
    'business_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _whatsappNumberMeta = const VerificationMeta(
    'whatsappNumber',
  );
  @override
  late final GeneratedColumn<String> whatsappNumber = GeneratedColumn<String>(
    'whatsapp_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    businessName,
    ownerName,
    phoneNumber,
    address,
    businessType,
    whatsappNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_name')) {
      context.handle(
        _businessNameMeta,
        businessName.isAcceptableOrUnknown(
          data['business_name']!,
          _businessNameMeta,
        ),
      );
    }
    if (data.containsKey('owner_name')) {
      context.handle(
        _ownerNameMeta,
        ownerName.isAcceptableOrUnknown(data['owner_name']!, _ownerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerNameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('business_type')) {
      context.handle(
        _businessTypeMeta,
        businessType.isAcceptableOrUnknown(
          data['business_type']!,
          _businessTypeMeta,
        ),
      );
    }
    if (data.containsKey('whatsapp_number')) {
      context.handle(
        _whatsappNumberMeta,
        whatsappNumber.isAcceptableOrUnknown(
          data['whatsapp_number']!,
          _whatsappNumberMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppProfileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      businessName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_name'],
      ),
      ownerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      businessType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_type'],
      ),
      whatsappNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp_number'],
      ),
    );
  }

  @override
  $AppProfilesTable createAlias(String alias) {
    return $AppProfilesTable(attachedDatabase, alias);
  }
}

class AppProfileData extends DataClass implements Insertable<AppProfileData> {
  final String id;
  final String? businessName;
  final String ownerName;
  final String phoneNumber;
  final String? address;
  final String? businessType;
  final String? whatsappNumber;
  const AppProfileData({
    required this.id,
    this.businessName,
    required this.ownerName,
    required this.phoneNumber,
    this.address,
    this.businessType,
    this.whatsappNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || businessName != null) {
      map['business_name'] = Variable<String>(businessName);
    }
    map['owner_name'] = Variable<String>(ownerName);
    map['phone_number'] = Variable<String>(phoneNumber);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || businessType != null) {
      map['business_type'] = Variable<String>(businessType);
    }
    if (!nullToAbsent || whatsappNumber != null) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber);
    }
    return map;
  }

  AppProfilesCompanion toCompanion(bool nullToAbsent) {
    return AppProfilesCompanion(
      id: Value(id),
      businessName: businessName == null && nullToAbsent
          ? const Value.absent()
          : Value(businessName),
      ownerName: Value(ownerName),
      phoneNumber: Value(phoneNumber),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      businessType: businessType == null && nullToAbsent
          ? const Value.absent()
          : Value(businessType),
      whatsappNumber: whatsappNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsappNumber),
    );
  }

  factory AppProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppProfileData(
      id: serializer.fromJson<String>(json['id']),
      businessName: serializer.fromJson<String?>(json['businessName']),
      ownerName: serializer.fromJson<String>(json['ownerName']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      address: serializer.fromJson<String?>(json['address']),
      businessType: serializer.fromJson<String?>(json['businessType']),
      whatsappNumber: serializer.fromJson<String?>(json['whatsappNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessName': serializer.toJson<String?>(businessName),
      'ownerName': serializer.toJson<String>(ownerName),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'address': serializer.toJson<String?>(address),
      'businessType': serializer.toJson<String?>(businessType),
      'whatsappNumber': serializer.toJson<String?>(whatsappNumber),
    };
  }

  AppProfileData copyWith({
    String? id,
    Value<String?> businessName = const Value.absent(),
    String? ownerName,
    String? phoneNumber,
    Value<String?> address = const Value.absent(),
    Value<String?> businessType = const Value.absent(),
    Value<String?> whatsappNumber = const Value.absent(),
  }) => AppProfileData(
    id: id ?? this.id,
    businessName: businessName.present ? businessName.value : this.businessName,
    ownerName: ownerName ?? this.ownerName,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    address: address.present ? address.value : this.address,
    businessType: businessType.present ? businessType.value : this.businessType,
    whatsappNumber: whatsappNumber.present
        ? whatsappNumber.value
        : this.whatsappNumber,
  );
  AppProfileData copyWithCompanion(AppProfilesCompanion data) {
    return AppProfileData(
      id: data.id.present ? data.id.value : this.id,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      ownerName: data.ownerName.present ? data.ownerName.value : this.ownerName,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      address: data.address.present ? data.address.value : this.address,
      businessType: data.businessType.present
          ? data.businessType.value
          : this.businessType,
      whatsappNumber: data.whatsappNumber.present
          ? data.whatsappNumber.value
          : this.whatsappNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppProfileData(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('ownerName: $ownerName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('address: $address, ')
          ..write('businessType: $businessType, ')
          ..write('whatsappNumber: $whatsappNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    businessName,
    ownerName,
    phoneNumber,
    address,
    businessType,
    whatsappNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppProfileData &&
          other.id == this.id &&
          other.businessName == this.businessName &&
          other.ownerName == this.ownerName &&
          other.phoneNumber == this.phoneNumber &&
          other.address == this.address &&
          other.businessType == this.businessType &&
          other.whatsappNumber == this.whatsappNumber);
}

class AppProfilesCompanion extends UpdateCompanion<AppProfileData> {
  final Value<String> id;
  final Value<String?> businessName;
  final Value<String> ownerName;
  final Value<String> phoneNumber;
  final Value<String?> address;
  final Value<String?> businessType;
  final Value<String?> whatsappNumber;
  final Value<int> rowid;
  const AppProfilesCompanion({
    this.id = const Value.absent(),
    this.businessName = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.address = const Value.absent(),
    this.businessType = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppProfilesCompanion.insert({
    required String id,
    this.businessName = const Value.absent(),
    required String ownerName,
    required String phoneNumber,
    this.address = const Value.absent(),
    this.businessType = const Value.absent(),
    this.whatsappNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerName = Value(ownerName),
       phoneNumber = Value(phoneNumber);
  static Insertable<AppProfileData> custom({
    Expression<String>? id,
    Expression<String>? businessName,
    Expression<String>? ownerName,
    Expression<String>? phoneNumber,
    Expression<String>? address,
    Expression<String>? businessType,
    Expression<String>? whatsappNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessName != null) 'business_name': businessName,
      if (ownerName != null) 'owner_name': ownerName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (address != null) 'address': address,
      if (businessType != null) 'business_type': businessType,
      if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppProfilesCompanion copyWith({
    Value<String>? id,
    Value<String?>? businessName,
    Value<String>? ownerName,
    Value<String>? phoneNumber,
    Value<String?>? address,
    Value<String?>? businessType,
    Value<String?>? whatsappNumber,
    Value<int>? rowid,
  }) {
    return AppProfilesCompanion(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      businessType: businessType ?? this.businessType,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (ownerName.present) {
      map['owner_name'] = Variable<String>(ownerName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (businessType.present) {
      map['business_type'] = Variable<String>(businessType.value);
    }
    if (whatsappNumber.present) {
      map['whatsapp_number'] = Variable<String>(whatsappNumber.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppProfilesCompanion(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('ownerName: $ownerName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('address: $address, ')
          ..write('businessType: $businessType, ')
          ..write('whatsappNumber: $whatsappNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _iconTypeMeta = const VerificationMeta(
    'iconType',
  );
  @override
  late final GeneratedColumn<String> iconType = GeneratedColumn<String>(
    'icon_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    balance,
    type,
    iconType,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('icon_type')) {
      context.handle(
        _iconTypeMeta,
        iconType.isAcceptableOrUnknown(data['icon_type']!, _iconTypeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      iconType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_type'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class AccountData extends DataClass implements Insertable<AccountData> {
  final String id;
  final String name;
  final double balance;
  final String type;
  final String? iconType;
  final DateTime createdAt;
  const AccountData({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
    this.iconType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['balance'] = Variable<double>(balance);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || iconType != null) {
      map['icon_type'] = Variable<String>(iconType);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      balance: Value(balance),
      type: Value(type),
      iconType: iconType == null && nullToAbsent
          ? const Value.absent()
          : Value(iconType),
      createdAt: Value(createdAt),
    );
  }

  factory AccountData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      balance: serializer.fromJson<double>(json['balance']),
      type: serializer.fromJson<String>(json['type']),
      iconType: serializer.fromJson<String?>(json['iconType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'balance': serializer.toJson<double>(balance),
      'type': serializer.toJson<String>(type),
      'iconType': serializer.toJson<String?>(iconType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AccountData copyWith({
    String? id,
    String? name,
    double? balance,
    String? type,
    Value<String?> iconType = const Value.absent(),
    DateTime? createdAt,
  }) => AccountData(
    id: id ?? this.id,
    name: name ?? this.name,
    balance: balance ?? this.balance,
    type: type ?? this.type,
    iconType: iconType.present ? iconType.value : this.iconType,
    createdAt: createdAt ?? this.createdAt,
  );
  AccountData copyWithCompanion(AccountsCompanion data) {
    return AccountData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      balance: data.balance.present ? data.balance.value : this.balance,
      type: data.type.present ? data.type.value : this.type,
      iconType: data.iconType.present ? data.iconType.value : this.iconType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balance: $balance, ')
          ..write('type: $type, ')
          ..write('iconType: $iconType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, balance, type, iconType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountData &&
          other.id == this.id &&
          other.name == this.name &&
          other.balance == this.balance &&
          other.type == this.type &&
          other.iconType == this.iconType &&
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<AccountData> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> balance;
  final Value<String> type;
  final Value<String?> iconType;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.balance = const Value.absent(),
    this.type = const Value.absent(),
    this.iconType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String name,
    this.balance = const Value.absent(),
    this.type = const Value.absent(),
    this.iconType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<AccountData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? balance,
    Expression<String>? type,
    Expression<String>? iconType,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (balance != null) 'balance': balance,
      if (type != null) 'type': type,
      if (iconType != null) 'icon_type': iconType,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? balance,
    Value<String>? type,
    Value<String?>? iconType,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      type: type ?? this.type,
      iconType: iconType ?? this.iconType,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (iconType.present) {
      map['icon_type'] = Variable<String>(iconType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balance: $balance, ')
          ..write('type: $type, ')
          ..write('iconType: $iconType, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrinterSettingsTable extends PrinterSettings
    with TableInfo<$PrinterSettingsTable, PrinterSettingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrinterSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('default'),
  );
  static const VerificationMeta _deviceNameMeta = const VerificationMeta(
    'deviceName',
  );
  @override
  late final GeneratedColumn<String> deviceName = GeneratedColumn<String>(
    'device_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceAddressMeta = const VerificationMeta(
    'deviceAddress',
  );
  @override
  late final GeneratedColumn<String> deviceAddress = GeneratedColumn<String>(
    'device_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vendorIdMeta = const VerificationMeta(
    'vendorId',
  );
  @override
  late final GeneratedColumn<String> vendorId = GeneratedColumn<String>(
    'vendor_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paperSizeMeta = const VerificationMeta(
    'paperSize',
  );
  @override
  late final GeneratedColumn<String> paperSize = GeneratedColumn<String>(
    'paper_size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('58mm'),
  );
  static const VerificationMeta _connectionTypeMeta = const VerificationMeta(
    'connectionType',
  );
  @override
  late final GeneratedColumn<String> connectionType = GeneratedColumn<String>(
    'connection_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USB'),
  );
  static const VerificationMeta _autoCutMeta = const VerificationMeta(
    'autoCut',
  );
  @override
  late final GeneratedColumn<bool> autoCut = GeneratedColumn<bool>(
    'auto_cut',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_cut" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _autoPrintMeta = const VerificationMeta(
    'autoPrint',
  );
  @override
  late final GeneratedColumn<bool> autoPrint = GeneratedColumn<bool>(
    'auto_print',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_print" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceName,
    deviceAddress,
    vendorId,
    productId,
    paperSize,
    connectionType,
    autoCut,
    autoPrint,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'printer_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrinterSettingData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_name')) {
      context.handle(
        _deviceNameMeta,
        deviceName.isAcceptableOrUnknown(data['device_name']!, _deviceNameMeta),
      );
    }
    if (data.containsKey('device_address')) {
      context.handle(
        _deviceAddressMeta,
        deviceAddress.isAcceptableOrUnknown(
          data['device_address']!,
          _deviceAddressMeta,
        ),
      );
    }
    if (data.containsKey('vendor_id')) {
      context.handle(
        _vendorIdMeta,
        vendorId.isAcceptableOrUnknown(data['vendor_id']!, _vendorIdMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('paper_size')) {
      context.handle(
        _paperSizeMeta,
        paperSize.isAcceptableOrUnknown(data['paper_size']!, _paperSizeMeta),
      );
    }
    if (data.containsKey('connection_type')) {
      context.handle(
        _connectionTypeMeta,
        connectionType.isAcceptableOrUnknown(
          data['connection_type']!,
          _connectionTypeMeta,
        ),
      );
    }
    if (data.containsKey('auto_cut')) {
      context.handle(
        _autoCutMeta,
        autoCut.isAcceptableOrUnknown(data['auto_cut']!, _autoCutMeta),
      );
    }
    if (data.containsKey('auto_print')) {
      context.handle(
        _autoPrintMeta,
        autoPrint.isAcceptableOrUnknown(data['auto_print']!, _autoPrintMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrinterSettingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrinterSettingData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deviceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_name'],
      ),
      deviceAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_address'],
      ),
      vendorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor_id'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      paperSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paper_size'],
      )!,
      connectionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}connection_type'],
      )!,
      autoCut: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_cut'],
      )!,
      autoPrint: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_print'],
      )!,
    );
  }

  @override
  $PrinterSettingsTable createAlias(String alias) {
    return $PrinterSettingsTable(attachedDatabase, alias);
  }
}

class PrinterSettingData extends DataClass
    implements Insertable<PrinterSettingData> {
  final String id;
  final String? deviceName;
  final String? deviceAddress;
  final String? vendorId;
  final String? productId;
  final String paperSize;
  final String connectionType;
  final bool autoCut;
  final bool autoPrint;
  const PrinterSettingData({
    required this.id,
    this.deviceName,
    this.deviceAddress,
    this.vendorId,
    this.productId,
    required this.paperSize,
    required this.connectionType,
    required this.autoCut,
    required this.autoPrint,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || deviceName != null) {
      map['device_name'] = Variable<String>(deviceName);
    }
    if (!nullToAbsent || deviceAddress != null) {
      map['device_address'] = Variable<String>(deviceAddress);
    }
    if (!nullToAbsent || vendorId != null) {
      map['vendor_id'] = Variable<String>(vendorId);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    map['paper_size'] = Variable<String>(paperSize);
    map['connection_type'] = Variable<String>(connectionType);
    map['auto_cut'] = Variable<bool>(autoCut);
    map['auto_print'] = Variable<bool>(autoPrint);
    return map;
  }

  PrinterSettingsCompanion toCompanion(bool nullToAbsent) {
    return PrinterSettingsCompanion(
      id: Value(id),
      deviceName: deviceName == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceName),
      deviceAddress: deviceAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceAddress),
      vendorId: vendorId == null && nullToAbsent
          ? const Value.absent()
          : Value(vendorId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      paperSize: Value(paperSize),
      connectionType: Value(connectionType),
      autoCut: Value(autoCut),
      autoPrint: Value(autoPrint),
    );
  }

  factory PrinterSettingData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrinterSettingData(
      id: serializer.fromJson<String>(json['id']),
      deviceName: serializer.fromJson<String?>(json['deviceName']),
      deviceAddress: serializer.fromJson<String?>(json['deviceAddress']),
      vendorId: serializer.fromJson<String?>(json['vendorId']),
      productId: serializer.fromJson<String?>(json['productId']),
      paperSize: serializer.fromJson<String>(json['paperSize']),
      connectionType: serializer.fromJson<String>(json['connectionType']),
      autoCut: serializer.fromJson<bool>(json['autoCut']),
      autoPrint: serializer.fromJson<bool>(json['autoPrint']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deviceName': serializer.toJson<String?>(deviceName),
      'deviceAddress': serializer.toJson<String?>(deviceAddress),
      'vendorId': serializer.toJson<String?>(vendorId),
      'productId': serializer.toJson<String?>(productId),
      'paperSize': serializer.toJson<String>(paperSize),
      'connectionType': serializer.toJson<String>(connectionType),
      'autoCut': serializer.toJson<bool>(autoCut),
      'autoPrint': serializer.toJson<bool>(autoPrint),
    };
  }

  PrinterSettingData copyWith({
    String? id,
    Value<String?> deviceName = const Value.absent(),
    Value<String?> deviceAddress = const Value.absent(),
    Value<String?> vendorId = const Value.absent(),
    Value<String?> productId = const Value.absent(),
    String? paperSize,
    String? connectionType,
    bool? autoCut,
    bool? autoPrint,
  }) => PrinterSettingData(
    id: id ?? this.id,
    deviceName: deviceName.present ? deviceName.value : this.deviceName,
    deviceAddress: deviceAddress.present
        ? deviceAddress.value
        : this.deviceAddress,
    vendorId: vendorId.present ? vendorId.value : this.vendorId,
    productId: productId.present ? productId.value : this.productId,
    paperSize: paperSize ?? this.paperSize,
    connectionType: connectionType ?? this.connectionType,
    autoCut: autoCut ?? this.autoCut,
    autoPrint: autoPrint ?? this.autoPrint,
  );
  PrinterSettingData copyWithCompanion(PrinterSettingsCompanion data) {
    return PrinterSettingData(
      id: data.id.present ? data.id.value : this.id,
      deviceName: data.deviceName.present
          ? data.deviceName.value
          : this.deviceName,
      deviceAddress: data.deviceAddress.present
          ? data.deviceAddress.value
          : this.deviceAddress,
      vendorId: data.vendorId.present ? data.vendorId.value : this.vendorId,
      productId: data.productId.present ? data.productId.value : this.productId,
      paperSize: data.paperSize.present ? data.paperSize.value : this.paperSize,
      connectionType: data.connectionType.present
          ? data.connectionType.value
          : this.connectionType,
      autoCut: data.autoCut.present ? data.autoCut.value : this.autoCut,
      autoPrint: data.autoPrint.present ? data.autoPrint.value : this.autoPrint,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrinterSettingData(')
          ..write('id: $id, ')
          ..write('deviceName: $deviceName, ')
          ..write('deviceAddress: $deviceAddress, ')
          ..write('vendorId: $vendorId, ')
          ..write('productId: $productId, ')
          ..write('paperSize: $paperSize, ')
          ..write('connectionType: $connectionType, ')
          ..write('autoCut: $autoCut, ')
          ..write('autoPrint: $autoPrint')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceName,
    deviceAddress,
    vendorId,
    productId,
    paperSize,
    connectionType,
    autoCut,
    autoPrint,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrinterSettingData &&
          other.id == this.id &&
          other.deviceName == this.deviceName &&
          other.deviceAddress == this.deviceAddress &&
          other.vendorId == this.vendorId &&
          other.productId == this.productId &&
          other.paperSize == this.paperSize &&
          other.connectionType == this.connectionType &&
          other.autoCut == this.autoCut &&
          other.autoPrint == this.autoPrint);
}

class PrinterSettingsCompanion extends UpdateCompanion<PrinterSettingData> {
  final Value<String> id;
  final Value<String?> deviceName;
  final Value<String?> deviceAddress;
  final Value<String?> vendorId;
  final Value<String?> productId;
  final Value<String> paperSize;
  final Value<String> connectionType;
  final Value<bool> autoCut;
  final Value<bool> autoPrint;
  final Value<int> rowid;
  const PrinterSettingsCompanion({
    this.id = const Value.absent(),
    this.deviceName = const Value.absent(),
    this.deviceAddress = const Value.absent(),
    this.vendorId = const Value.absent(),
    this.productId = const Value.absent(),
    this.paperSize = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.autoCut = const Value.absent(),
    this.autoPrint = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrinterSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.deviceName = const Value.absent(),
    this.deviceAddress = const Value.absent(),
    this.vendorId = const Value.absent(),
    this.productId = const Value.absent(),
    this.paperSize = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.autoCut = const Value.absent(),
    this.autoPrint = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<PrinterSettingData> custom({
    Expression<String>? id,
    Expression<String>? deviceName,
    Expression<String>? deviceAddress,
    Expression<String>? vendorId,
    Expression<String>? productId,
    Expression<String>? paperSize,
    Expression<String>? connectionType,
    Expression<bool>? autoCut,
    Expression<bool>? autoPrint,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceName != null) 'device_name': deviceName,
      if (deviceAddress != null) 'device_address': deviceAddress,
      if (vendorId != null) 'vendor_id': vendorId,
      if (productId != null) 'product_id': productId,
      if (paperSize != null) 'paper_size': paperSize,
      if (connectionType != null) 'connection_type': connectionType,
      if (autoCut != null) 'auto_cut': autoCut,
      if (autoPrint != null) 'auto_print': autoPrint,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrinterSettingsCompanion copyWith({
    Value<String>? id,
    Value<String?>? deviceName,
    Value<String?>? deviceAddress,
    Value<String?>? vendorId,
    Value<String?>? productId,
    Value<String>? paperSize,
    Value<String>? connectionType,
    Value<bool>? autoCut,
    Value<bool>? autoPrint,
    Value<int>? rowid,
  }) {
    return PrinterSettingsCompanion(
      id: id ?? this.id,
      deviceName: deviceName ?? this.deviceName,
      deviceAddress: deviceAddress ?? this.deviceAddress,
      vendorId: vendorId ?? this.vendorId,
      productId: productId ?? this.productId,
      paperSize: paperSize ?? this.paperSize,
      connectionType: connectionType ?? this.connectionType,
      autoCut: autoCut ?? this.autoCut,
      autoPrint: autoPrint ?? this.autoPrint,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deviceName.present) {
      map['device_name'] = Variable<String>(deviceName.value);
    }
    if (deviceAddress.present) {
      map['device_address'] = Variable<String>(deviceAddress.value);
    }
    if (vendorId.present) {
      map['vendor_id'] = Variable<String>(vendorId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (paperSize.present) {
      map['paper_size'] = Variable<String>(paperSize.value);
    }
    if (connectionType.present) {
      map['connection_type'] = Variable<String>(connectionType.value);
    }
    if (autoCut.present) {
      map['auto_cut'] = Variable<bool>(autoCut.value);
    }
    if (autoPrint.present) {
      map['auto_print'] = Variable<bool>(autoPrint.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrinterSettingsCompanion(')
          ..write('id: $id, ')
          ..write('deviceName: $deviceName, ')
          ..write('deviceAddress: $deviceAddress, ')
          ..write('vendorId: $vendorId, ')
          ..write('productId: $productId, ')
          ..write('paperSize: $paperSize, ')
          ..write('connectionType: $connectionType, ')
          ..write('autoCut: $autoCut, ')
          ..write('autoPrint: $autoPrint, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KhatasTable extends Khatas with TableInfo<$KhatasTable, KhataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KhatasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personNameMeta = const VerificationMeta(
    'personName',
  );
  @override
  late final GeneratedColumn<String> personName = GeneratedColumn<String>(
    'person_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingBalanceMeta = const VerificationMeta(
    'openingBalance',
  );
  @override
  late final GeneratedColumn<double> openingBalance = GeneratedColumn<double>(
    'opening_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _remainingBalanceMeta = const VerificationMeta(
    'remainingBalance',
  );
  @override
  late final GeneratedColumn<double> remainingBalance = GeneratedColumn<double>(
    'remaining_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personName,
    openingBalance,
    totalAmount,
    paidAmount,
    remainingBalance,
    date,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'khatas';
  @override
  VerificationContext validateIntegrity(
    Insertable<KhataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('person_name')) {
      context.handle(
        _personNameMeta,
        personName.isAcceptableOrUnknown(data['person_name']!, _personNameMeta),
      );
    } else if (isInserting) {
      context.missing(_personNameMeta);
    }
    if (data.containsKey('opening_balance')) {
      context.handle(
        _openingBalanceMeta,
        openingBalance.isAcceptableOrUnknown(
          data['opening_balance']!,
          _openingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    }
    if (data.containsKey('remaining_balance')) {
      context.handle(
        _remainingBalanceMeta,
        remainingBalance.isAcceptableOrUnknown(
          data['remaining_balance']!,
          _remainingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KhataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KhataData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      personName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_name'],
      )!,
      openingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}opening_balance'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paid_amount'],
      )!,
      remainingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}remaining_balance'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $KhatasTable createAlias(String alias) {
    return $KhatasTable(attachedDatabase, alias);
  }
}

class KhataData extends DataClass implements Insertable<KhataData> {
  final String id;
  final String personName;
  final double openingBalance;
  final double totalAmount;
  final double paidAmount;
  final double remainingBalance;
  final DateTime date;
  final DateTime createdAt;
  const KhataData({
    required this.id,
    required this.personName,
    required this.openingBalance,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingBalance,
    required this.date,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['person_name'] = Variable<String>(personName);
    map['opening_balance'] = Variable<double>(openingBalance);
    map['total_amount'] = Variable<double>(totalAmount);
    map['paid_amount'] = Variable<double>(paidAmount);
    map['remaining_balance'] = Variable<double>(remainingBalance);
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  KhatasCompanion toCompanion(bool nullToAbsent) {
    return KhatasCompanion(
      id: Value(id),
      personName: Value(personName),
      openingBalance: Value(openingBalance),
      totalAmount: Value(totalAmount),
      paidAmount: Value(paidAmount),
      remainingBalance: Value(remainingBalance),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory KhataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KhataData(
      id: serializer.fromJson<String>(json['id']),
      personName: serializer.fromJson<String>(json['personName']),
      openingBalance: serializer.fromJson<double>(json['openingBalance']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      remainingBalance: serializer.fromJson<double>(json['remainingBalance']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'personName': serializer.toJson<String>(personName),
      'openingBalance': serializer.toJson<double>(openingBalance),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'remainingBalance': serializer.toJson<double>(remainingBalance),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  KhataData copyWith({
    String? id,
    String? personName,
    double? openingBalance,
    double? totalAmount,
    double? paidAmount,
    double? remainingBalance,
    DateTime? date,
    DateTime? createdAt,
  }) => KhataData(
    id: id ?? this.id,
    personName: personName ?? this.personName,
    openingBalance: openingBalance ?? this.openingBalance,
    totalAmount: totalAmount ?? this.totalAmount,
    paidAmount: paidAmount ?? this.paidAmount,
    remainingBalance: remainingBalance ?? this.remainingBalance,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
  );
  KhataData copyWithCompanion(KhatasCompanion data) {
    return KhataData(
      id: data.id.present ? data.id.value : this.id,
      personName: data.personName.present
          ? data.personName.value
          : this.personName,
      openingBalance: data.openingBalance.present
          ? data.openingBalance.value
          : this.openingBalance,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      remainingBalance: data.remainingBalance.present
          ? data.remainingBalance.value
          : this.remainingBalance,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KhataData(')
          ..write('id: $id, ')
          ..write('personName: $personName, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personName,
    openingBalance,
    totalAmount,
    paidAmount,
    remainingBalance,
    date,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KhataData &&
          other.id == this.id &&
          other.personName == this.personName &&
          other.openingBalance == this.openingBalance &&
          other.totalAmount == this.totalAmount &&
          other.paidAmount == this.paidAmount &&
          other.remainingBalance == this.remainingBalance &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class KhatasCompanion extends UpdateCompanion<KhataData> {
  final Value<String> id;
  final Value<String> personName;
  final Value<double> openingBalance;
  final Value<double> totalAmount;
  final Value<double> paidAmount;
  final Value<double> remainingBalance;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const KhatasCompanion({
    this.id = const Value.absent(),
    this.personName = const Value.absent(),
    this.openingBalance = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainingBalance = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KhatasCompanion.insert({
    required String id,
    required String personName,
    this.openingBalance = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.remainingBalance = const Value.absent(),
    required DateTime date,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       personName = Value(personName),
       date = Value(date);
  static Insertable<KhataData> custom({
    Expression<String>? id,
    Expression<String>? personName,
    Expression<double>? openingBalance,
    Expression<double>? totalAmount,
    Expression<double>? paidAmount,
    Expression<double>? remainingBalance,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personName != null) 'person_name': personName,
      if (openingBalance != null) 'opening_balance': openingBalance,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (remainingBalance != null) 'remaining_balance': remainingBalance,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KhatasCompanion copyWith({
    Value<String>? id,
    Value<String>? personName,
    Value<double>? openingBalance,
    Value<double>? totalAmount,
    Value<double>? paidAmount,
    Value<double>? remainingBalance,
    Value<DateTime>? date,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return KhatasCompanion(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      openingBalance: openingBalance ?? this.openingBalance,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (personName.present) {
      map['person_name'] = Variable<String>(personName.value);
    }
    if (openingBalance.present) {
      map['opening_balance'] = Variable<double>(openingBalance.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (remainingBalance.present) {
      map['remaining_balance'] = Variable<double>(remainingBalance.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KhatasCompanion(')
          ..write('id: $id, ')
          ..write('personName: $personName, ')
          ..write('openingBalance: $openingBalance, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KhataItemsTable extends KhataItems
    with TableInfo<$KhataItemsTable, KhataItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KhataItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _khataIdMeta = const VerificationMeta(
    'khataId',
  );
  @override
  late final GeneratedColumn<String> khataId = GeneratedColumn<String>(
    'khata_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES khatas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('cashOut'),
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    khataId,
    itemName,
    price,
    type,
    paymentMethod,
    date,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'khata_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<KhataItemData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('khata_id')) {
      context.handle(
        _khataIdMeta,
        khataId.isAcceptableOrUnknown(data['khata_id']!, _khataIdMeta),
      );
    } else if (isInserting) {
      context.missing(_khataIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KhataItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KhataItemData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      khataId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}khata_id'],
      )!,
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $KhataItemsTable createAlias(String alias) {
    return $KhataItemsTable(attachedDatabase, alias);
  }
}

class KhataItemData extends DataClass implements Insertable<KhataItemData> {
  final int id;
  final String khataId;
  final String? itemName;
  final double price;
  final String type;
  final String? paymentMethod;
  final DateTime date;
  final DateTime createdAt;
  const KhataItemData({
    required this.id,
    required this.khataId,
    this.itemName,
    required this.price,
    required this.type,
    this.paymentMethod,
    required this.date,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['khata_id'] = Variable<String>(khataId);
    if (!nullToAbsent || itemName != null) {
      map['item_name'] = Variable<String>(itemName);
    }
    map['price'] = Variable<double>(price);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  KhataItemsCompanion toCompanion(bool nullToAbsent) {
    return KhataItemsCompanion(
      id: Value(id),
      khataId: Value(khataId),
      itemName: itemName == null && nullToAbsent
          ? const Value.absent()
          : Value(itemName),
      price: Value(price),
      type: Value(type),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory KhataItemData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KhataItemData(
      id: serializer.fromJson<int>(json['id']),
      khataId: serializer.fromJson<String>(json['khataId']),
      itemName: serializer.fromJson<String?>(json['itemName']),
      price: serializer.fromJson<double>(json['price']),
      type: serializer.fromJson<String>(json['type']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'khataId': serializer.toJson<String>(khataId),
      'itemName': serializer.toJson<String?>(itemName),
      'price': serializer.toJson<double>(price),
      'type': serializer.toJson<String>(type),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  KhataItemData copyWith({
    int? id,
    String? khataId,
    Value<String?> itemName = const Value.absent(),
    double? price,
    String? type,
    Value<String?> paymentMethod = const Value.absent(),
    DateTime? date,
    DateTime? createdAt,
  }) => KhataItemData(
    id: id ?? this.id,
    khataId: khataId ?? this.khataId,
    itemName: itemName.present ? itemName.value : this.itemName,
    price: price ?? this.price,
    type: type ?? this.type,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
  );
  KhataItemData copyWithCompanion(KhataItemsCompanion data) {
    return KhataItemData(
      id: data.id.present ? data.id.value : this.id,
      khataId: data.khataId.present ? data.khataId.value : this.khataId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      price: data.price.present ? data.price.value : this.price,
      type: data.type.present ? data.type.value : this.type,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KhataItemData(')
          ..write('id: $id, ')
          ..write('khataId: $khataId, ')
          ..write('itemName: $itemName, ')
          ..write('price: $price, ')
          ..write('type: $type, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    khataId,
    itemName,
    price,
    type,
    paymentMethod,
    date,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KhataItemData &&
          other.id == this.id &&
          other.khataId == this.khataId &&
          other.itemName == this.itemName &&
          other.price == this.price &&
          other.type == this.type &&
          other.paymentMethod == this.paymentMethod &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class KhataItemsCompanion extends UpdateCompanion<KhataItemData> {
  final Value<int> id;
  final Value<String> khataId;
  final Value<String?> itemName;
  final Value<double> price;
  final Value<String> type;
  final Value<String?> paymentMethod;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  const KhataItemsCompanion({
    this.id = const Value.absent(),
    this.khataId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.price = const Value.absent(),
    this.type = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  KhataItemsCompanion.insert({
    this.id = const Value.absent(),
    required String khataId,
    this.itemName = const Value.absent(),
    required double price,
    this.type = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : khataId = Value(khataId),
       price = Value(price);
  static Insertable<KhataItemData> custom({
    Expression<int>? id,
    Expression<String>? khataId,
    Expression<String>? itemName,
    Expression<double>? price,
    Expression<String>? type,
    Expression<String>? paymentMethod,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (khataId != null) 'khata_id': khataId,
      if (itemName != null) 'item_name': itemName,
      if (price != null) 'price': price,
      if (type != null) 'type': type,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  KhataItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? khataId,
    Value<String?>? itemName,
    Value<double>? price,
    Value<String>? type,
    Value<String?>? paymentMethod,
    Value<DateTime>? date,
    Value<DateTime>? createdAt,
  }) {
    return KhataItemsCompanion(
      id: id ?? this.id,
      khataId: khataId ?? this.khataId,
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      type: type ?? this.type,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (khataId.present) {
      map['khata_id'] = Variable<String>(khataId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KhataItemsCompanion(')
          ..write('id: $id, ')
          ..write('khataId: $khataId, ')
          ..write('itemName: $itemName, ')
          ..write('price: $price, ')
          ..write('type: $type, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $LaboursTable labours = $LaboursTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $TrailasTable trailas = $TrailasTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceItemsTable invoiceItems = $InvoiceItemsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $SplitDetailsTable splitDetails = $SplitDetailsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TrailaExpensesTable trailaExpenses = $TrailaExpensesTable(this);
  late final $LabourWorkEntriesTable labourWorkEntries =
      $LabourWorkEntriesTable(this);
  late final $BuyersTable buyers = $BuyersTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $AppProfilesTable appProfiles = $AppProfilesTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $PrinterSettingsTable printerSettings = $PrinterSettingsTable(
    this,
  );
  late final $KhatasTable khatas = $KhatasTable(this);
  late final $KhataItemsTable khataItems = $KhataItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    suppliers,
    labours,
    products,
    trailas,
    invoices,
    invoiceItems,
    payments,
    splitDetails,
    transactions,
    trailaExpenses,
    labourWorkEntries,
    buyers,
    sales,
    appSettings,
    appProfiles,
    accounts,
    printerSettings,
    khatas,
    khataItems,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trailas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('invoices', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'invoices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('invoice_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'payments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('split_details', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trailas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('traila_expenses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'labours',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('labour_work_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trailas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('labour_work_entries', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'trailas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sales', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'khatas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('khata_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SuppliersTableCreateCompanionBuilder =
    SuppliersCompanion Function({
      required String id,
      required String name,
      Value<String> phone,
      Value<String> shopName,
      Value<String> location,
      Value<String> whatsappNumber,
      Value<String> address,
      required DateTime registrationDate,
      Value<double> openingBalance,
      Value<double> totalAmount,
      Value<double> totalPaid,
      Value<double> remainingBalance,
      Value<double> advanceBalance,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$SuppliersTableUpdateCompanionBuilder =
    SuppliersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> phone,
      Value<String> shopName,
      Value<String> location,
      Value<String> whatsappNumber,
      Value<String> address,
      Value<DateTime> registrationDate,
      Value<double> openingBalance,
      Value<double> totalAmount,
      Value<double> totalPaid,
      Value<double> remainingBalance,
      Value<double> advanceBalance,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$SuppliersTableReferences
    extends BaseReferences<_$AppDatabase, $SuppliersTable, SupplierData> {
  $$SuppliersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TrailaExpensesTable, List<TrailaExpenseData>>
  _trailaExpensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trailaExpenses,
    aliasName: $_aliasNameGenerator(
      db.suppliers.id,
      db.trailaExpenses.supplierId,
    ),
  );

  $$TrailaExpensesTableProcessedTableManager get trailaExpensesRefs {
    final manager = $$TrailaExpensesTableTableManager(
      $_db,
      $_db.trailaExpenses,
    ).filter((f) => f.supplierId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trailaExpensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopName => $composableBuilder(
    column: $table.shopName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPaid => $composableBuilder(
    column: $table.totalPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get advanceBalance => $composableBuilder(
    column: $table.advanceBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> trailaExpensesRefs(
    Expression<bool> Function($$TrailaExpensesTableFilterComposer f) f,
  ) {
    final $$TrailaExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trailaExpenses,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailaExpensesTableFilterComposer(
            $db: $db,
            $table: $db.trailaExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopName => $composableBuilder(
    column: $table.shopName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPaid => $composableBuilder(
    column: $table.totalPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get advanceBalance => $composableBuilder(
    column: $table.advanceBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get shopName =>
      $composableBuilder(column: $table.shopName, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalPaid =>
      $composableBuilder(column: $table.totalPaid, builder: (column) => column);

  GeneratedColumn<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get advanceBalance => $composableBuilder(
    column: $table.advanceBalance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> trailaExpensesRefs<T extends Object>(
    Expression<T> Function($$TrailaExpensesTableAnnotationComposer a) f,
  ) {
    final $$TrailaExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trailaExpenses,
      getReferencedColumn: (t) => t.supplierId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailaExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.trailaExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SuppliersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SuppliersTable,
          SupplierData,
          $$SuppliersTableFilterComposer,
          $$SuppliersTableOrderingComposer,
          $$SuppliersTableAnnotationComposer,
          $$SuppliersTableCreateCompanionBuilder,
          $$SuppliersTableUpdateCompanionBuilder,
          (SupplierData, $$SuppliersTableReferences),
          SupplierData,
          PrefetchHooks Function({bool trailaExpensesRefs})
        > {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> shopName = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<String> whatsappNumber = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<DateTime> registrationDate = const Value.absent(),
                Value<double> openingBalance = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> totalPaid = const Value.absent(),
                Value<double> remainingBalance = const Value.absent(),
                Value<double> advanceBalance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SuppliersCompanion(
                id: id,
                name: name,
                phone: phone,
                shopName: shopName,
                location: location,
                whatsappNumber: whatsappNumber,
                address: address,
                registrationDate: registrationDate,
                openingBalance: openingBalance,
                totalAmount: totalAmount,
                totalPaid: totalPaid,
                remainingBalance: remainingBalance,
                advanceBalance: advanceBalance,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> phone = const Value.absent(),
                Value<String> shopName = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<String> whatsappNumber = const Value.absent(),
                Value<String> address = const Value.absent(),
                required DateTime registrationDate,
                Value<double> openingBalance = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> totalPaid = const Value.absent(),
                Value<double> remainingBalance = const Value.absent(),
                Value<double> advanceBalance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SuppliersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                shopName: shopName,
                location: location,
                whatsappNumber: whatsappNumber,
                address: address,
                registrationDate: registrationDate,
                openingBalance: openingBalance,
                totalAmount: totalAmount,
                totalPaid: totalPaid,
                remainingBalance: remainingBalance,
                advanceBalance: advanceBalance,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SuppliersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trailaExpensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (trailaExpensesRefs) db.trailaExpenses,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (trailaExpensesRefs)
                    await $_getPrefetchedData<
                      SupplierData,
                      $SuppliersTable,
                      TrailaExpenseData
                    >(
                      currentTable: table,
                      referencedTable: $$SuppliersTableReferences
                          ._trailaExpensesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SuppliersTableReferences(
                            db,
                            table,
                            p0,
                          ).trailaExpensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.supplierId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SuppliersTable,
      SupplierData,
      $$SuppliersTableFilterComposer,
      $$SuppliersTableOrderingComposer,
      $$SuppliersTableAnnotationComposer,
      $$SuppliersTableCreateCompanionBuilder,
      $$SuppliersTableUpdateCompanionBuilder,
      (SupplierData, $$SuppliersTableReferences),
      SupplierData,
      PrefetchHooks Function({bool trailaExpensesRefs})
    >;
typedef $$LaboursTableCreateCompanionBuilder =
    LaboursCompanion Function({
      required String id,
      required String name,
      Value<String> phone,
      Value<String> whatsappNumber,
      Value<String> address,
      required DateTime registrationDate,
      Value<double> openingBalance,
      Value<double> totalPayable,
      Value<double> totalPaid,
      Value<double> remainingBalance,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$LaboursTableUpdateCompanionBuilder =
    LaboursCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> phone,
      Value<String> whatsappNumber,
      Value<String> address,
      Value<DateTime> registrationDate,
      Value<double> openingBalance,
      Value<double> totalPayable,
      Value<double> totalPaid,
      Value<double> remainingBalance,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$LaboursTableReferences
    extends BaseReferences<_$AppDatabase, $LaboursTable, LabourData> {
  $$LaboursTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TrailaExpensesTable, List<TrailaExpenseData>>
  _trailaExpensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trailaExpenses,
    aliasName: $_aliasNameGenerator(db.labours.id, db.trailaExpenses.labourId),
  );

  $$TrailaExpensesTableProcessedTableManager get trailaExpensesRefs {
    final manager = $$TrailaExpensesTableTableManager(
      $_db,
      $_db.trailaExpenses,
    ).filter((f) => f.labourId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trailaExpensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LabourWorkEntriesTable, List<LabourWorkEntryData>>
  _labourWorkEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.labourWorkEntries,
        aliasName: $_aliasNameGenerator(
          db.labours.id,
          db.labourWorkEntries.labourId,
        ),
      );

  $$LabourWorkEntriesTableProcessedTableManager get labourWorkEntriesRefs {
    final manager = $$LabourWorkEntriesTableTableManager(
      $_db,
      $_db.labourWorkEntries,
    ).filter((f) => f.labourId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _labourWorkEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LaboursTableFilterComposer
    extends Composer<_$AppDatabase, $LaboursTable> {
  $$LaboursTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPayable => $composableBuilder(
    column: $table.totalPayable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPaid => $composableBuilder(
    column: $table.totalPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> trailaExpensesRefs(
    Expression<bool> Function($$TrailaExpensesTableFilterComposer f) f,
  ) {
    final $$TrailaExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trailaExpenses,
      getReferencedColumn: (t) => t.labourId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailaExpensesTableFilterComposer(
            $db: $db,
            $table: $db.trailaExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> labourWorkEntriesRefs(
    Expression<bool> Function($$LabourWorkEntriesTableFilterComposer f) f,
  ) {
    final $$LabourWorkEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.labourWorkEntries,
      getReferencedColumn: (t) => t.labourId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabourWorkEntriesTableFilterComposer(
            $db: $db,
            $table: $db.labourWorkEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LaboursTableOrderingComposer
    extends Composer<_$AppDatabase, $LaboursTable> {
  $$LaboursTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPayable => $composableBuilder(
    column: $table.totalPayable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPaid => $composableBuilder(
    column: $table.totalPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LaboursTableAnnotationComposer
    extends Composer<_$AppDatabase, $LaboursTable> {
  $$LaboursTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalPayable => $composableBuilder(
    column: $table.totalPayable,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalPaid =>
      $composableBuilder(column: $table.totalPaid, builder: (column) => column);

  GeneratedColumn<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> trailaExpensesRefs<T extends Object>(
    Expression<T> Function($$TrailaExpensesTableAnnotationComposer a) f,
  ) {
    final $$TrailaExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trailaExpenses,
      getReferencedColumn: (t) => t.labourId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailaExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.trailaExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> labourWorkEntriesRefs<T extends Object>(
    Expression<T> Function($$LabourWorkEntriesTableAnnotationComposer a) f,
  ) {
    final $$LabourWorkEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.labourWorkEntries,
          getReferencedColumn: (t) => t.labourId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LabourWorkEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.labourWorkEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LaboursTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LaboursTable,
          LabourData,
          $$LaboursTableFilterComposer,
          $$LaboursTableOrderingComposer,
          $$LaboursTableAnnotationComposer,
          $$LaboursTableCreateCompanionBuilder,
          $$LaboursTableUpdateCompanionBuilder,
          (LabourData, $$LaboursTableReferences),
          LabourData,
          PrefetchHooks Function({
            bool trailaExpensesRefs,
            bool labourWorkEntriesRefs,
          })
        > {
  $$LaboursTableTableManager(_$AppDatabase db, $LaboursTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LaboursTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LaboursTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LaboursTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> whatsappNumber = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<DateTime> registrationDate = const Value.absent(),
                Value<double> openingBalance = const Value.absent(),
                Value<double> totalPayable = const Value.absent(),
                Value<double> totalPaid = const Value.absent(),
                Value<double> remainingBalance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LaboursCompanion(
                id: id,
                name: name,
                phone: phone,
                whatsappNumber: whatsappNumber,
                address: address,
                registrationDate: registrationDate,
                openingBalance: openingBalance,
                totalPayable: totalPayable,
                totalPaid: totalPaid,
                remainingBalance: remainingBalance,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> phone = const Value.absent(),
                Value<String> whatsappNumber = const Value.absent(),
                Value<String> address = const Value.absent(),
                required DateTime registrationDate,
                Value<double> openingBalance = const Value.absent(),
                Value<double> totalPayable = const Value.absent(),
                Value<double> totalPaid = const Value.absent(),
                Value<double> remainingBalance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LaboursCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                whatsappNumber: whatsappNumber,
                address: address,
                registrationDate: registrationDate,
                openingBalance: openingBalance,
                totalPayable: totalPayable,
                totalPaid: totalPaid,
                remainingBalance: remainingBalance,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LaboursTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({trailaExpensesRefs = false, labourWorkEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (trailaExpensesRefs) db.trailaExpenses,
                    if (labourWorkEntriesRefs) db.labourWorkEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (trailaExpensesRefs)
                        await $_getPrefetchedData<
                          LabourData,
                          $LaboursTable,
                          TrailaExpenseData
                        >(
                          currentTable: table,
                          referencedTable: $$LaboursTableReferences
                              ._trailaExpensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LaboursTableReferences(
                                db,
                                table,
                                p0,
                              ).trailaExpensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.labourId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (labourWorkEntriesRefs)
                        await $_getPrefetchedData<
                          LabourData,
                          $LaboursTable,
                          LabourWorkEntryData
                        >(
                          currentTable: table,
                          referencedTable: $$LaboursTableReferences
                              ._labourWorkEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LaboursTableReferences(
                                db,
                                table,
                                p0,
                              ).labourWorkEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.labourId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LaboursTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LaboursTable,
      LabourData,
      $$LaboursTableFilterComposer,
      $$LaboursTableOrderingComposer,
      $$LaboursTableAnnotationComposer,
      $$LaboursTableCreateCompanionBuilder,
      $$LaboursTableUpdateCompanionBuilder,
      (LabourData, $$LaboursTableReferences),
      LabourData,
      PrefetchHooks Function({
        bool trailaExpensesRefs,
        bool labourWorkEntriesRefs,
      })
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String name,
      Value<double> defaultPrice,
      Value<String> unit,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> defaultPrice,
      Value<String> unit,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultPrice => $composableBuilder(
    column: $table.defaultPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultPrice => $composableBuilder(
    column: $table.defaultPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get defaultPrice => $composableBuilder(
    column: $table.defaultPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          ProductData,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (
            ProductData,
            BaseReferences<_$AppDatabase, $ProductsTable, ProductData>,
          ),
          ProductData,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> defaultPrice = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                defaultPrice: defaultPrice,
                unit: unit,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<double> defaultPrice = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                defaultPrice: defaultPrice,
                unit: unit,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      ProductData,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (ProductData, BaseReferences<_$AppDatabase, $ProductsTable, ProductData>),
      ProductData,
      PrefetchHooks Function()
    >;
typedef $$TrailasTableCreateCompanionBuilder =
    TrailasCompanion Function({
      required String id,
      required String name,
      required DateTime registrationDate,
      required String status,
      Value<double> totalManufacturingCost,
      Value<double?> salePrice,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$TrailasTableUpdateCompanionBuilder =
    TrailasCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> registrationDate,
      Value<String> status,
      Value<double> totalManufacturingCost,
      Value<double?> salePrice,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TrailasTableReferences
    extends BaseReferences<_$AppDatabase, $TrailasTable, TrailaData> {
  $$TrailasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InvoicesTable, List<InvoiceData>>
  _invoicesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: $_aliasNameGenerator(db.trailas.id, db.invoices.trailaId),
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.trailaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrailaExpensesTable, List<TrailaExpenseData>>
  _trailaExpensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trailaExpenses,
    aliasName: $_aliasNameGenerator(db.trailas.id, db.trailaExpenses.trailaId),
  );

  $$TrailaExpensesTableProcessedTableManager get trailaExpensesRefs {
    final manager = $$TrailaExpensesTableTableManager(
      $_db,
      $_db.trailaExpenses,
    ).filter((f) => f.trailaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trailaExpensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LabourWorkEntriesTable, List<LabourWorkEntryData>>
  _labourWorkEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.labourWorkEntries,
        aliasName: $_aliasNameGenerator(
          db.trailas.id,
          db.labourWorkEntries.trailaId,
        ),
      );

  $$LabourWorkEntriesTableProcessedTableManager get labourWorkEntriesRefs {
    final manager = $$LabourWorkEntriesTableTableManager(
      $_db,
      $_db.labourWorkEntries,
    ).filter((f) => f.trailaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _labourWorkEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SalesTable, List<SaleData>> _salesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sales,
    aliasName: $_aliasNameGenerator(db.trailas.id, db.sales.trailaId),
  );

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.trailaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TrailasTableFilterComposer
    extends Composer<_$AppDatabase, $TrailasTable> {
  $$TrailasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalManufacturingCost => $composableBuilder(
    column: $table.totalManufacturingCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.trailaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trailaExpensesRefs(
    Expression<bool> Function($$TrailaExpensesTableFilterComposer f) f,
  ) {
    final $$TrailaExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trailaExpenses,
      getReferencedColumn: (t) => t.trailaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailaExpensesTableFilterComposer(
            $db: $db,
            $table: $db.trailaExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> labourWorkEntriesRefs(
    Expression<bool> Function($$LabourWorkEntriesTableFilterComposer f) f,
  ) {
    final $$LabourWorkEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.labourWorkEntries,
      getReferencedColumn: (t) => t.trailaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabourWorkEntriesTableFilterComposer(
            $db: $db,
            $table: $db.labourWorkEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> salesRefs(
    Expression<bool> Function($$SalesTableFilterComposer f) f,
  ) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.trailaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrailasTableOrderingComposer
    extends Composer<_$AppDatabase, $TrailasTable> {
  $$TrailasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalManufacturingCost => $composableBuilder(
    column: $table.totalManufacturingCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrailasTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrailasTable> {
  $$TrailasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get totalManufacturingCost => $composableBuilder(
    column: $table.totalManufacturingCost,
    builder: (column) => column,
  );

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.trailaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trailaExpensesRefs<T extends Object>(
    Expression<T> Function($$TrailaExpensesTableAnnotationComposer a) f,
  ) {
    final $$TrailaExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trailaExpenses,
      getReferencedColumn: (t) => t.trailaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailaExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.trailaExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> labourWorkEntriesRefs<T extends Object>(
    Expression<T> Function($$LabourWorkEntriesTableAnnotationComposer a) f,
  ) {
    final $$LabourWorkEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.labourWorkEntries,
          getReferencedColumn: (t) => t.trailaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LabourWorkEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.labourWorkEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> salesRefs<T extends Object>(
    Expression<T> Function($$SalesTableAnnotationComposer a) f,
  ) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.trailaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrailasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrailasTable,
          TrailaData,
          $$TrailasTableFilterComposer,
          $$TrailasTableOrderingComposer,
          $$TrailasTableAnnotationComposer,
          $$TrailasTableCreateCompanionBuilder,
          $$TrailasTableUpdateCompanionBuilder,
          (TrailaData, $$TrailasTableReferences),
          TrailaData,
          PrefetchHooks Function({
            bool invoicesRefs,
            bool trailaExpensesRefs,
            bool labourWorkEntriesRefs,
            bool salesRefs,
          })
        > {
  $$TrailasTableTableManager(_$AppDatabase db, $TrailasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrailasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrailasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrailasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> registrationDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> totalManufacturingCost = const Value.absent(),
                Value<double?> salePrice = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrailasCompanion(
                id: id,
                name: name,
                registrationDate: registrationDate,
                status: status,
                totalManufacturingCost: totalManufacturingCost,
                salePrice: salePrice,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime registrationDate,
                required String status,
                Value<double> totalManufacturingCost = const Value.absent(),
                Value<double?> salePrice = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrailasCompanion.insert(
                id: id,
                name: name,
                registrationDate: registrationDate,
                status: status,
                totalManufacturingCost: totalManufacturingCost,
                salePrice: salePrice,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrailasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                invoicesRefs = false,
                trailaExpensesRefs = false,
                labourWorkEntriesRefs = false,
                salesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoicesRefs) db.invoices,
                    if (trailaExpensesRefs) db.trailaExpenses,
                    if (labourWorkEntriesRefs) db.labourWorkEntries,
                    if (salesRefs) db.sales,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoicesRefs)
                        await $_getPrefetchedData<
                          TrailaData,
                          $TrailasTable,
                          InvoiceData
                        >(
                          currentTable: table,
                          referencedTable: $$TrailasTableReferences
                              ._invoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrailasTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trailaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (trailaExpensesRefs)
                        await $_getPrefetchedData<
                          TrailaData,
                          $TrailasTable,
                          TrailaExpenseData
                        >(
                          currentTable: table,
                          referencedTable: $$TrailasTableReferences
                              ._trailaExpensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrailasTableReferences(
                                db,
                                table,
                                p0,
                              ).trailaExpensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trailaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (labourWorkEntriesRefs)
                        await $_getPrefetchedData<
                          TrailaData,
                          $TrailasTable,
                          LabourWorkEntryData
                        >(
                          currentTable: table,
                          referencedTable: $$TrailasTableReferences
                              ._labourWorkEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrailasTableReferences(
                                db,
                                table,
                                p0,
                              ).labourWorkEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trailaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (salesRefs)
                        await $_getPrefetchedData<
                          TrailaData,
                          $TrailasTable,
                          SaleData
                        >(
                          currentTable: table,
                          referencedTable: $$TrailasTableReferences
                              ._salesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrailasTableReferences(db, table, p0).salesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trailaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TrailasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrailasTable,
      TrailaData,
      $$TrailasTableFilterComposer,
      $$TrailasTableOrderingComposer,
      $$TrailasTableAnnotationComposer,
      $$TrailasTableCreateCompanionBuilder,
      $$TrailasTableUpdateCompanionBuilder,
      (TrailaData, $$TrailasTableReferences),
      TrailaData,
      PrefetchHooks Function({
        bool invoicesRefs,
        bool trailaExpensesRefs,
        bool labourWorkEntriesRefs,
        bool salesRefs,
      })
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      required String id,
      required String invoiceNumber,
      required DateTime date,
      required String type,
      required String ownerId,
      required String ownerName,
      required String ownerType,
      Value<String?> trailaId,
      required double amount,
      required double previousBalance,
      required double remainingBalance,
      required String paymentMethod,
      required String ownerNameDisplay,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<String> id,
      Value<String> invoiceNumber,
      Value<DateTime> date,
      Value<String> type,
      Value<String> ownerId,
      Value<String> ownerName,
      Value<String> ownerType,
      Value<String?> trailaId,
      Value<double> amount,
      Value<double> previousBalance,
      Value<double> remainingBalance,
      Value<String> paymentMethod,
      Value<String> ownerNameDisplay,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$InvoicesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTable, InvoiceData> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TrailasTable _trailaIdTable(_$AppDatabase db) => db.trailas
      .createAlias($_aliasNameGenerator(db.invoices.trailaId, db.trailas.id));

  $$TrailasTableProcessedTableManager? get trailaId {
    final $_column = $_itemColumn<String>('traila_id');
    if ($_column == null) return null;
    final manager = $$TrailasTableTableManager(
      $_db,
      $_db.trailas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trailaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoiceItemsTable, List<InvoiceItemData>>
  _invoiceItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceItems,
    aliasName: $_aliasNameGenerator(db.invoices.id, db.invoiceItems.invoiceId),
  );

  $$InvoiceItemsTableProcessedTableManager get invoiceItemsRefs {
    final manager = $$InvoiceItemsTableTableManager(
      $_db,
      $_db.invoiceItems,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get previousBalance => $composableBuilder(
    column: $table.previousBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerNameDisplay => $composableBuilder(
    column: $table.ownerNameDisplay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TrailasTableFilterComposer get trailaId {
    final $$TrailasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trailaId,
      referencedTable: $db.trailas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailasTableFilterComposer(
            $db: $db,
            $table: $db.trailas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoiceItemsRefs(
    Expression<bool> Function($$InvoiceItemsTableFilterComposer f) f,
  ) {
    final $$InvoiceItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItems,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableFilterComposer(
            $db: $db,
            $table: $db.invoiceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get previousBalance => $composableBuilder(
    column: $table.previousBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerNameDisplay => $composableBuilder(
    column: $table.ownerNameDisplay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrailasTableOrderingComposer get trailaId {
    final $$TrailasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trailaId,
      referencedTable: $db.trailas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailasTableOrderingComposer(
            $db: $db,
            $table: $db.trailas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get ownerName =>
      $composableBuilder(column: $table.ownerName, builder: (column) => column);

  GeneratedColumn<String> get ownerType =>
      $composableBuilder(column: $table.ownerType, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get previousBalance => $composableBuilder(
    column: $table.previousBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerNameDisplay => $composableBuilder(
    column: $table.ownerNameDisplay,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TrailasTableAnnotationComposer get trailaId {
    final $$TrailasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trailaId,
      referencedTable: $db.trailas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailasTableAnnotationComposer(
            $db: $db,
            $table: $db.trailas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoiceItemsRefs<T extends Object>(
    Expression<T> Function($$InvoiceItemsTableAnnotationComposer a) f,
  ) {
    final $$InvoiceItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItems,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          InvoiceData,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (InvoiceData, $$InvoicesTableReferences),
          InvoiceData,
          PrefetchHooks Function({bool trailaId, bool invoiceItemsRefs})
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> invoiceNumber = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> ownerName = const Value.absent(),
                Value<String> ownerType = const Value.absent(),
                Value<String?> trailaId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double> previousBalance = const Value.absent(),
                Value<double> remainingBalance = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<String> ownerNameDisplay = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                invoiceNumber: invoiceNumber,
                date: date,
                type: type,
                ownerId: ownerId,
                ownerName: ownerName,
                ownerType: ownerType,
                trailaId: trailaId,
                amount: amount,
                previousBalance: previousBalance,
                remainingBalance: remainingBalance,
                paymentMethod: paymentMethod,
                ownerNameDisplay: ownerNameDisplay,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String invoiceNumber,
                required DateTime date,
                required String type,
                required String ownerId,
                required String ownerName,
                required String ownerType,
                Value<String?> trailaId = const Value.absent(),
                required double amount,
                required double previousBalance,
                required double remainingBalance,
                required String paymentMethod,
                required String ownerNameDisplay,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                invoiceNumber: invoiceNumber,
                date: date,
                type: type,
                ownerId: ownerId,
                ownerName: ownerName,
                ownerType: ownerType,
                trailaId: trailaId,
                amount: amount,
                previousBalance: previousBalance,
                remainingBalance: remainingBalance,
                paymentMethod: paymentMethod,
                ownerNameDisplay: ownerNameDisplay,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({trailaId = false, invoiceItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoiceItemsRefs) db.invoiceItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (trailaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.trailaId,
                                    referencedTable: $$InvoicesTableReferences
                                        ._trailaIdTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._trailaIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoiceItemsRefs)
                        await $_getPrefetchedData<
                          InvoiceData,
                          $InvoicesTable,
                          InvoiceItemData
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._invoiceItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      InvoiceData,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (InvoiceData, $$InvoicesTableReferences),
      InvoiceData,
      PrefetchHooks Function({bool trailaId, bool invoiceItemsRefs})
    >;
typedef $$InvoiceItemsTableCreateCompanionBuilder =
    InvoiceItemsCompanion Function({
      Value<int> id,
      required String invoiceId,
      required String productName,
      required double quantity,
      required double unitPrice,
      required double lineTotal,
      Value<DateTime> createdAt,
    });
typedef $$InvoiceItemsTableUpdateCompanionBuilder =
    InvoiceItemsCompanion Function({
      Value<int> id,
      Value<String> invoiceId,
      Value<String> productName,
      Value<double> quantity,
      Value<double> unitPrice,
      Value<double> lineTotal,
      Value<DateTime> createdAt,
    });

final class $$InvoiceItemsTableReferences
    extends BaseReferences<_$AppDatabase, $InvoiceItemsTable, InvoiceItemData> {
  $$InvoiceItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias(
        $_aliasNameGenerator(db.invoiceItems.invoiceId, db.invoices.id),
      );

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvoiceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceItemsTable,
          InvoiceItemData,
          $$InvoiceItemsTableFilterComposer,
          $$InvoiceItemsTableOrderingComposer,
          $$InvoiceItemsTableAnnotationComposer,
          $$InvoiceItemsTableCreateCompanionBuilder,
          $$InvoiceItemsTableUpdateCompanionBuilder,
          (InvoiceItemData, $$InvoiceItemsTableReferences),
          InvoiceItemData,
          PrefetchHooks Function({bool invoiceId})
        > {
  $$InvoiceItemsTableTableManager(_$AppDatabase db, $InvoiceItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> invoiceId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double> lineTotal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InvoiceItemsCompanion(
                id: id,
                invoiceId: invoiceId,
                productName: productName,
                quantity: quantity,
                unitPrice: unitPrice,
                lineTotal: lineTotal,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String invoiceId,
                required String productName,
                required double quantity,
                required double unitPrice,
                required double lineTotal,
                Value<DateTime> createdAt = const Value.absent(),
              }) => InvoiceItemsCompanion.insert(
                id: id,
                invoiceId: invoiceId,
                productName: productName,
                quantity: quantity,
                unitPrice: unitPrice,
                lineTotal: lineTotal,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoiceItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (invoiceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invoiceId,
                                referencedTable: $$InvoiceItemsTableReferences
                                    ._invoiceIdTable(db),
                                referencedColumn: $$InvoiceItemsTableReferences
                                    ._invoiceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InvoiceItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceItemsTable,
      InvoiceItemData,
      $$InvoiceItemsTableFilterComposer,
      $$InvoiceItemsTableOrderingComposer,
      $$InvoiceItemsTableAnnotationComposer,
      $$InvoiceItemsTableCreateCompanionBuilder,
      $$InvoiceItemsTableUpdateCompanionBuilder,
      (InvoiceItemData, $$InvoiceItemsTableReferences),
      InvoiceItemData,
      PrefetchHooks Function({bool invoiceId})
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      required String id,
      required double amount,
      required DateTime date,
      required String method,
      Value<String?> receiptNumber,
      Value<double?> previousBalance,
      Value<double?> updatedBalance,
      required String ownerId,
      required String ownerType,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<String> id,
      Value<double> amount,
      Value<DateTime> date,
      Value<String> method,
      Value<String?> receiptNumber,
      Value<double?> previousBalance,
      Value<double?> updatedBalance,
      Value<String> ownerId,
      Value<String> ownerType,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, PaymentData> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SplitDetailsTable, List<SplitDetailData>>
  _splitDetailsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.splitDetails,
    aliasName: $_aliasNameGenerator(db.payments.id, db.splitDetails.paymentId),
  );

  $$SplitDetailsTableProcessedTableManager get splitDetailsRefs {
    final manager = $$SplitDetailsTableTableManager(
      $_db,
      $_db.splitDetails,
    ).filter((f) => f.paymentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_splitDetailsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get previousBalance => $composableBuilder(
    column: $table.previousBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get updatedBalance => $composableBuilder(
    column: $table.updatedBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> splitDetailsRefs(
    Expression<bool> Function($$SplitDetailsTableFilterComposer f) f,
  ) {
    final $$SplitDetailsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.splitDetails,
      getReferencedColumn: (t) => t.paymentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitDetailsTableFilterComposer(
            $db: $db,
            $table: $db.splitDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get previousBalance => $composableBuilder(
    column: $table.previousBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get updatedBalance => $composableBuilder(
    column: $table.updatedBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get previousBalance => $composableBuilder(
    column: $table.previousBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get updatedBalance => $composableBuilder(
    column: $table.updatedBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get ownerType =>
      $composableBuilder(column: $table.ownerType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> splitDetailsRefs<T extends Object>(
    Expression<T> Function($$SplitDetailsTableAnnotationComposer a) f,
  ) {
    final $$SplitDetailsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.splitDetails,
      getReferencedColumn: (t) => t.paymentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SplitDetailsTableAnnotationComposer(
            $db: $db,
            $table: $db.splitDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          PaymentData,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (PaymentData, $$PaymentsTableReferences),
          PaymentData,
          PrefetchHooks Function({bool splitDetailsRefs})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String?> receiptNumber = const Value.absent(),
                Value<double?> previousBalance = const Value.absent(),
                Value<double?> updatedBalance = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> ownerType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                amount: amount,
                date: date,
                method: method,
                receiptNumber: receiptNumber,
                previousBalance: previousBalance,
                updatedBalance: updatedBalance,
                ownerId: ownerId,
                ownerType: ownerType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double amount,
                required DateTime date,
                required String method,
                Value<String?> receiptNumber = const Value.absent(),
                Value<double?> previousBalance = const Value.absent(),
                Value<double?> updatedBalance = const Value.absent(),
                required String ownerId,
                required String ownerType,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                amount: amount,
                date: date,
                method: method,
                receiptNumber: receiptNumber,
                previousBalance: previousBalance,
                updatedBalance: updatedBalance,
                ownerId: ownerId,
                ownerType: ownerType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({splitDetailsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (splitDetailsRefs) db.splitDetails],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (splitDetailsRefs)
                    await $_getPrefetchedData<
                      PaymentData,
                      $PaymentsTable,
                      SplitDetailData
                    >(
                      currentTable: table,
                      referencedTable: $$PaymentsTableReferences
                          ._splitDetailsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PaymentsTableReferences(
                        db,
                        table,
                        p0,
                      ).splitDetailsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.paymentId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      PaymentData,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (PaymentData, $$PaymentsTableReferences),
      PaymentData,
      PrefetchHooks Function({bool splitDetailsRefs})
    >;
typedef $$SplitDetailsTableCreateCompanionBuilder =
    SplitDetailsCompanion Function({
      Value<int> id,
      required String paymentId,
      required String method,
      required double amount,
      Value<DateTime> createdAt,
    });
typedef $$SplitDetailsTableUpdateCompanionBuilder =
    SplitDetailsCompanion Function({
      Value<int> id,
      Value<String> paymentId,
      Value<String> method,
      Value<double> amount,
      Value<DateTime> createdAt,
    });

final class $$SplitDetailsTableReferences
    extends BaseReferences<_$AppDatabase, $SplitDetailsTable, SplitDetailData> {
  $$SplitDetailsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PaymentsTable _paymentIdTable(_$AppDatabase db) =>
      db.payments.createAlias(
        $_aliasNameGenerator(db.splitDetails.paymentId, db.payments.id),
      );

  $$PaymentsTableProcessedTableManager get paymentId {
    final $_column = $_itemColumn<String>('payment_id')!;

    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SplitDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $SplitDetailsTable> {
  $$SplitDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PaymentsTableFilterComposer get paymentId {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentId,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SplitDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $SplitDetailsTable> {
  $$SplitDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PaymentsTableOrderingComposer get paymentId {
    final $$PaymentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentId,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableOrderingComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SplitDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SplitDetailsTable> {
  $$SplitDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PaymentsTableAnnotationComposer get paymentId {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentId,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SplitDetailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SplitDetailsTable,
          SplitDetailData,
          $$SplitDetailsTableFilterComposer,
          $$SplitDetailsTableOrderingComposer,
          $$SplitDetailsTableAnnotationComposer,
          $$SplitDetailsTableCreateCompanionBuilder,
          $$SplitDetailsTableUpdateCompanionBuilder,
          (SplitDetailData, $$SplitDetailsTableReferences),
          SplitDetailData,
          PrefetchHooks Function({bool paymentId})
        > {
  $$SplitDetailsTableTableManager(_$AppDatabase db, $SplitDetailsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SplitDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SplitDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SplitDetailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> paymentId = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SplitDetailsCompanion(
                id: id,
                paymentId: paymentId,
                method: method,
                amount: amount,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String paymentId,
                required String method,
                required double amount,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SplitDetailsCompanion.insert(
                id: id,
                paymentId: paymentId,
                method: method,
                amount: amount,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SplitDetailsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({paymentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (paymentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.paymentId,
                                referencedTable: $$SplitDetailsTableReferences
                                    ._paymentIdTable(db),
                                referencedColumn: $$SplitDetailsTableReferences
                                    ._paymentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SplitDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SplitDetailsTable,
      SplitDetailData,
      $$SplitDetailsTableFilterComposer,
      $$SplitDetailsTableOrderingComposer,
      $$SplitDetailsTableAnnotationComposer,
      $$SplitDetailsTableCreateCompanionBuilder,
      $$SplitDetailsTableUpdateCompanionBuilder,
      (SplitDetailData, $$SplitDetailsTableReferences),
      SplitDetailData,
      PrefetchHooks Function({bool paymentId})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required String accountName,
      required String type,
      required double amount,
      required String person,
      required String description,
      required DateTime date,
      required String category,
      Value<String?> linkedTransferId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String> accountName,
      Value<String> type,
      Value<double> amount,
      Value<String> person,
      Value<String> description,
      Value<DateTime> date,
      Value<String> category,
      Value<String?> linkedTransferId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedTransferId => $composableBuilder(
    column: $table.linkedTransferId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedTransferId => $composableBuilder(
    column: $table.linkedTransferId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountName => $composableBuilder(
    column: $table.accountName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get person =>
      $composableBuilder(column: $table.person, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get linkedTransferId => $composableBuilder(
    column: $table.linkedTransferId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TransactionData,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            TransactionData,
            BaseReferences<_$AppDatabase, $TransactionsTable, TransactionData>,
          ),
          TransactionData,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountName = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> person = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> linkedTransferId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                accountName: accountName,
                type: type,
                amount: amount,
                person: person,
                description: description,
                date: date,
                category: category,
                linkedTransferId: linkedTransferId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountName,
                required String type,
                required double amount,
                required String person,
                required String description,
                required DateTime date,
                required String category,
                Value<String?> linkedTransferId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                accountName: accountName,
                type: type,
                amount: amount,
                person: person,
                description: description,
                date: date,
                category: category,
                linkedTransferId: linkedTransferId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TransactionData,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        TransactionData,
        BaseReferences<_$AppDatabase, $TransactionsTable, TransactionData>,
      ),
      TransactionData,
      PrefetchHooks Function()
    >;
typedef $$TrailaExpensesTableCreateCompanionBuilder =
    TrailaExpensesCompanion Function({
      required String id,
      Value<String?> trailaId,
      required String type,
      required String description,
      required double amount,
      required DateTime date,
      Value<String?> supplierId,
      Value<String?> labourId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$TrailaExpensesTableUpdateCompanionBuilder =
    TrailaExpensesCompanion Function({
      Value<String> id,
      Value<String?> trailaId,
      Value<String> type,
      Value<String> description,
      Value<double> amount,
      Value<DateTime> date,
      Value<String?> supplierId,
      Value<String?> labourId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TrailaExpensesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TrailaExpensesTable, TrailaExpenseData> {
  $$TrailaExpensesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TrailasTable _trailaIdTable(_$AppDatabase db) =>
      db.trailas.createAlias(
        $_aliasNameGenerator(db.trailaExpenses.trailaId, db.trailas.id),
      );

  $$TrailasTableProcessedTableManager? get trailaId {
    final $_column = $_itemColumn<String>('traila_id');
    if ($_column == null) return null;
    final manager = $$TrailasTableTableManager(
      $_db,
      $_db.trailas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trailaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias(
        $_aliasNameGenerator(db.trailaExpenses.supplierId, db.suppliers.id),
      );

  $$SuppliersTableProcessedTableManager? get supplierId {
    final $_column = $_itemColumn<String>('supplier_id');
    if ($_column == null) return null;
    final manager = $$SuppliersTableTableManager(
      $_db,
      $_db.suppliers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LaboursTable _labourIdTable(_$AppDatabase db) =>
      db.labours.createAlias(
        $_aliasNameGenerator(db.trailaExpenses.labourId, db.labours.id),
      );

  $$LaboursTableProcessedTableManager? get labourId {
    final $_column = $_itemColumn<String>('labour_id');
    if ($_column == null) return null;
    final manager = $$LaboursTableTableManager(
      $_db,
      $_db.labours,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_labourIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrailaExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $TrailaExpensesTable> {
  $$TrailaExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TrailasTableFilterComposer get trailaId {
    final $$TrailasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trailaId,
      referencedTable: $db.trailas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailasTableFilterComposer(
            $db: $db,
            $table: $db.trailas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableFilterComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LaboursTableFilterComposer get labourId {
    final $$LaboursTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labourId,
      referencedTable: $db.labours,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LaboursTableFilterComposer(
            $db: $db,
            $table: $db.labours,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrailaExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $TrailaExpensesTable> {
  $$TrailaExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrailasTableOrderingComposer get trailaId {
    final $$TrailasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trailaId,
      referencedTable: $db.trailas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailasTableOrderingComposer(
            $db: $db,
            $table: $db.trailas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableOrderingComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LaboursTableOrderingComposer get labourId {
    final $$LaboursTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labourId,
      referencedTable: $db.labours,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LaboursTableOrderingComposer(
            $db: $db,
            $table: $db.labours,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrailaExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrailaExpensesTable> {
  $$TrailaExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TrailasTableAnnotationComposer get trailaId {
    final $$TrailasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trailaId,
      referencedTable: $db.trailas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailasTableAnnotationComposer(
            $db: $db,
            $table: $db.trailas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplierId,
      referencedTable: $db.suppliers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SuppliersTableAnnotationComposer(
            $db: $db,
            $table: $db.suppliers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LaboursTableAnnotationComposer get labourId {
    final $$LaboursTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labourId,
      referencedTable: $db.labours,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LaboursTableAnnotationComposer(
            $db: $db,
            $table: $db.labours,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrailaExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrailaExpensesTable,
          TrailaExpenseData,
          $$TrailaExpensesTableFilterComposer,
          $$TrailaExpensesTableOrderingComposer,
          $$TrailaExpensesTableAnnotationComposer,
          $$TrailaExpensesTableCreateCompanionBuilder,
          $$TrailaExpensesTableUpdateCompanionBuilder,
          (TrailaExpenseData, $$TrailaExpensesTableReferences),
          TrailaExpenseData,
          PrefetchHooks Function({
            bool trailaId,
            bool supplierId,
            bool labourId,
          })
        > {
  $$TrailaExpensesTableTableManager(
    _$AppDatabase db,
    $TrailaExpensesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrailaExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrailaExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrailaExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> trailaId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<String?> labourId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrailaExpensesCompanion(
                id: id,
                trailaId: trailaId,
                type: type,
                description: description,
                amount: amount,
                date: date,
                supplierId: supplierId,
                labourId: labourId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> trailaId = const Value.absent(),
                required String type,
                required String description,
                required double amount,
                required DateTime date,
                Value<String?> supplierId = const Value.absent(),
                Value<String?> labourId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrailaExpensesCompanion.insert(
                id: id,
                trailaId: trailaId,
                type: type,
                description: description,
                amount: amount,
                date: date,
                supplierId: supplierId,
                labourId: labourId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrailaExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({trailaId = false, supplierId = false, labourId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (trailaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.trailaId,
                                    referencedTable:
                                        $$TrailaExpensesTableReferences
                                            ._trailaIdTable(db),
                                    referencedColumn:
                                        $$TrailaExpensesTableReferences
                                            ._trailaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (supplierId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.supplierId,
                                    referencedTable:
                                        $$TrailaExpensesTableReferences
                                            ._supplierIdTable(db),
                                    referencedColumn:
                                        $$TrailaExpensesTableReferences
                                            ._supplierIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (labourId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.labourId,
                                    referencedTable:
                                        $$TrailaExpensesTableReferences
                                            ._labourIdTable(db),
                                    referencedColumn:
                                        $$TrailaExpensesTableReferences
                                            ._labourIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TrailaExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrailaExpensesTable,
      TrailaExpenseData,
      $$TrailaExpensesTableFilterComposer,
      $$TrailaExpensesTableOrderingComposer,
      $$TrailaExpensesTableAnnotationComposer,
      $$TrailaExpensesTableCreateCompanionBuilder,
      $$TrailaExpensesTableUpdateCompanionBuilder,
      (TrailaExpenseData, $$TrailaExpensesTableReferences),
      TrailaExpenseData,
      PrefetchHooks Function({bool trailaId, bool supplierId, bool labourId})
    >;
typedef $$LabourWorkEntriesTableCreateCompanionBuilder =
    LabourWorkEntriesCompanion Function({
      required String id,
      required String labourId,
      Value<String?> trailaId,
      required String entryNumber,
      required String description,
      required double cost,
      required DateTime date,
      Value<double> previousOutstanding,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$LabourWorkEntriesTableUpdateCompanionBuilder =
    LabourWorkEntriesCompanion Function({
      Value<String> id,
      Value<String> labourId,
      Value<String?> trailaId,
      Value<String> entryNumber,
      Value<String> description,
      Value<double> cost,
      Value<DateTime> date,
      Value<double> previousOutstanding,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$LabourWorkEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $LabourWorkEntriesTable,
          LabourWorkEntryData
        > {
  $$LabourWorkEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LaboursTable _labourIdTable(_$AppDatabase db) =>
      db.labours.createAlias(
        $_aliasNameGenerator(db.labourWorkEntries.labourId, db.labours.id),
      );

  $$LaboursTableProcessedTableManager get labourId {
    final $_column = $_itemColumn<String>('labour_id')!;

    final manager = $$LaboursTableTableManager(
      $_db,
      $_db.labours,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_labourIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TrailasTable _trailaIdTable(_$AppDatabase db) =>
      db.trailas.createAlias(
        $_aliasNameGenerator(db.labourWorkEntries.trailaId, db.trailas.id),
      );

  $$TrailasTableProcessedTableManager? get trailaId {
    final $_column = $_itemColumn<String>('traila_id');
    if ($_column == null) return null;
    final manager = $$TrailasTableTableManager(
      $_db,
      $_db.trailas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trailaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LabourWorkEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LabourWorkEntriesTable> {
  $$LabourWorkEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entryNumber => $composableBuilder(
    column: $table.entryNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get previousOutstanding => $composableBuilder(
    column: $table.previousOutstanding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LaboursTableFilterComposer get labourId {
    final $$LaboursTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labourId,
      referencedTable: $db.labours,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LaboursTableFilterComposer(
            $db: $db,
            $table: $db.labours,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TrailasTableFilterComposer get trailaId {
    final $$TrailasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trailaId,
      referencedTable: $db.trailas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailasTableFilterComposer(
            $db: $db,
            $table: $db.trailas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabourWorkEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LabourWorkEntriesTable> {
  $$LabourWorkEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryNumber => $composableBuilder(
    column: $table.entryNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get previousOutstanding => $composableBuilder(
    column: $table.previousOutstanding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LaboursTableOrderingComposer get labourId {
    final $$LaboursTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labourId,
      referencedTable: $db.labours,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LaboursTableOrderingComposer(
            $db: $db,
            $table: $db.labours,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TrailasTableOrderingComposer get trailaId {
    final $$TrailasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trailaId,
      referencedTable: $db.trailas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailasTableOrderingComposer(
            $db: $db,
            $table: $db.trailas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabourWorkEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabourWorkEntriesTable> {
  $$LabourWorkEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entryNumber => $composableBuilder(
    column: $table.entryNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get previousOutstanding => $composableBuilder(
    column: $table.previousOutstanding,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$LaboursTableAnnotationComposer get labourId {
    final $$LaboursTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labourId,
      referencedTable: $db.labours,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LaboursTableAnnotationComposer(
            $db: $db,
            $table: $db.labours,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TrailasTableAnnotationComposer get trailaId {
    final $$TrailasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trailaId,
      referencedTable: $db.trailas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailasTableAnnotationComposer(
            $db: $db,
            $table: $db.trailas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LabourWorkEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LabourWorkEntriesTable,
          LabourWorkEntryData,
          $$LabourWorkEntriesTableFilterComposer,
          $$LabourWorkEntriesTableOrderingComposer,
          $$LabourWorkEntriesTableAnnotationComposer,
          $$LabourWorkEntriesTableCreateCompanionBuilder,
          $$LabourWorkEntriesTableUpdateCompanionBuilder,
          (LabourWorkEntryData, $$LabourWorkEntriesTableReferences),
          LabourWorkEntryData,
          PrefetchHooks Function({bool labourId, bool trailaId})
        > {
  $$LabourWorkEntriesTableTableManager(
    _$AppDatabase db,
    $LabourWorkEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabourWorkEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabourWorkEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabourWorkEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> labourId = const Value.absent(),
                Value<String?> trailaId = const Value.absent(),
                Value<String> entryNumber = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> cost = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> previousOutstanding = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabourWorkEntriesCompanion(
                id: id,
                labourId: labourId,
                trailaId: trailaId,
                entryNumber: entryNumber,
                description: description,
                cost: cost,
                date: date,
                previousOutstanding: previousOutstanding,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String labourId,
                Value<String?> trailaId = const Value.absent(),
                required String entryNumber,
                required String description,
                required double cost,
                required DateTime date,
                Value<double> previousOutstanding = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabourWorkEntriesCompanion.insert(
                id: id,
                labourId: labourId,
                trailaId: trailaId,
                entryNumber: entryNumber,
                description: description,
                cost: cost,
                date: date,
                previousOutstanding: previousOutstanding,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LabourWorkEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({labourId = false, trailaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (labourId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.labourId,
                                referencedTable:
                                    $$LabourWorkEntriesTableReferences
                                        ._labourIdTable(db),
                                referencedColumn:
                                    $$LabourWorkEntriesTableReferences
                                        ._labourIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (trailaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trailaId,
                                referencedTable:
                                    $$LabourWorkEntriesTableReferences
                                        ._trailaIdTable(db),
                                referencedColumn:
                                    $$LabourWorkEntriesTableReferences
                                        ._trailaIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LabourWorkEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LabourWorkEntriesTable,
      LabourWorkEntryData,
      $$LabourWorkEntriesTableFilterComposer,
      $$LabourWorkEntriesTableOrderingComposer,
      $$LabourWorkEntriesTableAnnotationComposer,
      $$LabourWorkEntriesTableCreateCompanionBuilder,
      $$LabourWorkEntriesTableUpdateCompanionBuilder,
      (LabourWorkEntryData, $$LabourWorkEntriesTableReferences),
      LabourWorkEntryData,
      PrefetchHooks Function({bool labourId, bool trailaId})
    >;
typedef $$BuyersTableCreateCompanionBuilder =
    BuyersCompanion Function({
      required String id,
      required String name,
      Value<String?> phone,
      Value<String?> cnic,
      Value<String?> address,
      Value<String?> whatsappNumber,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$BuyersTableUpdateCompanionBuilder =
    BuyersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> phone,
      Value<String?> cnic,
      Value<String?> address,
      Value<String?> whatsappNumber,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$BuyersTableReferences
    extends BaseReferences<_$AppDatabase, $BuyersTable, BuyerData> {
  $$BuyersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SalesTable, List<SaleData>> _salesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sales,
    aliasName: $_aliasNameGenerator(db.buyers.id, db.sales.buyerId),
  );

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.buyerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BuyersTableFilterComposer
    extends Composer<_$AppDatabase, $BuyersTable> {
  $$BuyersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cnic => $composableBuilder(
    column: $table.cnic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> salesRefs(
    Expression<bool> Function($$SalesTableFilterComposer f) f,
  ) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.buyerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BuyersTableOrderingComposer
    extends Composer<_$AppDatabase, $BuyersTable> {
  $$BuyersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cnic => $composableBuilder(
    column: $table.cnic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BuyersTableAnnotationComposer
    extends Composer<_$AppDatabase, $BuyersTable> {
  $$BuyersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get cnic =>
      $composableBuilder(column: $table.cnic, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> salesRefs<T extends Object>(
    Expression<T> Function($$SalesTableAnnotationComposer a) f,
  ) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.buyerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BuyersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BuyersTable,
          BuyerData,
          $$BuyersTableFilterComposer,
          $$BuyersTableOrderingComposer,
          $$BuyersTableAnnotationComposer,
          $$BuyersTableCreateCompanionBuilder,
          $$BuyersTableUpdateCompanionBuilder,
          (BuyerData, $$BuyersTableReferences),
          BuyerData,
          PrefetchHooks Function({bool salesRefs})
        > {
  $$BuyersTableTableManager(_$AppDatabase db, $BuyersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BuyersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BuyersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BuyersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> cnic = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> whatsappNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BuyersCompanion(
                id: id,
                name: name,
                phone: phone,
                cnic: cnic,
                address: address,
                whatsappNumber: whatsappNumber,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> cnic = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> whatsappNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BuyersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                cnic: cnic,
                address: address,
                whatsappNumber: whatsappNumber,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BuyersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({salesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (salesRefs) db.sales],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (salesRefs)
                    await $_getPrefetchedData<
                      BuyerData,
                      $BuyersTable,
                      SaleData
                    >(
                      currentTable: table,
                      referencedTable: $$BuyersTableReferences._salesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$BuyersTableReferences(db, table, p0).salesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.buyerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BuyersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BuyersTable,
      BuyerData,
      $$BuyersTableFilterComposer,
      $$BuyersTableOrderingComposer,
      $$BuyersTableAnnotationComposer,
      $$BuyersTableCreateCompanionBuilder,
      $$BuyersTableUpdateCompanionBuilder,
      (BuyerData, $$BuyersTableReferences),
      BuyerData,
      PrefetchHooks Function({bool salesRefs})
    >;
typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      required String id,
      required String trailaId,
      required String buyerId,
      required double salePrice,
      Value<double> manufacturingCost,
      Value<double> profit,
      required DateTime saleDate,
      required double paidAmount,
      required double remainingBalance,
      required String receiptNumber,
      Value<double> globalPreviousBalance,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<String> id,
      Value<String> trailaId,
      Value<String> buyerId,
      Value<double> salePrice,
      Value<double> manufacturingCost,
      Value<double> profit,
      Value<DateTime> saleDate,
      Value<double> paidAmount,
      Value<double> remainingBalance,
      Value<String> receiptNumber,
      Value<double> globalPreviousBalance,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$SalesTableReferences
    extends BaseReferences<_$AppDatabase, $SalesTable, SaleData> {
  $$SalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TrailasTable _trailaIdTable(_$AppDatabase db) => db.trailas
      .createAlias($_aliasNameGenerator(db.sales.trailaId, db.trailas.id));

  $$TrailasTableProcessedTableManager get trailaId {
    final $_column = $_itemColumn<String>('traila_id')!;

    final manager = $$TrailasTableTableManager(
      $_db,
      $_db.trailas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trailaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BuyersTable _buyerIdTable(_$AppDatabase db) => db.buyers.createAlias(
    $_aliasNameGenerator(db.sales.buyerId, db.buyers.id),
  );

  $$BuyersTableProcessedTableManager get buyerId {
    final $_column = $_itemColumn<String>('buyer_id')!;

    final manager = $$BuyersTableTableManager(
      $_db,
      $_db.buyers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_buyerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get manufacturingCost => $composableBuilder(
    column: $table.manufacturingCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get profit => $composableBuilder(
    column: $table.profit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get saleDate => $composableBuilder(
    column: $table.saleDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get globalPreviousBalance => $composableBuilder(
    column: $table.globalPreviousBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TrailasTableFilterComposer get trailaId {
    final $$TrailasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trailaId,
      referencedTable: $db.trailas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailasTableFilterComposer(
            $db: $db,
            $table: $db.trailas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BuyersTableFilterComposer get buyerId {
    final $$BuyersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.buyerId,
      referencedTable: $db.buyers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuyersTableFilterComposer(
            $db: $db,
            $table: $db.buyers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get manufacturingCost => $composableBuilder(
    column: $table.manufacturingCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get profit => $composableBuilder(
    column: $table.profit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get saleDate => $composableBuilder(
    column: $table.saleDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get globalPreviousBalance => $composableBuilder(
    column: $table.globalPreviousBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrailasTableOrderingComposer get trailaId {
    final $$TrailasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trailaId,
      referencedTable: $db.trailas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailasTableOrderingComposer(
            $db: $db,
            $table: $db.trailas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BuyersTableOrderingComposer get buyerId {
    final $$BuyersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.buyerId,
      referencedTable: $db.buyers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuyersTableOrderingComposer(
            $db: $db,
            $table: $db.buyers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<double> get manufacturingCost => $composableBuilder(
    column: $table.manufacturingCost,
    builder: (column) => column,
  );

  GeneratedColumn<double> get profit =>
      $composableBuilder(column: $table.profit, builder: (column) => column);

  GeneratedColumn<DateTime> get saleDate =>
      $composableBuilder(column: $table.saleDate, builder: (column) => column);

  GeneratedColumn<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get globalPreviousBalance => $composableBuilder(
    column: $table.globalPreviousBalance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TrailasTableAnnotationComposer get trailaId {
    final $$TrailasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trailaId,
      referencedTable: $db.trailas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrailasTableAnnotationComposer(
            $db: $db,
            $table: $db.trailas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BuyersTableAnnotationComposer get buyerId {
    final $$BuyersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.buyerId,
      referencedTable: $db.buyers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BuyersTableAnnotationComposer(
            $db: $db,
            $table: $db.buyers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          SaleData,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (SaleData, $$SalesTableReferences),
          SaleData,
          PrefetchHooks Function({bool trailaId, bool buyerId})
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> trailaId = const Value.absent(),
                Value<String> buyerId = const Value.absent(),
                Value<double> salePrice = const Value.absent(),
                Value<double> manufacturingCost = const Value.absent(),
                Value<double> profit = const Value.absent(),
                Value<DateTime> saleDate = const Value.absent(),
                Value<double> paidAmount = const Value.absent(),
                Value<double> remainingBalance = const Value.absent(),
                Value<String> receiptNumber = const Value.absent(),
                Value<double> globalPreviousBalance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                trailaId: trailaId,
                buyerId: buyerId,
                salePrice: salePrice,
                manufacturingCost: manufacturingCost,
                profit: profit,
                saleDate: saleDate,
                paidAmount: paidAmount,
                remainingBalance: remainingBalance,
                receiptNumber: receiptNumber,
                globalPreviousBalance: globalPreviousBalance,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String trailaId,
                required String buyerId,
                required double salePrice,
                Value<double> manufacturingCost = const Value.absent(),
                Value<double> profit = const Value.absent(),
                required DateTime saleDate,
                required double paidAmount,
                required double remainingBalance,
                required String receiptNumber,
                Value<double> globalPreviousBalance = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                trailaId: trailaId,
                buyerId: buyerId,
                salePrice: salePrice,
                manufacturingCost: manufacturingCost,
                profit: profit,
                saleDate: saleDate,
                paidAmount: paidAmount,
                remainingBalance: remainingBalance,
                receiptNumber: receiptNumber,
                globalPreviousBalance: globalPreviousBalance,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SalesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({trailaId = false, buyerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (trailaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trailaId,
                                referencedTable: $$SalesTableReferences
                                    ._trailaIdTable(db),
                                referencedColumn: $$SalesTableReferences
                                    ._trailaIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (buyerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.buyerId,
                                referencedTable: $$SalesTableReferences
                                    ._buyerIdTable(db),
                                referencedColumn: $$SalesTableReferences
                                    ._buyerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      SaleData,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (SaleData, $$SalesTableReferences),
      SaleData,
      PrefetchHooks Function({bool trailaId, bool buyerId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSettingData,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingData,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingData>,
          ),
          AppSettingData,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSettingData,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingData,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingData>,
      ),
      AppSettingData,
      PrefetchHooks Function()
    >;
typedef $$AppProfilesTableCreateCompanionBuilder =
    AppProfilesCompanion Function({
      required String id,
      Value<String?> businessName,
      required String ownerName,
      required String phoneNumber,
      Value<String?> address,
      Value<String?> businessType,
      Value<String?> whatsappNumber,
      Value<int> rowid,
    });
typedef $$AppProfilesTableUpdateCompanionBuilder =
    AppProfilesCompanion Function({
      Value<String> id,
      Value<String?> businessName,
      Value<String> ownerName,
      Value<String> phoneNumber,
      Value<String?> address,
      Value<String?> businessType,
      Value<String?> whatsappNumber,
      Value<int> rowid,
    });

class $$AppProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $AppProfilesTable> {
  $$AppProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessType => $composableBuilder(
    column: $table.businessType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppProfilesTable> {
  $$AppProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessType => $composableBuilder(
    column: $table.businessType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppProfilesTable> {
  $$AppProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerName =>
      $composableBuilder(column: $table.ownerName, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get businessType => $composableBuilder(
    column: $table.businessType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whatsappNumber => $composableBuilder(
    column: $table.whatsappNumber,
    builder: (column) => column,
  );
}

class $$AppProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppProfilesTable,
          AppProfileData,
          $$AppProfilesTableFilterComposer,
          $$AppProfilesTableOrderingComposer,
          $$AppProfilesTableAnnotationComposer,
          $$AppProfilesTableCreateCompanionBuilder,
          $$AppProfilesTableUpdateCompanionBuilder,
          (
            AppProfileData,
            BaseReferences<_$AppDatabase, $AppProfilesTable, AppProfileData>,
          ),
          AppProfileData,
          PrefetchHooks Function()
        > {
  $$AppProfilesTableTableManager(_$AppDatabase db, $AppProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> businessName = const Value.absent(),
                Value<String> ownerName = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> businessType = const Value.absent(),
                Value<String?> whatsappNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppProfilesCompanion(
                id: id,
                businessName: businessName,
                ownerName: ownerName,
                phoneNumber: phoneNumber,
                address: address,
                businessType: businessType,
                whatsappNumber: whatsappNumber,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> businessName = const Value.absent(),
                required String ownerName,
                required String phoneNumber,
                Value<String?> address = const Value.absent(),
                Value<String?> businessType = const Value.absent(),
                Value<String?> whatsappNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppProfilesCompanion.insert(
                id: id,
                businessName: businessName,
                ownerName: ownerName,
                phoneNumber: phoneNumber,
                address: address,
                businessType: businessType,
                whatsappNumber: whatsappNumber,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppProfilesTable,
      AppProfileData,
      $$AppProfilesTableFilterComposer,
      $$AppProfilesTableOrderingComposer,
      $$AppProfilesTableAnnotationComposer,
      $$AppProfilesTableCreateCompanionBuilder,
      $$AppProfilesTableUpdateCompanionBuilder,
      (
        AppProfileData,
        BaseReferences<_$AppDatabase, $AppProfilesTable, AppProfileData>,
      ),
      AppProfileData,
      PrefetchHooks Function()
    >;
typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      required String id,
      required String name,
      Value<double> balance,
      Value<String> type,
      Value<String?> iconType,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> balance,
      Value<String> type,
      Value<String?> iconType,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconType => $composableBuilder(
    column: $table.iconType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconType => $composableBuilder(
    column: $table.iconType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get iconType =>
      $composableBuilder(column: $table.iconType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          AccountData,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (
            AccountData,
            BaseReferences<_$AppDatabase, $AccountsTable, AccountData>,
          ),
          AccountData,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> iconType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                balance: balance,
                type: type,
                iconType: iconType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<double> balance = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> iconType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                balance: balance,
                type: type,
                iconType: iconType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      AccountData,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (AccountData, BaseReferences<_$AppDatabase, $AccountsTable, AccountData>),
      AccountData,
      PrefetchHooks Function()
    >;
typedef $$PrinterSettingsTableCreateCompanionBuilder =
    PrinterSettingsCompanion Function({
      Value<String> id,
      Value<String?> deviceName,
      Value<String?> deviceAddress,
      Value<String?> vendorId,
      Value<String?> productId,
      Value<String> paperSize,
      Value<String> connectionType,
      Value<bool> autoCut,
      Value<bool> autoPrint,
      Value<int> rowid,
    });
typedef $$PrinterSettingsTableUpdateCompanionBuilder =
    PrinterSettingsCompanion Function({
      Value<String> id,
      Value<String?> deviceName,
      Value<String?> deviceAddress,
      Value<String?> vendorId,
      Value<String?> productId,
      Value<String> paperSize,
      Value<String> connectionType,
      Value<bool> autoCut,
      Value<bool> autoPrint,
      Value<int> rowid,
    });

class $$PrinterSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $PrinterSettingsTable> {
  $$PrinterSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceAddress => $composableBuilder(
    column: $table.deviceAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paperSize => $composableBuilder(
    column: $table.paperSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoCut => $composableBuilder(
    column: $table.autoCut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoPrint => $composableBuilder(
    column: $table.autoPrint,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrinterSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrinterSettingsTable> {
  $$PrinterSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceAddress => $composableBuilder(
    column: $table.deviceAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vendorId => $composableBuilder(
    column: $table.vendorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paperSize => $composableBuilder(
    column: $table.paperSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoCut => $composableBuilder(
    column: $table.autoCut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoPrint => $composableBuilder(
    column: $table.autoPrint,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrinterSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrinterSettingsTable> {
  $$PrinterSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceAddress => $composableBuilder(
    column: $table.deviceAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vendorId =>
      $composableBuilder(column: $table.vendorId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get paperSize =>
      $composableBuilder(column: $table.paperSize, builder: (column) => column);

  GeneratedColumn<String> get connectionType => $composableBuilder(
    column: $table.connectionType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoCut =>
      $composableBuilder(column: $table.autoCut, builder: (column) => column);

  GeneratedColumn<bool> get autoPrint =>
      $composableBuilder(column: $table.autoPrint, builder: (column) => column);
}

class $$PrinterSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrinterSettingsTable,
          PrinterSettingData,
          $$PrinterSettingsTableFilterComposer,
          $$PrinterSettingsTableOrderingComposer,
          $$PrinterSettingsTableAnnotationComposer,
          $$PrinterSettingsTableCreateCompanionBuilder,
          $$PrinterSettingsTableUpdateCompanionBuilder,
          (
            PrinterSettingData,
            BaseReferences<
              _$AppDatabase,
              $PrinterSettingsTable,
              PrinterSettingData
            >,
          ),
          PrinterSettingData,
          PrefetchHooks Function()
        > {
  $$PrinterSettingsTableTableManager(
    _$AppDatabase db,
    $PrinterSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrinterSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrinterSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrinterSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> deviceName = const Value.absent(),
                Value<String?> deviceAddress = const Value.absent(),
                Value<String?> vendorId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String> paperSize = const Value.absent(),
                Value<String> connectionType = const Value.absent(),
                Value<bool> autoCut = const Value.absent(),
                Value<bool> autoPrint = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrinterSettingsCompanion(
                id: id,
                deviceName: deviceName,
                deviceAddress: deviceAddress,
                vendorId: vendorId,
                productId: productId,
                paperSize: paperSize,
                connectionType: connectionType,
                autoCut: autoCut,
                autoPrint: autoPrint,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> deviceName = const Value.absent(),
                Value<String?> deviceAddress = const Value.absent(),
                Value<String?> vendorId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String> paperSize = const Value.absent(),
                Value<String> connectionType = const Value.absent(),
                Value<bool> autoCut = const Value.absent(),
                Value<bool> autoPrint = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrinterSettingsCompanion.insert(
                id: id,
                deviceName: deviceName,
                deviceAddress: deviceAddress,
                vendorId: vendorId,
                productId: productId,
                paperSize: paperSize,
                connectionType: connectionType,
                autoCut: autoCut,
                autoPrint: autoPrint,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrinterSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrinterSettingsTable,
      PrinterSettingData,
      $$PrinterSettingsTableFilterComposer,
      $$PrinterSettingsTableOrderingComposer,
      $$PrinterSettingsTableAnnotationComposer,
      $$PrinterSettingsTableCreateCompanionBuilder,
      $$PrinterSettingsTableUpdateCompanionBuilder,
      (
        PrinterSettingData,
        BaseReferences<
          _$AppDatabase,
          $PrinterSettingsTable,
          PrinterSettingData
        >,
      ),
      PrinterSettingData,
      PrefetchHooks Function()
    >;
typedef $$KhatasTableCreateCompanionBuilder =
    KhatasCompanion Function({
      required String id,
      required String personName,
      Value<double> openingBalance,
      Value<double> totalAmount,
      Value<double> paidAmount,
      Value<double> remainingBalance,
      required DateTime date,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$KhatasTableUpdateCompanionBuilder =
    KhatasCompanion Function({
      Value<String> id,
      Value<String> personName,
      Value<double> openingBalance,
      Value<double> totalAmount,
      Value<double> paidAmount,
      Value<double> remainingBalance,
      Value<DateTime> date,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$KhatasTableReferences
    extends BaseReferences<_$AppDatabase, $KhatasTable, KhataData> {
  $$KhatasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$KhataItemsTable, List<KhataItemData>>
  _khataItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.khataItems,
    aliasName: $_aliasNameGenerator(db.khatas.id, db.khataItems.khataId),
  );

  $$KhataItemsTableProcessedTableManager get khataItemsRefs {
    final manager = $$KhataItemsTableTableManager(
      $_db,
      $_db.khataItems,
    ).filter((f) => f.khataId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_khataItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KhatasTableFilterComposer
    extends Composer<_$AppDatabase, $KhatasTable> {
  $$KhatasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personName => $composableBuilder(
    column: $table.personName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> khataItemsRefs(
    Expression<bool> Function($$KhataItemsTableFilterComposer f) f,
  ) {
    final $$KhataItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.khataItems,
      getReferencedColumn: (t) => t.khataId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KhataItemsTableFilterComposer(
            $db: $db,
            $table: $db.khataItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KhatasTableOrderingComposer
    extends Composer<_$AppDatabase, $KhatasTable> {
  $$KhatasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personName => $composableBuilder(
    column: $table.personName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KhatasTableAnnotationComposer
    extends Composer<_$AppDatabase, $KhatasTable> {
  $$KhatasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get personName => $composableBuilder(
    column: $table.personName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get openingBalance => $composableBuilder(
    column: $table.openingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> khataItemsRefs<T extends Object>(
    Expression<T> Function($$KhataItemsTableAnnotationComposer a) f,
  ) {
    final $$KhataItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.khataItems,
      getReferencedColumn: (t) => t.khataId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KhataItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.khataItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KhatasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KhatasTable,
          KhataData,
          $$KhatasTableFilterComposer,
          $$KhatasTableOrderingComposer,
          $$KhatasTableAnnotationComposer,
          $$KhatasTableCreateCompanionBuilder,
          $$KhatasTableUpdateCompanionBuilder,
          (KhataData, $$KhatasTableReferences),
          KhataData,
          PrefetchHooks Function({bool khataItemsRefs})
        > {
  $$KhatasTableTableManager(_$AppDatabase db, $KhatasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KhatasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KhatasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KhatasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> personName = const Value.absent(),
                Value<double> openingBalance = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> paidAmount = const Value.absent(),
                Value<double> remainingBalance = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KhatasCompanion(
                id: id,
                personName: personName,
                openingBalance: openingBalance,
                totalAmount: totalAmount,
                paidAmount: paidAmount,
                remainingBalance: remainingBalance,
                date: date,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String personName,
                Value<double> openingBalance = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> paidAmount = const Value.absent(),
                Value<double> remainingBalance = const Value.absent(),
                required DateTime date,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KhatasCompanion.insert(
                id: id,
                personName: personName,
                openingBalance: openingBalance,
                totalAmount: totalAmount,
                paidAmount: paidAmount,
                remainingBalance: remainingBalance,
                date: date,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$KhatasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({khataItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (khataItemsRefs) db.khataItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (khataItemsRefs)
                    await $_getPrefetchedData<
                      KhataData,
                      $KhatasTable,
                      KhataItemData
                    >(
                      currentTable: table,
                      referencedTable: $$KhatasTableReferences
                          ._khataItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$KhatasTableReferences(db, table, p0).khataItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.khataId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$KhatasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KhatasTable,
      KhataData,
      $$KhatasTableFilterComposer,
      $$KhatasTableOrderingComposer,
      $$KhatasTableAnnotationComposer,
      $$KhatasTableCreateCompanionBuilder,
      $$KhatasTableUpdateCompanionBuilder,
      (KhataData, $$KhatasTableReferences),
      KhataData,
      PrefetchHooks Function({bool khataItemsRefs})
    >;
typedef $$KhataItemsTableCreateCompanionBuilder =
    KhataItemsCompanion Function({
      Value<int> id,
      required String khataId,
      Value<String?> itemName,
      required double price,
      Value<String> type,
      Value<String?> paymentMethod,
      Value<DateTime> date,
      Value<DateTime> createdAt,
    });
typedef $$KhataItemsTableUpdateCompanionBuilder =
    KhataItemsCompanion Function({
      Value<int> id,
      Value<String> khataId,
      Value<String?> itemName,
      Value<double> price,
      Value<String> type,
      Value<String?> paymentMethod,
      Value<DateTime> date,
      Value<DateTime> createdAt,
    });

final class $$KhataItemsTableReferences
    extends BaseReferences<_$AppDatabase, $KhataItemsTable, KhataItemData> {
  $$KhataItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KhatasTable _khataIdTable(_$AppDatabase db) => db.khatas.createAlias(
    $_aliasNameGenerator(db.khataItems.khataId, db.khatas.id),
  );

  $$KhatasTableProcessedTableManager get khataId {
    final $_column = $_itemColumn<String>('khata_id')!;

    final manager = $$KhatasTableTableManager(
      $_db,
      $_db.khatas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_khataIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KhataItemsTableFilterComposer
    extends Composer<_$AppDatabase, $KhataItemsTable> {
  $$KhataItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$KhatasTableFilterComposer get khataId {
    final $$KhatasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.khataId,
      referencedTable: $db.khatas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KhatasTableFilterComposer(
            $db: $db,
            $table: $db.khatas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KhataItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $KhataItemsTable> {
  $$KhataItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$KhatasTableOrderingComposer get khataId {
    final $$KhatasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.khataId,
      referencedTable: $db.khatas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KhatasTableOrderingComposer(
            $db: $db,
            $table: $db.khatas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KhataItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KhataItemsTable> {
  $$KhataItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$KhatasTableAnnotationComposer get khataId {
    final $$KhatasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.khataId,
      referencedTable: $db.khatas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KhatasTableAnnotationComposer(
            $db: $db,
            $table: $db.khatas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KhataItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KhataItemsTable,
          KhataItemData,
          $$KhataItemsTableFilterComposer,
          $$KhataItemsTableOrderingComposer,
          $$KhataItemsTableAnnotationComposer,
          $$KhataItemsTableCreateCompanionBuilder,
          $$KhataItemsTableUpdateCompanionBuilder,
          (KhataItemData, $$KhataItemsTableReferences),
          KhataItemData,
          PrefetchHooks Function({bool khataId})
        > {
  $$KhataItemsTableTableManager(_$AppDatabase db, $KhataItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KhataItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KhataItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KhataItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> khataId = const Value.absent(),
                Value<String?> itemName = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => KhataItemsCompanion(
                id: id,
                khataId: khataId,
                itemName: itemName,
                price: price,
                type: type,
                paymentMethod: paymentMethod,
                date: date,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String khataId,
                Value<String?> itemName = const Value.absent(),
                required double price,
                Value<String> type = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => KhataItemsCompanion.insert(
                id: id,
                khataId: khataId,
                itemName: itemName,
                price: price,
                type: type,
                paymentMethod: paymentMethod,
                date: date,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KhataItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({khataId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (khataId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.khataId,
                                referencedTable: $$KhataItemsTableReferences
                                    ._khataIdTable(db),
                                referencedColumn: $$KhataItemsTableReferences
                                    ._khataIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$KhataItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KhataItemsTable,
      KhataItemData,
      $$KhataItemsTableFilterComposer,
      $$KhataItemsTableOrderingComposer,
      $$KhataItemsTableAnnotationComposer,
      $$KhataItemsTableCreateCompanionBuilder,
      $$KhataItemsTableUpdateCompanionBuilder,
      (KhataItemData, $$KhataItemsTableReferences),
      KhataItemData,
      PrefetchHooks Function({bool khataId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$LaboursTableTableManager get labours =>
      $$LaboursTableTableManager(_db, _db.labours);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$TrailasTableTableManager get trailas =>
      $$TrailasTableTableManager(_db, _db.trailas);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoiceItemsTableTableManager get invoiceItems =>
      $$InvoiceItemsTableTableManager(_db, _db.invoiceItems);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$SplitDetailsTableTableManager get splitDetails =>
      $$SplitDetailsTableTableManager(_db, _db.splitDetails);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TrailaExpensesTableTableManager get trailaExpenses =>
      $$TrailaExpensesTableTableManager(_db, _db.trailaExpenses);
  $$LabourWorkEntriesTableTableManager get labourWorkEntries =>
      $$LabourWorkEntriesTableTableManager(_db, _db.labourWorkEntries);
  $$BuyersTableTableManager get buyers =>
      $$BuyersTableTableManager(_db, _db.buyers);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$AppProfilesTableTableManager get appProfiles =>
      $$AppProfilesTableTableManager(_db, _db.appProfiles);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$PrinterSettingsTableTableManager get printerSettings =>
      $$PrinterSettingsTableTableManager(_db, _db.printerSettings);
  $$KhatasTableTableManager get khatas =>
      $$KhatasTableTableManager(_db, _db.khatas);
  $$KhataItemsTableTableManager get khataItems =>
      $$KhataItemsTableTableManager(_db, _db.khataItems);
}
