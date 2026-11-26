import 'dart:typed_data';

import '../models/scan_result_model.dart';

/// Hợp đồng xử lý nhận diện hình ảnh bằng AI.
///
/// Implementation thực tế sẽ gọi backend bảo vệ Gemini API Key.
abstract class IAiRepository {
  Future<ScanResultModel> recognizeFood({
    required Uint8List imageBytes,
    required String mimeType,
    required ScanSource source,
  });
}

/// Lỗi xử lý AI có thông báo phù hợp để hiển thị.
class AiAnalysisException implements Exception {
  final String message;

  const AiAnalysisException(this.message);

  @override
  String toString() => message;
}
