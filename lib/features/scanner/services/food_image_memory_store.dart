import 'dart:typed_data';

/// Lưu ảnh gốc tạm thời theo foodId.
/// Dữ liệu sẽ mất khi khởi động lại ứng dụng.
class FoodImageMemoryStore {
  FoodImageMemoryStore._();

  static final FoodImageMemoryStore instance = FoodImageMemoryStore._();

  final Map<String, Uint8List> _baselineImages = {};

  Uint8List? baselineFor(String foodId) {
    final bytes = _baselineImages[foodId];
    return bytes == null ? null : Uint8List.fromList(bytes);
  }

  bool hasBaseline(String foodId) {
    return _baselineImages.containsKey(foodId);
  }

  void saveBaselineIfAbsent(
    String foodId,
    Uint8List imageBytes,
  ) {
    if (foodId.trim().isEmpty || imageBytes.isEmpty) {
      throw ArgumentError('Ảnh gốc hoặc mã thực phẩm không hợp lệ.');
    }

    _baselineImages.putIfAbsent(
      foodId,
      () => Uint8List.fromList(imageBytes),
    );
  }

  void deleteBaseline(String foodId) {
    _baselineImages.remove(foodId);
  }

  void clear() {
    _baselineImages.clear();
  }
}
