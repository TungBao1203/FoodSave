import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../viewmodels/food_viewmodel.dart';
import 'fridge_screen.dart';

class FridgeAppScreen extends StatelessWidget {
  const FridgeAppScreen({super.key});

  // Giữ dữ liệu trong suốt phiên chạy ứng dụng.
  // Giai đoạn Firebase sẽ thay bằng repository dùng chung.
  static final FoodRepository _repository = FoodRepository();
  static final FoodViewModel _viewModel =
      FoodViewModel(repository: _repository);

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
      body: FridgeScreen(viewModel: _viewModel),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (index) => _onNavigationTap(context, index),
      ),
    );
  }
}
