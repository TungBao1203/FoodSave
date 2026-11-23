import 'package:flutter/material.dart';
import '../../../data/models/family_member_model.dart';
import '../../../data/repositories/family_repository.dart';

class FamilyViewModel extends ChangeNotifier {
  final IFamilyRepository _familyRepository;

  FamilyViewModel({IFamilyRepository? familyRepository})
      : _familyRepository = familyRepository ?? FamilyRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  FamilyGroupModel? _familyGroup;
  FamilyGroupModel? get familyGroup => _familyGroup;

  String? _statusMessage;
  String? get statusMessage => _statusMessage;

  Future<void> loadFamilyGroup() async {
    _isLoading = true;
    notifyListeners();

    try {
      _familyGroup = await _familyRepository.getFamilyGroup();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeMember(String memberId) async {
    final success = await _familyRepository.removeMember(memberId);
    if (success) {
      await loadFamilyGroup();
      _statusMessage = 'Đã xóa thành viên khỏi gia đình';
      notifyListeners();
    }
    return success;
  }

  Future<String?> tryInvite(String method) async {
    try {
      final link = await _familyRepository.generateInviteLink(method);
      return link;
    } catch (e) {
      return null;
    }
  }

  Future<bool> inviteByPhone(String phone) async {
    final success = await _familyRepository.inviteByPhone(phone);
    if (success) {
      await loadFamilyGroup();
      _statusMessage = 'Đã gửi lời mời tới $phone';
      notifyListeners();
    }
    return success;
  }

  Future<void> updateGroupName(String newName) async {
    await _familyRepository.updateGroupName(newName);
    await loadFamilyGroup();
    _statusMessage = 'Đã đổi tên nhóm thành "$newName"';
    notifyListeners();
  }

  Future<void> updateCurrentUserName(String newName) async {
    await _familyRepository.updateCurrentUserName(newName);
    await loadFamilyGroup();
    _statusMessage = 'Đã cập nhật tên thành "$newName"';
    notifyListeners();
  }

  Future<void> updateCurrentUserAvatarColor(Color newColor) async {
    await _familyRepository.updateCurrentUserAvatarColor(newColor);
    await loadFamilyGroup();
    notifyListeners();
  }
}
