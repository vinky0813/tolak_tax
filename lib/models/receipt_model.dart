class Receipt {
  final String title;
  final DateTime date;
  final double amount;
  final String category;

  Receipt({
    required this.title,
    required this.date,
    required this.amount,
    required this.category,
  });

  /// Factory to create a Receipt from a Map (e.g., from JSON or raw list)
  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      title: map['title'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] ?? 'uncategorized',
    );
  }

  /// Convert a Receipt instance to a Map (e.g., for saving or API use)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'amount': amount,
      'category': category,
    };
  }
}
