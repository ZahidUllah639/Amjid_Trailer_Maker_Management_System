class Product {
  final String id;
  final String name;
  final double defaultPrice;
  final String unit; // 'PCS', 'LTR', 'KG', etc.

  Product({
    required this.id,
    required this.name,
    this.defaultPrice = 0.0,
    this.unit = 'PCS',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'defaultPrice': defaultPrice,
      'unit': unit,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      defaultPrice: (map['defaultPrice'] as num).toDouble(),
      unit: map['unit'] ?? 'PCS',
    );
  }
}
