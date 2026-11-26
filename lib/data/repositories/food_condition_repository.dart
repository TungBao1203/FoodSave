import '../models/food_condition_check.dart';

abstract class IFoodConditionRepository {
  Future<void> addCheck(FoodConditionCheck check);

  Future<List<FoodConditionCheck>> getChecksByFoodId(
    String foodId,
  );

  Future<void> deleteChecksByFoodId(String foodId);
}

/// Repository lưu tạm lịch sử kiểm tra trong bộ nhớ.
/// Sẽ thay bằng Firestore ở Giai đoạn 06.
class FoodConditionRepository implements IFoodConditionRepository {
  final List<FoodConditionCheck> _checks = [];

  @override
  Future<void> addCheck(FoodConditionCheck check) async {
    if (check.id.trim().isEmpty || check.foodId.trim().isEmpty) {
      throw ArgumentError('ID kiểm tra và foodId là bắt buộc.');
    }

    if (_checks.any((item) => item.id == check.id)) {
      throw StateError('Mã lần kiểm tra đã tồn tại.');
    }

    _checks.add(check);
  }

  @override
  Future<List<FoodConditionCheck>> getChecksByFoodId(
    String foodId,
  ) async {
    final result = _checks.where((check) => check.foodId == foodId).toList();

    result.sort(
      (a, b) => b.checkedAt.compareTo(a.checkedAt),
    );

    return List.unmodifiable(result);
  }

  @override
  Future<void> deleteChecksByFoodId(String foodId) async {
    _checks.removeWhere(
      (check) => check.foodId == foodId,
    );
  }
}
