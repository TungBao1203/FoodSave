import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/app_leaf_logo.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../viewmodels/suggestions_viewmodel.dart';
import '../widgets/ai_priority_banner.dart';
import '../widgets/filter_chips_bar.dart';
import '../widgets/featured_recipe_card.dart';
import '../widgets/recipe_tile_card.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  late final SuggestionsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SuggestionsViewModel();
    _viewModel.loadData();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    if (index == 2) return;

    if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.fridge);
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, AppRoutes.family);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trang chủ đang được phát triển.'),
        ),
      );
    }
  }

  // Gọi AI sáng tạo món mới
  void _handleGenerateAiRecipe() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AlertDialog(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.auto_awesome, color: AppColors.primary, size: 40),
              SizedBox(height: 16),
              Text(
                'AI Gemini đang phân tích tủ lạnh...',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Đang tìm nguyên liệu cận hạn và kết hợp gia vị để sáng tạo công thức tối ưu nhất.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(color: AppColors.primary),
            ],
          ),
        ),
      ),
    );

    final aiRecipe = await _viewModel.generateAiRecipe();
    if (!mounted) return;
    Navigator.pop(context); // Tắt dialog loading

    if (aiRecipe != null) {
      Navigator.pushNamed(
        context,
        AppRoutes.recipeDetail,
        arguments: aiRecipe, // Truyền trực tiếp món AI vừa tạo sang Màn hình 08
      );
    }
  }

  void _showBookmarkedRecipesSheet(BuildContext context) async {
    final bookmarks = await _viewModel.getBookmarkedRecipes();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Công thức đã lưu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (bookmarks.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'Bạn chưa lưu công thức nào.\nHãy bấm vào biểu tượng bookmark ở góc trên để lưu nhé!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.textSecondary, height: 1.4),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: bookmarks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = bookmarks[index];
                      return RecipeTileCard(
                        recipe: item,
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.pushNamed(
                            context,
                            AppRoutes.recipeDetail,
                            arguments: item.id,
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            leading: const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Center(child: AppLeafLogo(size: 36)),
            ),
            title: const Text('Gợi ý món ăn'),
            actions: [
              IconButton(
                onPressed: () => _showBookmarkedRecipesSheet(context),
                icon: const Icon(Icons.bookmark_border_rounded, size: 24),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: _viewModel.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _viewModel.refreshSuggestions,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. BỘ LỌC NGANG: Nằm ngay đầu tiên sau Header & Bookmark
                        FilterChipsBar(
                          filters: _viewModel.filters,
                          selectedFilter: _viewModel.selectedFilter,
                          onSelected: _viewModel.selectFilter,
                        ),
                        const SizedBox(height: 14),

                        // 2. THẺ MÓN NỔI BẬT: Nằm ngay sau bộ lọc, rất hút mắt
                        if (_viewModel.featuredRecipe != null)
                          FeaturedRecipeCard(
                            recipe: _viewModel.featuredRecipe!,
                            activeFilter: _viewModel.selectedFilter,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.recipeDetail,
                                arguments: _viewModel.featuredRecipe!.id,
                              );
                            },
                          ),
                        const SizedBox(height: 14),

                        // 3. THANH AI TINH GỌN: Thanh hành động nhỏ gọn, hiện đại
                        AiPriorityBanner(
                          isGenerating: _viewModel.isAiGenerating,
                          onGenerateAiTap: _handleGenerateAiRecipe,
                        ),
                        const SizedBox(height: 20),

                        // 4. MỤC THÊM LỰA CHỌN PHÙ HỢP: Danh sách 5 món + Nút Làm mới
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Thêm lựa chọn phù hợp',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            InkWell(
                              onTap: _viewModel.refreshSuggestions,
                              borderRadius: BorderRadius.circular(8),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.refresh_rounded,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Làm mới',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Danh sách 5 món
                        if (_viewModel.suggestedRecipes.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(24),
                            alignment: Alignment.center,
                            child: const Text(
                              'Không tìm thấy món phù hợp với tiêu chí hiện tại.\nHãy thử chọn tab khác hoặc bấm Làm mới!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _viewModel.suggestedRecipes.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final recipe = _viewModel.suggestedRecipes[index];
                              return RecipeTileCard(
                                recipe: recipe,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.recipeDetail,
                                    arguments: recipe.id,
                                  );
                                },
                              );
                            },
                          ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: 2, // "Món AI"
            onTap: _onBottomNavTapped,
          ),
        );
      },
    );
  }
}
