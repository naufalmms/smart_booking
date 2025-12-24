import 'package:flutter/foundation.dart';
import 'package:smart_booking_apps/features/wallet/model/wallet_model.dart';
import 'package:smart_booking_apps/features/wallet/service/wallet_service.dart';

class WalletViewModel extends ChangeNotifier {
  final WalletService _walletService = WalletService();

  List<WalletBalance> _balances = [];
  List<WalletBalance> get balances => _balances;

  List<TransactionModel> _allTransactions = [];
  List<TransactionModel> _filteredTransactions = [];
  List<TransactionModel> get transactions => _filteredTransactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Tab Selection: 'RM' or 'GP'
  String _selectedTab = 'RM';
  String get selectedTab => _selectedTab;

  // Filter State
  String _filterType = 'All';
  String get filterType => _filterType;
  String _filterStatus = 'All';
  String get filterStatus => _filterStatus;
  String _searchQuery = '';

  // Getters for Stats
  double get earnedAmount {
    return _allTransactions
        .where(
          (t) =>
              t.currency == _selectedTab &&
              (t.type == 'topup' || t.type == 'reward') &&
              t.status == 'completed',
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get spentAmount {
    return _allTransactions
        .where(
          (t) =>
              t.currency == _selectedTab &&
              t.type == 'payment' &&
              t.status == 'completed',
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get currentBalance {
    final balance = _balances.firstWhere(
      (b) => b.currency == _selectedTab,
      orElse: () => WalletBalance(currency: _selectedTab, amount: 0),
    );
    return balance.amount;
  }

  // Getters for Flow Stats (All Time)
  double get totalRmFlow {
    return _allTransactions
        .where((t) => t.currency == 'RM' && t.status == 'completed')
        .fold(
          0.0,
          (sum, t) => sum + (t.type == 'payment' ? -t.amount : t.amount),
        );
  }

  double get totalGpFlow {
    return _allTransactions
        .where((t) => t.currency == 'GP' && t.status == 'completed')
        .fold(
          0.0,
          (sum, t) => sum + (t.type == 'payment' ? -t.amount : t.amount),
        );
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _walletService.getBalances(),
        _walletService.getTransactions(),
      ]);

      _balances = results[0] as List<WalletBalance>;
      _allTransactions = results[1] as List<TransactionModel>;
      _applyFilter();
    } catch (e) {
      debugPrint('Error loading wallet data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void filterTransactions({String? type, String? status, String? query}) {
    if (type != null) _filterType = type;
    if (status != null) _filterStatus = status;
    if (query != null) _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    _filteredTransactions = _allTransactions.where((t) {
      bool matchesType =
          _filterType == 'All' ||
          (_filterType == 'Top Up' && t.type == 'topup') ||
          (_filterType == 'Payment' && t.type == 'payment') ||
          (_filterType == 'Reward' && t.type == 'reward');

      bool matchesStatus =
          _filterStatus == 'All' ||
          t.status.toLowerCase() == _filterStatus.toLowerCase();

      bool matchesQuery =
          _searchQuery.isEmpty ||
          t.description.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesType && matchesStatus && matchesQuery;
    }).toList();

    // Sort by date desc
    _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
  }

  // Helper for Main Screen to get recent transactions for selected tab
  List<TransactionModel> get recentTransactions {
    return _allTransactions.where((t) => t.currency == _selectedTab).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> topUp(double amount, String currency, String method) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _walletService.topUp(amount, currency, method);
      await loadData();
    } catch (e) {
      debugPrint('Error processing top up: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> makePayment(
    double amount,
    String currency,
    String description,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _walletService.deductBalance(amount, currency, description);
      await loadData();
    } catch (e) {
      debugPrint('Error processing payment: $e');
      rethrow; // Allow UI to handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
