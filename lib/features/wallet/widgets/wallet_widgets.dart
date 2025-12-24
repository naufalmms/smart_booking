import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_booking_apps/features/wallet/model/wallet_model.dart';

class WalletTabSelector extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const WalletTabSelector({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab('RM', 'Wallet', Icons.account_balance_wallet_outlined),
          _buildTab('GP', 'GP Coins', Icons.monetization_on_outlined),
        ],
      ),
    );
  }

  Widget _buildTab(String id, String label, IconData icon) {
    final isSelected = selectedTab == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? const Color(0xFF1A56DB) : Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF1A56DB) : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  final String currency;
  final double amount;
  final VoidCallback onTopUp;

  const BalanceCard({
    super.key,
    required this.currency,
    required this.amount,
    required this.onTopUp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          currency == 'RM' ? 'Available Balance' : 'Token Balance',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
        ),
        const SizedBox(height: 8),
        Text(
          currency == 'RM'
              ? 'RM ${amount.toStringAsFixed(2)}'
              : '${amount.toStringAsFixed(0).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (currency == 'RM') ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onTopUp,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Top Up Wallet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class WalletStatsCard extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const WalletStatsCard({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPositive =
        transaction.type == 'topup' || transaction.type == 'reward';
    final color = isPositive ? Colors.green : Colors.red;
    final icon = _getIcon(transaction.type);
    final iconBg = _getIconBg(transaction.type);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: _getIconColor(transaction.type), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(transaction),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM yyyy').format(transaction.date),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : '-'}${transaction.currency == 'RM' ? 'RM ' : ''}${transaction.amount.toStringAsFixed(transaction.currency == 'RM' ? 2 : 0)}${transaction.currency == 'GP' ? ' GP' : ''}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.type == 'payment'
                    ? 'Booking'
                    : (transaction.type == 'topup' ? 'Topup' : 'Reward'),
                style: TextStyle(color: Colors.grey[400], fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTitle(TransactionModel t) {
    if (t.description.isNotEmpty) return t.description;
    switch (t.type) {
      case 'topup':
        return 'Wallet Top-up';
      case 'payment':
        return 'Service Payment';
      case 'reward':
        return 'Reward Earned';
      default:
        return 'Transaction';
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'topup':
        return Icons.south_west;
      case 'payment':
        return Icons.north_east;
      case 'reward':
        return Icons.south_west;
      default:
        return Icons.swap_horiz;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'topup':
        return Colors.green;
      case 'payment':
        return Colors.red;
      case 'reward':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Color _getIconBg(String type) {
    switch (type) {
      case 'topup':
        return Colors.green.withOpacity(0.1);
      case 'payment':
        return Colors.red.withOpacity(0.1);
      case 'reward':
        return Colors.orange.withOpacity(0.1);
      default:
        return Colors.blue.withOpacity(0.1);
    }
  }
}
