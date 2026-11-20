import 'package:flutter_test/flutter_test.dart';

import 'package:food_save/data/models/food_model.dart';
import 'package:food_save/data/repositories/food_repository.dart';
import 'package:food_save/features/fridge/viewmodels/food_viewmodel.dart';

void main() {
  late FoodRepository repository;
  late FoodViewModel viewModel;

  const apple = FoodModel(
    id: 'food_001',
    name: 'Táo',
    quantity: 3,
    unit: 'quả',
    daysUntilExpiry: 7,
    category: 'Trái cây',
  );

  const milk = FoodModel(
    id: 'food_002',
    name: 'Sữa tươi',
    quantity: 1,
    unit: 'hộp',
    daysUntilExpiry: 2,
    category: 'Sữa',
  );

  const chicken = FoodModel(
    id: 'food_003',
    name: 'Thịt gà',
    quantity: 500,
    unit: 'g',
    daysUntilExpiry: -1,
    category: 'Thịt',
  );

  setUp(() {
    repository = FoodRepository(
      initialFoods: [apple, milk, chicken],
    );

    viewModel = FoodViewModel(
      repository: repository,
    );
  });

  tearDown(() {
    viewModel.dispose();
    repository.dispose();
  });

  group('FoodViewModel Tests', () {
    test('Should load all food items', () async {
      await viewModel.loadFoods();

      expect(viewModel.totalFoods, 3);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, isNull);
    });

    test('Should calculate expiry statistics', () async {
      await viewModel.loadFoods();

      expect(viewModel.freshCount, 1);
      expect(viewModel.expiringSoonCount, 1);
      expect(viewModel.expiredCount, 1);
    });

    test('Should search food by name', () async {
      await viewModel.loadFoods();

      viewModel.setSearchQuery('táo');

      expect(viewModel.filteredFoods.length, 1);
      expect(viewModel.filteredFoods.first.name, 'Táo');
    });

    test('Should search without case sensitivity', () async {
      await viewModel.loadFoods();

      viewModel.setSearchQuery('SỮA');

      expect(viewModel.filteredFoods.length, 1);
      expect(viewModel.filteredFoods.first.name, 'Sữa tươi');
    });

    test('Should filter expiring food', () async {
      await viewModel.loadFoods();

      viewModel.setFilter(FoodFilter.expiringSoon);

      expect(viewModel.filteredFoods.length, 1);
      expect(viewModel.filteredFoods.first.name, 'Sữa tươi');
    });

    test('Should filter expired food', () async {
      await viewModel.loadFoods();

      viewModel.setFilter(FoodFilter.expired);

      expect(viewModel.filteredFoods.length, 1);
      expect(viewModel.filteredFoods.first.name, 'Thịt gà');
    });

    test('Should sort food by expiry date', () async {
      await viewModel.loadFoods();

      final foods = viewModel.filteredFoods;

      expect(foods[0].name, 'Thịt gà');
      expect(foods[1].name, 'Sữa tươi');
      expect(foods[2].name, 'Táo');
    });

    test('Should add food through repository', () async {
      await viewModel.loadFoods();

      const banana = FoodModel(
        id: 'food_004',
        name: 'Chuối',
        quantity: 4,
        unit: 'quả',
        daysUntilExpiry: 4,
        category: 'Trái cây',
      );

      final success = await viewModel.addFood(banana);

      expect(success, true);
      expect(viewModel.totalFoods, 4);
    });

    test('Should update food quantity', () async {
      await viewModel.loadFoods();

      final success = await viewModel.updateFood(
        apple.copyWith(quantity: 2),
      );

      expect(success, true);

      final updated = await repository.getFoodById('food_001');

      expect(updated!.quantity, 2);
    });

    test('Should delete food', () async {
      await viewModel.loadFoods();

      final success = await viewModel.deleteFood('food_001');

      expect(success, true);
      expect(viewModel.totalFoods, 2);
    });

    test('Should handle invalid food', () async {
      await viewModel.loadFoods();

      final invalidFood = apple.copyWith(
        id: 'invalid_food',
        quantity: -5,
      );

      final success = await viewModel.addFood(invalidFood);

      expect(success, false);
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.totalFoods, 3);
    });

    test('Should clear search and filters', () async {
      await viewModel.loadFoods();

      viewModel.setSearchQuery('táo');
      viewModel.setFilter(FoodFilter.fresh);

      viewModel.clearFilters();

      expect(viewModel.searchQuery, '');
      expect(viewModel.selectedFilter, FoodFilter.all);
      expect(viewModel.filteredFoods.length, 3);
    });
  });
}
