import 'package:flutter_test/flutter_test.dart';
import 'package:food_save/data/models/food_model.dart';

void main() {
  group('FoodModel Tests', () {
    test('Should create a food item correctly', () {
      const food = FoodModel(
        id: 'food_001',
        name: 'Táo',
        quantity: 3,
        unit: 'quả',
        daysUntilExpiry: 5,
        category: 'Trái cây',
      );

      expect(food.name, 'Táo');
      expect(food.quantity, 3);
      expect(food.remainingDays, 5);
      expect(food.expiryStatus, ExpiryStatus.fresh);
    });

    test('Should detect expired food', () {
      const food = FoodModel(
        id: 'food_002',
        name: 'Sữa tươi',
        quantity: 1,
        unit: 'hộp',
        daysUntilExpiry: -2,
        category: 'Sữa',
      );

      expect(food.expiryStatus, ExpiryStatus.expired);
      expect(food.expiryLabel, 'Đã hết hạn');
    });

    test('Should detect expiring food', () {
      const food = FoodModel(
        id: 'food_003',
        name: 'Cà chua',
        quantity: 4,
        unit: 'quả',
        daysUntilExpiry: 2,
        category: 'Rau củ',
      );

      expect(
        food.expiryStatus,
        ExpiryStatus.expiringSoon,
      );
    });

    test('Should calculate remaining days from expiry date', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final food = FoodModel(
        id: 'food_004',
        name: 'Trứng gà',
        quantity: 6,
        unit: 'quả',
        daysUntilExpiry: 99,
        category: 'Trứng',
        expiryDate: today.add(const Duration(days: 2)),
      );

      expect(food.remainingDays, 2);
      expect(food.expiryStatus, ExpiryStatus.expiringSoon);
    });

    test('Should update food with copyWith', () {
      const food = FoodModel(
        id: 'food_005',
        name: 'Chuối',
        quantity: 5,
        unit: 'quả',
        daysUntilExpiry: 4,
        category: 'Trái cây',
      );

      final updated = food.copyWith(quantity: 2);

      expect(updated.quantity, 2);
      expect(updated.name, 'Chuối');
      expect(food.quantity, 5);
    });

    test('Should convert FoodModel to JSON and back', () {
      const food = FoodModel(
        id: 'food_006',
        name: 'Thịt bò',
        quantity: 500,
        unit: 'g',
        daysUntilExpiry: 3,
        category: 'Thịt',
        notes: 'Bảo quản ngăn mát',
      );

      final json = food.toJson();
      final restored = FoodModel.fromJson(json);

      expect(restored.id, food.id);
      expect(restored.name, food.name);
      expect(restored.quantity, food.quantity);
      expect(restored.notes, food.notes);
    });
  });
}
