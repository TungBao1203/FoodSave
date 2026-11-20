import 'package:flutter/foundation.dart';
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
}
