import 'package:flutter/foundation.dart';

import '../../../data/models/food_model.dart';
import '../../../data/repositories/food_repository.dart';

enum FoodFilter {
  all,
  fresh,
  expiringSoon,
  expired,
}

class FoodViewModel extends ChangeNotifier {
  final IFoodRepository _repository;

  FoodViewModel({
    required IFoodRepository repository,
  }) : _repository = repository;

  List<FoodModel> _foods = [];

  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  FoodFilter _selectedFilter = FoodFilter.all;

  // ===== GETTERS =====

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;

  FoodFilter get selectedFilter => _selectedFilter;

  List<FoodModel> get allFoods => List.unmodifiable(_foods);

  int get totalFoods => _foods.length;

  int get freshCount =>
      _foods.where((food) => food.expiryStatus == ExpiryStatus.fresh).length;

  int get expiringSoonCount => _foods
      .where((food) => food.expiryStatus == ExpiryStatus.expiringSoon)
      .length;

  int get expiredCount =>
      _foods.where((food) => food.expiryStatus == ExpiryStatus.expired).length;

  // ===== SEARCH & FILTER =====

  List<FoodModel> get filteredFoods {
    final query = _searchQuery.trim().toLowerCase();

    final result = _foods.where((food) {
      final matchesSearch = food.name.toLowerCase().contains(query) ||
          food.category.toLowerCase().contains(query);

      final matchesFilter = switch (_selectedFilter) {
        FoodFilter.all => true,
        FoodFilter.fresh => food.expiryStatus == ExpiryStatus.fresh,
        FoodFilter.expiringSoon =>
          food.expiryStatus == ExpiryStatus.expiringSoon,
        FoodFilter.expired => food.expiryStatus == ExpiryStatus.expired,
      };

      return matchesSearch && matchesFilter;
    }).toList();

    // Ưu tiên thực phẩm gần hết hạn.
    result.sort((a, b) {
      final compareDays = a.remainingDays.compareTo(b.remainingDays);

      if (compareDays != 0) {
        return compareDays;
      }

      return a.name.compareTo(b.name);
    });

    return List.unmodifiable(result);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(FoodFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedFilter = FoodFilter.all;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ===== READ =====

  Future<void> loadFoods() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _foods = await _repository.getFoods();
    } catch (e) {
      _errorMessage = 'Không thể tải thực phẩm: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===== CREATE =====

  Future<bool> addFood(FoodModel food) {
    return _executeAction(
      () => _repository.addFood(food),
    );
  }

  // ===== UPDATE =====

  Future<bool> updateFood(FoodModel food) {
    return _executeAction(
      () => _repository.updateFood(food),
    );
  }

  // ===== DELETE =====

  Future<bool> deleteFood(String id) {
    return _executeAction(
      () => _repository.deleteFood(id),
    );
  }

  // ===== SHARED ACTION HANDLER =====

  Future<bool> _executeAction(
    Future<void> Function() action,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var success = false;

    try {
      await action();

      // Tải lại danh sách sau khi thay đổi dữ liệu.
      _foods = await _repository.getFoods();

      success = true;
    } catch (e) {
      _errorMessage = 'Thao tác thất bại: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return success;
  }
}
