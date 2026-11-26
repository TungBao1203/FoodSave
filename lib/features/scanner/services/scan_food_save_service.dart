import 'dart:typed_data';

import '../../../data/models/food_model.dart';
import 'food_image_memory_store.dart';
import '../../../data/models/scan_result_model.dart';
import '../../fridge/viewmodels/food_viewmodel.dart';

class ScanFoodSaveService {
  final FoodViewModel foodViewModel;

  ScanFoodSaveService({required this.foodViewModel});

  Future<void> saveItems(
    List<ScanFoodItem> items, {
    Uint8List? baselineImage,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError('Không có thực phẩm để lưu.');
    }

    // Kiểm tra toàn bộ dữ liệu trước khi bắt đầu lưu.
    for (final item in items) {
      if (item.name.trim().isEmpty ||
          item.category.trim().isEmpty ||
          item.quantity == null ||
          !item.quantity!.isFinite ||
          item.quantity! <= 0 ||
          item.unit == null ||
          item.unit!.trim().isEmpty ||
          item.expiryDate == null) {
        throw ArgumentError(
          'Vui lòng nhập đủ tên, danh mục, số lượng, '
          'đơn vị và hạn sử dụng.',
        );
      }
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final expiry = item.expiryDate!;

      final expiryDay = DateTime(
        expiry.year,
        expiry.month,
        expiry.day,
      );

      final food = FoodModel(
        id: 'scan_${now.microsecondsSinceEpoch}_$i',
        name: item.name.trim(),
        category: item.category.trim(),
        quantity: item.quantity!,
        unit: item.unit!.trim(),
        daysUntilExpiry: expiryDay.difference(today).inDays,
        expiryDate: expiryDay,
        addedDate: now,
        storageLocation: StorageLocation.fridge,
      );

      final success = await foodViewModel.addFood(food);

      if (!success) {
        throw StateError(
          foodViewModel.errorMessage ?? 'Không thể lưu thực phẩm.',
        );
      }

      if (baselineImage != null && baselineImage.isNotEmpty) {
        FoodImageMemoryStore.instance.saveBaselineIfAbsent(
          food.id,
          baselineImage,
        );
      }
    }
  }
}
