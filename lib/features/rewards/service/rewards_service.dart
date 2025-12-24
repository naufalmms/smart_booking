import 'package:smart_booking_apps/core/database/database_helper.dart';
import 'package:smart_booking_apps/features/rewards/model/reward_model.dart';

class RewardsService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<RewardItem>> getRewards() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('rewards');
    return maps.map((e) => RewardItem.fromMap(e)).toList();
  }

  Future<void> claimReward(String id) async {
    final db = await _dbHelper.database;
    await db.update(
      'rewards',
      {'is_claimed': 1, 'type': 'voucher'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
