class ServiceItem {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final double price;
  final int priceGp;
  final String currency;
  final String duration;
  final bool isAvailable;

  ServiceItem({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.price,
    required this.priceGp,
    required this.currency,
    required this.duration,
    this.isAvailable = true,
  });

  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    return ServiceItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      iconName: map['icon_name'],
      price: map['price'],
      priceGp: map['price_gp'] ?? 0,
      currency: map['currency'],
      duration: map['duration'] ?? '',
      isAvailable: map['is_available'] == 1,
    );
  }
}
