import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../data/models/food_model.dart';
import '../../../data/models/food_condition_check.dart';
import '../../../data/repositories/food_condition_repository.dart';
import '../../scanner/views/food_condition_screen.dart';
import '../../scanner/services/food_image_memory_store.dart';

class FoodConditionHistoryScreen extends StatefulWidget {
  final FoodModel food;
  final IFoodConditionRepository repository;

  const FoodConditionHistoryScreen({
    super.key,
    required this.food,
    required this.repository,
  });

  @override
  State<FoodConditionHistoryScreen> createState() =>
      _FoodConditionHistoryScreenState();
}

class _FoodConditionHistoryScreenState
    extends State<FoodConditionHistoryScreen> {
  late Future<List<FoodConditionCheck>> _history;

  @override
  void initState() {
    super.initState();
    _reloadHistory();
  }

  void _reloadHistory() {
    _history = widget.repository.getChecksByFoodId(
      widget.food.id,
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Future<void> _openComparison() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FoodConditionScreen(
          initialBeforeImage: FoodImageMemoryStore.instance.baselineFor(
            widget.food.id,
          ),
          onSaveCheck: (
            Uint8List before,
            Uint8List after,
          ) async {
            if (before.isEmpty || after.isEmpty) {
              throw ArgumentError('Ảnh không hợp lệ.');
            }

            FoodImageMemoryStore.instance.saveBaselineIfAbsent(
              widget.food.id,
              before,
            );

            final now = DateTime.now();

            await widget.repository.addCheck(
              FoodConditionCheck(
                id: 'check_${now.microsecondsSinceEpoch}',
                foodId: widget.food.id,
                checkedAt: now,
                resultSummary: 'Đã chọn hai ảnh. Chưa phân tích AI; '
                    'ảnh chưa được lưu.',
              ),
            );
          },
        ),
      ),
    );

    if (!mounted) return;

    setState(_reloadHistory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử kiểm tra'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.food.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Danh mục: ${widget.food.category}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mã thực phẩm: ${widget.food.id}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                key: const Key('start_food_condition_check'),
                onPressed: _openComparison,
                icon: const Icon(Icons.compare_outlined),
                label: const Text('So sánh ảnh thực phẩm'),
              ),
              const SizedBox(height: 20),
              Text(
                'Các lần kiểm tra',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<FoodConditionCheck>>(
                future: _history,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Không thể tải lịch sử kiểm tra.',
                    );
                  }

                  final checks = snapshot.data ?? [];

                  if (checks.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Chưa có lịch sử kiểm tra '
                          'cho thực phẩm này.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      for (final check in checks)
                        Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.history,
                            ),
                            title: Text(
                              'Kiểm tra ngày '
                              '${_formatDate(check.checkedAt)}',
                            ),
                            subtitle: Text(
                              check.resultSummary ??
                                  'Chưa có kết quả phân tích.',
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Lịch sử hiện được lưu tạm trong '
                'bộ nhớ. Chức năng phân tích ảnh '
                'và lưu kết quả sẽ được hoàn thiện '
                'ở bước tiếp theo.',
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
