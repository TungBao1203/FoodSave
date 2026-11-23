import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum _SettingsStep { menu, personalInfo, familyInfo }

/// BottomSheet Cài đặt chuẩn phân cấp (Drill-down Navigation):
/// - Bước 1: Lúc mở lên CHỈ hiện đúng 3 mục (tiêu đề gọn, không có chữ nhỏ bên dưới):
///   1. Thông tin cá nhân
///   2. Thông tin gia đình
///   3. Rời nhóm
/// - Bước 2: Tương tác trực tiếp và đồng bộ thời gian thực:
///   + Thông tin cá nhân: Giao diện gọn gàng, không có Avatar cồng kềnh, 1 nút chỉnh sửa duy nhất
///   + Thông tin gia đình: Thông tin nhóm tinh tế & cài đặt thông báo (Đổi tên nhóm đã đưa ra Màn 9)
///   + Đồng bộ dữ liệu ra màn hình chính ngay lập tức
class FamilySettingsSheet extends StatefulWidget {
  final String currentGroupName;
  final String currentUserName;
  final bool isPremium;
  final ValueChanged<String> onUpdateUserName;
  final VoidCallback onLeaveGroup;

  const FamilySettingsSheet({
    super.key,
    required this.currentGroupName,
    required this.currentUserName,
    this.isPremium = false,
    required this.onUpdateUserName,
    required this.onLeaveGroup,
  });

  @override
  State<FamilySettingsSheet> createState() => _FamilySettingsSheetState();
}

class _FamilySettingsSheetState extends State<FamilySettingsSheet> {
  _SettingsStep _currentStep = _SettingsStep.menu;
  bool _notifyNewFood = true;
  bool _notifyExpiring = true;

  // Dữ liệu Nhóm gia đình
  late String _groupName;

  // Dữ liệu Cá nhân người dùng
  late String _userName;
  String _userPhone = '0901 234 567';
  String _userEmail = 'vu.hoai@foodsave.app';

  @override
  void initState() {
    super.initState();
    _groupName = widget.currentGroupName;
    _userName = widget.currentUserName;
  }

  // Hộp thoại Chỉnh sửa thông tin cá nhân (Đồng bộ ra ngoài tức thì)
  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _userName);
    nameCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: nameCtrl.text.length),
    );
    final phoneCtrl = TextEditingController(text: _userPhone);
    phoneCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneCtrl.text.length),
    );
    final emailCtrl = TextEditingController(text: _userEmail);
    emailCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: emailCtrl.text.length),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Chỉnh sửa thông tin cá nhân',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                enableSuggestions: true,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
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
              final newName = nameCtrl.text.trim();
              final newPhone = phoneCtrl.text.trim();
              final newEmail = emailCtrl.text.trim();

              if (newName.isNotEmpty) {
                setState(() {
                  _userName = newName;
                  if (newPhone.isNotEmpty) _userPhone = newPhone;
                  if (newEmail.isNotEmpty) _userEmail = newEmail;
                });
                widget.onUpdateUserName(newName);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã cập nhật thông tin thành "$newName"')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Lưu thay đổi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thanh gạt modal bar phía trên
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header động tùy theo bước hiện tại
            _buildHeader(),
            const SizedBox(height: 12),

            // Nội dung theo bước: 3 mục ban đầu HOẶC trang chi tiết
            if (_currentStep == _SettingsStep.menu)
              _buildMainMenu()
            else if (_currentStep == _SettingsStep.personalInfo)
              _buildPersonalInfoView()
            else if (_currentStep == _SettingsStep.familyInfo)
              _buildFamilyInfoView(),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Header (Có nút Back khi đang ở trang con)
  Widget _buildHeader() {
    final isSubPage = _currentStep != _SettingsStep.menu;

    return Row(
      children: [
        if (isSubPage) ...[
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              setState(() {
                _currentStep = _SettingsStep.menu;
              });
            },
          ),
          const SizedBox(width: 10),
        ],
        Text(
          _currentStep == _SettingsStep.menu
              ? 'Cài đặt'
              : _currentStep == _SettingsStep.personalInfo
                  ? 'Thông tin cá nhân'
                  : 'Thông tin gia đình',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  // ==========================================
  // BƯỚC 1: MENU CHÍNH VỚI ĐÚNG 3 MỤC TINH GỌN (KHÔNG CHỮ NHỎ)
  // ==========================================
  Widget _buildMainMenu() {
    return Column(
      children: [
        // Mục 1: Thông tin cá nhân
        _buildMenuTile(
          icon: Icons.person_outline_rounded,
          iconBgColor: AppColors.primaryLight,
          iconColor: AppColors.primary,
          title: 'Thông tin cá nhân',
          onTap: () {
            setState(() {
              _currentStep = _SettingsStep.personalInfo;
            });
          },
        ),
        const Divider(height: 1),

        // Mục 2: Thông tin gia đình
        _buildMenuTile(
          icon: Icons.family_restroom_rounded,
          iconBgColor: AppColors.primaryLight,
          iconColor: AppColors.primary,
          title: 'Thông tin gia đình',
          onTap: () {
            setState(() {
              _currentStep = _SettingsStep.familyInfo;
            });
          },
        ),
        const Divider(height: 1),

        // Mục 3: Rời nhóm (Tone màu trung tính thanh lịch)
        _buildMenuTile(
          icon: Icons.logout_rounded,
          iconBgColor: AppColors.surfaceVariant,
          iconColor: AppColors.textSecondary,
          title: 'Rời nhóm',
          onTap: () {
            Navigator.pop(context); // đóng sheet
            widget.onLeaveGroup(); // mở hộp thoại xác nhận rời nhóm
          },
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textMuted,
        size: 22,
      ),
      onTap: onTap,
    );
  }

  // ==========================================
  // BƯỚC 2A: CHI TIẾT THÔNG TIN CÁ NHÂN (GỌN GÀNG, BỎ AVATAR)
  // ==========================================
  Widget _buildPersonalInfoView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        // Header Người dùng tinh tế (Không có Avatar cồng kềnh)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Chủ hộ nhóm',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Các hàng thông tin cá nhân
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              _buildInfoItem(Icons.phone_outlined, 'Số điện thoại', _userPhone),
              const Divider(height: 16),
              _buildInfoItem(Icons.email_outlined, 'Email', _userEmail),
              const Divider(height: 16),
              _buildInfoItem(
                Icons.card_membership_outlined,
                'Gói sử dụng',
                widget.isPremium
                    ? 'Gói Gia đình Premium (Không giới hạn)'
                    : 'Gói Gia đình Miễn phí (2 TV)',
              ),
              const Divider(height: 16),
              _buildInfoItem(Icons.calendar_today_outlined, 'Ngày tham gia', '15/10/2026'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // DUY NHẤT 1 NƠI CHỈNH SỬA THÔNG TIN
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: _showEditProfileDialog,
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: const Text('Chỉnh sửa thông tin'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Nút quay lại danh mục Cài đặt
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _currentStep = _SettingsStep.menu;
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.borderLight),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Quay lại danh mục Cài đặt'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ==========================================
  // BƯỚC 2B: CHI TIẾT THÔNG TIN GIA ĐÌNH (GỌN GÀNG, BỎ AVATAR & BỎ ĐỔI TÊN)
  // ==========================================
  Widget _buildFamilyInfoView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        // Header Tên nhóm tinh tế
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.family_restroom_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _groupName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Tủ lạnh chung của gia đình • 2 thành viên',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1),

        // 1. Switch thông báo thực phẩm mới
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          activeThumbColor: AppColors.primary,
          title: const Text(
            'Thông báo thực phẩm mới',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
          ),
          subtitle: const Text(
            'Nhận tin khi thành viên thêm món vào tủ',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          value: _notifyNewFood,
          onChanged: (val) {
            setState(() => _notifyNewFood = val);
          },
        ),
        const Divider(height: 1),

        // 2. Switch cảnh báo thực phẩm cận hạn
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          activeThumbColor: AppColors.primary,
          title: const Text(
            'Cảnh báo thực phẩm cận hạn',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
          ),
          subtitle: const Text(
            'Cảnh báo khi thức ăn chung sắp hết hạn',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          value: _notifyExpiring,
          onChanged: (val) {
            setState(() => _notifyExpiring = val);
          },
        ),
        const SizedBox(height: 14),

        // Nút quay lại danh mục Cài đặt
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _currentStep = _SettingsStep.menu;
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.borderLight),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Quay lại danh mục Cài đặt'),
          ),
        ),
      ],
    );
  }
}
