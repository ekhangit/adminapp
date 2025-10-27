class AirlineModel {
  final int id;
  final String? iata;
  final String? icao;
  final String? name;
  final String? logoUrl;

  AirlineModel({
    required this.id,
    this.iata,
    this.icao,
    this.name,
    this.logoUrl,
  });

  factory AirlineModel.fromJson(Map<String, dynamic> json) {
    return AirlineModel(
      id: json['id'] ?? 0,
      iata: json['iata'] ?? '',
      icao: json['icao'] ?? '',
      name: json['name'] ?? '',
      logoUrl: json['logo_url'] ?? '',
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
