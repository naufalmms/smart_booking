class RewardItem {
  final String id;
  final String title;
  final String description;
  final int pointsCost;
  final String category;
  final bool isClaimed;
  final DateTime? expiryDate;
  final String? tag; // 'Campaign', 'Loyalty', 'Event'
  final String? discount; // e.g. '50%', 'RM20'
  final String type; // 'voucher', 'offer'

  RewardItem({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsCost,
    required this.category,
    required this.isClaimed,
    this.expiryDate,
    this.tag,
    this.discount,
    required this.type,
  });

  factory RewardItem.fromMap(Map<String, dynamic> map) {
    return RewardItem(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      pointsCost: map['points_cost'],
      category: map['category'],
      isClaimed: map['is_claimed'] == 1,
      expiryDate: map['expiry_date'] != null
          ? DateTime.parse(map['expiry_date'])
          : null,
      tag: map['tag'],
      discount: map['discount'],
      type: map['type'] ?? 'offer',
    );
  }
}
