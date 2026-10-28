class Buyer {
  final String id;
  final String name;
  final String phone;
  final String cnic;
  final String address;
  final String whatsappNumber;

  Buyer({
    required this.id,
    required this.name,
    required this.phone,
    required this.cnic,
    required this.address,
    this.whatsappNumber = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'cnic': cnic,
      'address': address,
      'whatsapp': whatsappNumber,
    };
  }

  factory Buyer.fromMap(Map<String, dynamic> map) {
    return Buyer(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      cnic: map['cnic'] ?? '',
      address: map['address'] ?? '',
      whatsappNumber: map['whatsapp'] ?? '',
    );
  }

  Buyer copyWith({
    String? id,
    String? name,
    String? phone,
    String? cnic,
    String? address,
    String? whatsappNumber,
  }) {
    return Buyer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      cnic: cnic ?? this.cnic,
      address: address ?? this.address,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
    );
  }
}
