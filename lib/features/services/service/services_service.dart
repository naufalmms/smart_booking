import 'package:smart_booking_apps/core/database/database_helper.dart';
import 'package:smart_booking_apps/features/services/model/service_model.dart';

class ServicesService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<ServiceItem>> getServices() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('services');
    return maps.map((e) => ServiceItem.fromMap(e)).toList();
  }
}
