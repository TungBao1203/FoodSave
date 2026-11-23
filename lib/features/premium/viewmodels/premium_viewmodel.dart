import 'package:flutter/foundation.dart';
import '../../../data/repositories/family_repository.dart';

enum SubscriptionPlan { monthly, yearly }

class PremiumViewModel extends ChangeNotifier {
  final IFamilyRepository _familyRepository;

  PremiumViewModel({IFamilyRepository? familyRepository})
      : _familyRepository = familyRepository ?? FamilyRepository();

  SubscriptionPlan _selectedPlan = SubscriptionPlan.yearly;
  SubscriptionPlan get selectedPlan => _selectedPlan;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isUpgraded = false;
  bool get isUpgraded => _isUpgraded;

  void selectPlan(SubscriptionPlan plan) {
    _selectedPlan = plan;
    notifyListeners();
  }

  Future<bool> upgrade() async {
    _isProcessing = true;
    notifyListeners();

    try {
      await _familyRepository.upgradeToPremium();
      _isUpgraded = true;
      return true;
    } catch (e) {
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  String get ctaButtonText {
    return _selectedPlan == SubscriptionPlan.yearly
        ? 'Nâng cấp Premium theo năm'
        : 'Nâng cấp Premium theo tháng';
  }

  String get pricingSubtext {
    return _selectedPlan == SubscriptionPlan.yearly
        ? '348.000đ/năm • Có thể hủy bất kỳ lúc nào trước kỳ gia hạn tiếp theo'
        : '59.000đ/tháng • Tự động gia hạn hàng tháng';
  }
}
