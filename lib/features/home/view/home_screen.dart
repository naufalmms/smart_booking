import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_booking_apps/features/wallet/view/wallet_screen.dart';
import 'package:smart_booking_apps/features/wallet/viewmodel/wallet_viewmodel.dart';
import 'package:smart_booking_apps/features/bookings/viewmodel/bookings_viewmodel.dart';
import 'package:smart_booking_apps/features/home/viewmodel/home_viewmodel.dart';
import 'package:smart_booking_apps/features/home/widgets/dashboard_widgets.dart';
import 'package:smart_booking_apps/features/services/view/services_screen.dart';
import 'package:smart_booking_apps/features/rewards/view/rewards_screen.dart';
import 'package:smart_booking_apps/features/bookings/view/bookings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data for dashboard
    Future.microtask(() {
      Provider.of<WalletViewModel>(context, listen: false).loadData();
      Provider.of<BookingsViewModel>(context, listen: false).loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB), // Light gray background
          body: IndexedStack(
            index: viewModel.selectedIndex,
            children: [
              _buildDashboard(context),
              const WalletScreen(),
              const ServicesScreen(),
              const RewardsScreen(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: viewModel.selectedIndex,
              onTap: viewModel.setIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF1A56DB),
              unselectedItemColor: Colors.grey[400],
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  activeIcon: Icon(Icons.account_balance_wallet),
                  label: 'Wallet',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  activeIcon: Icon(Icons.calendar_today),
                  label: 'Services',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_giftcard_outlined),
                  activeIcon: Icon(Icons.card_giftcard),
                  label: 'Rewards',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your services and rewards',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF374151),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.map_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Wallet Card
            Consumer<WalletViewModel>(
              builder: (context, walletVM, _) {
                return WalletSummaryCard(
                  balances: walletVM.balances,
                  onViewDetails: () {
                    Provider.of<HomeViewModel>(
                      context,
                      listen: false,
                    ).setIndex(1);
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Active Booking
            Consumer<BookingsViewModel>(
              builder: (context, bookingsVM, _) {
                // Find first confirmed booking
                final activeBooking = bookingsVM.bookings.isNotEmpty
                    ? bookingsVM.bookings.firstWhere(
                        (b) => b.status.toLowerCase() == 'confirmed',
                        orElse: () => bookingsVM.bookings.first,
                      )
                    : null;

                if (activeBooking == null) return const SizedBox.shrink();

                return Column(
                  children: [
                    ActiveBookingCard(booking: activeBooking),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                QuickActionCard(
                  title: 'Book Service',
                  subtitle: 'Valet, wash & more',
                  icon: Icons.directions_car_outlined,
                  iconColor: Colors.blue,
                  iconBgColor: Colors.blue.shade50,
                  onTap: () {
                    Provider.of<HomeViewModel>(
                      context,
                      listen: false,
                    ).setIndex(2);
                  },
                ),
                const SizedBox(width: 16),
                QuickActionCard(
                  title: 'Rewards',
                  subtitle: 'Claim offers',
                  icon: Icons.auto_awesome_outlined,
                  iconColor: Colors.purple,
                  iconBgColor: Colors.purple.shade50,
                  onTap: () {
                    Provider.of<HomeViewModel>(
                      context,
                      listen: false,
                    ).setIndex(3);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Bookings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Bookings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingsScreen(),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Consumer<BookingsViewModel>(
              builder: (context, bookingsVM, _) {
                if (bookingsVM.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (bookingsVM.bookings.isEmpty) {
                  return const Center(child: Text('No bookings yet'));
                }
                // Show top 3
                final recentBookings = bookingsVM.bookings.take(3).toList();
                return Column(
                  children: recentBookings
                      .map((b) => RecentBookingItem(booking: b))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
