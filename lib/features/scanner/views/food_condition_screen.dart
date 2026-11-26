import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../services/image_picker_service.dart';

class FoodConditionScreen extends StatefulWidget {
  final ImagePickerService? imagePickerService;
  final Uint8List? initialBeforeImage;
  final Future<void> Function(
    Uint8List before,
    Uint8List after,
  )? onSaveCheck;

  const FoodConditionScreen({
    super.key,
    this.imagePickerService,
    this.initialBeforeImage,
    this.onSaveCheck,
  });

  @override
  State<FoodConditionScreen> createState() => _FoodConditionScreenState();
}

class _FoodConditionScreenState extends State<FoodConditionScreen> {
  late final ImagePickerService _picker;

  Uint8List? _beforeImage;
  Uint8List? _afterImage;

  bool _isPicking = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _picker = widget.imagePickerService ?? ImagePickerService();
    if (widget.initialBeforeImage != null) {
      _beforeImage = Uint8List.fromList(
        widget.initialBeforeImage!,
      );
    }
  }

  Future<void> _chooseImage({
    required bool isBefore,
    required bool camera,
  }) async {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
      _errorMessage = null;
    });

    try {
      final file = camera
          ? await _picker.pickFromCamera()
          : await _picker.pickFromGallery();

      if (file == null) return;

      const maxBytes = 10 * 1024 * 1024;

      if (await file.length() > maxBytes) {
        throw const FormatException('Ảnh lớn hơn 10 MB.');
      }

      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        throw const FormatException('Ảnh không hợp lệ.');
      }

      if (!mounted) return;

      setState(() {
        if (isBefore) {
          _beforeImage = bytes;
        } else {
          _afterImage = bytes;
        }
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Không thể đọc ảnh. Vui lòng chọn ảnh khác '
            '(tối đa 10 MB).';
      });
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  Future<void> _saveCheck() async {
    if (_isSaving ||
        _isPicking ||
        _beforeImage == null ||
        _afterImage == null ||
        widget.onSaveCheck == null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.onSaveCheck!(
        _beforeImage!,
        _afterImage!,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Không thể lưu lần kiểm tra. Vui lòng thử lại.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _imageCard({
    required bool isBefore,
    required String title,
    required Uint8List? bytes,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Container(
              height: 210,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              child: bytes == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined, size: 48),
                        SizedBox(height: 8),
                        Text('Chưa chọn ảnh'),
                      ],
                    )
                  : Image.memory(
                      bytes,
                      key: Key(
                        isBefore
                            ? 'condition_before_image'
                            : 'condition_after_image',
                      ),
                      fit: BoxFit.contain,
                    ),
            ),
            const SizedBox(height: 12),
            if (!isBefore || widget.initialBeforeImage == null)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isPicking
                          ? null
                          : () => _chooseImage(
                                isBefore: isBefore,
                                camera: false,
                              ),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Thư viện'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isPicking
                          ? null
                          : () => _chooseImage(
                                isBefore: isBefore,
                                camera: true,
                              ),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Camera'),
                    ),
                  ),
                ],
              ),
            if (bytes != null &&
                (!isBefore || widget.initialBeforeImage == null))
              TextButton.icon(
                onPressed: _isPicking
                    ? null
                    : () {
                        setState(() {
                          if (isBefore) {
                            _beforeImage = null;
                          } else {
                            _afterImage = null;
                          }
                        });
                      },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Xóa ảnh'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = _beforeImage != null && _afterImage != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiểm tra tình trạng thực phẩm'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'So sánh tình trạng thực phẩm',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Chọn hai ảnh của cùng một thực phẩm, '
                'chụp tại hai thời điểm khác nhau.',
              ),
              const SizedBox(height: 20),
              _imageCard(
                isBefore: true,
                title: '1. Ảnh ban đầu',
                bytes: _beforeImage,
              ),
              const SizedBox(height: 12),
              _imageCard(
                isBefore: false,
                title: '2. Ảnh hiện tại',
                bytes: _afterImage,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: AppColors.danger,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton.icon(
                key: const Key('compare_food_button'),
                onPressed: ready && !_isPicking
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Đã chọn đủ hai ảnh. '
                              'Chức năng phân tích AI '
                              'sẽ được kết nối sau.',
                            ),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.compare_outlined),
                label: const Text('So sánh bằng AI'),
              ),
              const SizedBox(height: 12),
              if (widget.onSaveCheck != null) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  key: const Key('condition_save_check_button'),
                  onPressed:
                      ready && !_isPicking && !_isSaving ? _saveCheck : null,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(
                    _isSaving ? 'Đang lưu...' : 'Lưu lần kiểm tra',
                  ),
                ),
              ],
              const Text(
                'Chưa có phân tích AI tại bước này. '
                'Ảnh không thể xác định chắc chắn '
                'thực phẩm có an toàn để ăn hay không.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
