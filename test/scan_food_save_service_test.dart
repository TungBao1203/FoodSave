import 'package:flutter_test/flutter_test.dart';

import 'package:food_save/data/models/scan_result_model.dart';
import 'package:food_save/data/repositories/food_repository.dart';
import 'package:food_save/features/fridge/viewmodels/food_viewmodel.dart';
import 'package:food_save/features/scanner/services/scan_food_save_service.dart';

void main() {
  late FoodRepository repository;
  late FoodViewModel foodViewModel;
  late ScanFoodSaveService service;

  setUp(() {
    repository = FoodRepository();
    foodViewModel = FoodViewModel(repository: repository);

    service = ScanFoodSaveService(
      foodViewModel: foodViewModel,
    );
  });

  tearDown(() {
    foodViewModel.dispose();
    repository.dispose();
  });

  test('Lưu một thực phẩm hợp lệ vào Tủ lạnh', () async {
    await service.saveItems([
      ScanFoodItem(
        name: 'Cà chua',
        category: 'Rau củ',
        quantity: 2,
        unit: 'quả',
        expiryDate: DateTime(2026, 12, 1),
      ),
    ]);

    final foods = await repository.getFoods();

    expect(foods.length, 1);
    expect(foods.first.name, 'Cà chua');
    expect(foods.first.quantity, 2);
    expect(foods.first.category, 'Rau củ');
    expect(foods.first.expiryDate, DateTime(2026, 12, 1));
  });

  test('Lưu nhiều thực phẩm cùng lúc', () async {
    await service.saveItems([
      ScanFoodItem(
        name: 'Táo',
        category: 'Trái cây',
        quantity: 3,
        unit: 'quả',
        expiryDate: DateTime(2026, 12, 5),
      ),
      ScanFoodItem(
        name: 'Sữa tươi',
        category: 'Sữa',
        quantity: 1,
        unit: 'hộp',
        expiryDate: DateTime(2026, 12, 3),
      ),
    ]);

    final foods = await repository.getFoods();

    expect(foods.length, 2);
    expect(
      foods.map((food) => food.name),
      containsAll(['Táo', 'Sữa tươi']),
    );
  });

  test('Không lưu khi thiếu hạn sử dụng', () async {
    await expectLater(
      service.saveItems([
        const ScanFoodItem(
          name: 'Trứng',
          category: 'Trứng',
          quantity: 6,
          unit: 'quả',
        ),
      ]),
      throwsArgumentError,
    );

    expect((await repository.getFoods()), isEmpty);
  });

  test('Không lưu số lượng không hợp lệ', () async {
    await expectLater(
      service.saveItems([
        ScanFoodItem(
          name: 'Thịt bò',
          category: 'Thịt',
          quantity: -1,
          unit: 'kg',
          expiryDate: DateTime(2026, 12, 2),
        ),
      ]),
      throwsArgumentError,
    );

    expect((await repository.getFoods()), isEmpty);
  });

  test('Không lưu một phần nếu dữ liệu đầu vào sai', () async {
    await expectLater(
      service.saveItems([
        ScanFoodItem(
          name: 'Táo',
          category: 'Trái cây',
          quantity: 2,
          unit: 'quả',
          expiryDate: DateTime(2026, 12, 3),
        ),
        const ScanFoodItem(
          name: '',
          category: 'Rau củ',
          quantity: 1,
          unit: 'kg',
        ),
      ]),
      throwsArgumentError,
    );

    expect((await repository.getFoods()), isEmpty);
  });

  test('Không lưu danh sách rỗng', () async {
    await expectLater(
      service.saveItems([]),
      throwsArgumentError,
    );

    expect((await repository.getFoods()), isEmpty);
  });
}
