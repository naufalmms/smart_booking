class Booking {
  final String id;
  final String serviceId;
  final DateTime date;
  final String time;
  final String location;
  final String status;
  final String paymentMethod;
  final double amount;
  final String currency;

  Booking({
    required this.id,
    required this.serviceId,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    required this.paymentMethod,
    required this.amount,
    required this.currency,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      serviceId: map['service_id'],
      date: DateTime.parse(map['date']),
      time: map['time'],
      location: map['location'],
      status: map['status'],
      paymentMethod: map['payment_method'],
      amount: map['amount'],
      currency: map['currency'],
    );
  }
}
