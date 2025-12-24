import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_booking_apps/features/rewards/viewmodel/rewards_viewmodel.dart';
import 'package:smart_booking_apps/features/rewards/widgets/rewards_widgets.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<RewardsViewModel>(context, listen: false).loadRewards(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Consumer<RewardsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
                  decoration: const BoxDecoration(
                    color: Color(0xFF9333EA), // Purple
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rewards Center',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Claim exclusive offers and rewards',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tabs
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _buildTab('All Offers', viewModel),
                            _buildTab('Campaigns', viewModel),
                            _buildTab('Loyalty', viewModel),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // My Vouchers
                if (viewModel.myVouchers.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Text(
                      'My Vouchers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.myVouchers.length,
                    itemBuilder: (context, index) {
                      return VoucherCard(voucher: viewModel.myVouchers[index]);
                    },
                  ),
                ],

                // More Offers
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Text(
                    'More Offers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),

                if (viewModel.availableOffers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No offers available',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.availableOffers.length,
                    itemBuilder: (context, index) {
                      final offer = viewModel.availableOffers[index];
                      return OfferCard(
                        offer: offer,
                        onClaim: () => viewModel.claimReward(offer.id),
                      );
                    },
                  ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(String label, RewardsViewModel viewModel) {
    final isSelected = viewModel.selectedTab == label;

    // Determine colors based on label
    Color selectedBgColor = const Color(0xFFE9D5FF); // Default Light Purple
    Color selectedTextColor = const Color(0xFF9333EA); // Default Purple

    if (label == 'Loyalty') {
      selectedBgColor = const Color(0xFFFEF3C7); // Light Yellow
      selectedTextColor = const Color(0xFFD97706); // Dark Yellow/Orange
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => viewModel.setTab(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? selectedBgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? selectedTextColor : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
