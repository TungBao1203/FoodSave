enum FoodConditionStatus {
  noVisibleChange,
  visibleChange,
  needsReview,
  unknown,
}

class FoodConditionResult {
  final String foodId;
  final FoodConditionStatus status;
  final List<String> visibleChanges;
  final String summary;
  final bool needsReview;
  final DateTime checkedAt;

  const FoodConditionResult({
    required this.foodId,
    required this.status,
    required this.visibleChanges,
    required this.summary,
    required this.needsReview,
    required this.checkedAt,
  });

  factory FoodConditionResult.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawStatus = json['status'] as String?;

    final status = FoodConditionStatus.values.firstWhere(
      (value) => value.name == rawStatus,
      orElse: () => FoodConditionStatus.unknown,
    );

    return FoodConditionResult(
      foodId: json['foodId'] as String,
      status: status,
      visibleChanges: (json['visibleChanges'] as List<dynamic>? ?? [])
          .map((value) => value.toString())
          .toList(),
      summary: json['summary'] as String? ??
          'Không đủ thông tin để đánh giá hình ảnh.',
      needsReview: json['needsReview'] as bool? ?? true,
      checkedAt: DateTime.parse(json['checkedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'status': status.name,
      'visibleChanges': visibleChanges,
      'summary': summary,
      'needsReview': needsReview,
      'checkedAt': checkedAt.toIso8601String(),
    };
  }
}
