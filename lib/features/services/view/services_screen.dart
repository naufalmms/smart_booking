import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:smart_booking_apps/features/bookings/model/booking_model.dart';
import 'package:smart_booking_apps/features/bookings/viewmodel/bookings_viewmodel.dart';
import 'package:smart_booking_apps/features/wallet/viewmodel/wallet_viewmodel.dart';
import 'package:smart_booking_apps/features/services/model/service_model.dart';
import 'package:smart_booking_apps/features/services/viewmodel/services_viewmodel.dart';
import 'package:smart_booking_apps/features/services/widgets/booking_dialog.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ServicesViewModel>(context, listen: false).loadServices();
      Provider.of<WalletViewModel>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Available Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              'Book services with your wallet or GP Coins',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(
            child: Consumer<ServicesViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.services.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.build_circle_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No services available',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.services.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final service = viewModel.services[index];
                    return _buildServiceCard(context, service);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, ServiceItem service) {
    final isAvailable = service.isAvailable;

    return Opacity(
      opacity: isAvailable ? 1.0 : 0.6,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isAvailable
                ? () => _showBookingDialog(context, service)
                : null,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIcon(service.iconName),
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    service.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ),
                                if (!isAvailable)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Unavailable',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              service.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            service.duration,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'RM ${service.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            '${service.priceGp} GP Coins',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context, ServiceItem service) {
    final walletVM = Provider.of<WalletViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BookingDialog(
          service: service,
          balances: walletVM.balances,
          onConfirm: (date, time, location, paymentMethod) {
            _handleBookingConfirm(
              context,
              service,
              date,
              time,
              location,
              paymentMethod,
            );
          },
        ),
      ),
    );
  }

  void _handleBookingConfirm(
    BuildContext context,
    ServiceItem service,
    DateTime date,
    String time,
    String location,
    String paymentMethod,
  ) {
    final booking = Booking(
      id: const Uuid().v4(),
      serviceId: service.id,
      date: date,
      time: time,
      location: location,
      status: 'confirmed', // Auto confirm for demo
      paymentMethod: paymentMethod,
      amount: paymentMethod == 'wallet'
          ? service.price
          : service.priceGp.toDouble(),
      currency: paymentMethod == 'wallet' ? 'RM' : 'GP',
    );

    final walletVM = Provider.of<WalletViewModel>(context, listen: false);
    final bookingsVM = Provider.of<BookingsViewModel>(context, listen: false);

    final amount = paymentMethod == 'wallet'
        ? service.price
        : service.priceGp.toDouble();
    final currency = paymentMethod == 'wallet' ? 'RM' : 'GP';

    // 1. Process Payment
    walletVM
        .makePayment(amount, currency, 'Booking: ${service.name}')
        .then((_) {
          // 2. If payment success, Add Booking
          bookingsVM.addBooking(booking).then((_) {
            Navigator.pop(context); // Close dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking Confirmed!'),
                backgroundColor: Colors.green,
              ),
            );
          });
        })
        .catchError((error) {
          Navigator.pop(context); // Close dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment Failed: ${error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        });
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'car':
        return Icons.directions_car_outlined;
      case 'droplet':
        return Icons.local_car_wash_outlined;
      case 'map-pin':
        return Icons.local_parking_outlined;
      default:
        return Icons.help_outline;
    }
  }
}
