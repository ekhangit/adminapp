class FlightDetailModel {
  final BasicDetails basicDetails;
  final Airport departureAirport;
  final Airport arrivalAirport;
  final Aircraft aircraft;
  final Capacity capacity;
  final ActualPax actualPax;
  // final String inboundFlight;
  // final String outboundFlight;
  // final FlightMessages messages;

  FlightDetailModel({
    required this.basicDetails,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.aircraft,
    required this.capacity,
    required this.actualPax,
    // required this.inboundFlight,
    // required this.outboundFlight,
    // required this.messages,
  });

  factory FlightDetailModel.fromJson(Map<String, dynamic> json) {
    final info = json['flight_info'];
    return FlightDetailModel(
      basicDetails: BasicDetails.fromJson(info['basic_details']),
      departureAirport: Airport.fromJson(info['departure_airport']),
      arrivalAirport: Airport.fromJson(info['arrival_airport']),
      aircraft: Aircraft.fromJson(info['aircraft']),
      capacity: Capacity.fromJson(info['capacity']),
      actualPax: ActualPax.fromJson(info['actual_pax']),
      // inboundFlight: info['inbound_flight'] ?? '',
      // outboundFlight: info['outbound_flight'] ?? '',
      // messages: FlightMessages.fromJson(json['messages']

      // ),
    );
  }
}

class BasicDetails {
  final int id;
  final String flightInfo;
  final String std;
  final String atd;
  final String sta;
  final String ata;
  final String date;
  final String? callSign;
  final String? gate;
  final String? pos;
  final String? beggageBelt;

  BasicDetails({
    required this.id,
    required this.flightInfo,
    required this.std,
    required this.atd,
    required this.sta,
    required this.ata,
    required this.date,
    this.callSign,
    this.gate,
    this.pos,
    this.beggageBelt,
  });

  factory BasicDetails.fromJson(Map<String, dynamic> json) => BasicDetails(
    id: json['id'],
    flightInfo: json['flight_info'],
    std: json['std'],
    atd: json['atd'],
    sta: json['sta'],
    ata: json['ata'],
    date: json['date'],
    callSign: json['call_sign'],
    gate: json['gate'],
    pos: json['pos'],
    beggageBelt: json['beggage_belt'],
  );
}

class Airport {
  final int id;
  final String iataCode;

  Airport({required this.id, required this.iataCode});

  factory Airport.fromJson(Map<String, dynamic> json) =>
      Airport(id: json['id'], iataCode: json['iata_code']);
}

class Aircraft {
  final int id;
  final String name;
  final AircraftType aircraftType;

  Aircraft({required this.id, required this.name, required this.aircraftType});

  factory Aircraft.fromJson(Map<String, dynamic> json) => Aircraft(
    id: json['id'],
    name: json['name'],
    aircraftType: AircraftType.fromJson(json['aircraft_type']),
  );
}

class AircraftType {
  final int id;
  final String icao;

  AircraftType({required this.id, required this.icao});

  factory AircraftType.fromJson(Map<String, dynamic> json) =>
      AircraftType(id: json['id'], icao: json['icao']);
}

class Capacity {
  final String? f;
  final String? j;
  final String? c;
  final String? s;
  final String? w;
  final String? y;
  final String? m;

  Capacity({this.f, this.j, this.c, this.s, this.w, this.y, this.m});

  factory Capacity.fromJson(Map<String, dynamic> json) => Capacity(
    f: json['F'],
    j: json['J'],
    c: json['C'],
    s: json['S'],
    w: json['W'],
    y: json['Y'],
    m: json['M'],
  );
}

class ActualPax {
  final String? paxA;
  final String? paxC;
  final String? paxW;
  final String? paxY;
  final String? paxInf;
  final String? paxJmp;

  ActualPax({
    this.paxA,
    this.paxC,
    this.paxW,
    this.paxY,
    this.paxInf,
    this.paxJmp,
  });

  factory ActualPax.fromJson(Map<String, dynamic> json) => ActualPax(
    paxA: json['pax_a_actual'] ?? '',
    paxC: json['pax_c_actual'] ?? '',
    paxW: json['pax_w_actual'] ?? '',
    paxY: json['pax_y_actual'] ?? '',
    paxInf: json['pax_inf_actual'] ?? '',
    paxJmp: json['pax_jmp_actual'] ?? '',
  );
}

class FlightMessages {
  final List<MessageData> mvtDeparture;
  final List<MessageData> mvtArrival;
  final List<MessageData> ldm;
  final List<MessageData> lir;
  final List<MessageData> lds;
  final List<MessageData> cpm;
  final List<MessageData> psm;
  final List<MessageData> ptm;

  FlightMessages({
    required this.mvtDeparture,
    required this.mvtArrival,
    required this.ldm,
    required this.lir,
    required this.lds,
    required this.cpm,
    required this.psm,
    required this.ptm,
  });

  factory FlightMessages.fromJson(Map<String, dynamic> json) => FlightMessages(
    mvtDeparture:
        (json['mvt_departure'] as List)
            .map((e) => MessageData.fromJson(e))
            .toList(),
    mvtArrival:
        (json['mvt_arrival'] as List)
            .map((e) => MessageData.fromJson(e))
            .toList(),
    ldm:
        (json['ldm_messages'] as List)
            .map((e) => MessageData.fromJson(e))
            .toList(),
    lir:
        (json['lir_messages'] as List)
            .map((e) => MessageData.fromJson(e))
            .toList(),
    lds:
        (json['lds_messages'] as List)
            .map((e) => MessageData.fromJson(e))
            .toList(),
    cpm:
        (json['cpm_messages'] as List)
            .map((e) => MessageData.fromJson(e))
            .toList(),
    psm:
        (json['psm_messages'] as List)
            .map((e) => MessageData.fromJson(e))
            .toList(),
    ptm:
        (json['ptm_messages'] as List)
            .map((e) => MessageData.fromJson(e))
            .toList(),
  );
}

class MessageData {
  final String message;
  final String source;
  final String receivedDatetime;
  final String updatedAt;

  MessageData({
    required this.message,
    required this.source,
    required this.receivedDatetime,
    required this.updatedAt,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
    message: json['message'],
    source: json['source'],
    receivedDatetime: json['received_datetime'],
    updatedAt: json['updated_at'],
  );
}
