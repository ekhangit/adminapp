import 'package:flutter/material.dart';

class TodayRoster {
  final int employeeId;
  final String date;
  final String dayName;
  final String? startTime;
  final String? endTime;
  final int totalDutyMinutes;
  final String formattedDutyTime;
  final double breakHours;
  final int breakMinutes;
  final List<Duty> duties;
  final bool isOnLeave;
  final bool isDayOff;

  TodayRoster({
    required this.employeeId,
    required this.date,
    required this.dayName,
    this.startTime,
    this.endTime,
    required this.totalDutyMinutes,
    required this.formattedDutyTime,
    this.breakHours = 0,
    this.breakMinutes = 0,
    required this.duties,
    required this.isOnLeave,
    required this.isDayOff,
  });

  factory TodayRoster.fromJson(Map<String, dynamic> json) {
    return TodayRoster(
      employeeId: json['employee_id'],
      date: json['date'],
      dayName: json['day_name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      totalDutyMinutes: json['total_duty_minutes'],
      formattedDutyTime: json['formatted_duty_time'],
      breakHours: json['breakHours'] ?? 0.0,
      breakMinutes: json['breakMinutes'] ?? 0,
      duties:
          (json['duties'] as List<dynamic>)
              .map((duty) => Duty.fromJson(duty))
              .toList(),
      isOnLeave: json['is_on_leave'],
      isDayOff: json['is_day_off'],
    );
  }
}

class BreakTimeEntry {
  final String startTime;
  final String endTime;

  BreakTimeEntry({required this.startTime, required this.endTime});

  BreakTimeEntry copyWith({String? startTime, String? endTime}) {
    return BreakTimeEntry(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

class Duty {
  final int id;
  final String? type;
  final String terminal;
  final String name;
  final Color? color;
  final String? flightInfo;
  final String timeIn;
  final String? actualTimeIn;
  final String timeOut;
  final String? actualTimeOut;

  Duty({
    required this.id,
    this.type,
    required this.terminal,
    required this.name,
    this.color,
    this.flightInfo,
    required this.timeIn,
    this.actualTimeIn,
    required this.timeOut,
    this.actualTimeOut,
  });

  // Helper getters for backward compatibility and UI display
  String get title =>
      '${type ?? ""} $terminal-$name ${flightInfo ?? ""}'.trim();
  String get startTime => _extractTimeFromDateTime(timeIn);
  String get endTime => _extractTimeFromDateTime(timeOut);
  String get plnTime => 'PLN - $startTime-$endTime';
  String? get actTime {
    if (actualTimeIn != null && actualTimeOut != null) {
      final actStart = _extractTimeFromDateTime(actualTimeIn!);
      final actEnd = _extractTimeFromDateTime(actualTimeOut!);
      return 'ACT - $actStart-$actEnd';
    }
    return null;
  }

  String get dutyPeriod {
    final startDateTime = DateTime.parse(timeIn);
    final endDateTime = DateTime.parse(timeOut);
    final duration = endDateTime.difference(startDateTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String get breakTime => '-'; // Can be enhanced based on shift rules

  static String _extractTimeFromDateTime(String dateTime) {
    final dt = DateTime.parse(dateTime);
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Duty copyWith({
    int? id,
    String? type,
    String? terminal,
    String? name,
    Color? color,
    String? flightInfo,
    String? timeIn,
    String? actualTimeIn,
    String? timeOut,
    String? actualTimeOut,
  }) {
    return Duty(
      id: id ?? this.id,
      type: type,
      terminal: terminal ?? this.terminal,
      name: name ?? this.name,
      color: color,
      flightInfo: flightInfo,
      timeIn: timeIn ?? this.timeIn,
      actualTimeIn: actualTimeIn ?? this.actualTimeIn,
      timeOut: timeOut ?? this.timeOut,
      actualTimeOut: actualTimeOut ?? this.actualTimeOut,
    );
  }

  // Factory constructor from API JSON
  factory Duty.fromJson(Map<String, dynamic> json) {
    return Duty(
      id: json['id'],
      type: json['type'],
      terminal: json['terminal'],
      name: json['name'],
      color:
          json['color'] != null
              ? Color(int.parse(json['color'].replaceAll('#', '0xFF')))
              : null,
      flightInfo: json['flight_info'],
      timeIn: json['time_in'],
      actualTimeIn: json['actual_time_in'],
      timeOut: json['time_out'],
      actualTimeOut: json['actual_time_out'],
    );
  }

  // Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'terminal': terminal,
      'name': name,
      'color':
          color != null
              ? '#${color!.value.toRadixString(16).substring(2).padLeft(6, '0')}'
              : null,
      'flight_info': flightInfo,
      'time_in': timeIn,
      'actual_time_in': actualTimeIn,
      'time_out': timeOut,
      'actual_time_out': actualTimeOut,
    };
  }
}

class Week {
  final int number;
  final DateTime startDate;
  final DateTime endDate;
  final List<Day> days;

  Week({
    required this.number,
    required this.startDate,
    required this.endDate,
    required this.days,
  });

  Week copyWith({
    int? number,
    DateTime? startDate,
    DateTime? endDate,
    List<Day>? days,
  }) {
    return Week(
      number: number ?? this.number,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      days: days ?? this.days,
    );
  }

  // Factory constructor from API JSON
  factory Week.fromJson(Map<String, dynamic> json) {
    return Week(
      number: json['week_number'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      days:
          (json['days'] as List<dynamic>)
              .map((day) => Day.fromJson(day))
              .toList(),
    );
  }
}

class Day {
  final DateTime date;
  final List<Duty> duties;
  final String? dayName;
  final String? startTime;
  final String? endTime;
  final int totalDutyMinutes;
  final String formattedDutyTime;
  final double breakHours;
  final int breakMinutes;
  final int dd;
  final bool onLeave;
  final bool isDayOff;
  final String totalDutyHours;
  final String totalPeriodHours;
  final bool hasDuties;

  Day({
    required this.date,
    required this.duties,
    this.dayName,
    this.startTime,
    this.endTime,
    this.totalDutyMinutes = 0,
    this.formattedDutyTime = '',
    this.breakHours = 0,
    this.breakMinutes = 0,
    this.dd = 0,
    this.onLeave = false,
    this.isDayOff = false,
    this.totalDutyHours = '',
    this.totalPeriodHours = '0.00',
    this.hasDuties = false,
  });

  Day copyWith({
    DateTime? date,
    List<Duty>? duties,
    String? dayName,
    String? startTime,
    String? endTime,
    int? totalDutyMinutes,
    String? formattedDutyTime,
    double? breakHours,
    int? breakMinutes,
    int? dd,
    bool? onLeave,
    bool? isDayOff,
    String? totalDutyHours,
    String? totalPeriodHours,
    bool? hasDuties,
  }) {
    return Day(
      date: date ?? this.date,
      duties: duties ?? this.duties,
      dayName: dayName ?? this.dayName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalDutyMinutes: totalDutyMinutes ?? this.totalDutyMinutes,
      formattedDutyTime: formattedDutyTime ?? this.formattedDutyTime,
      breakHours: breakHours ?? this.breakHours,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      dd: dd ?? this.dd,
      onLeave: onLeave ?? this.onLeave,
      isDayOff: isDayOff ?? this.isDayOff,
      totalDutyHours: totalDutyHours ?? this.totalDutyHours,
      totalPeriodHours: totalPeriodHours ?? this.totalPeriodHours,
      hasDuties: hasDuties ?? this.hasDuties,
    );
  }

  // Factory constructor from API JSON
  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      date: DateTime.parse(json['date']),
      dayName: json['day_name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      totalDutyMinutes: json['total_duty_minutes'] ?? 0,
      formattedDutyTime: json['formatted_duty_time'] ?? '',
      breakHours: json['breakHours'] ?? 0.0,
      breakMinutes: json['breakMinutes'] ?? 0,
      dd: json['dd'] ?? 0,
      onLeave: json['on_leave'] ?? false,
      isDayOff: json['is_day_off'] ?? false,
      totalDutyHours: json['total_duty_hours'] ?? '',
      totalPeriodHours: json['total_period_hours'] ?? '0.00',
      hasDuties: json['has_duties'] ?? false,
      duties:
          (json['duties'] as List<dynamic>)
              .map((duty) => Duty.fromJson(duty))
              .toList(),
    );
  }
}
