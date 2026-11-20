import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/family_member_model.dart';

class MemberListTile extends StatelessWidget {
  final FamilyMemberModel member;
  final VoidCallback? onDelete;

  const MemberListTile({
    super.key,
    required this.member,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Avatar Letter Circle
          CircleAvatar(
            radius: 20,
            backgroundColor: member.avatarBgColor,
            child: Text(
              member.avatarLetter,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name
          Text(
            member.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),

          // Role Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: member.isOwner
                  ? AppColors.primaryLight
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              member.role,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: member.isOwner
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          const Spacer(),

          // Delete button (only for non-owners)
          if (!member.isOwner && onDelete != null)
            InkWell(
              onTap: onDelete,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.dangerLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.danger.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      size: 14,
                      color: AppColors.danger,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Xóa',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
