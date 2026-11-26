import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../viewmodels/food_viewmodel.dart';
import 'fridge_screen.dart';
import 'food_condition_history_screen.dart';
import '../../../data/models/food_model.dart';
import '../../../data/repositories/food_condition_repository.dart';
import '../../../data/models/scan_result_model.dart';
import '../../scanner/services/scan_food_save_service.dart';
import '../../scanner/views/scanner_screen.dart';

class FridgeAppScreen extends StatelessWidget {
  const FridgeAppScreen({super.key});

  // Giữ dữ liệu trong suốt phiên chạy ứng dụng.
  // Giai đoạn Firebase sẽ thay bằng repository dùng chung.
  static final FoodRepository _repository = FoodRepository();
  static final FoodViewModel _viewModel =
      FoodViewModel(repository: _repository);

  Future<void> _saveItems(
    List<ScanFoodItem> items,
    Uint8List imageBytes,
  ) {
    return ScanFoodSaveService(
      foodViewModel: _viewModel,
    ).saveItems(items, baselineImage: imageBytes);
  }

  static final FoodConditionRepository _conditionRepository =
      FoodConditionRepository();

  Future<void> _openConditionHistory(
      BuildContext context, FoodModel food) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FoodConditionHistoryScreen(
          food: food,
          repository: _conditionRepository,
        ),
      ),
    );
  }

  void _onNavigationTap(BuildContext context, int index) {
    switch (index) {
      case 1:
        return;
      case 2:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.suggestions,
        );
        return;
      case 3:
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.family,
        );
        return;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trang chủ đang được phát triển.'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FridgeScreen(
        viewModel: _viewModel,
        onCheckCondition: (food) => _openConditionHistory(context, food),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('open_scanner_button'),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ScannerScreen(onConfirmWithImage: _saveItems),
            ),
          );
        },
        icon: const Icon(Icons.document_scanner_outlined),
        label: const Text('Quét thực phẩm'),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (index) => _onNavigationTap(context, index),
      ),
    );
  }
}
