class DetailedCustomerInfoModel {
  String date;
  String litre;
  String cost;
  String phase;

  DetailedCustomerInfoModel({
    required this.date,
    required this.litre,
    required this.cost,
    required this.phase,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'litre': litre,
      'cost': cost,
      'phase': phase,
    };
  }

  factory DetailedCustomerInfoModel.fromMap(Map<String, dynamic> map) {
    return DetailedCustomerInfoModel(
      date: map['date'],
      litre: map['litre'],
      cost: map['cost'],
      phase: map['phase'],
    );
  }
}
