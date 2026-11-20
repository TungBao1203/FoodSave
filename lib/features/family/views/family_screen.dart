import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/app_leaf_logo.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../viewmodels/family_viewmodel.dart';
import '../widgets/family_quota_card.dart';
import '../widgets/member_list_tile.dart';
import '../widgets/invite_method_card.dart';
import '../widgets/upgrade_family_banner.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  late final FamilyViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = FamilyViewModel();
    _viewModel.loadFamilyGroup();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    if (index == 3) return; // already here
    if (index == 2) {
      Navigator.pushReplacementNamed(context, AppRoutes.suggestions);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            index == 0
                ? 'Màn hình Trang chủ do Thành viên 1 phụ trách'
                : 'Màn hình Tủ lạnh do Thành viên 2 phụ trách',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _handleInvite(String method) async {
    final link = await _viewModel.tryInvite(method);
    if (!mounted) return;

    if (link == null) {
      _showUpgradeDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã tạo liên kết mời qua $method!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đã đạt giới hạn thành viên'),
        content: const Text(
          'Gói miễn phí chỉ hỗ trợ tối đa 2 thành viên trong gia đình. Nâng cấp lên FoodSave Premium để chia sẻ không giới hạn!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Để sau'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, AppRoutes.premium);
            },
            child: const Text('Nâng cấp ngay'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteMember(String memberId, String memberName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa $memberName khỏi nhóm gia đình?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _viewModel.removeMember(memberId);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        final familyGroup = _viewModel.familyGroup;

        return Scaffold(
          appBar: AppBar(
            leading: const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Center(child: AppLeafLogo(size: 36)),
            ),
            title: const Text('Gia đình'),
            actions: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cài đặt nhóm gia đình'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.settings_outlined, size: 24),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: _viewModel.isLoading || familyGroup == null
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Family quota card
                      FamilyQuotaCard(familyGroup: familyGroup),
                      const SizedBox(height: 20),

                      // Members section header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Thành viên nhà mình',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${familyGroup.currentCount} thành viên',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Members card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.borderLight,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            ...List.generate(familyGroup.members.length, (index) {
                              final member = familyGroup.members[index];
                              return Column(
                                children: [
                                  if (index > 0) const Divider(),
                                  MemberListTile(
                                    member: member,
                                    onDelete: () => _confirmDeleteMember(
                                      member.id,
                                      member.name,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Invite options
                      InviteMethodCard(
                        isLimitReached: familyGroup.isFull && !familyGroup.isPremium,
                        onSelectMethod: _handleInvite,
                      ),
                      const SizedBox(height: 20),

                      // Upgrade banner
                      UpgradeFamilyBanner(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.premium);
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
          bottomNavigationBar: AppBottomNavBar(
            currentIndex: 3, // "Gia đình"
            onTap: _onBottomNavTapped,
          ),
        );
      },
    );
  }
}
