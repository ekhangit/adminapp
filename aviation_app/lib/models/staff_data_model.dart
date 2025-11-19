class StaffDataModel {
  final FlightInfo flightInfo;
  final AirportInfo airportInfo;
  final RosterInfo roster;
  final List<FlightService> flightServices;
  final List<dynamic> rosterServices;
  final FormData formData;

  StaffDataModel({
    required this.flightInfo,
    required this.airportInfo,
    required this.roster,
    required this.flightServices,
    required this.rosterServices,
    required this.formData,
  });

  factory StaffDataModel.fromJson(Map<String, dynamic> json) {
    return StaffDataModel(
      flightInfo: FlightInfo.fromJson(json['flight_info'] ?? {}),
      airportInfo: AirportInfo.fromJson(json['airport_info'] ?? {}),
      roster: RosterInfo.fromJson(json['roster'] ?? {}),
      flightServices: (json['flight_services'] as List?)
              ?.map((e) => FlightService.fromJson(e))
              .toList() ??
          [],
      rosterServices: json['roster_services'] ?? [],
      formData: FormData.fromJson(json['form_data'] ?? {}),
    );
  }
}

class FlightInfo {
  final String id;
  final String flightNumber;
  final String itinerary;
  final int airlineId;
  final ScheduledTimes scheduledTimes;
  final ServiceFlags serviceFlags;

  FlightInfo({
    required this.id,
    required this.flightNumber,
    required this.itinerary,
    required this.airlineId,
    required this.scheduledTimes,
    required this.serviceFlags,
  });

  factory FlightInfo.fromJson(Map<String, dynamic> json) {
    return FlightInfo(
      id: json['id']?.toString() ?? '',
      flightNumber: json['flight_number']?.toString() ?? '',
      itinerary: json['itinerary']?.toString() ?? '',
      airlineId: json['airline_id'] ?? 0,
      scheduledTimes:
          ScheduledTimes.fromJson(json['scheduled_times'] ?? {}),
      serviceFlags: ServiceFlags.fromJson(json['service_flags'] ?? {}),
    );
  }
}

class ScheduledTimes {
  final TimeDetails departure;
  final TimeDetails arrival;

  ScheduledTimes({
    required this.departure,
    required this.arrival,
  });

  factory ScheduledTimes.fromJson(Map<String, dynamic> json) {
    return ScheduledTimes(
      departure: TimeDetails.fromJson(json['departure'] ?? {}),
      arrival: TimeDetails.fromJson(json['arrival'] ?? {}),
    );
  }
}

class TimeDetails {
  final String? std;
  final String? etd;
  final String? atd;
  final String? sta;
  final String? eta;
  final String? ata;

  TimeDetails({
    this.std,
    this.etd,
    this.atd,
    this.sta,
    this.eta,
    this.ata,
  });

  factory TimeDetails.fromJson(Map<String, dynamic> json) {
    return TimeDetails(
      std: json['std']?.toString(),
      etd: json['etd']?.toString(),
      atd: json['atd']?.toString(),
      sta: json['sta']?.toString(),
      eta: json['eta']?.toString(),
      ata: json['ata']?.toString(),
    );
  }
}

class ServiceFlags {
  final int departureService;
  final int arrivalService;
  final int turnaroundService;

  ServiceFlags({
    required this.departureService,
    required this.arrivalService,
    required this.turnaroundService,
  });

  factory ServiceFlags.fromJson(Map<String, dynamic> json) {
    return ServiceFlags(
      departureService: json['departure_service'] ?? 0,
      arrivalService: json['arrival_service'] ?? 0,
      turnaroundService: json['turnaround_service'] ?? 0,
    );
  }
}

class AirportInfo {
  final String name;
  final int id;

  AirportInfo({
    required this.name,
    required this.id,
  });

  factory AirportInfo.fromJson(Map<String, dynamic> json) {
    return AirportInfo(
      name: json['name']?.toString() ?? '',
      id: json['id'] ?? 0,
    );
  }
}

class RosterInfo {
  final int? id;
  final String date;

  RosterInfo({
    this.id,
    required this.date,
  });

  factory RosterInfo.fromJson(Map<String, dynamic> json) {
    return RosterInfo(
      id: json['id'],
      date: json['date']?.toString() ?? '',
    );
  }
}

class FlightService {
  final int serviceId;
  final String abbr;
  final int staffRequired;
  final String startTime;
  final String endTime;
  final String duration;
  final dynamic turnaroundService;
  final int arrivalService;
  final int departureService;
  final List<Employee> assignedEmployees;
  final List<Employee> availableEmployees;

  FlightService({
    required this.serviceId,
    required this.abbr,
    required this.staffRequired,
    required this.startTime,
    required this.endTime,
    required this.duration,
    this.turnaroundService,
    required this.arrivalService,
    required this.departureService,
    required this.assignedEmployees,
    required this.availableEmployees,
  });

  factory FlightService.fromJson(Map<String, dynamic> json) {
    return FlightService(
      serviceId: json['service_id'] ?? 0,
      abbr: json['abbr']?.toString() ?? '',
      staffRequired: json['staff_required'] ?? 0,
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      turnaroundService: json['turnaround_service'],
      arrivalService: json['arrival_service'] ?? 0,
      departureService: json['departure_service'] ?? 0,
      assignedEmployees: (json['assigned_employees'] as List?)
              ?.map((e) => Employee.fromJson(e))
              .toList() ??
          [],
      availableEmployees: (json['available_employees'] as List?)
              ?.map((e) => Employee.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Employee {
  final int id;
  final String name;
  final int departmentId;

  Employee({
    required this.id,
    required this.name,
    required this.departmentId,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      departmentId: json['department_id'] ?? 0,
    );
  }
}

class FormData {
  final int airlineId;
  final String flightScheduledArrivalTime;
  final String flightScheduledDepartureTime;
  final String flightId;

  FormData({
    required this.airlineId,
    required this.flightScheduledArrivalTime,
    required this.flightScheduledDepartureTime,
    required this.flightId,
  });

  factory FormData.fromJson(Map<String, dynamic> json) {
    return FormData(
      airlineId: json['airline_id'] ?? 0,
      flightScheduledArrivalTime:
          json['flight_scheduled_arrival_time']?.toString() ?? '',
      flightScheduledDepartureTime:
          json['flight_scheduled_departure_time']?.toString() ?? '',
      flightId: json['flight_id']?.toString() ?? '',
    );
  }
}
