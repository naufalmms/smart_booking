import 'package:smart_booking_apps/core/database/database_helper.dart';
import 'package:smart_booking_apps/features/bookings/model/booking_model.dart';

class BookingsService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Booking>> getBookings() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookings',
      orderBy: 'date DESC',
    );
    return maps.map((e) => Booking.fromMap(e)).toList();
  }

  Future<void> addBooking(Booking booking) async {
    final db = await _dbHelper.database;
    await db.insert('bookings', {
      'id': booking.id,
      'service_id': booking.serviceId,
      'date': booking.date.toIso8601String(),
      'time': booking.time,
      'location': booking.location,
      'status': booking.status,
      'payment_method': booking.paymentMethod,
      'amount': booking.amount,
      'currency': booking.currency,
    });
  }
}
