enum ScanSource {
  camera,
  gallery,
}

class ScanFoodItem {
  final String name;
  final String category;
  final double? quantity;
  final String? unit;
  final double? confidence;
  final DateTime? expiryDate;

  const ScanFoodItem({
    required this.name,
    required this.category,
    this.quantity,
    this.unit,
    this.confidence,
    this.expiryDate,
  });

  // Chuyển JSON nhận diện thành đối tượng Dart.
  factory ScanFoodItem.fromJson(Map<String, dynamic> json) {
    return ScanFoodItem(
      name: json['name'] as String,
      category: json['category'] as String? ?? 'Khác',
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      expiryDate: _parseDate(json['expiryDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'confidence': confidence,
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }

  // Cho phép chỉnh sửa kết quả AI trước khi lưu.
  ScanFoodItem copyWith({
    String? name,
    String? category,
    double? quantity,
    String? unit,
    double? confidence,
    DateTime? expiryDate,
  }) {
    return ScanFoodItem(
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      confidence: confidence ?? this.confidence,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

class ScanResultModel {
  final String id;
  final String? imagePath;
  final ScanSource source;
  final DateTime scannedAt;
  final List<ScanFoodItem> items;

  const ScanResultModel({
    required this.id,
    required this.source,
    required this.scannedAt,
    required this.items,
    this.imagePath,
  });

  bool get hasFood => items.isNotEmpty;

  int get totalItems => items.length;

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    final sourceValue = json['source'] as String? ?? 'camera';

    return ScanResultModel(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String?,
      source: ScanSource.values.byName(sourceValue),
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      items: (json['items'] as List<dynamic>)
          .map(
            (item) => ScanFoodItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'source': source.name,
      'scannedAt': scannedAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  ScanResultModel copyWith({
    String? imagePath,
    List<ScanFoodItem>? items,
  }) {
    return ScanResultModel(
      id: id,
      imagePath: imagePath ?? this.imagePath,
      source: source,
      scannedAt: scannedAt,
      items: items ?? this.items,
    );
  }
}
