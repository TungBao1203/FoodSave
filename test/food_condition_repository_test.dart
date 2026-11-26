import 'package:flutter_test/flutter_test.dart';

import 'package:food_save/data/models/food_condition_check.dart';
import 'package:food_save/data/repositories/food_condition_repository.dart';

void main() {
  late FoodConditionRepository repository;

  setUp(() {
    repository = FoodConditionRepository();
  });

  FoodConditionCheck createCheck({
    required String id,
    required String foodId,
    required int day,
  }) {
    return FoodConditionCheck(
      id: id,
      foodId: foodId,
      checkedAt: DateTime.utc(2026, 11, day),
    );
  }

  test('Lưu và lấy lịch sử theo foodId', () async {
    await repository.addCheck(
      createCheck(id: 'check_1', foodId: 'apple_1', day: 26),
    );

    final history = await repository.getChecksByFoodId('apple_1');

    expect(history.length, 1);
    expect(history.first.foodId, 'apple_1');
  });

  test('Không lẫn lịch sử của hai thực phẩm', () async {
    await repository.addCheck(
      createCheck(id: 'check_1', foodId: 'apple_1', day: 26),
    );

    await repository.addCheck(
      createCheck(id: 'check_2', foodId: 'tomato_1', day: 27),
    );

    final history = await repository.getChecksByFoodId('apple_1');

    expect(history.length, 1);
    expect(history.first.id, 'check_1');
  });

  test('Lịch sử mới nhất hiển thị trước', () async {
    await repository.addCheck(
      createCheck(id: 'old', foodId: 'apple_1', day: 26),
    );

    await repository.addCheck(
      createCheck(id: 'new', foodId: 'apple_1', day: 28),
    );

    final history = await repository.getChecksByFoodId('apple_1');

    expect(history.first.id, 'new');
    expect(history.last.id, 'old');
  });

  test('Không cho thêm mã kiểm tra trùng', () async {
    await repository.addCheck(
      createCheck(id: 'check_1', foodId: 'apple_1', day: 26),
    );

    await expectLater(
      repository.addCheck(
        createCheck(
          id: 'check_1',
          foodId: 'apple_1',
          day: 27,
        ),
      ),
      throwsStateError,
    );
  });

  test('Xóa đúng lịch sử của một thực phẩm', () async {
    await repository.addCheck(
      createCheck(id: 'check_1', foodId: 'apple_1', day: 26),
    );

    await repository.addCheck(
      createCheck(id: 'check_2', foodId: 'tomato_1', day: 27),
    );

    await repository.deleteChecksByFoodId('apple_1');

    expect(
      await repository.getChecksByFoodId('apple_1'),
      isEmpty,
    );

    expect(
      (await repository.getChecksByFoodId('tomato_1')).length,
      1,
    );
  });
}
