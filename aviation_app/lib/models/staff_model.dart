import 'package:aviation_app/models/flight_model.dart';

class StaffModel {
  final int id;
  final String name;
  final String? avatar;
  final int airportId;
  final Airport airport;

  StaffModel({
    required this.id,
    required this.name,
    this.avatar,
    required this.airportId,
    required this.airport,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      airportId: json['airport_id'],
      airport: Airport.fromJson(json['airport']),
    );
  }
}
