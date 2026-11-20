import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../services/image_picker_service.dart';

class ScannerScreen extends StatefulWidget {
  final ImagePickerService? imagePickerService;

  const ScannerScreen({
    super.key,
    this.imagePickerService,
  });

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late final ImagePickerService _picker;

  XFile? _selectedImage;
  Uint8List? _imageBytes;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _picker = widget.imagePickerService ?? ImagePickerService();
  }

  Future<void> _pickImage({required bool camera}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final image = camera
          ? await _picker.pickFromCamera()
          : await _picker.pickFromGallery();

      if (image == null) return;

      const maxBytes = 10 * 1024 * 1024;

      if (await image.length() > maxBytes) {
        throw Exception('Ảnh vượt quá giới hạn 10 MB');
      }

      final bytes = await image.readAsBytes();

      if (bytes.isEmpty) {
        throw Exception('Không thể đọc ảnh đã chọn');
      }

      if (!mounted) return;

      setState(() {
        _selectedImage = image;
        _imageBytes = bytes;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Không thể mở ảnh. Vui lòng thử lại.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageBytes = null;
      _errorMessage = null;
    });
  }

  void _showAiNotice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng phân tích AI đang được phát triển.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _imageBytes != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quét thực phẩm'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Nhận diện thực phẩm',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Chụp hoặc chọn ảnh thực phẩm để chuẩn bị phân tích.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Container(
                height: 290,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: hasImage
                      ? Image.memory(
                          _imageBytes!,
                          key: const Key('scanner_preview_image'),
                          fit: BoxFit.contain,
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 64,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: 14),
                            Text(
                              'Chưa có ảnh thực phẩm',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Chọn ảnh để xem trước',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              if (_selectedImage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _selectedImage!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.danger),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('scanner_camera_button'),
                      onPressed:
                          _isLoading ? null : () => _pickImage(camera: true),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Chụp ảnh'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('scanner_gallery_button'),
                      onPressed:
                          _isLoading ? null : () => _pickImage(camera: false),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Thư viện'),
                    ),
                  ),
                ],
              ),
              if (hasImage) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  key: const Key('scanner_remove_button'),
                  onPressed: _isLoading ? null : _removeImage,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Xóa ảnh'),
                ),
              ],
              const SizedBox(height: 22),
              FilledButton.icon(
                key: const Key('scanner_analyze_button'),
                onPressed: hasImage && !_isLoading ? _showAiNotice : null,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome),
                label: const Text('Phân tích bằng AI'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ảnh chỉ được xem trước trên thiết bị, chưa tải lên máy chủ.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
