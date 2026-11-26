import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_save/data/models/food_model.dart';
import 'package:food_save/data/models/food_condition_check.dart';
import 'package:food_save/data/repositories/food_condition_repository.dart';
import 'package:food_save/features/fridge/views/food_condition_history_screen.dart';

void main() {
  const food = FoodModel(
    id: 'apple_01',
    name: 'Táo đỏ',
    quantity: 2,
    unit: 'quả',
    daysUntilExpiry: 5,
    category: 'Trái cây',
  );

  late FoodConditionRepository repository;

  setUp(() {
    repository = FoodConditionRepository();
  });

  Future<void> showHistory(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FoodConditionHistoryScreen(
          food: food,
          repository: repository,
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('Hiển thị đúng thực phẩm và lịch sử rỗng', (tester) async {
    await showHistory(tester);

    expect(find.text('Táo đỏ'), findsOneWidget);
    expect(
      find.textContaining('Chưa có lịch sử kiểm tra'),
      findsOneWidget,
    );
  });

  testWidgets('Chỉ hiển thị lịch sử của thực phẩm hiện tại', (tester) async {
    await repository.addCheck(
      FoodConditionCheck(
        id: 'check_apple',
        foodId: 'apple_01',
        checkedAt: DateTime(2026, 11, 26),
        resultSummary: 'Đã chọn hai ảnh của táo.',
      ),
    );

    await repository.addCheck(
      FoodConditionCheck(
        id: 'check_tomato',
        foodId: 'tomato_01',
        checkedAt: DateTime(2026, 11, 27),
        resultSummary: 'Lịch sử cà chua.',
      ),
    );

    await showHistory(tester);

    expect(
      find.text('Đã chọn hai ảnh của táo.'),
      findsOneWidget,
    );
    expect(find.text('Lịch sử cà chua.'), findsNothing);
  });

  testWidgets('Mở màn hình so sánh từ lịch sử', (tester) async {
    await showHistory(tester);

    await tester.tap(
      find.byKey(const Key('start_food_condition_check')),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('So sánh tình trạng thực phẩm'),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('compare_food_button')),
      150,
      scrollable: find.byType(Scrollable).first,
    );

    expect(
      find.byKey(const Key('compare_food_button')),
      findsOneWidget,
    );
  });
}
