import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/family_member_model.dart';
import 'member_list_tile.dart';

/// Thẻ Hạn ngạch & Thành viên thiết kế thu gọn (Compact & Expandable):
/// - Thu gọn: Hiển thị thanh hạn ngạch 2/2, các avatar thu nhỏ và nút mở rộng
/// - Mở rộng: Bung danh sách chi tiết các thành viên khi người dùng nhấn vào
class FamilyGroupCard extends StatefulWidget {
  final FamilyGroupModel familyGroup;
  final void Function(String id, String name) onDeleteMember;
  final VoidCallback? onRenameGroup;

  const FamilyGroupCard({
    super.key,
    required this.familyGroup,
    required this.onDeleteMember,
    this.onRenameGroup,
  });

  @override
  State<FamilyGroupCard> createState() => _FamilyGroupCardState();
}

class _FamilyGroupCardState extends State<FamilyGroupCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final group = widget.familyGroup;
    final isFull = group.isFull;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Phần Tóm tắt Hạn ngạch (luôn hiển thị, gọn gàng)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        group.isPremium
                            ? Icons.workspace_premium_rounded
                            : Icons.home_rounded,
                        color: group.isPremium
                            ? AppColors.accentGold
                            : AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  group.name,
                                  style: const TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.onRenameGroup != null) ...[
                                const SizedBox(width: 6),
                                InkWell(
                                  onTap: widget.onRenameGroup,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.edit_outlined,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            group.isPremium
                                ? 'Gói Premium • Thành viên không giới hạn'
                                : (isFull
                                    ? 'Đạt hạn ngạch tối đa gói Miễn phí'
                                    : 'Đang sử dụng ${group.currentCount}/${group.maxMembers} thành viên'),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        group.isPremium
                            ? '👑 ${group.currentCount} thành viên'
                            : '${group.currentCount}/${group.maxMembers} người',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Thanh tiến trình hạn ngạch màu xanh tự nhiên
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: group.isPremium
                        ? 1.0
                        : (group.currentCount / group.maxMembers),
                    minHeight: 6,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Hàng Avatar xếp lớp + Nút Bấm xem danh sách
                InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        // Stacked avatar xem nhanh
                        SizedBox(
                          height: 32,
                          width: (group.members.length * 24.0) + 12,
                          child: Stack(
                            children: List.generate(group.members.length, (i) {
                              final member = group.members[i];
                              return Positioned(
                                left: i * 22.0,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: member.avatarBgColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    member.avatarLetter,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isExpanded ? 'Thu gọn danh sách' : 'Xem danh sách thành viên (${group.currentCount})',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Danh sách thành viên mở rộng (Chỉ hiện khi _isExpanded == true)
          if (_isExpanded) ...[
            const Divider(height: 1, thickness: 1, color: AppColors.borderLight),
            ...List.generate(group.members.length, (index) {
              final member = group.members[index];
              return Column(
                children: [
                  MemberListTile(
                    member: member,
                    onDelete: () => widget.onDeleteMember(member.id, member.name),
                  ),
                  if (index < group.members.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 1,
                        thickness: 0.5,
                        color: AppColors.borderLight,
                      ),
                    ),
                ],
              );
            }),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}
