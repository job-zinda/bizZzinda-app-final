class WalletTransaction {
  final String id;
  final String userId;
  final double amount;
  final String source;
  final String message;
  final String transactionType;
  final String status;
  final DateTime createdAt;

  WalletTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.source,
    required this.message,
    required this.transactionType,
    required this.status,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      source: json['source'] ?? '',
      transactionType: json['transactionType'] ?? '',
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
