import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:food_save/features/scanner/services/food_image_memory_store.dart';

void main() {
  final store = FoodImageMemoryStore.instance;

  setUp(store.clear);
  tearDown(store.clear);

  test('Lưu ảnh gốc theo đúng foodId', () {
    store.saveBaselineIfAbsent(
      'apple_01',
      Uint8List.fromList([1, 2, 3]),
    );

    expect(store.hasBaseline('apple_01'), true);
    expect(store.hasBaseline('tomato_01'), false);
    expect(store.baselineFor('apple_01'), [1, 2, 3]);
  });

  test('Ảnh gốc không bị ghi đè khi kiểm tra lần sau', () {
    store.saveBaselineIfAbsent(
      'apple_01',
      Uint8List.fromList([1, 2, 3]),
    );

    store.saveBaselineIfAbsent(
      'apple_01',
      Uint8List.fromList([4, 5, 6]),
    );

    expect(store.baselineFor('apple_01'), [1, 2, 3]);
  });

  test('Ảnh của hai thực phẩm không bị lẫn', () {
    store.saveBaselineIfAbsent(
      'apple_01',
      Uint8List.fromList([1]),
    );

    store.saveBaselineIfAbsent(
      'tomato_01',
      Uint8List.fromList([9]),
    );

    expect(store.baselineFor('apple_01'), [1]);
    expect(store.baselineFor('tomato_01'), [9]);
  });

  test('Không cho dữ liệu bên ngoài sửa ảnh gốc', () {
    final original = Uint8List.fromList([1, 2, 3]);

    store.saveBaselineIfAbsent('apple_01', original);
    original[0] = 99;

    final retrieved = store.baselineFor('apple_01')!;
    retrieved[1] = 88;

    expect(store.baselineFor('apple_01'), [1, 2, 3]);
  });
}
