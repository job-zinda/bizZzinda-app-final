class CoursePurchaseModel {
  final String? orderId;
  final String? paymentId;
  final String? paymentStatus;
  final int? amount;

  CoursePurchaseModel({this.orderId, this.paymentId, this.paymentStatus, this.amount});

  factory CoursePurchaseModel.fromJson(Map<String, dynamic> json) {
    return CoursePurchaseModel(
      orderId: json['orderId'] as String?,
      paymentId: json['paymentId'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      amount: json['amount'] as int?,
    );
  }
}
