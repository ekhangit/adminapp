import 'package:get/get.dart';

import '../constant.dart';

class FlightsModel {
  final int id;
  final String flightInfo;
  final int airlineId;
  final int departureAirportId;
  final int arrivalAirportId;
  final String? flightDatetime;
  final String scheduledDepartureTime;
  final String scheduledArrivalTime;
  final String status;
  final String? std;
  final String? atd;
  final String? sta;
  final String? ata;
  final String? eta;
  final String? etd;
  final RxInt unReadCount;
  final Airline? airline;
  final Airport? departureAirport;
  final Airport? arrivalAirport;
  final Aircraft? aircraft;
  final AircraftType? aircraftType;
  final List<FlightDelay> flightDelays;
  final RxBool isFavorite;
  final int departureDelayMinutes;
  final String departureDelayColor;
  final String departureColor;
  final int arrivalDelayMinutes;
  final String arrivalDelayColor;
  final String arrivalColor;

  FlightsModel({
    required this.id,
    required this.flightInfo,
    required this.airlineId,
    required this.departureAirportId,
    required this.arrivalAirportId,
    this.flightDatetime,
    required this.scheduledDepartureTime,
    required this.scheduledArrivalTime,
    required this.status,
    this.std,
    this.atd,
    this.sta,
    this.ata,
    this.eta,
    this.etd,
    int unReadCount = 0, // Accept regular int parameter
    this.airline,
    this.departureAirport,
    this.arrivalAirport,
    this.aircraft,
    this.aircraftType,
    required this.flightDelays,
    required bool isFavorite,
    required this.departureDelayMinutes,
    required this.departureDelayColor,
    required this.departureColor,
    required this.arrivalDelayMinutes,
    required this.arrivalDelayColor,
    required this.arrivalColor,
  }) : unReadCount = RxInt(unReadCount),
       isFavorite = isFavorite.obs;

  factory FlightsModel.fromJson(Map<String, dynamic> json) {
    final delaysJson = json['flight_delays'] as List?;
    final List<FlightDelay> delays =
        (delaysJson != null && delaysJson.isNotEmpty)
            ? delaysJson.map((e) => FlightDelay.fromJson(e)).toList()
            : <FlightDelay>[];

    return FlightsModel(
      id: json['id'],
      flightInfo: json['flight_info'],
      airlineId: json['airline_id'],
      departureAirportId: json['departure_airport_id'],
      arrivalAirportId: json['arrival_airport_id'],
      flightDatetime: json['flight_datetime'] ?? '',
      scheduledDepartureTime: json['scheduled_departure_time'],
      scheduledArrivalTime: json['scheduled_arrival_time'],
      status: json['status'],
      std: json['std'] ?? '',
      atd: json['atd'] ?? '',
      sta: json['sta'] ?? '',
      ata: json['ata'] ?? '',
      eta: json['eta'] ?? '',
      etd: json['etd'] ?? '',
      airline:
          json['airline'] != null ? Airline.fromJson(json['airline']) : null,
      departureAirport:
          json['departure_airport'] != null
              ? Airport.fromJson(json['departure_airport'])
              : null,
      arrivalAirport:
          json['arrival_airport'] != null
              ? Airport.fromJson(json['arrival_airport'])
              : null,
      aircraft:
          json['aircraft'] != null ? Aircraft.fromJson(json['aircraft']) : null,
      aircraftType:
          json['aircraft_type'] != null ? AircraftType.fromJson(json['aircraft_type']) : null,
      flightDelays: delays,
      isFavorite: (json['is_favorite'] ?? false),
      departureDelayMinutes: _parseDelay(json['departure_delay']),
      departureDelayColor: json['departure_delay_color'] ?? '',
      departureColor: json['departure_color'] ?? '',
      arrivalDelayMinutes: _parseDelay(json['arrival_delay']),
      arrivalDelayColor: json['arrival_delay_color'] ?? '',
      arrivalColor: json['arrival_color'] ?? '',
    );
  }

  bool get isDeparture => ['GND'].contains(departureAirport?.iataCode);

  bool get flightDelayStatus => flightDelays.isNotEmpty;

  String get formattedDepartureDelay {
    final minutes = departureDelayMinutes.abs(); // Handle negative values
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return "${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}";
  }

  String get formattedArrivalDelay {
    final minutes = arrivalDelayMinutes.abs(); // Handle negative values
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return "${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}";
  }

  static int _parseDelay(dynamic delayString) {
    if (delayString is! String || delayString.isEmpty) return 0;

    try {
      final parts = delayString.split(':');
      if (parts.length == 2) {
        final hours = int.tryParse(parts[0]) ?? 0;
        final minutes = int.tryParse(parts[1]) ?? 0;
        return hours * 60 + minutes;
      }
    } catch (_) {}

    return 0;
  }
}

class Airline {
  final int id;
  final String picture;
  final String mobilePicture;

  Airline({
    required this.id,
    required this.picture,
    required this.mobilePicture,
  });

  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(
      id: json['id'],

      picture: "$apiUrl/storage/airline_img/${json['picture'] ?? ''}",
      mobilePicture: "$apiUrl/storage/airline_img/${json['mobile_logo'] ?? ''}",
    );
  }
}

class Airport {
  final int id;
  final String iataCode;

  Airport({required this.id, required this.iataCode});

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(id: json['id'], iataCode: json['iata_code'] ?? '');
  }
}

class Aircraft {
  final int id;
  final String name;
  final int aircraftTypeId;

  Aircraft({required this.id, required this.name, required this.aircraftTypeId});

  factory Aircraft.fromJson(Map<String, dynamic> json) {
    return Aircraft(
      id: json['id'],
      name: json['name'] ?? '',
      aircraftTypeId: json['aircraft_type_id'] ?? 0,
    );
  }
}

class AircraftType {
  final int id;
  final String? icao;

  AircraftType({required this.id,  this.icao});

  factory AircraftType.fromJson(Map<String, dynamic> json) {
    return AircraftType(id: json['id'], icao: json['icao'] ?? '');
  }
}

class FlightDelay {
  final int id;
  final int flightId;
  final String delayType;
  final String delayCode;
  final String delayDate;

  FlightDelay({
    required this.id,
    required this.flightId,
    required this.delayType,
    required this.delayCode,
    required this.delayDate,
  });

  factory FlightDelay.fromJson(Map<String, dynamic> json) {
    return FlightDelay(
      id: json['id'],
      flightId: json['flight_id'],
      delayType: json['delay_type'] ?? '',
      delayCode: json['delay_code'] ?? '',
      delayDate: json['delay_date'] ?? '',
    );
  }

  factory FlightDelay.empty() => FlightDelay(
    id: 0,
    flightId: 0,
    delayType: '-',
    delayCode: '-',
    delayDate: '-',
  );
}
