class PillModel {
  String orderId;
  String pillId;
  String totalMoney;
  String interior;
  String remian;
  String payedAmount;
  OptionPaymentWay optionPaymentWay;
  int stepsCounter;
  String customerName;
  PillModel({
    this.customerName = '',
    this.interior = "0.0",
    this.remian = "0.0",
    this.payedAmount="0.0",
    this.optionPaymentWay = OptionPaymentWay.atRecieve,
    this.orderId = '',
    this.pillId = '',
    this.stepsCounter = 1,
    this.totalMoney = "0.0",
  });
  Map<String, dynamic> toJson({String? orderIdd}) {
    return {
      "orderId": orderIdd ?? orderId,
      "pillId": pillId,
      "remainMoney":
          (double.parse(totalMoney) - double.parse(interior)).toString(),
      "totalMoney": totalMoney,
      "interior": interior,
      "optionPaymentWay": optionPaymentWay.index,
      "stepsCounter": stepsCounter,
      "customerName": customerName,
    };
  }

  factory PillModel.fromJson(Map<String, dynamic> json) => PillModel(
        customerName: json["customerName"] as String,
        interior: json['interior'] as String,
        optionPaymentWay:
            OptionPaymentWay.values[json['optionPaymentWay'] as int],
        orderId: json['orderId'] as String,
        pillId: json['pillId'] as String,
        stepsCounter: json['stepsCounter'] as int,
        totalMoney: json['totalMoney'] as String,
        remian:
            json['remainMoney'] != null ? json['remainMoney'] as String : "0.0",
      );
}

enum OptionPaymentWay { atRecieve, onSteps }
