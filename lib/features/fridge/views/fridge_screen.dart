import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/food_model.dart';
import '../viewmodels/food_viewmodel.dart';
import 'food_form_screen.dart';

class FridgeScreen extends StatefulWidget {
  final FoodViewModel viewModel;

  const FridgeScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final vm = widget.viewModel;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Tủ lạnh nhà mình'),
            leading: const Icon(
              Icons.kitchen_outlined,
              color: AppColors.primary,
            ),
            actions: [
              IconButton(
                key: const Key('add_food_button'),
                tooltip: 'Thêm thực phẩm',
                onPressed: () => _openFoodForm(),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                children: [
                  _buildSearch(vm),
                  _buildFilters(vm),
                  Expanded(child: _buildContent(vm)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearch(FoodViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        key: const Key('food_search'),
        onChanged: vm.setSearchQuery,
        decoration: InputDecoration(
          hintText: 'Tìm thực phẩm...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(FoodViewModel vm) {
    const filters = [
      (FoodFilter.all, 'Tất cả'),
      (FoodFilter.expiringSoon, 'Sắp hết hạn'),
      (FoodFilter.fridge, 'Ngăn mát'),
      (FoodFilter.freezer, 'Ngăn đông'),
      (FoodFilter.expired, 'Đã hết hạn'),
    ];

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = vm.selectedFilter == filter.$1;

          return Center(
            child: ChoiceChip(
              label: Text(filter.$2),
              selected: selected,
              onSelected: (_) => vm.setFilter(filter.$1),
              selectedColor: AppColors.primaryContainer,
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.border,
              ),
              labelStyle: TextStyle(
                color:
                    selected ? AppColors.primaryDark : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(FoodViewModel vm) {
    if (vm.isLoading && vm.allFoods.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (vm.errorMessage != null && vm.allFoods.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 36),
            const SizedBox(height: 10),
            const Text('Không thể tải danh sách thực phẩm'),
            TextButton(
              onPressed: vm.loadFoods,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    final foods = vm.filteredFoods;

    return RefreshIndicator(
      onRefresh: vm.loadFoods,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _buildSummary(vm),
          const SizedBox(height: 16),
          _buildFamilyCard(vm),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Danh sách thực phẩm',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${foods.length} loại',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (foods.isEmpty)
            _buildEmptyState()
          else
            ...foods.map(_buildFoodCard),
        ],
      ),
    );
  }

  Widget _buildSummary(FoodViewModel vm) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _statusChip(
          'Tổng ${vm.totalFoods}',
          AppColors.primary,
        ),
        _statusChip(
          'Sắp hết hạn ${vm.expiringSoonCount}',
          AppColors.accentOrange,
        ),
        _statusChip(
          'Đã hết hạn ${vm.expiredCount}',
          AppColors.danger,
        ),
      ],
    );
  }

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFamilyCard(FoodViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.home_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nhà mình dùng chung',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${vm.totalFoods} loại thực phẩm',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Chưa đồng bộ Firebase',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 44,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          const Text(
            'Không tìm thấy thực phẩm phù hợp',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: widget.viewModel.clearFilters,
            child: const Text('Xóa bộ lọc'),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(FoodModel food) {
    final days = food.remainingDays;

    final status = days < 0
        ? 'Đã hết hạn'
        : days == 0
            ? 'Hết hạn hôm nay'
            : 'Còn $days ngày';

    final statusColor = days < 0
        ? AppColors.danger
        : days <= 3
            ? AppColors.accentOrange
            : AppColors.primary;

    final location = switch (food.storageLocation) {
      StorageLocation.fridge => 'Ngăn mát',
      StorageLocation.freezer => 'Ngăn đông',
      StorageLocation.pantry => 'Bên ngoài',
    };

    final quantity = food.quantity % 1 == 0
        ? food.quantity.toStringAsFixed(0)
        : food.quantity.toString();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        key: Key('edit_${food.id}'),
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openFoodForm(food),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildFoodImage(food),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$quantity ${food.unit} · $location',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: Key('delete_${food.id}'),
                tooltip: 'Xóa thực phẩm',
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => _confirmDelete(food),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodImage(FoodModel food) {
    final url = food.imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 62,
        width: 62,
        child: url == null || url.trim().isEmpty
            ? _imagePlaceholder()
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _imagePlaceholder(),
              ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return const ColoredBox(
      color: AppColors.primaryLight,
      child: Icon(
        Icons.kitchen_outlined,
        color: AppColors.primary,
        size: 27,
      ),
    );
  }

  Future<void> _openFoodForm([FoodModel? food]) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FoodFormScreen(
          viewModel: widget.viewModel,
          food: food,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(FoodModel food) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa thực phẩm?'),
        content: Text('Xóa “${food.name}” khỏi tủ lạnh?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await widget.viewModel.deleteFood(food.id);

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.viewModel.errorMessage ?? 'Không thể xóa thực phẩm',
          ),
        ),
      );
    }
  }
}
