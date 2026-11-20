import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_save/data/models/food_model.dart';
import 'package:food_save/data/repositories/food_repository.dart';
import 'package:food_save/features/fridge/viewmodels/food_viewmodel.dart';
import 'package:food_save/features/fridge/views/fridge_screen.dart';

void main() {
  late FoodRepository repository;
  late FoodViewModel viewModel;

  const milk = FoodModel(
    id: 'food_01',
    name: 'Sữa tươi',
    quantity: 2,
    unit: 'hộp',
    category: 'Sữa',
    daysUntilExpiry: 5,
    storageLocation: StorageLocation.fridge,
  );

  const chicken = FoodModel(
    id: 'food_02',
    name: 'Thịt gà',
    quantity: 1,
    unit: 'kg',
    category: 'Thịt',
    daysUntilExpiry: 2,
    storageLocation: StorageLocation.freezer,
  );

  setUp(() {
    repository = FoodRepository(
      initialFoods: [milk, chicken],
    );

    viewModel = FoodViewModel(
      repository: repository,
    );
  });

  tearDown(() {
    viewModel.dispose();
    repository.dispose();
  });

  Future<void> showFridge(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FridgeScreen(viewModel: viewModel),
      ),
    );

    await tester.pumpAndSettle();
  }

  Future<void> saveForm(WidgetTester tester) async {
    final saveButton = find.byKey(const Key('save_food'));

    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();

    await tester.tap(saveButton);
    await tester.pumpAndSettle();
  }

  group('FridgeScreen Widget Tests', () {
    testWidgets('Hiển thị danh sách thực phẩm', (tester) async {
      await showFridge(tester);

      expect(find.text('Tủ lạnh nhà mình'), findsOneWidget);
      expect(find.text('Sữa tươi'), findsOneWidget);
      expect(find.text('Thịt gà'), findsOneWidget);
      expect(viewModel.totalFoods, 2);
    });

    testWidgets('Lọc thực phẩm theo ngăn đông', (tester) async {
      await showFridge(tester);

      final freezerFilter = find.text('Ngăn đông');

      await tester.scrollUntilVisible(
        freezerFilter,
        150,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.pumpAndSettle();
      await tester.tap(freezerFilter);
      await tester.pumpAndSettle();

      expect(find.text('Thịt gà'), findsOneWidget);
      expect(find.text('Sữa tươi'), findsNothing);
    });

    testWidgets('Thêm thực phẩm mới', (tester) async {
      await showFridge(tester);

      await tester.tap(
        find.byKey(const Key('add_food_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Thêm thực phẩm'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('food_name')),
        'Táo Fuji',
      );

      await tester.enterText(
        find.byKey(const Key('food_quantity')),
        '3',
      );

      await saveForm(tester);

      expect(viewModel.totalFoods, 3);

      final foods = await repository.getFoods();

      expect(
        foods.any((food) => food.name == 'Táo Fuji'),
        isTrue,
      );
    });

    testWidgets('Sửa số lượng thực phẩm', (tester) async {
      await showFridge(tester);

      await tester.tap(find.text('Sữa tươi'));
      await tester.pumpAndSettle();

      expect(find.text('Sửa thực phẩm'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('food_quantity')),
        '5',
      );

      await saveForm(tester);

      final updated = await repository.getFoodById('food_01');

      expect(updated, isNotNull);
      expect(updated!.quantity, 5);
    });

    testWidgets('Xóa thực phẩm sau xác nhận', (tester) async {
      await showFridge(tester);

      await tester.tap(
        find.byKey(const Key('delete_food_01')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Xóa thực phẩm?'), findsOneWidget);

      await tester.tap(find.text('Xóa'));
      await tester.pumpAndSettle();

      final deleted = await repository.getFoodById('food_01');

      expect(deleted, isNull);
      expect(viewModel.totalFoods, 1);
    });

    testWidgets('Không lưu số lượng không hợp lệ', (tester) async {
      await showFridge(tester);

      await tester.tap(
        find.byKey(const Key('add_food_button')),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('food_name')),
        'Cam',
      );

      await tester.enterText(
        find.byKey(const Key('food_quantity')),
        '-2',
      );

      await saveForm(tester);

      expect(
        find.text('Số lượng phải lớn hơn 0'),
        findsOneWidget,
      );

      expect(viewModel.totalFoods, 2);
    });
  });
}
