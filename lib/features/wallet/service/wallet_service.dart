import 'package:uuid/uuid.dart';
import 'package:smart_booking_apps/core/database/database_helper.dart';
import 'package:smart_booking_apps/features/wallet/model/wallet_model.dart';

class WalletService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Uuid _uuid = const Uuid();

  Future<List<WalletBalance>> getBalances() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('wallet_balance');
    return maps.map((e) => WalletBalance.fromMap(e)).toList();
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );
    return maps.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<void> topUp(double amount, String currency, String method) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      // 1. Update Balance
      final List<Map<String, dynamic>> balanceMaps = await txn.query(
        'wallet_balance',
        where: 'currency = ?',
        whereArgs: [currency],
      );

      if (balanceMaps.isNotEmpty) {
        double currentAmount = balanceMaps.first['amount'];
        await txn.update(
          'wallet_balance',
          {'amount': currentAmount + amount},
          where: 'currency = ?',
          whereArgs: [currency],
        );
      } else {
        await txn.insert('wallet_balance', {
          'currency': currency,
          'amount': amount,
        });
      }

      // 2. Add Transaction Record
      final newTransaction = TransactionModel(
        id: _uuid.v4(),
        type: 'topup',
        amount: amount,
        currency: currency,
        date: DateTime.now(),
        status: 'completed',
        description: 'Top Up via $method',
      );

      await txn.insert('transactions', newTransaction.toMap());
    });
  }

  Future<void> deductBalance(
    double amount,
    String currency,
    String description,
  ) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      // 1. Check & Update Balance
      final List<Map<String, dynamic>> balanceMaps = await txn.query(
        'wallet_balance',
        where: 'currency = ?',
        whereArgs: [currency],
      );

      if (balanceMaps.isNotEmpty) {
        double currentAmount = balanceMaps.first['amount'];
        if (currentAmount < amount) {
          throw Exception('Insufficient balance');
        }

        await txn.update(
          'wallet_balance',
          {'amount': currentAmount - amount},
          where: 'currency = ?',
          whereArgs: [currency],
        );
      } else {
        throw Exception('Wallet not found');
      }

      // 2. Add Transaction Record
      final newTransaction = TransactionModel(
        id: _uuid.v4(),
        type: 'payment',
        amount: amount,
        currency: currency,
        date: DateTime.now(),
        status: 'completed',
        description: description,
      );

      await txn.insert('transactions', newTransaction.toMap());
    });
  }
}
