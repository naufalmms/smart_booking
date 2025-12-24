import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_booking_apps/features/wallet/viewmodel/wallet_viewmodel.dart';
import 'package:smart_booking_apps/features/wallet/widgets/wallet_widgets.dart';
// import 'package:smart_booking_apps/features/wallet/view/transaction_history_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<WalletViewModel>(context, listen: false).loadData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Consumer<WalletViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final isRm = viewModel.selectedTab == 'RM';
          final recentTransactions = viewModel.recentTransactions
              .take(5)
              .toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Section (Blue Background)
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A56DB),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'My Wallet',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         const TransactionHistoryScreen(),
                              //   ),
                              // );
                            },
                            icon: const Icon(Icons.history, size: 16),
                            label: const Text('All Transactions'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      WalletTabSelector(
                        selectedTab: viewModel.selectedTab,
                        onTabSelected: viewModel.setTab,
                      ),
                      const SizedBox(height: 32),
                      BalanceCard(
                        currency: viewModel.selectedTab,
                        amount: viewModel.currentBalance,
                        onTopUp: () => _showTopUpDialog(context, viewModel),
                      ),
                    ],
                  ),
                ),

                // Stats Cards
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      WalletStatsCard(
                        label: 'Earned',
                        amount: isRm
                            ? 'RM ${viewModel.earnedAmount.toStringAsFixed(2)}'
                            : '${viewModel.earnedAmount.toStringAsFixed(0)} GP',
                        icon: Icons.trending_up,
                        iconColor: Colors.green,
                        iconBgColor: Colors.green.withOpacity(0.1),
                      ),
                      const SizedBox(width: 16),
                      WalletStatsCard(
                        label: 'Spent',
                        amount: isRm
                            ? 'RM ${viewModel.spentAmount.toStringAsFixed(2)}'
                            : '${viewModel.spentAmount.toStringAsFixed(0)} GP',
                        icon: Icons.trending_down,
                        iconColor: Colors.red,
                        iconBgColor: Colors.red.withOpacity(0.1),
                      ),
                    ],
                  ),
                ),

                // Transaction History
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transaction History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         const TransactionHistoryScreen(),
                              //   ),
                              // );
                            },
                            child: const Text('Filter'),
                          ),
                        ],
                      ),
                      if (recentTransactions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'No recent transactions',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        )
                      else
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recentTransactions.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return TransactionItem(
                              transaction: recentTransactions[index],
                            );
                          },
                        ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showTopUpDialog(BuildContext context, WalletViewModel viewModel) {
    final TextEditingController amountController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Up Wallet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (RM)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixText: 'RM ',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final amount = double.tryParse(amountController.text);
                  if (amount != null && amount > 0) {
                    try {
                      await viewModel.topUp(amount, 'RM', 'Online Banking');
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Top Up of RM ${amount.toStringAsFixed(2)} Successful!',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Top Up Failed: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A56DB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Confirm Top Up'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
