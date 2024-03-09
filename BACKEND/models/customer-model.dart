class CustomerModel {
  String id; // Add this property
  String name;
  String litre;
  String price;
  String phase;
  String startDate;
  String endDate;

  CustomerModel({
    required this.id,
    required this.name,
    required this.litre,
    required this.price,
    required this.phase,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'litre': litre,
      'price': price,
      'phase': phase,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory CustomerModel.fromMap(String id, Map<String, dynamic> map) {
    return CustomerModel(
      id: id,
      name: map['name'],
      litre: map['litre'],
      price: map['price'],
      phase: map['phase'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }
}
