class WalletBalance {
  final String currency;
  final double amount;

  WalletBalance({required this.currency, required this.amount});

  factory WalletBalance.fromMap(Map<String, dynamic> map) {
    return WalletBalance(currency: map['currency'], amount: map['amount']);
  }
}

class TransactionModel {
  final String id;
  final String type; // 'topup', 'payment'
  final double amount;
  final String currency;
  final DateTime date;
  final String status; // 'completed', 'pending', 'failed'
  final String description;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.date,
    required this.status,
    required this.description,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      currency: map['currency'],
      date: DateTime.parse(map['date']),
      status: map['status'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'currency': currency,
      'date': date.toIso8601String(),
      'status': status,
      'description': description,
    };
  }
}
