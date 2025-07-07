class FlightDetailModel {
  final BasicDetails basicDetails;
  final Airport departureAirport;
  final Airport arrivalAirport;
  final Aircraft? aircraft;
  final Capacity capacity;
  final ActualPax actualPax;
  final String? inboundFlight; // New field
  final String? outboundFlight;
  final TrcData? trc;
  final CkinData? ckin;
  final ArrData? arr;
  final FlightMessages messages;
  final List<SodData> sodData;

  FlightDetailModel({
    required this.basicDetails,
    required this.departureAirport,
    required this.arrivalAirport,
    this.aircraft,
    required this.capacity,
    required this.actualPax,
    this.inboundFlight,
    this.outboundFlight,
    this.trc,
    this.ckin,
    this.arr,
    required this.messages,
    required this.sodData,
  });

  factory FlightDetailModel.fromJson(Map<String, dynamic> json) {
    final info = json['flight_info'] ?? {};
    final trcJson = json['trc'];
    final ckinJson = json['ckin'];
    final arrJson = json['arr'];
    final messagesJson = json['messages'] ?? {};
    final sodJson = json['sod'] ?? [];

    return FlightDetailModel(
      basicDetails: BasicDetails.fromJson(info['basic_details']),
      departureAirport: Airport.fromJson(info['departure_airport']),
      arrivalAirport: Airport.fromJson(info['arrival_airport']),
      aircraft:
          info['aircraft'] != null ? Aircraft.fromJson(info['aircraft']) : null,
      capacity: Capacity.fromJson(info['capacity']),
      actualPax: ActualPax.fromJson(info['actual_pax']),
      inboundFlight: info['inbound_flight']?.toString(),
      outboundFlight: info['outbound_flight']?.toString(),
      trc: trcJson != null ? TrcData.fromJson(trcJson) : null,
      ckin: ckinJson != null ? CkinData.fromJson(ckinJson) : null,
      arr: arrJson != null ? ArrData.fromJson(arrJson) : null,
      messages: FlightMessages.fromJson(messagesJson),
      sodData: List<SodData>.from(sodJson.map((x) => SodData.fromJson(x))),
    );
  }

  bool get isConnectingFlight => inboundFlight?.isNotEmpty == true || 
      outboundFlight?.isNotEmpty == true;
}

class BasicDetails {
  final int id;
  final String flightInfo;
  final String? std;
  final String? atd;
  final String? sta;
  final String? ata;
  final String date;
  final String? callSign;
  final String? gate;
  final String? pos;
  final String? beggageBelt;

  BasicDetails({
    required this.id,
    required this.flightInfo,
    this.std,
    this.atd,
    this.sta,
    this.ata,
    required this.date,
    this.callSign,
    this.gate,
    this.pos,
    this.beggageBelt,
  });

  factory BasicDetails.fromJson(Map<String, dynamic> json) => BasicDetails(
    id: json['id'] ?? 0,
    flightInfo: json['flight_info'],
    std: json['std'] ?? '',
    atd: json['atd'] ?? '',
    sta: json['sta'] ?? '',
    ata: json['ata'] ?? '',
    date: json['date'],
    callSign: json['call_sign'] ?? '',
    gate: json['gate'] ?? '',
    pos: json['pos'] ?? '',
    beggageBelt: json['beggage_belt'] ?? '',
  );
}

class Airport {
  final int id;
  final String iataCode;

  Airport({required this.id, required this.iataCode});

  factory Airport.fromJson(Map<String, dynamic> json) =>
      Airport(id: json['id'] ?? 0, iataCode: json['iata_code'] ?? '');
}

class Aircraft {
  final int id;
  final String name;
  final AircraftType aircraftType;

  Aircraft({required this.id, required this.name, required this.aircraftType});

  factory Aircraft.fromJson(Map<String, dynamic> json) => Aircraft(
    id: json['id'] ?? 0,
    name: json['name'],
    aircraftType: AircraftType.fromJson(json['aircraft_type']),
  );
}

class AircraftType {
  final int id;
  final String icao;

  AircraftType({required this.id, required this.icao});

  factory AircraftType.fromJson(Map<String, dynamic> json) =>
      AircraftType(id: json['id'] ?? 0, icao: json['icao']);
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

// class ActualPax {
//   final String? paxA;
//   final String? paxC;
//   final String? paxW;
//   final String? paxY;
//   final String? paxInf;
//   final String? paxJmp;

//   ActualPax({
//     this.paxA,
//     this.paxC,
//     this.paxW,
//     this.paxY,
//     this.paxInf,
//     this.paxJmp,
//   });

//   factory ActualPax.fromJson(Map<String, dynamic> json) => ActualPax(
//     paxA: json['pax_a_actual'] ?? '',
//     paxC: json['pax_c_actual'] ?? '',
//     paxW: json['pax_w_actual'] ?? '',
//     paxY: json['pax_y_actual'] ?? '',
//     paxInf: json['pax_inf_actual'] ?? '',
//     paxJmp: json['pax_jmp_actual'] ?? '',
//   );

//   int get totalPax {
//     // Helper function to parse string to int (handling empty/null)
//     int parsePax(String? value) {
//       if (value == null || value.isEmpty) return 0;
//       return int.tryParse(value) ?? 0;
//     }

//     return parsePax(paxA) +
//         parsePax(paxC) +
//         parsePax(paxW) +
//         parsePax(paxY) +
//         parsePax(paxInf) +
//         parsePax(paxJmp);
//   }
// }

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
    paxA: json['pax_a_actual']?.toString(), // Convert to string if not null
    paxC: json['pax_c_actual']?.toString(),
    paxW: json['pax_w_actual']?.toString(),
    paxY: json['pax_y_actual']?.toString(),
    paxInf: json['pax_inf_actual']?.toString(),
    paxJmp: json['pax_jmp_actual']?.toString(),
  );

  // Parses a string value to int (handles empty strings and null)
  static int _parsePaxValue(String? value) {
    if (value == null || value.isEmpty) return 0;
    return int.tryParse(value) ?? 0;
  }

  // Getter for each value as integer
  int get paxACount => _parsePaxValue(paxA);
  int get paxCCount => _parsePaxValue(paxC);
  int get paxWCount => _parsePaxValue(paxW);
  int get paxYCount => _parsePaxValue(paxY);
  int get paxInfCount => _parsePaxValue(paxInf);
  int get paxJmpCount => _parsePaxValue(paxJmp);

  // Total passengers calculation
  int get totalPax =>
      paxACount + paxCCount + paxWCount + paxYCount + paxInfCount + paxJmpCount;

  // Helper to check if infants are present
  bool get hasInfants => paxInfCount > 0;

  // Helper to format passenger counts for display
  String formatPaxCount(String? value) {
    final count = _parsePaxValue(value);
    return count > 0 ? count.toString() : '--';
  }

  // Convert back to JSON
  Map<String, dynamic> toJson() => {
    'pax_a_actual': paxA,
    'pax_c_actual': paxC,
    'pax_w_actual': paxW,
    'pax_y_actual': paxY,
    'pax_inf_actual': paxInf,
    'pax_jmp_actual': paxJmp,
  };
}

class TrcData {
  final String? trc;
  final String? mobile;
  final String? remarks;
  final String? beforeArrival;
  final String? beforeDeparture;
  final String? afterDeparture;
  final String? crew;
  final String? pantry;
  final String? captain;
  final String? dow;
  final String? doi;
  final String? mtow;
  final String? rtow;
  final String? taxi;
  final String? block;
  final String? trip;
  final String? eet;
  final String? takeOff;
  final String? uplifted;
  final String? altn;
  // Add all other fields from the JSON

  TrcData({
    this.trc,
    this.mobile,
    this.remarks,
    this.beforeArrival,
    this.beforeDeparture,
    this.afterDeparture,
    this.crew,
    this.pantry,
    this.captain,
    this.dow,
    this.doi,
    this.mtow,
    this.rtow,
    this.taxi,
    this.block,
    this.trip,
    this.eet,
    this.takeOff,
    this.uplifted,
    this.altn,
  });

  factory TrcData.fromJson(Map<String, dynamic> json) => TrcData(
    trc: json['trc']?.toString() ?? '',
    mobile: json['mobile']?.toString() ?? '',
    remarks: json['remarks']?.toString() ?? '',
    beforeArrival: json['before_arrival']?.toString() ?? '',
    beforeDeparture: json['before_departure']?.toString() ?? '',
    afterDeparture: json['after_departure']?.toString() ?? '',
    crew: json['crew']?.toString() ?? '',
    pantry: json['pantry']?.toString() ?? '',
    captain: json['captain']?.toString() ?? '',
    dow: json['dow']?.toString() ?? '',
    doi: json['doi']?.toString() ?? '',
    mtow: json['mtow']?.toString() ?? '',
    rtow: json['rtow']?.toString() ?? '',
    taxi: json['taxi']?.toString() ?? '',
    block: json['block']?.toString() ?? '',
    trip: json['trip']?.toString() ?? '',
    eet: json['eet']?.toString() ?? '',
    takeOff: json['take_off']?.toString() ?? '',
    uplifted: json['uplifted']?.toString() ?? '',
    altn: json['altn']?.toString() ?? '',
  );
}

class CkinData {
  final List<String> ckinStaffNames;
  final List<String> gateStaffNames;
  final List<String> gateSpvrStaffNames;
  final List<String> spvrNames;
  final String? spvrRemark;
  final String? deskNo;
  final String? deskUsed;
  final String? ckinOpened;
  final String? ckinClosed;
  final String? gateOpened;
  final String? gateClosed;
  final String? bdgStarted;
  final String? bdgCompleted;
  final String? securedAtCkin;
  final String? securedAtGate;
  final String? special;
  final String? bookingStatus;
  final String? scheduleInfo;
  final String? docsCheck;
  final String? ramp;
  final String? other;
  final BookedPax? bookedPax;
  final PaxType? paxType;
  final String? seatArea;
  final String? baggageGatePcs;
  final String? baggageGateWt;
  final String? baggageCkinPcs;
  final String? baggageCkinWt;
  final CargoData? cargo;
  final CargoData? baggage;
  final CargoData? mail;
  final CargoData? eic;
  final CargoData? transit;
  final String? catering;

  CkinData({
    required this.ckinStaffNames,
    required this.gateStaffNames,
    required this.gateSpvrStaffNames,
    required this.spvrNames,
    this.spvrRemark,
    this.deskNo,
    this.deskUsed,
    this.ckinOpened,
    this.ckinClosed,
    this.gateOpened,
    this.gateClosed,
    this.bdgStarted,
    this.bdgCompleted,
    this.securedAtCkin,
    this.securedAtGate,
    this.special,
    this.bookingStatus,
    this.scheduleInfo,
    this.docsCheck,
    this.ramp,
    this.other,
    this.bookedPax,
    this.paxType,
    this.seatArea,
    this.baggageGatePcs,
    this.baggageGateWt,
    this.baggageCkinPcs,
    this.baggageCkinWt,
    this.cargo,
    this.baggage,
    this.mail,
    this.eic,
    this.transit,
    this.catering,
  });

  factory CkinData.fromJson(Map<String, dynamic> json) {
    return CkinData(
      ckinStaffNames: List<String>.from(
        (json['ckin_staff_names'] as List<dynamic>? ?? []).map(
          (e) => e.toString(),
        ),
      ),
      gateStaffNames: List<String>.from(
        (json['gate_staff_names'] as List<dynamic>? ?? []).map(
          (e) => e.toString(),
        ),
      ),
      gateSpvrStaffNames: List<String>.from(
        (json['gate_spvr_staff_names'] as List<dynamic>? ?? []).map(
          (e) => e.toString(),
        ),
      ),
      spvrNames: List<String>.from(
        (json['spvr_names'] as List<dynamic>? ?? []).map((e) => e.toString()),
      ),
      spvrRemark: json['spvr_remark']?.toString(),
      deskNo: json['desk_no']?.toString(),
      deskUsed: json['desk_used']?.toString(),
      ckinOpened: json['ckin_opened']?.toString(),
      ckinClosed: json['ckin_closed']?.toString(),
      gateOpened: json['gate_opened']?.toString(),
      gateClosed: json['gate_closed']?.toString(),
      bdgStarted: json['bdg_started']?.toString(),
      bdgCompleted: json['bdg_completed']?.toString(),
      securedAtCkin: json['secured_at_ckin']?.toString(),
      securedAtGate: json['secured_at_gate']?.toString(),
      special: json['special']?.toString(),
      bookingStatus: json['booking_status']?.toString(),
      scheduleInfo: json['schedule_info']?.toString(),
      docsCheck: json['docs_check']?.toString(),
      ramp: json['ramp']?.toString(),
      other: json['other']?.toString(),
      bookedPax:
          json['booked_pax'] != null
              ? BookedPax.fromJson(json['booked_pax'])
              : null,
      paxType:
          json['pax_type'] != null ? PaxType.fromJson(json['pax_type']) : null,
      seatArea: json['seat_area']?.toString(),
      baggageGatePcs: json['baggage_gate_pcs']?.toString(),
      baggageGateWt: json['baggage_gate_wt']?.toString(),
      baggageCkinPcs: json['baggage_ckin_pcs']?.toString(),
      baggageCkinWt: json['baggage_ckin_wt']?.toString(),
      cargo: json['cargo'] != null ? CargoData.fromJson(json['cargo']) : null,
      baggage:
          json['baggage'] != null ? CargoData.fromJson(json['baggage']) : null,
      mail: json['mail'] != null ? CargoData.fromJson(json['mail']) : null,
      eic: json['eic'] != null ? CargoData.fromJson(json['eic']) : null,
      transit:
          json['transit'] != null ? CargoData.fromJson(json['transit']) : null,
      catering: json['catering']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ckin_staff_names': ckinStaffNames,
      'gate_staff_names': gateStaffNames,
      'gate_spvr_staff_names': gateSpvrStaffNames,
      'spvr_names': spvrNames,
      'spvr_remark': spvrRemark,
      'desk_no': deskNo,
      'desk_used': deskUsed,
      'ckin_opened': ckinOpened,
      'ckin_closed': ckinClosed,
      'gate_opened': gateOpened,
      'gate_closed': gateClosed,
      'bdg_started': bdgStarted,
      'bdg_completed': bdgCompleted,
      'secured_at_ckin': securedAtCkin,
      'secured_at_gate': securedAtGate,
      'special': special,
      'booking_status': bookingStatus,
      'schedule_info': scheduleInfo,
      'docs_check': docsCheck,
      'ramp': ramp,
      'other': other,
      'booked_pax': bookedPax?.toJson(),
      'pax_type': paxType?.toJson(),
      'seat_area': seatArea,
      'baggage_gate_pcs': baggageGatePcs,
      'baggage_gate_wt': baggageGateWt,
      'baggage_ckin_pcs': baggageCkinPcs,
      'baggage_ckin_wt': baggageCkinWt,
      'cargo': cargo?.toJson(),
      'baggage': baggage?.toJson(),
      'mail': mail?.toJson(),
      'eic': eic?.toJson(),
      'transit': transit?.toJson(),
      'catering': catering,
    };
  }
}

class BookedPax {
  final String? paxABooked;
  final String? paxCBooked;
  final String? paxWBooked;
  final String? paxYBooked;
  final String? paxInfBooked;

  BookedPax({
    this.paxABooked,
    this.paxCBooked,
    this.paxWBooked,
    this.paxYBooked,
    this.paxInfBooked,
  });

  factory BookedPax.fromJson(Map<String, dynamic> json) {
    return BookedPax(
      paxABooked: json['pax_a_booked']?.toString(),
      paxCBooked: json['pax_c_booked']?.toString(),
      paxWBooked: json['pax_w_booked']?.toString(),
      paxYBooked: json['pax_y_booked']?.toString(),
      paxInfBooked: json['pax_inf_booked']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pax_a_booked': paxABooked,
      'pax_c_booked': paxCBooked,
      'pax_w_booked': paxWBooked,
      'pax_y_booked': paxYBooked,
      'pax_inf_booked': paxInfBooked,
    };
  }
}

class PaxType {
  final String? paxAdultsActual;
  final String? paxMActual;
  final String? paxFActual;
  final String? paxChActual;
  final String? paxInfActual;

  PaxType({
    this.paxAdultsActual,
    this.paxMActual,
    this.paxFActual,
    this.paxChActual,
    this.paxInfActual,
  });

  factory PaxType.fromJson(Map<String, dynamic> json) {
    return PaxType(
      paxAdultsActual: json['pax_adults_actual']?.toString(),
      paxMActual: json['pax_m_actual']?.toString(),
      paxFActual: json['pax_f_actual']?.toString(),
      paxChActual: json['pax_ch_actual']?.toString(),
      paxInfActual: json['pax_inf_actual']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pax_adults_actual': paxAdultsActual,
      'pax_m_actual': paxMActual,
      'pax_f_actual': paxFActual,
      'pax_ch_actual': paxChActual,
      'pax_inf_actual': paxInfActual,
    };
  }
}

class CargoData {
  final String pcs;
  final String wt;

  CargoData({required this.pcs, required this.wt});

  factory CargoData.fromJson(Map<String, dynamic> json) {
    return CargoData(
      pcs: json['pcs']?.toString() ?? '0',
      wt: json['wt']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {'pcs': pcs, 'wt': wt};
  }
}

class ArrData {
  final String? staff;
  final String? remarks;
  final String? startTime;
  final String? endTime;
  final String? mhb;
  final String? ohd;
  final String? dpr;

  ArrData({
    this.staff,
    this.remarks,
    this.startTime,
    this.endTime,
    this.mhb,
    this.ohd,
    this.dpr,
  });

  factory ArrData.fromJson(Map<String, dynamic> json) => ArrData(
    staff: json['staff'] ?? '',
    remarks: json['remarks'] ?? '',
    startTime: json['start_time'] ?? '',
    endTime: json['end_time'] ?? '',
    mhb: json['mhb'] ?? '',
    ohd: json['ohd'] ?? '',
    dpr: json['dpr'] ?? '',
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

class SodData {
  final String serviceAbbr;
  final String type;
  final String slaTimeIn;
  final String slaTimeOut;
  final String duration;
  final int requiredStaff;
  final List<SodEmployee> employees;

  SodData({
    required this.serviceAbbr,
    required this.type,
    required this.slaTimeIn,
    required this.slaTimeOut,
    required this.duration,
    required this.requiredStaff,
    required this.employees,
  });

  factory SodData.fromJson(Map<String, dynamic> json) => SodData(
    serviceAbbr: json['service_abbr']?.toString() ?? '',
    type: json['type']?.toString() ?? '',
    slaTimeIn: json['sla_time_in']?.toString() ?? '',
    slaTimeOut: json['sla_time_out']?.toString() ?? '',
    duration: json['duration']?.toString() ?? '00:00',
    requiredStaff: (json['required_staff'] as int?) ?? 0,
    employees: (json['employees'] as List<dynamic>?)
        ?.map((e) => SodEmployee.fromJson(e))
        .toList() ?? [],
  );
}

class SodEmployee {
  final int employeeId;
  final String name;
  final String airport;
  final String plannedTimeIn;
  final String plannedTimeOut;
  final String actualTimeIn;
  final String actualTimeOut;
  final String plannedDuration;
  final String actualDuration;

  SodEmployee({
    required this.employeeId,
    required this.name,
    required this.airport,
    required this.plannedTimeIn,
    required this.plannedTimeOut,
    required this.actualTimeIn,
    required this.actualTimeOut,
    required this.plannedDuration,
    required this.actualDuration,
  });

  factory SodEmployee.fromJson(Map<String, dynamic> json) => SodEmployee(
    employeeId: (json['employee_id'] as int?) ?? 0,
    name: json['name']?.toString() ?? '',
    airport: json['airport']?.toString() ?? '',
    plannedTimeIn: json['planned_time_in']?.toString() ?? '',
    plannedTimeOut: json['planned_time_out']?.toString() ?? '',
    actualTimeIn: json['actual_time_in']?.toString() ?? '',
    actualTimeOut: json['actual_time_out']?.toString() ?? '',
    plannedDuration: json['planned_duration']?.toString() ?? '00:00',
    actualDuration: json['actual_duration']?.toString() ?? '00:00',
  );
}


