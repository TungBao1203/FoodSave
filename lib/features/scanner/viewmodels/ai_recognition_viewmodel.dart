import 'package:flutter/foundation.dart';

import '../../../data/models/scan_result_model.dart';
import '../../../data/repositories/ai_repository.dart';

class AiRecognitionViewModel extends ChangeNotifier {
  final IAiRepository _repository;

  AiRecognitionViewModel({
    required IAiRepository repository,
  }) : _repository = repository;

  bool _isAnalyzing = false;
  String? _errorMessage;
  ScanResultModel? _result;

  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;
  ScanResultModel? get result => _result;

  Future<bool> analyzeImage({
    required Uint8List imageBytes,
    required String mimeType,
    required ScanSource source,
  }) async {
    if (_isAnalyzing) return false;

    _isAnalyzing = true;
    _errorMessage = null;
    _result = null;
    notifyListeners();

    try {
      if (imageBytes.isEmpty) {
        throw const AiAnalysisException(
          'Ảnh không hợp lệ. Vui lòng chọn ảnh khác.',
        );
      }

      if (mimeType != 'image/jpeg' &&
          mimeType != 'image/png' &&
          mimeType != 'image/webp') {
        throw const AiAnalysisException(
          'Định dạng ảnh chưa được hỗ trợ.',
        );
      }

      final response = await _repository.recognizeFood(
        imageBytes: imageBytes,
        mimeType: mimeType,
        source: source,
      );

      _result = response;
      return true;
    } on AiAnalysisException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage = 'Không thể phân tích ảnh lúc này. Vui lòng thử lại.';
      return false;
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  void clearResult() {
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }
}
