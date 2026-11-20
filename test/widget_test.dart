import 'package:flutter_test/flutter_test.dart';
import 'package:food_save/main.dart';

void main() {
  testWidgets('FoodSave app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FoodSaveApp());

    // Verify that the title of Screen 07 is rendered
    expect(find.text('Gợi ý món ăn'), findsOneWidget);
  });
}
