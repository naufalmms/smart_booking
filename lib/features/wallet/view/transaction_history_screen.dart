import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_booking_apps/features/wallet/viewmodel/wallet_viewmodel.dart';
import 'package:smart_booking_apps/features/wallet/widgets/wallet_widgets.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFilterVisible = false;

  @override
  void initState() {
    super.initState();
    // Reset filters when entering screen
    Future.microtask(() {
      final viewModel = Provider.of<WalletViewModel>(context, listen: false);
      viewModel.filterTransactions(type: 'All', status: 'All', query: '');
    });
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
              'Transaction History',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Consumer<WalletViewModel>(
              builder: (context, viewModel, _) {
                return Text(
                  '${viewModel.transactions.length} transactions',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
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
      body: Consumer<WalletViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              if (_isFilterVisible)
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
                          hintText: 'Search transactions...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          viewModel.filterTransactions(query: value);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Filter Sections
                      // Filter Sections
                      _buildFilterSection(
                        'Transaction Type',
                        ['All', 'Top Up', 'Payment', 'Reward'],
                        viewModel.filterType,
                        (val) => viewModel.filterTransactions(type: val),
                      ),

                      const SizedBox(height: 12),

                      _buildFilterSection(
                        'Status',
                        ['All', 'Completed', 'Pending', 'Failed'],
                        viewModel.filterStatus,
                        (val) => viewModel.filterTransactions(status: val),
                      ),
                    ],
                  ),
                ),

              // Flow Stats
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildFlowCard(
                      'Total RM Flow',
                      '+RM ${viewModel.totalRmFlow.toStringAsFixed(2)}',
                      Colors.green.shade50,
                      Colors.green,
                    ),
                    const SizedBox(width: 16),
                    _buildFlowCard(
                      'Total GP Flow',
                      '${viewModel.totalGpFlow.toStringAsFixed(0)} GP',
                      Colors.orange.shade50,
                      Colors
                          .red, // Using red as per design image for GP? Or maybe orange. Image shows red text for GP Flow.
                    ),
                  ],
                ),
              ),

              // List
              Expanded(
                child: viewModel.transactions.isEmpty
                    ? Center(
                        child: Text(
                          'No transactions found',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: viewModel.transactions.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return TransactionItem(
                            transaction: viewModel.transactions[index],
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((option) {
              final isSelected = option == selectedValue;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) onSelected(option);
                  },
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFF1A56DB),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade300,
                    ),
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFlowCard(
    String label,
    String amount,
    Color bgColor,
    Color textColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: bgColor.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
