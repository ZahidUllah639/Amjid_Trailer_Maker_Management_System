class AppProfile {
  final String id;
  final String? businessName;
  final String ownerName;
  final String phoneNumber;
  final String? address;
  final String? whatsappNumber;

  AppProfile({
    required this.id,
    this.businessName,
    required this.ownerName,
    required this.phoneNumber,
    this.address,
    this.whatsappNumber,
  });

  AppProfile copyWith({
    String? id,
    String? businessName,
    String? ownerName,
    String? phoneNumber,
    String? address,
    String? whatsappNumber,
  }) {
    return AppProfile(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'businessName': businessName,
      'ownerName': ownerName,
      'phoneNumber': phoneNumber,
      'address': address,
      'whatsappNumber': whatsappNumber,
    };
  }

  factory AppProfile.fromMap(Map<String, dynamic> map) {
    return AppProfile(
      id: map['id'] ?? 'default',
      businessName: map['businessName'],
      ownerName: map['ownerName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'],
      whatsappNumber: map['whatsappNumber'],
    );
  }
}
