import 'package:flutter/foundation.dart';
import 'package:smart_booking_apps/features/services/model/service_model.dart';
import 'package:smart_booking_apps/features/services/service/services_service.dart';

class ServicesViewModel extends ChangeNotifier {
  final ServicesService _service = ServicesService();

  List<ServiceItem> _services = [];
  List<ServiceItem> get services => _services;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadServices() async {
    _isLoading = true;
    notifyListeners();

    try {
      _services = await _service.getServices();
    } catch (e) {
      debugPrint('Error loading services: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
