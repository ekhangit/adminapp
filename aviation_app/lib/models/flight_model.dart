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
  final int chatsCount;
  final int unseenChatsCount;
  final Airline? airline;
  final Airport departureAirport;
  final Airport arrivalAirport;
  final Aircraft? aircraft;
  final List<FlightDelay> flightDelays;
  final bool isFavorite;
  final int departureDelayMinutes;
  final String departureDelayColor;
  final int arrivalDelayMinutes;
  final String arrivalDelayColor;

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
    required this.std,
    required this.atd,
    required this.sta,
    this.ata,
    required this.chatsCount,
    required this.unseenChatsCount,
    this.airline,
    required this.departureAirport,
    required this.arrivalAirport,
    this.aircraft,
    required this.flightDelays,
    required this.isFavorite,
    required this.departureDelayMinutes,
    required this.departureDelayColor,
    required this.arrivalDelayMinutes,
    required this.arrivalDelayColor,
  });

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
      chatsCount: json['chats_count'],
      unseenChatsCount: json['unseen_chats_count'],
      airline:
          json['airline'] != null ? Airline.fromJson(json['airline']) : null,
      departureAirport: Airport.fromJson(json['departure_airport']),
      arrivalAirport: Airport.fromJson(json['arrival_airport']),
      aircraft:
          json['aircraft'] != null ? Aircraft.fromJson(json['aircraft']) : null,
      flightDelays: delays,
      isFavorite: json['is_favorite'] ?? false,
      departureDelayMinutes: json['departure_delay_minutes'] ?? 0,
      departureDelayColor: json['departure_delay_color'] ?? 'green',
      arrivalDelayMinutes: json['arrival_delay_minutes'] ?? 0,
      arrivalDelayColor: json['arrival_delay_color'] ?? 'green',
    );
  }

  bool get isDeparture =>
      ['FRA', 'MUC', 'DUS', 'HAM', 'STR'].contains(departureAirport.iataCode);

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
}

class Airline {
  final int id;
  final String picture;

  Airline({required this.id, required this.picture});

  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(
      id: json['id'],

      picture: "$apiUrl/storage/airline_img/${json['picture'] ?? ''}",
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
  final AircraftType? aircraftType;

  Aircraft({required this.id, required this.name, this.aircraftType});

  factory Aircraft.fromJson(Map<String, dynamic> json) {
    return Aircraft(
      id: json['id'],
      name: json['name'] ?? '',
      aircraftType:
          json['aircraft_type'] != null
              ? AircraftType.fromJson(json['aircraft_type'])
              : null,
    );
  }
}

class AircraftType {
  final int id;
  final String icao;

  AircraftType({required this.id, required this.icao});

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
