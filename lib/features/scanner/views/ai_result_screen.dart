import 'package:flutter/material.dart';

import '../../../data/models/scan_result_model.dart';

typedef ConfirmScanResult = Future<void> Function(
  List<ScanFoodItem> items,
);

class AiResultScreen extends StatefulWidget {
  final ScanResultModel result;
  final ConfirmScanResult? onConfirm;
  final bool isPreview;

  const AiResultScreen({
    super.key,
    required this.result,
    this.onConfirm,
    this.isPreview = false,
  });

  @override
  State<AiResultScreen> createState() => _AiResultScreenState();
}

class _AiResultScreenState extends State<AiResultScreen> {
  final _formKey = GlobalKey<FormState>();

  late final List<TextEditingController> _names;
  late final List<TextEditingController> _categories;
  late final List<TextEditingController> _quantities;
  late final List<TextEditingController> _units;
  late final List<DateTime?> _expiryDates;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final items = widget.result.items;

    _names =
        items.map((item) => TextEditingController(text: item.name)).toList();

    _categories = items
        .map((item) => TextEditingController(text: item.category))
        .toList();

    _quantities = items
        .map(
          (item) => TextEditingController(
            text: item.quantity?.toString() ?? '',
          ),
        )
        .toList();

    _units = items
        .map(
          (item) => TextEditingController(text: item.unit ?? ''),
        )
        .toList();

    _expiryDates = items.map((item) => item.expiryDate).toList();
  }

  @override
  void dispose() {
    for (final controller in [
      ..._names,
      ..._categories,
      ..._quantities,
      ..._units,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _selectExpiryDate(int index) async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: _expiryDates[index] ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected == null || !mounted) return;

    setState(() {
      _expiryDates[index] = selected;
    });
  }

  List<ScanFoodItem> _collectItems() {
    return List.generate(widget.result.items.length, (index) {
      final original = widget.result.items[index];
      final quantityText = _quantities[index].text.trim();

      return ScanFoodItem(
        name: _names[index].text.trim(),
        category: _categories[index].text.trim(),
        quantity: quantityText.isEmpty
            ? null
            : double.parse(quantityText.replaceAll(',', '.')),
        unit: _units[index].text.trim().isEmpty
            ? null
            : _units[index].text.trim(),
        confidence: original.confidence,
        expiryDate: _expiryDates[index],
      );
    });
  }

  Future<void> _confirm() async {
    if (_isSaving || widget.onConfirm == null || widget.isPreview) {
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final missingDetails = List.generate(
      widget.result.items.length,
      (i) => i,
    ).any(
      (i) =>
          _quantities[i].text.trim().isEmpty ||
          _units[i].text.trim().isEmpty ||
          _expiryDates[i] == null,
    );

    if (missingDetails) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng xác nhận số lượng, đơn vị và hạn sử dụng.',
          ),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.onConfirm!(_collectItems());

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Không thể lưu thực phẩm. Vui lòng thử lại.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _buildFoodForm(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thực phẩm ${index + 1}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _names[index],
              decoration: const InputDecoration(
                labelText: 'Tên thực phẩm *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vui lòng nhập tên thực phẩm'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _categories[index],
              decoration: const InputDecoration(
                labelText: 'Danh mục *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vui lòng nhập danh mục'
                  : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantities[index],
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Số lượng',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }

                      final number = double.tryParse(
                        value.trim().replaceAll(',', '.'),
                      );

                      if (number == null || number <= 0) {
                        return 'Số lượng phải lớn hơn 0';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _units[index],
                    decoration: const InputDecoration(
                      labelText: 'Đơn vị',
                      hintText: 'kg, quả, hộp...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _selectExpiryDate(index),
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text(
                _expiryDates[index] == null
                    ? 'Chọn hạn sử dụng'
                    : 'Hạn dùng: ${_formatDate(_expiryDates[index]!)}',
              ),
            ),
            if (_expiryDates[index] != null)
              TextButton(
                onPressed: () {
                  setState(() {
                    _expiryDates[index] = null;
                  });
                },
                child: const Text('Xóa ngày đã chọn'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.result.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả nhận diện'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (widget.isPreview)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'CHẾ ĐỘ XEM TRƯỚC — '
                        'Dữ liệu mẫu, chưa phân tích bằng AI.',
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  'Đã nhận diện ${items.length} thực phẩm',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Vui lòng kiểm tra và chỉnh sửa thông tin '
                  'trước khi lưu vào Tủ lạnh.',
                ),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  const Text(
                    'Không tìm thấy thực phẩm trong kết quả.',
                  ),
                for (var index = 0; index < items.length; index++)
                  _buildFoodForm(index),
                const Text(
                  'AI có thể nhận diện sai. '
                  'Hạn sử dụng cần được kiểm tra từ bao bì '
                  'hoặc thông tin thực tế của sản phẩm.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  key: const Key('confirm_scan_result_button'),
                  onPressed: items.isEmpty ||
                          widget.isPreview ||
                          widget.onConfirm == null ||
                          _isSaving
                      ? null
                      : _confirm,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(
                    _isSaving ? 'Đang lưu...' : 'Xác nhận và lưu vào Tủ lạnh',
                  ),
                ),
                if (widget.onConfirm == null || widget.isPreview)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Chức năng lưu sẽ được kết nối ở bước tiếp theo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
