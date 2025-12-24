import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_booking_apps/features/home/view/home_screen.dart';
import 'package:smart_booking_apps/features/home/viewmodel/home_viewmodel.dart';
import 'package:smart_booking_apps/features/wallet/viewmodel/wallet_viewmodel.dart';
import 'package:smart_booking_apps/features/services/viewmodel/services_viewmodel.dart';
import 'package:smart_booking_apps/features/rewards/viewmodel/rewards_viewmodel.dart';
import 'package:smart_booking_apps/features/bookings/viewmodel/bookings_viewmodel.dart';

void main() {
  runApp(const SmartBookingApp());
}

class SmartBookingApp extends StatelessWidget {
  const SmartBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => WalletViewModel()),
        ChangeNotifierProvider(create: (_) => ServicesViewModel()),
        ChangeNotifierProvider(create: (_) => RewardsViewModel()),
        ChangeNotifierProvider(create: (_) => BookingsViewModel()),
      ],
      child: MaterialApp(
        title: 'Smart Booking',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
