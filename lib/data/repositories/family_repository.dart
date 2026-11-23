import 'package:flutter/material.dart';
import '../models/family_member_model.dart';
import '../models/food_model.dart';

abstract class IFamilyRepository {
  Future<FamilyGroupModel> getFamilyGroup();
  Future<bool> removeMember(String memberId);
  Future<String> generateInviteLink(String method);
  Future<bool> inviteByPhone(String phone);
  Future<void> updateGroupName(String newName);
  Future<void> updateCurrentUserName(String newName);
  Future<void> updateCurrentUserAvatarColor(Color newColor);
  Future<void> upgradeToPremium();
  Future<List<FoodModel>> getSharedFridgeData();
}

class FamilyRepository implements IFamilyRepository {
  static final FamilyRepository _instance = FamilyRepository._internal();
  factory FamilyRepository() => _instance;
  FamilyRepository._internal() {
    _familyGroup = FamilyGroupModel(
      id: 'family_home_01',
      name: 'Nhà mình',
      maxMembers: 2,
      isPremium: false,
      members: [
        FamilyMemberModel(
          id: 'mem_1',
          name: 'Vũ',
          role: 'Chủ hộ',
          avatarLetter: 'V',
          avatarBgColor: const Color(0xFFD6ECD9),
          isOwner: true,
          isCurrentUser: true,
          joinedDate: DateTime.now().subtract(const Duration(days: 30)),
        ),
        FamilyMemberModel(
          id: 'mem_2',
          name: 'Anh',
          role: 'Thành viên',
          avatarLetter: 'A',
          avatarBgColor: const Color(0xFFFDE8E0),
          isOwner: false,
          isCurrentUser: false,
          joinedDate: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ],
    );
  }

  late FamilyGroupModel _familyGroup;

  @override
  Future<FamilyGroupModel> getFamilyGroup() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _familyGroup;
  }

  @override
  Future<bool> removeMember(String memberId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final updatedMembers =
        _familyGroup.members.where((m) => m.id != memberId).toList();
    _familyGroup = _familyGroup.copyWith(members: updatedMembers);
    return true;
  }

  @override
  Future<void> updateGroupName(String newName) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _familyGroup = _familyGroup.copyWith(name: newName);
  }

  @override
  Future<void> updateCurrentUserName(String newName) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    final initial = trimmed.isNotEmpty ? trimmed[0].toUpperCase() : 'V';
    final updatedMembers = _familyGroup.members.map((m) {
      if (m.isCurrentUser || m.isOwner) {
        return m.copyWith(
          name: trimmed,
          avatarLetter: initial,
        );
      }
      return m;
    }).toList();
    _familyGroup = _familyGroup.copyWith(members: updatedMembers);
  }

  @override
  Future<void> updateCurrentUserAvatarColor(Color newColor) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final updatedMembers = _familyGroup.members.map((m) {
      if (m.isCurrentUser || m.isOwner) {
        return m.copyWith(avatarBgColor: newColor);
      }
      return m;
    }).toList();
    _familyGroup = _familyGroup.copyWith(members: updatedMembers);
  }

  @override
  Future<bool> inviteByPhone(String phone) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (_familyGroup.isFull && !_familyGroup.isPremium) {
      return false;
    }
    // Khi còn chỗ hoặc đã là Premium: tự động thêm thành viên mới
    final suffix = phone.length >= 4 ? phone.substring(phone.length - 4) : phone;
    final newMember = FamilyMemberModel(
      id: 'mem_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Thành viên (...$suffix)',
      role: 'Thành viên',
      avatarLetter: 'T',
      avatarBgColor: const Color(0xFFE8F5E9),
      isOwner: false,
      isCurrentUser: false,
      joinedDate: DateTime.now(),
    );
    _familyGroup = _familyGroup.copyWith(
      members: [..._familyGroup.members, newMember],
    );
    return true;
  }

  @override
  Future<String> generateInviteLink(String method) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (_familyGroup.isFull && !_familyGroup.isPremium) {
      throw Exception('Đã đạt giới hạn số lượng thành viên miễn phí');
    }
    return 'https://foodsave.app/join/${_familyGroup.id}?method=$method';
  }

  @override
  Future<void> upgradeToPremium() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _familyGroup = _familyGroup.copyWith(
      isPremium: true,
      maxMembers: 999, // unlimited
    );
  }

  @override
  Future<List<FoodModel>> getSharedFridgeData() async {
    // Simulates shared fridge data between family members
    return [
      const FoodModel(
        id: 'food_1',
        name: 'Thịt heo nạc',
        quantity: 300,
        unit: 'g',
        daysUntilExpiry: 1,
        category: 'Thịt & Hải sản',
        isExpiringSoon: true,
      ),
      const FoodModel(
        id: 'food_2',
        name: 'Cà chua',
        quantity: 3,
        unit: 'quả',
        daysUntilExpiry: 2,
        category: 'Rau củ',
        isExpiringSoon: true,
      ),
      const FoodModel(
        id: 'food_3',
        name: 'Trứng gà',
        quantity: 4,
        unit: 'quả',
        daysUntilExpiry: 5,
        category: 'Trứng & Sữa',
        isExpiringSoon: false,
      ),
      const FoodModel(
        id: 'food_4',
        name: 'Rau cải xanh',
        quantity: 1,
        unit: 'bó',
        daysUntilExpiry: 2,
        category: 'Rau củ',
        isExpiringSoon: true,
      ),
    ];
  }
}
