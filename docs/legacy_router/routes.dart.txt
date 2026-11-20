/// Toàn bộ đường dẫn của app, dùng chung để tránh gõ sai chuỗi.
class Routes {
  // Onboarding / auth
  static const welcome = '/';
  static const phone = '/phone';
  static const login = '/login';

  // 4 tab chính
  static const home = '/home';
  static const fridge = '/fridge';
  static const aiRecipes = '/ai-recipes';
  static const family = '/family';

  // Màn đẩy lên trên (push)
  static const addFood = '/add-food';
  static const aiScan = '/ai-scan';
  static const aiResult = '/ai-result';
  static const premium = '/premium';
  static const recipeDetail = '/recipe/:id';

  static String recipe(String id) => '/recipe/$id';
}