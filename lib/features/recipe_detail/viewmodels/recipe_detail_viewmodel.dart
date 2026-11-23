import 'package:flutter/foundation.dart';
import '../../../data/models/recipe_model.dart';
import '../../../data/repositories/recipe_repository.dart';

class RecipeDetailViewModel extends ChangeNotifier {
  final IRecipeRepository _recipeRepository;

  RecipeDetailViewModel({IRecipeRepository? recipeRepository})
      : _recipeRepository = recipeRepository ?? RecipeRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RecipeModel? _recipe;
  RecipeModel? get recipe => _recipe;

  final Set<int> _checkedIngredientIndices = {};
  Set<int> get checkedIngredientIndices => _checkedIngredientIndices;

  Future<void> loadRecipe(String recipeId) async {
    _isLoading = true;
    notifyListeners();

    _recipe = await _recipeRepository.getRecipeById(recipeId);

    _checkedIngredientIndices.clear();
    if (_recipe != null) {
      for (int i = 0; i < _recipe!.ingredients.length; i++) {
        if (_recipe!.ingredients[i].isAvailable) {
          _checkedIngredientIndices.add(i);
        }
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void setRecipe(RecipeModel recipe) {
    _recipe = recipe;
    _checkedIngredientIndices.clear();
    for (int i = 0; i < recipe.ingredients.length; i++) {
      if (recipe.ingredients[i].isAvailable) {
        _checkedIngredientIndices.add(i);
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  void toggleIngredient(int index) {
    if (_checkedIngredientIndices.contains(index)) {
      _checkedIngredientIndices.remove(index);
    } else {
      _checkedIngredientIndices.add(index);
    }
    notifyListeners();
  }

  Future<void> toggleBookmark() async {
    if (_recipe == null) return;
    await _recipeRepository.toggleBookmark(_recipe!.id);
    _recipe = _recipe!.copyWith(isBookmarked: !_recipe!.isBookmarked);
    notifyListeners();
  }
}
