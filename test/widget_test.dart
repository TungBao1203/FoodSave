import 'package:flutter_test/flutter_test.dart';
import 'package:food_save/main.dart';

void main() {
  testWidgets('FoodSave app smoke test', (WidgetTester tester) async {
    // Khởi tạo ứng dụng FoodSave.
    await tester.pumpWidget(const FoodSaveApp());

    // Chờ dữ liệu bất đồng bộ và các frame cập nhật hoàn tất.
    await tester.pumpAndSettle();

    // Kiểm tra màn hình Gợi ý món ăn hiển thị.
    expect(find.text('Gợi ý món ăn'), findsOneWidget);
  });
}
