import 'package:flutter/foundation.dart';

import '../models/food_model.dart';

/// Interface dùng chung cho các nguồn dữ liệu thực phẩm.
/// Sau này FirestoreFoodRepository có thể triển khai interface này.
abstract class IFoodRepository {
  Future<List<FoodModel>> getFoods();

  Future<FoodModel?> getFoodById(String id);

  Future<void> addFood(FoodModel food);

  Future<void> updateFood(FoodModel food);

  Future<void> deleteFood(String id);
}

/// Repository tạm thời sử dụng dữ liệu trong bộ nhớ.
///
/// Dùng cho giai đoạn phát triển và kiểm thử.
/// Dữ liệu sẽ mất khi ứng dụng khởi động lại.
class FoodRepository extends ChangeNotifier implements IFoodRepository {
  final List<FoodModel> _foods;

  FoodRepository({List<FoodModel>? initialFoods})
      : _foods = List<FoodModel>.of(initialFoods ?? []);

  /// Danh sách chỉ đọc dành cho những nơi cần truy xuất đồng bộ.
  List<FoodModel> get foods => List.unmodifiable(_foods);

  /// Lấy tất cả thực phẩm.
  @override
  Future<List<FoodModel>> getFoods() async {
    return List.unmodifiable(_foods);
  }

  /// Tìm thực phẩm theo ID.
  @override
  Future<FoodModel?> getFoodById(String id) async {
    for (final food in _foods) {
      if (food.id == id) {
        return food;
      }
    }

    return null;
  }

  /// Thêm thực phẩm mới.
  @override
  Future<void> addFood(FoodModel food) async {
    _validateFood(food);

    final exists = _foods.any((item) => item.id == food.id);

    if (exists) {
      throw StateError('Thực phẩm với ID ${food.id} đã tồn tại');
    }

    _foods.add(food);
    notifyListeners();
  }

  /// Cập nhật thực phẩm hiện có.
  @override
  Future<void> updateFood(FoodModel food) async {
    _validateFood(food);

    final index = _foods.indexWhere((item) => item.id == food.id);

    if (index == -1) {
      throw StateError('Không tìm thấy thực phẩm: ${food.id}');
    }

    _foods[index] = food;
    notifyListeners();
  }

  /// Xóa thực phẩm theo ID.
  @override
  Future<void> deleteFood(String id) async {
    final index = _foods.indexWhere((item) => item.id == id);

    if (index == -1) {
      throw StateError('Không tìm thấy thực phẩm: $id');
    }

    _foods.removeAt(index);
    notifyListeners();
  }

  /// Đếm tổng số loại thực phẩm.
  int get totalFoods => _foods.length;

  /// Đếm số loại thực phẩm đã hết hạn.
  int get expiredCount {
    return _foods
        .where(
          (food) => food.expiryStatus == ExpiryStatus.expired,
        )
        .length;
  }

  /// Đếm số loại thực phẩm sắp hết hạn.
  int get expiringSoonCount {
    return _foods
        .where(
          (food) => food.expiryStatus == ExpiryStatus.expiringSoon,
        )
        .length;
  }

  /// Kiểm tra dữ liệu trước khi thêm hoặc sửa.
  void _validateFood(FoodModel food) {
    if (food.id.trim().isEmpty) {
      throw ArgumentError('ID thực phẩm không được để trống');
    }

    if (food.name.trim().isEmpty) {
      throw ArgumentError('Tên thực phẩm không được để trống');
    }

    if (!food.quantity.isFinite || food.quantity <= 0) {
      throw ArgumentError('Số lượng thực phẩm phải lớn hơn 0');
    }

    if (food.unit.trim().isEmpty) {
      throw ArgumentError('Đơn vị không được để trống');
    }
  }
}
