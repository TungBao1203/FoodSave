import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/models/family_member_model.dart';
import '../../../shared/widgets/app_leaf_logo.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../viewmodels/family_viewmodel.dart';
import '../widgets/family_group_card.dart';
import '../widgets/invite_method_card.dart';
import '../widgets/upgrade_family_banner.dart';
import '../widgets/family_settings_sheet.dart';

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
    if (index == 3) return; // đang ở màn gia đình
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

  // 1. Mở BottomSheet Cài đặt & Quản lý nhóm (Bao gồm Thông tin cá nhân, Cài đặt gia đình, Rời nhóm)
  void _showSettingsSheet(FamilyGroupModel familyGroup) {
    final currentMember = familyGroup.members.firstWhere(
      (m) => m.isCurrentUser || m.isOwner,
      orElse: () => familyGroup.members.first,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => FamilySettingsSheet(
        currentGroupName: familyGroup.name,
        currentUserName: currentMember.name,
        isPremium: familyGroup.isPremium,
        onUpdateUserName: (newName) {
          _viewModel.updateCurrentUserName(newName);
        },
        onLeaveGroup: _confirmLeaveGroup,
      ),
    );
  }

  // Mở hộp thoại Đổi tên nhóm trực tiếp từ Màn hình 9 (Hoặc từ Settings)
  void _showRenameDialog(FamilyGroupModel familyGroup) {
    final controller = TextEditingController(text: familyGroup.name);
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    const suggestions = [
      'Nhà mình',
      'Gia đình nhỏ',
      'Tổ ấm thân yêu',
      'Bếp ấm',
      'Căn bếp vui vẻ',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Đổi tên nhóm',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  enableSuggestions: true,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Tên nhóm gia đình',
                    hintText: 'Nhập tên mới (ví dụ: Nhà mình)',
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              controller.clear();
                              setDialogState(() {});
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  onChanged: (_) => setDialogState(() {}),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Gợi ý tên nhanh:',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: suggestions.map((sug) {
                    final isCurrent = controller.text == sug;
                    return InkWell(
                      onTap: () {
                        controller.text = sug;
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                        setDialogState(() {});
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isCurrent ? AppColors.primaryLight : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCurrent ? AppColors.primary : AppColors.borderLight,
                          ),
                        ),
                        child: Text(
                          sug,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                            color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  _viewModel.updateGroupName(newName);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã đổi tên nhóm thành "$newName"')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Mở Pop-up Quét mã QR
  void _showQRDialog(FamilyGroupModel familyGroup) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Column(
            children: [
              const Text(
                'Mã QR Nhóm Gia Đình',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                familyGroup.name,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.qr_code_2_rounded,
                size: 160,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Mã nhóm: FS-8899',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Người thân chỉ cần mở camera điện thoại quét mã này để tham gia tủ lạnh gia đình.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Đóng'),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Mở Pop-up Mời qua SĐT
  void _showPhoneInviteDialog(FamilyGroupModel familyGroup) {
    if (familyGroup.isFull && !familyGroup.isPremium) {
      _showUpgradeDialog();
      return;
    }

    final phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Mời qua số điện thoại',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập số điện thoại người thân để gửi lời mời tham gia tủ lạnh dùng chung của gia đình.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Ví dụ: 0912 345 678',
                prefixIcon: Icon(Icons.phone_rounded, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final phone = phoneController.text.trim();
              if (phone.isNotEmpty) {
                Navigator.pop(ctx);
                _viewModel.inviteByPhone(phone);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã gửi lời mời tham gia nhóm tới $phone!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Gửi lời mời'),
          ),
        ],
      ),
    );
  }

  // Điều hướng sang Màn hình 10 (Premium) và tự động đồng bộ lại dữ liệu khi quay về
  Future<void> _navigateToPremium() async {
    await Navigator.pushNamed(context, AppRoutes.premium);
    if (mounted) {
      await _viewModel.loadFamilyGroup();
    }
  }

  // 4. Hộp thoại Nâng cấp Premium
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
              _navigateToPremium();
            },
            child: const Text('Nâng cấp ngay'),
          ),
        ],
      ),
    );
  }

  // 5. Xác nhận xóa thành viên
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

  // 6. Xác nhận rời nhóm
  void _confirmLeaveGroup() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rời khỏi nhóm'),
        content: const Text(
          'Bạn có chắc chắn muốn rời nhóm gia đình? Bạn sẽ không còn quyền truy cập tủ lạnh dùng chung nữa.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã rời khỏi nhóm gia đình')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Rời nhóm'),
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
              if (familyGroup != null)
                IconButton(
                  onPressed: () => _showSettingsSheet(familyGroup),
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
                      // 1. Thẻ quản lý Hạn ngạch & Thành viên thiết kế Thu gọn (Bấm vào để mở rộng danh sách)
                      FamilyGroupCard(
                        familyGroup: familyGroup,
                        onDeleteMember: _confirmDeleteMember,
                        onRenameGroup: () => _showRenameDialog(familyGroup),
                      ),
                      const SizedBox(height: 18),

                      // 2. Mời vào nhà mình (Chỉ 2 lựa chọn: Quét mã QR & Mời qua SĐT)
                      InviteMethodCard(
                        isLimitReached:
                            familyGroup.isFull && !familyGroup.isPremium,
                        onTapQR: () => _showQRDialog(familyGroup),
                        onTapPhone: () => _showPhoneInviteDialog(familyGroup),
                      ),
                      const SizedBox(height: 18),

                      // 3. Banner nâng cấp Premium (Chỉ hiện khi chưa là Premium)
                      if (!familyGroup.isPremium) ...[
                        UpgradeFamilyBanner(
                          onTap: _navigateToPremium,
                        ),
                        const SizedBox(height: 24),
                      ] else ...[
                        _buildActivePremiumCard(),
                        const SizedBox(height: 24),
                      ],
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

  // Thẻ thông báo gói Premium đang hoạt động
  Widget _buildActivePremiumCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F9F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryContainer, width: 1),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            color: AppColors.accentGold,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gói Family Premium đang hoạt động',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Không giới hạn thành viên tham gia nhóm gia đình',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
        ],
      ),
    );
  }
}
