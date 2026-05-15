class Plans {
  String? sId;
  String? planName;
  bool? documentStatus;
  double? amountMRP;
  double? amount;
  double? billableAmount;
  String? planAmountPer;
  double? discountPercentage;
  String? durationDays;
  String? planType;
  List<String>? planFeatures;
  String? currency;
  String? currencySymbol;
  String? planIcon;
  bool isSubscribed;
  int? iV;

  Plans(
      {this.sId,
      this.planName,
      this.documentStatus,
      this.amountMRP,
      this.amount,
      this.billableAmount,
      this.planAmountPer,
      this.discountPercentage,
      this.durationDays,
      this.planType,
      this.planFeatures,
      this.currency,
      this.currencySymbol,
      this.planIcon,
      this.isSubscribed = false,
      this.iV});

  Plans.fromJson(Map<String, dynamic> json)
      : sId = json['_id'],
        planName = json['planName'],
        documentStatus = json['documentStatus'],
        amountMRP = double.parse(json['amountMRP'].toString()),
        amount = double.parse(json['amount'].toString()),
        billableAmount = double.parse(json['billableAmount'].toString()),
        planAmountPer = json['planAmountPer'],
        discountPercentage = double.parse(json['discountPercentage'].toString()),
        durationDays = json['durationDays'],
        planType = json['planType'],
        planFeatures = json['planFeatures'] != null
            ? List<String>.from(json['planFeatures'])
            : null,
        currency = json['currency'],
        isSubscribed = json['isSubscribed'] ?? false,
        currencySymbol = json['currencySymbol'],
        planIcon = json['planIcon'],
        iV = json['__v'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['planName'] = planName;
    data['documentStatus'] = documentStatus;
    data['amountMRP'] = amountMRP;
    data['amount'] = amount;
    data['billableAmount'] = billableAmount;
    data['planAmountPer'] = planAmountPer;
    data['discountPercentage'] = discountPercentage;
    data['durationDays'] = durationDays;
    data['planType'] = planType;
    data['isSubscribed'] = isSubscribed;
    data['planFeatures'] = planFeatures;
    data['currency'] = currency;
    data['currencySymbol'] = currencySymbol;
    data['planIcon'] = planIcon;
    data['__v'] = iV;
    return data;
  }
}
