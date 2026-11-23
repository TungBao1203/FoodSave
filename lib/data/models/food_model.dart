class FoodModel {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final int daysUntilExpiry;
  final String category;
  final bool isExpiringSoon;

  const FoodModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.daysUntilExpiry,
    required this.category,
    this.isExpiringSoon = false,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      daysUntilExpiry: json['daysUntilExpiry'] as int,
      category: json['category'] as String,
      isExpiringSoon: json['isExpiringSoon'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'daysUntilExpiry': daysUntilExpiry,
      'category': category,
      'isExpiringSoon': isExpiringSoon,
    };
  }
}
