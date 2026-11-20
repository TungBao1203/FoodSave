enum ExpiryStatus {
  expired,
  expiringSoon,
  fresh,
}

class FoodModel {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final int daysUntilExpiry;
  final String category;
  final bool isExpiringSoon;

  // Các trường mở rộng cho Food Management.
  final DateTime? expiryDate;
  final DateTime? addedDate;
  final String? imageUrl;
  final String? notes;

  const FoodModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.daysUntilExpiry,
    required this.category,
    this.isExpiringSoon = false,
    this.expiryDate,
    this.addedDate,
    this.imageUrl,
    this.notes,
  });

  // Số ngày còn lại tính từ ngày hết hạn thực tế.
  // Nếu chưa có expiryDate, dùng dữ liệu cũ.
  int get remainingDays {
    if (expiryDate == null) {
      return daysUntilExpiry;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final expiry = DateTime(
      expiryDate!.year,
      expiryDate!.month,
      expiryDate!.day,
    );

    return expiry.difference(today).inDays;
  }

  // Phân loại hạn sử dụng.
  ExpiryStatus get expiryStatus {
    if (remainingDays < 0) {
      return ExpiryStatus.expired;
    }

    if (remainingDays <= 3) {
      return ExpiryStatus.expiringSoon;
    }

    return ExpiryStatus.fresh;
  }

  // Hiển thị trạng thái bằng tiếng Việt.
  String get expiryLabel {
    if (remainingDays < 0) {
      return 'Đã hết hạn';
    }

    if (remainingDays == 0) {
      return 'Hết hạn hôm nay';
    }

    if (remainingDays <= 3) {
      return 'Sắp hết hạn';
    }

    return 'Còn hạn sử dụng';
  }

  // Tạo bản cập nhật mà không thay đổi đối tượng ban đầu.
  FoodModel copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    int? daysUntilExpiry,
    String? category,
    bool? isExpiringSoon,
    DateTime? expiryDate,
    DateTime? addedDate,
    String? imageUrl,
    String? notes,
  }) {
    return FoodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      daysUntilExpiry: daysUntilExpiry ?? this.daysUntilExpiry,
      category: category ?? this.category,
      isExpiringSoon: isExpiringSoon ?? this.isExpiringSoon,
      expiryDate: expiryDate ?? this.expiryDate,
      addedDate: addedDate ?? this.addedDate,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
    );
  }

  // Chuyển JSON thành FoodModel.
  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      daysUntilExpiry: (json['daysUntilExpiry'] as num).toInt(),
      category: json['category'] as String,
      isExpiringSoon: json['isExpiringSoon'] as bool? ?? false,
      expiryDate: _parseDate(json['expiryDate']),
      addedDate: _parseDate(json['addedDate']),
      imageUrl: json['imageUrl'] as String?,
      notes: json['notes'] as String?,
    );
  }

  // Chuyển FoodModel thành JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'daysUntilExpiry': daysUntilExpiry,
      'category': category,
      'isExpiringSoon': isExpiringSoon,
      'expiryDate': expiryDate?.toIso8601String(),
      'addedDate': addedDate?.toIso8601String(),
      'imageUrl': imageUrl,
      'notes': notes,
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
