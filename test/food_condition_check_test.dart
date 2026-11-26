import 'package:flutter_test/flutter_test.dart';
import 'package:food_save/data/models/food_condition_check.dart';

void main() {
  group('FoodConditionCheck', () {
    final checkedAt = DateTime.utc(2026, 11, 26);

    test('Tạo lịch sử gắn với đúng thực phẩm', () {
      final check = FoodConditionCheck(
        id: 'check_01',
        foodId: 'apple_01',
        checkedAt: checkedAt,
      );

      expect(check.id, 'check_01');
      expect(check.foodId, 'apple_01');
      expect(check.visibleChanges, isEmpty);
      expect(check.resultSummary, isNull);
    });

    test('Chuyển đổi JSON hai chiều', () {
      final original = FoodConditionCheck(
        id: 'check_02',
        foodId: 'tomato_01',
        checkedAt: checkedAt,
        beforeImageUrl: 'https://example.com/before.jpg',
        afterImageUrl: 'https://example.com/after.jpg',
        resultSummary: 'Có thay đổi nhìn thấy được.',
        visibleChanges: const ['Vùng màu sẫm'],
      );

      final restored = FoodConditionCheck.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.foodId, original.foodId);
      expect(restored.checkedAt, original.checkedAt);
      expect(restored.beforeImageUrl, original.beforeImageUrl);
      expect(restored.afterImageUrl, original.afterImageUrl);
      expect(restored.resultSummary, original.resultSummary);
      expect(restored.visibleChanges, original.visibleChanges);
    });

    test('Đọc JSON khi thiếu các trường tùy chọn', () {
      final check = FoodConditionCheck.fromJson({
        'id': 'check_03',
        'foodId': 'banana_01',
        'checkedAt': checkedAt.toIso8601String(),
      });

      expect(check.foodId, 'banana_01');
      expect(check.beforeImageUrl, isNull);
      expect(check.afterImageUrl, isNull);
      expect(check.visibleChanges, isEmpty);
    });
  });
}
