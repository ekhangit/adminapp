class AirlineModel {
  final int id;
  final String? iata;
  final String? icao;
  final String? name;

  AirlineModel({required this.id, this.iata, this.icao, this.name});

  factory AirlineModel.fromJson(Map<String, dynamic> json) {
    return AirlineModel(
      id: json['id'] ?? 0,
      iata: json['iata'] ?? '',
      icao: json['icao'] ?? '',
      name: json['name'] ?? '',
    );
  }
}



class AirportModel {
  final int id;
  final String? iata;
  final String? icao;

  AirportModel({required this.id, this.iata, this.icao});

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      id: json['id'] ?? 0,
      iata: json['iata'] ?? '',
      icao: json['icao'] ?? '',
    );
  }
}
