import 'package:flutter_test/flutter_test.dart';

import 'package:food_save/data/models/food_model.dart';
import 'package:food_save/data/repositories/food_repository.dart';

void main() {
  late FoodRepository repository;

  const apple = FoodModel(
    id: 'food_001',
    name: 'Táo',
    quantity: 3,
    unit: 'quả',
    daysUntilExpiry: 5,
    category: 'Trái cây',
  );

  const milk = FoodModel(
    id: 'food_002',
    name: 'Sữa tươi',
    quantity: 1,
    unit: 'hộp',
    daysUntilExpiry: -1,
    category: 'Sữa',
  );

  setUp(() {
    repository = FoodRepository();
  });

  tearDown(() {
    repository.dispose();
  });

  group('FoodRepository CRUD Tests', () {
    test('Should start with an empty food list', () async {
      final foods = await repository.getFoods();

      expect(foods, isEmpty);
      expect(repository.totalFoods, 0);
    });

    test('Should add a new food', () async {
      await repository.addFood(apple);

      final foods = await repository.getFoods();

      expect(foods.length, 1);
      expect(foods.first.name, 'Táo');
    });

    test('Should get food by ID', () async {
      await repository.addFood(apple);

      final result = await repository.getFoodById('food_001');

      expect(result, isNotNull);
      expect(result!.quantity, 3);
    });

    test('Should update existing food', () async {
      await repository.addFood(apple);

      final updated = apple.copyWith(quantity: 2);

      await repository.updateFood(updated);

      final result = await repository.getFoodById('food_001');

      expect(result!.quantity, 2);
    });

    test('Should delete a food', () async {
      await repository.addFood(apple);

      await repository.deleteFood('food_001');

      final foods = await repository.getFoods();

      expect(foods, isEmpty);
    });

    test('Should calculate expired food count', () async {
      await repository.addFood(apple);
      await repository.addFood(milk);

      expect(repository.totalFoods, 2);
      expect(repository.expiredCount, 1);
      expect(repository.expiringSoonCount, 0);
    });

    test('Should reject duplicate food IDs', () async {
      await repository.addFood(apple);

      await expectLater(
        repository.addFood(apple),
        throwsStateError,
      );
    });

    test('Should reject invalid quantity', () async {
      final invalidFood = apple.copyWith(quantity: -2);

      await expectLater(
        repository.addFood(invalidFood),
        throwsArgumentError,
      );
    });

    test('Should reject updating unknown food', () async {
      await expectLater(
        repository.updateFood(apple),
        throwsStateError,
      );
    });

    test('Should notify listeners when food changes', () async {
      var notifications = 0;

      repository.addListener(() {
        notifications++;
      });

      await repository.addFood(apple);
      await repository.updateFood(apple.copyWith(quantity: 2));
      await repository.deleteFood(apple.id);

      expect(notifications, 3);
    });

    test('Should prevent external list modification', () async {
      await repository.addFood(apple);

      final foods = await repository.getFoods();

      expect(
        () => foods.clear(),
        throwsUnsupportedError,
      );

      expect(repository.totalFoods, 1);
    });
  });
}
