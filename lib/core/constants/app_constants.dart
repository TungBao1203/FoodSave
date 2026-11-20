class AppConstants {
  AppConstants._();

  static const String appName = 'FoodSave';
  static const String currency = 'đ';

  // Filters for Screen 07
  static const List<String> recipeFilterChips = [
    'Tất cả',
    'Ưu tiên nấu trước',
    'Đủ nguyên liệu',
    '< 15 phút',
    '< 30 phút',
    '< 1 giờ',
    'Từ 1h - 2h',
  ];

  // Premium pricing
  static const int monthlyPrice = 59000;
  static const int yearlyMonthlyEquivalent = 29000;
  static const int yearlyTotal = 348000;
}
