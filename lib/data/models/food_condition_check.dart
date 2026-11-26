class FoodConditionCheck {
  final String id;
  final String foodId;
  final DateTime checkedAt;
  final String? beforeImageUrl;
  final String? afterImageUrl;
  final String? resultSummary;
  final List<String> visibleChanges;

  const FoodConditionCheck({
    required this.id,
    required this.foodId,
    required this.checkedAt,
    this.beforeImageUrl,
    this.afterImageUrl,
    this.resultSummary,
    this.visibleChanges = const [],
  });

  factory FoodConditionCheck.fromJson(
    Map<String, dynamic> json,
  ) {
    return FoodConditionCheck(
      id: json['id'] as String,
      foodId: json['foodId'] as String,
      checkedAt: DateTime.parse(
        json['checkedAt'] as String,
      ),
      beforeImageUrl: json['beforeImageUrl'] as String?,
      afterImageUrl: json['afterImageUrl'] as String?,
      resultSummary: json['resultSummary'] as String?,
      visibleChanges: (json['visibleChanges'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodId': foodId,
      'checkedAt': checkedAt.toIso8601String(),
      'beforeImageUrl': beforeImageUrl,
      'afterImageUrl': afterImageUrl,
      'resultSummary': resultSummary,
      'visibleChanges': visibleChanges,
    };
  }
}
