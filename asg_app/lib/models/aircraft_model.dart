class AircraftTypeModel {
  final int id;
  final String? name;
  final String? iataName;
  final String? icao;

  AircraftTypeModel({required this.id, this.name, this.iataName, this.icao});

  factory AircraftTypeModel.fromJson(Map<String, dynamic> json) {
    return AircraftTypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      iataName: json['iata_name'] ?? '',
      icao: json['icao'] ?? '',
    );
  }
}

class AircraftRegModel {
  final int id;
  final String? name;
  final String? mvtName;

  AircraftRegModel({required this.id, this.name, this.mvtName});

  factory AircraftRegModel.fromJson(Map<String, dynamic> json) {
    return AircraftRegModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      mvtName: json['mvt_name'] ?? '',
    );
  }
}
