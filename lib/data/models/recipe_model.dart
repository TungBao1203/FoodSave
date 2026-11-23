class RecipeIngredient {
  final String name;
  final String amount;
  final bool isAvailable;
  final bool isExpiringSoon;

  const RecipeIngredient({
    required this.name,
    required this.amount,
    this.isAvailable = true,
    this.isExpiringSoon = false,
  });

  RecipeIngredient copyWith({
    String? name,
    String? amount,
    bool? isAvailable,
    bool? isExpiringSoon,
  }) {
    return RecipeIngredient(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      isAvailable: isAvailable ?? this.isAvailable,
      isExpiringSoon: isExpiringSoon ?? this.isExpiringSoon,
    );
  }

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      name: json['name'] as String,
      amount: json['amount'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isExpiringSoon: json['isExpiringSoon'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'isAvailable': isAvailable,
      'isExpiringSoon': isExpiringSoon,
    };
  }
}

class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int cookTimeMinutes;
  final String difficulty;
  final int servings;
  final String? priorityTag;
  final bool isFeatured;
  final bool isBookmarked;
  final List<String> tags;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;

  const RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cookTimeMinutes,
    required this.difficulty,
    this.servings = 2,
    this.priorityTag,
    this.isFeatured = false,
    this.isBookmarked = false,
    this.tags = const [],
    required this.ingredients,
    required this.steps,
  });

  int get availableIngredientsCount =>
      ingredients.where((i) => i.isAvailable).length;

  int get missingIngredientsCount =>
      ingredients.where((i) => !i.isAvailable).length;

  int get expiringIngredientsCount =>
      ingredients.where((i) => i.isExpiringSoon && i.isAvailable).length;

  int get totalIngredientsCount => ingredients.length;

  bool get hasAllIngredients =>
      availableIngredientsCount == totalIngredientsCount;

  RecipeModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    int? cookTimeMinutes,
    String? difficulty,
    int? servings,
    String? priorityTag,
    bool? isFeatured,
    bool? isBookmarked,
    List<String>? tags,
    List<RecipeIngredient>? ingredients,
    List<String>? steps,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      difficulty: difficulty ?? this.difficulty,
      servings: servings ?? this.servings,
      priorityTag: priorityTag ?? this.priorityTag,
      isFeatured: isFeatured ?? this.isFeatured,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      tags: tags ?? this.tags,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }
}
