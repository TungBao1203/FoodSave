import 'package:flutter/foundation.dart';
import '../../../data/models/recipe_model.dart';
import '../../../data/repositories/recipe_repository.dart';

class SuggestionsViewModel extends ChangeNotifier {
  final IRecipeRepository _recipeRepository;

  SuggestionsViewModel({IRecipeRepository? recipeRepository})
      : _recipeRepository = recipeRepository ?? RecipeRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAiGenerating = false;
  bool get isAiGenerating => _isAiGenerating;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  RecipeModel? _featuredRecipe;
  RecipeModel? get featuredRecipe => _featuredRecipe;

  List<RecipeModel> _allFilteredRecipes = [];
  List<RecipeModel> _suggestedRecipes = [];
  List<RecipeModel> get suggestedRecipes => _suggestedRecipes;

  int _refreshIndex = 0;

  // Bộ lọc ngang thông minh
  String _selectedFilter = 'Tất cả';
  String get selectedFilter => _selectedFilter;

  final List<String> _filters = [
    'Tất cả',
    'Ưu tiên nấu trước',
    'Đủ nguyên liệu',
    '< 15 phút',
    '< 30 phút',
    '< 1 giờ',
    'Từ 1h - 2h',
  ];
  List<String> get filters => _filters;

  Future<void> loadData({bool isFilterChange = false}) async {
    if (!isFilterChange) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      // 1. Tải món nổi bật theo chip đang chọn
      _featuredRecipe = await _recipeRepository.getFeaturedRecipe(
        activeFilter: _selectedFilter,
      );

      // 2. Tải danh sách gợi ý
      final recipes = await _recipeRepository.getSuggestedRecipes(
        activeFilter: _selectedFilter,
      );

      // Loại trừ món featured để không bị trùng
      _allFilteredRecipes =
          recipes.where((r) => r.id != _featuredRecipe?.id).toList();

      _refreshIndex = 0;
      _pickNextSuggestions();
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách gợi ý: $e';
    } finally {
      if (!isFilterChange) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  // Lấy 5 món tiếp theo trong kho mà không trùng món cũ
  void _pickNextSuggestions() {
    if (_allFilteredRecipes.isEmpty) {
      _suggestedRecipes = [];
      return;
    }

    if (_allFilteredRecipes.length <= 5) {
      _suggestedRecipes = List.from(_allFilteredRecipes);
      return;
    }

    // Nếu có nhiều hơn 5 món, lấy lượt tiếp theo theo vòng tròn (round-robin)
    List<RecipeModel> batch = [];
    for (int i = 0; i < 5; i++) {
      final index = (_refreshIndex + i) % _allFilteredRecipes.length;
      batch.add(_allFilteredRecipes[index]);
    }
    _suggestedRecipes = batch;
  }

  void selectFilter(String filter) {
    if (_selectedFilter == filter && filter != 'Tất cả') {
      _selectedFilter = 'Tất cả';
    } else {
      _selectedFilter = filter;
    }
    loadData(isFilterChange: true);
  }

  // Khi bấm "Làm mới": CHỈ thay đổi 5 món bên dưới, KHÔNG đổi món nổi bật và KHÔNG lặp lại món cũ
  Future<void> refreshSuggestions() async {
    if (_allFilteredRecipes.length > 5) {
      _refreshIndex = (_refreshIndex + 5) % _allFilteredRecipes.length;
      _pickNextSuggestions();
      notifyListeners();
    } else {
      // Nếu ít món thì xáo trộn thứ tự
      _allFilteredRecipes.shuffle();
      _suggestedRecipes = _allFilteredRecipes.take(5).toList();
      notifyListeners();
    }
  }

  // Gọi AI sáng tạo món mới
  Future<RecipeModel?> generateAiRecipe() async {
    _isAiGenerating = true;
    notifyListeners();

    try {
      final aiRecipe = await _recipeRepository.generateAiRecipe();
      return aiRecipe;
    } catch (e) {
      _errorMessage = 'Lỗi khi gọi AI: $e';
      return null;
    } finally {
      _isAiGenerating = false;
      notifyListeners();
    }
  }

  Future<void> toggleBookmark(String recipeId) async {
    await _recipeRepository.toggleBookmark(recipeId);
    if (_featuredRecipe?.id == recipeId) {
      _featuredRecipe = _featuredRecipe!.copyWith(
        isBookmarked: !_featuredRecipe!.isBookmarked,
      );
    }
    final index = _suggestedRecipes.indexWhere((r) => r.id == recipeId);
    if (index != -1) {
      final item = _suggestedRecipes[index];
      _suggestedRecipes[index] =
          item.copyWith(isBookmarked: !item.isBookmarked);
    }
    notifyListeners();
  }

  Future<List<RecipeModel>> getBookmarkedRecipes() async {
    return await _recipeRepository.getBookmarkedRecipes();
  }
}
