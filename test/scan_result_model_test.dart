import 'package:flutter_test/flutter_test.dart';
import 'package:food_save/data/models/scan_result_model.dart';

void main() {
  group('ScanResultModel Tests', () {
    test('Should create a scanned food item', () {
      const item = ScanFoodItem(
        name: 'Táo',
        category: 'Trái cây',
        quantity: 2,
        unit: 'quả',
      );

      expect(item.name, 'Táo');
      expect(item.quantity, 2);
      expect(item.category, 'Trái cây');
    });

    test('Should support unknown quantity and expiry date', () {
      const item = ScanFoodItem(
        name: 'Chuối',
        category: 'Trái cây',
      );

      expect(item.quantity, isNull);
      expect(item.expiryDate, isNull);
      expect(item.confidence, isNull);
    });

    test('Should create scan result with multiple foods', () {
      final result = ScanResultModel(
        id: 'scan_001',
        source: ScanSource.camera,
        scannedAt: DateTime(2026, 11, 21),
        items: const [
          ScanFoodItem(
            name: 'Táo',
            category: 'Trái cây',
          ),
          ScanFoodItem(
            name: 'Chuối',
            category: 'Trái cây',
          ),
        ],
      );

      expect(result.hasFood, isTrue);
      expect(result.totalItems, 2);
    });

    test('Should handle empty scan result', () {
      final result = ScanResultModel(
        id: 'scan_002',
        source: ScanSource.gallery,
        scannedAt: DateTime(2026, 11, 21),
        items: const [],
      );

      expect(result.hasFood, isFalse);
      expect(result.totalItems, 0);
    });

    test('Should update scanned food item', () {
      const item = ScanFoodItem(
        name: 'Táo',
        category: 'Trái cây',
        quantity: 3,
        unit: 'quả',
      );

      final updated = item.copyWith(quantity: 2);

      expect(updated.quantity, 2);
      expect(item.quantity, 3);
    });

    test('Should convert scan result to JSON and back', () {
      final result = ScanResultModel(
        id: 'scan_003',
        imagePath: '/images/food.jpg',
        source: ScanSource.camera,
        scannedAt: DateTime(2026, 11, 21),
        items: const [
          ScanFoodItem(
            name: 'Cà chua',
            category: 'Rau củ',
            quantity: 4,
            unit: 'quả',
          ),
        ],
      );

      final json = result.toJson();
      final restored = ScanResultModel.fromJson(json);

      expect(restored.id, result.id);
      expect(restored.source, ScanSource.camera);
      expect(restored.totalItems, 1);
      expect(restored.items.first.name, 'Cà chua');
      expect(restored.items.first.quantity, 4);
    });
  });
}
