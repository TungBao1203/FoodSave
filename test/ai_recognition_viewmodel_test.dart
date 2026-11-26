import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:food_save/data/models/scan_result_model.dart';
import 'package:food_save/data/repositories/ai_repository.dart';
import 'package:food_save/features/scanner/viewmodels/ai_recognition_viewmodel.dart';

class FakeAiRepository implements IAiRepository {
  bool shouldFail = false;
  int callCount = 0;

  @override
  Future<ScanResultModel> recognizeFood({
    required Uint8List imageBytes,
    required String mimeType,
    required ScanSource source,
  }) async {
    callCount++;

    if (shouldFail) {
      throw const AiAnalysisException('Lỗi kết nối AI');
    }

    return ScanResultModel(
      id: 'scan_001',
      source: source,
      scannedAt: DateTime.utc(2026, 11, 26),
      items: const [
        ScanFoodItem(
          name: 'Cà chua',
          category: 'Rau củ',
        ),
      ],
    );
  }
}

void main() {
  late FakeAiRepository repository;
  late AiRecognitionViewModel viewModel;

  setUp(() {
    repository = FakeAiRepository();
    viewModel = AiRecognitionViewModel(
      repository: repository,
    );
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('Nhận kết quả nhận diện từ repository', () async {
    final success = await viewModel.analyzeImage(
      imageBytes: Uint8List.fromList([1, 2, 3]),
      mimeType: 'image/jpeg',
      source: ScanSource.gallery,
    );

    expect(success, true);
    expect(viewModel.result?.items.first.name, 'Cà chua');
    expect(viewModel.isAnalyzing, false);
    expect(viewModel.errorMessage, isNull);
    expect(repository.callCount, 1);
  });

  test('Từ chối ảnh rỗng', () async {
    final success = await viewModel.analyzeImage(
      imageBytes: Uint8List(0),
      mimeType: 'image/jpeg',
      source: ScanSource.gallery,
    );

    expect(success, false);
    expect(repository.callCount, 0);
    expect(viewModel.errorMessage, isNotNull);
  });

  test('Từ chối định dạng không hỗ trợ', () async {
    final success = await viewModel.analyzeImage(
      imageBytes: Uint8List.fromList([1, 2]),
      mimeType: 'application/pdf',
      source: ScanSource.gallery,
    );

    expect(success, false);
    expect(repository.callCount, 0);
  });

  test('Xử lý lỗi từ AI Repository', () async {
    repository.shouldFail = true;

    final success = await viewModel.analyzeImage(
      imageBytes: Uint8List.fromList([1, 2, 3]),
      mimeType: 'image/png',
      source: ScanSource.camera,
    );

    expect(success, false);
    expect(viewModel.errorMessage, 'Lỗi kết nối AI');
    expect(viewModel.result, isNull);
  });

  test('Xóa kết quả nhận diện', () async {
    await viewModel.analyzeImage(
      imageBytes: Uint8List.fromList([1, 2, 3]),
      mimeType: 'image/jpeg',
      source: ScanSource.gallery,
    );

    viewModel.clearResult();

    expect(viewModel.result, isNull);
    expect(viewModel.errorMessage, isNull);
  });
}
