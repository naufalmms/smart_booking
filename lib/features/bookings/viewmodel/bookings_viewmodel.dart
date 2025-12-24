import 'package:flutter/foundation.dart';
import 'package:smart_booking_apps/features/bookings/model/booking_model.dart';
import 'package:smart_booking_apps/features/bookings/service/bookings_service.dart';

class BookingsViewModel extends ChangeNotifier {
  final BookingsService _service = BookingsService();

  List<Booking> _allBookings = [];
  List<Booking> _filteredBookings = [];
  List<Booking> get bookings => _filteredBookings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _currentFilter = 'All';
  String get currentFilter => _currentFilter;

  String _searchQuery = '';

  Future<void> loadBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allBookings = await _service.getBookings();
      _applyFilter();
    } catch (e) {
      debugPrint('Error loading bookings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBooking(Booking booking) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.addBooking(booking);
      await loadBookings();
    } catch (e) {
      debugPrint('Error adding booking: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterBookings(String status) {
    _currentFilter = status;
    _applyFilter();
    notifyListeners();
  }

  void searchBookings(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    _filteredBookings = _allBookings.where((booking) {
      // Filter by status
      if (_currentFilter != 'All' &&
          booking.status.toLowerCase() != _currentFilter.toLowerCase()) {
        return false;
      }

      // Filter by search query (Service Name or ID)
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesId = booking.id.toLowerCase().contains(query);
        // Note: In a real app, we'd map serviceId to serviceName here or in the model
        final matchesService = booking.serviceId.toLowerCase().contains(query);
        return matchesId || matchesService;
      }

      return true;
    }).toList();
  }
}
