class FlightNoModel {
  final int id;
  final String flightInfo;

  FlightNoModel({required this.id, required this.flightInfo});

  factory FlightNoModel.fromJson(Map<String, dynamic> json) {
    return FlightNoModel(
      id: json['id'] ?? json['flight_id'] ?? 0,
      flightInfo: json['flight_info'] ?? '',
    );
  }
}
