import 'package:flutter_test/flutter_test.dart';

import 'package:food_save/data/models/food_condition_result.dart';

void main() {
  group('FoodConditionResult Tests', () {
    final checkedAt = DateTime.utc(2026, 11, 26);

    test('Tạo kết quả kiểm tra tình trạng', () {
      final result = FoodConditionResult(
        foodId: 'food_001',
        status: FoodConditionStatus.visibleChange,
        visibleChanges: const [
          'Xuất hiện vùng sẫm màu',
        ],
        summary: 'Có thay đổi trên bề mặt.',
        needsReview: true,
        checkedAt: checkedAt,
      );

      expect(result.foodId, 'food_001');
      expect(result.visibleChanges.length, 1);
      expect(result.needsReview, true);
    });

    test('Chuyển đổi JSON hai chiều', () {
      final original = FoodConditionResult(
        foodId: 'food_002',
        status: FoodConditionStatus.noVisibleChange,
        visibleChanges: const [],
        summary: 'Không phát hiện thay đổi rõ ràng.',
        needsReview: false,
        checkedAt: checkedAt,
      );

      final restored = FoodConditionResult.fromJson(
        original.toJson(),
      );

      expect(restored.foodId, original.foodId);
      expect(restored.status, original.status);
      expect(restored.summary, original.summary);
      expect(restored.checkedAt, original.checkedAt);
    });

    test('Trạng thái không hợp lệ được xử lý an toàn', () {
      final result = FoodConditionResult.fromJson({
        'foodId': 'food_003',
        'status': 'invalidStatus',
        'checkedAt': checkedAt.toIso8601String(),
      });

      expect(result.status, FoodConditionStatus.unknown);
      expect(result.needsReview, true);
      expect(result.visibleChanges, isEmpty);
    });
  });
}
