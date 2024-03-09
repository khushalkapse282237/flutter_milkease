class MilkProductionModel {
  int noOfCows;
  double totalMilk;
  double fat;
  String phase;
  String date;

  MilkProductionModel({
    required this.noOfCows,
    required this.totalMilk,
    required this.fat,
    required this.phase,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'noOfCows': noOfCows,
      'totalMilk': totalMilk,
      'fat': fat,
      'phase': phase,
      'date': date,
    };
  }

  factory MilkProductionModel.fromMap(Map<String, dynamic> map) {
    return MilkProductionModel(
      noOfCows: map['noOfCows'],
      totalMilk: map['totalMilk'],
      fat: map['fat'],
      phase: map['phase'],
      date: map['date'],
    );
  }
}
