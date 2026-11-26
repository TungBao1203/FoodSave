import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:food_save/features/scanner/services/image_picker_service.dart';
import 'package:food_save/features/scanner/views/scanner_screen.dart';

class FakeImagePickerService extends ImagePickerService {
  int cameraCalls = 0;
  int galleryCalls = 0;
  bool shouldCancel = false;

  XFile createTestImage() {
    final bytes = Uint8List.fromList(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwC'
        'AAAAC0lEQVR42mP8/x8AAwMCAO+/lXcAAAAASUVORK5CYII=',
      ),
    );

    return XFile.fromData(
      bytes,
      name: 'apple.png',
      mimeType: 'image/png',
    );
  }

  @override
  Future<XFile?> pickFromCamera() async {
    cameraCalls++;
    return shouldCancel ? null : createTestImage();
  }

  @override
  Future<XFile?> pickFromGallery() async {
    galleryCalls++;
    return shouldCancel ? null : createTestImage();
  }
}

void main() {
  late FakeImagePickerService picker;

  setUp(() {
    picker = FakeImagePickerService();
  });

  Future<void> showScanner(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ScannerScreen(
          imagePickerService: picker,
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('Hiển thị trạng thái chưa có ảnh', (tester) async {
    await showScanner(tester);

    expect(
      find.text('Chưa có ảnh thực phẩm'),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('scanner_analyze_button')),
      150,
      scrollable: find.byType(Scrollable).first,
    );

    final analyzeButton = tester.widget<FilledButton>(
      find.byKey(const Key('scanner_analyze_button')),
    );

    expect(analyzeButton.onPressed, isNull);
  });

  testWidgets('Chọn ảnh từ thư viện', (tester) async {
    await showScanner(tester);

    await tester.tap(
      find.byKey(const Key('scanner_gallery_button')),
    );

    await tester.pumpAndSettle();

    expect(picker.galleryCalls, 1);
    expect(
      find.byKey(const Key('scanner_preview_image')),
      findsOneWidget,
    );

    expect(
      find.byKey(const Key('scanner_preview_image')),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('scanner_analyze_button')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    final analyzeButton = tester.widget<FilledButton>(
      find.byKey(const Key('scanner_analyze_button')),
    );

    expect(analyzeButton.onPressed, isNotNull);
  });

  testWidgets('Chụp ảnh bằng camera', (tester) async {
    await showScanner(tester);

    await tester.tap(
      find.byKey(const Key('scanner_camera_button')),
    );

    await tester.pumpAndSettle();

    expect(picker.cameraCalls, 1);
    expect(picker.galleryCalls, 0);
    expect(
      find.byKey(const Key('scanner_preview_image')),
      findsOneWidget,
    );
  });

  testWidgets('Xóa ảnh đã chọn', (tester) async {
    await showScanner(tester);

    await tester.tap(
      find.byKey(const Key('scanner_gallery_button')),
    );

    await tester.pumpAndSettle();

    final removeButton = find.byKey(
      const Key('scanner_remove_button'),
    );

    await tester.ensureVisible(removeButton);
    await tester.pumpAndSettle();

    await tester.tap(removeButton);
    await tester.pumpAndSettle();

    expect(
      find.text('Chưa có ảnh thực phẩm'),
      findsOneWidget,
    );

    expect(
      find.byKey(const Key('scanner_preview_image')),
      findsNothing,
    );
  });

  testWidgets('Hủy chọn ảnh không gây lỗi', (tester) async {
    picker.shouldCancel = true;

    await showScanner(tester);

    await tester.tap(
      find.byKey(const Key('scanner_gallery_button')),
    );

    await tester.pumpAndSettle();

    expect(picker.galleryCalls, 1);

    expect(
      find.text('Chưa có ảnh thực phẩm'),
      findsOneWidget,
    );
  });
}
