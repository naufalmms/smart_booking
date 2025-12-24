import 'package:flutter/foundation.dart';
import 'package:smart_booking_apps/features/rewards/model/reward_model.dart';
import 'package:smart_booking_apps/features/rewards/service/rewards_service.dart';

class RewardsViewModel extends ChangeNotifier {
  final RewardsService _service = RewardsService();

  List<RewardItem> _allRewards = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _selectedTab = 'All Offers';
  String get selectedTab => _selectedTab;

  List<RewardItem> get myVouchers {
    return _allRewards
        .where((r) => r.isClaimed && r.type == 'voucher')
        .toList();
  }

  List<RewardItem> get availableOffers {
    return _allRewards.where((r) => !r.isClaimed && r.type == 'offer').where((
      r,
    ) {
      if (_selectedTab == 'All Offers') return true;
      if (_selectedTab == 'Campaigns') return r.category == 'Campaign';
      if (_selectedTab == 'Loyalty') return r.category == 'Loyalty';
      return true;
    }).toList();
  }

  Future<void> loadRewards() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allRewards = await _service.getRewards();
    } catch (e) {
      debugPrint('Error loading rewards: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  Future<void> claimReward(String id) async {
    try {
      await _service.claimReward(id);
      await loadRewards(); // Refresh
    } catch (e) {
      debugPrint('Error claiming reward: $e');
    }
  }
}
