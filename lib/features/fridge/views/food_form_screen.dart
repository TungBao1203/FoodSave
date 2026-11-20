import 'package:flutter/material.dart';

import '../../../data/models/food_model.dart';
import '../viewmodels/food_viewmodel.dart';

class FoodFormScreen extends StatefulWidget {
  final FoodViewModel viewModel;
  final FoodModel? food;

  const FoodFormScreen({
    super.key,
    required this.viewModel,
    this.food,
  });

  @override
  State<FoodFormScreen> createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends State<FoodFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _unitController;
  late final TextEditingController _categoryController;

  late StorageLocation _location;
  late DateTime _expiryDate;

  bool _saving = false;

  bool get _editing => widget.food != null;

  @override
  void initState() {
    super.initState();

    final food = widget.food;

    _nameController = TextEditingController(text: food?.name ?? '');
    _quantityController = TextEditingController(
      text: food?.quantity.toString() ?? '',
    );
    _unitController = TextEditingController(text: food?.unit ?? 'cái');
    _categoryController = TextEditingController(
      text: food?.category ?? 'Khác',
    );

    _location = food?.storageLocation ?? StorageLocation.fridge;

    final today = DateUtils.dateOnly(DateTime.now());
    _expiryDate =
        food?.expiryDate ?? today.add(Duration(days: food?.remainingDays ?? 3));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate() async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 20),
    );

    if (selected != null && mounted) {
      setState(() {
        _expiryDate = DateUtils.dateOnly(selected);
      });
    }
  }

  Future<void> _saveFood() async {
    if (!_formKey.currentState!.validate() || _saving) {
      return;
    }

    setState(() => _saving = true);

    final quantity = double.parse(
      _quantityController.text.trim().replaceAll(',', '.'),
    );

    final today = DateUtils.dateOnly(DateTime.now());
    final daysUntilExpiry = _expiryDate.difference(today).inDays;

    final food = FoodModel(
      id: widget.food?.id ?? 'food_${DateTime.now().microsecondsSinceEpoch}',
      name: _nameController.text.trim(),
      quantity: quantity,
      unit: _unitController.text.trim(),
      category: _categoryController.text.trim(),
      daysUntilExpiry: daysUntilExpiry,
      expiryDate: _expiryDate,
      addedDate: widget.food?.addedDate ?? today,
      imageUrl: widget.food?.imageUrl,
      notes: widget.food?.notes,
      storageLocation: _location,
    );

    final success = _editing
        ? await widget.viewModel.updateFood(food)
        : await widget.viewModel.addFood(food);

    if (!mounted) return;

    setState(() => _saving = false);

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.viewModel.errorMessage ?? 'Không thể lưu thực phẩm',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editing ? 'Sửa thực phẩm' : 'Thêm thực phẩm',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              key: const Key('food_name'),
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên thực phẩm',
                prefixIcon: Icon(Icons.fastfood_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vui lòng nhập tên thực phẩm'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('food_quantity'),
              controller: _quantityController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Số lượng',
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final quantity = double.tryParse(
                  (value ?? '').trim().replaceAll(',', '.'),
                );

                if (quantity == null || !quantity.isFinite || quantity <= 0) {
                  return 'Số lượng phải lớn hơn 0';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('food_unit'),
              controller: _unitController,
              decoration: const InputDecoration(
                labelText: 'Đơn vị (kg, hộp, quả...)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vui lòng nhập đơn vị'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('food_category'),
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Danh mục',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vui lòng nhập danh mục'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<StorageLocation>(
              key: const Key('food_storage'),
              initialValue: _location,
              decoration: const InputDecoration(
                labelText: 'Vị trí bảo quản',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: StorageLocation.fridge,
                  child: Text('Ngăn mát'),
                ),
                DropdownMenuItem(
                  value: StorageLocation.freezer,
                  child: Text('Ngăn đông'),
                ),
                DropdownMenuItem(
                  value: StorageLocation.pantry,
                  child: Text('Bên ngoài'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _location = value);
                }
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              key: const Key('food_expiry_date'),
              onPressed: _selectExpiryDate,
              icon: const Icon(Icons.calendar_month_outlined),
              label: Text(
                'Hạn sử dụng: '
                '${_expiryDate.day.toString().padLeft(2, '0')}/'
                '${_expiryDate.month.toString().padLeft(2, '0')}/'
                '${_expiryDate.year}',
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              key: const Key('save_food'),
              onPressed: _saving ? null : _saveFood,
              icon: _saving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                _editing ? 'Lưu thay đổi' : 'Thêm vào tủ lạnh',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
