import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:smart_booking_apps/features/bookings/model/booking_model.dart';
import 'package:smart_booking_apps/features/bookings/viewmodel/bookings_viewmodel.dart';
import 'package:smart_booking_apps/features/bookings/widgets/booking_detail_dialog.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFilterVisible = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<BookingsViewModel>(context, listen: false).loadBookings(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Bookings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Consumer<BookingsViewModel>(
              builder: (context, viewModel, _) {
                return Text(
                  '${viewModel.bookings.length} total bookings',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isFilterVisible = !_isFilterVisible;
              });
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search bookings...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (value) {
                    Provider.of<BookingsViewModel>(
                      context,
                      listen: false,
                    ).searchBookings(value);
                  },
                ),
                const SizedBox(height: 16),

                if (_isFilterVisible)
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      // Filter Chips
                      const Text(
                        'Filter by Status',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Consumer<BookingsViewModel>(
                          builder: (context, viewModel, _) {
                            return Row(
                              children: [
                                _buildFilterChip('All', viewModel),
                                _buildFilterChip('Pending', viewModel),
                                _buildFilterChip('Confirmed', viewModel),
                                _buildFilterChip('Completed', viewModel),
                                _buildFilterChip('Cancelled', viewModel),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Bookings List
          Expanded(
            child: Consumer<BookingsViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.bookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No bookings found',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.bookings.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final booking = viewModel.bookings[index];
                    return _buildBookingCard(context, booking);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, BookingsViewModel viewModel) {
    final isSelected = viewModel.currentFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          viewModel.filterBookings(label);
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF1A56DB),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getServiceName(booking.serviceId),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      booking.status,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    booking.status.toLowerCase(),
                    style: TextStyle(
                      color: _getStatusColor(booking.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'ID: ${booking.id.length >= 8 ? booking.id.substring(0, 8) : booking.id}',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    Icons.calendar_today_outlined,
                    DateFormat('yyyy-MM-dd').format(booking.date),
                  ),
                ),
                Expanded(child: _buildInfoRow(Icons.access_time, booking.time)),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on_outlined, booking.location),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.payment_outlined,
              'Paid with ${booking.currency} ${booking.amount.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => BookingDetailDialog(booking: booking),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: booking.status.toLowerCase() == 'completed'
                      ? Colors.grey[200]
                      : const Color(0xFF1A56DB),
                  foregroundColor: booking.status.toLowerCase() == 'completed'
                      ? Colors.grey[700]
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getServiceName(String id) {
    switch (id) {
      case 'valet':
        return 'Premium Valet Service';
      case 'carwash':
        return 'Express Car Wash';
      case 'bay_reservation':
        return 'Premium Bay Reservation';
      default:
        return 'Service';
    }
  }
}
