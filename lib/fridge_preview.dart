import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/models/food_model.dart';
import 'data/repositories/food_repository.dart';
import 'features/fridge/viewmodels/food_viewmodel.dart';
import 'features/fridge/views/fridge_screen.dart';

void main() {
  runApp(const FridgePreviewApp());
}

class FridgePreviewApp extends StatefulWidget {
  const FridgePreviewApp({super.key});

  @override
  State<FridgePreviewApp> createState() => _FridgePreviewAppState();
}

class _FridgePreviewAppState extends State<FridgePreviewApp> {
  late final FoodRepository repository;
  late final FoodViewModel viewModel;

  @override
  void initState() {
    super.initState();

    repository = FoodRepository(
      initialFoods: const [
        FoodModel(
          id: 'food_01',
          name: 'Sữa tươi Vinamilk',
          quantity: 1,
          unit: 'lít',
          daysUntilExpiry: 0,
          category: 'Sữa',
        ),
        FoodModel(
          id: 'food_02',
          name: 'Cà chua Đà Lạt',
          quantity: 0.6,
          unit: 'kg',
          daysUntilExpiry: 2,
          category: 'Rau củ',
        ),
        FoodModel(
          id: 'food_03',
          name: 'Thịt heo nạc',
          quantity: 0.5,
          unit: 'kg',
          daysUntilExpiry: 2,
          category: 'Thịt',
          storageLocation: StorageLocation.freezer,
        ),
        FoodModel(
          id: 'food_04',
          name: 'Rau cải xanh',
          quantity: 0.4,
          unit: 'kg',
          daysUntilExpiry: 3,
          category: 'Rau củ',
        ),
        FoodModel(
          id: 'food_05',
          name: 'Trứng gà ta',
          quantity: 10,
          unit: 'quả',
          daysUntilExpiry: 14,
          category: 'Trứng',
        ),
        FoodModel(
          id: 'food_06',
          name: 'Đậu hũ trắng',
          quantity: 2,
          unit: 'hộp',
          daysUntilExpiry: -1,
          category: 'Đậu',
        ),
      ],
    );

    viewModel = FoodViewModel(repository: repository);
  }

  @override
  void dispose() {
    viewModel.dispose();
    repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodSave - Fridge Preview',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: FridgeScreen(viewModel: viewModel),
    );
  }
}
