import 'dart:convert';
import 'dart:developer';

import '../controllers/storage/data_storage_controller.dart';

class ChatMessage {
  final String id;
  final int senderId;
  final String senderName;
  final String station;
  final String message;
  final String? attachment;
  final String? fileName;
  final String? type;
  final String? messageFrom;
  final String time;
  final bool isOwn;
  List<int>? readBy;
  final List<StaffService>? staffServicesMessage;
  final TrcMessage? trcMessage;
  final ArrMessage? arrMessage;
  final FhrMessage? fhrMessage;
  final SsrMessage? ssrMessage;
  final DsrMessage? dsrMessage;
  final CkinMessage? ckinMessage;
  final AttachmentMessage? attachmentMessage;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.station,
    required this.message,
    this.attachment,
    this.fileName,
    this.type,
    this.messageFrom,
    required this.time,
    required this.isOwn,
    this.readBy,
    this.trcMessage,
    this.staffServicesMessage,
    this.arrMessage,
    this.fhrMessage,
    this.ssrMessage,
    this.dsrMessage,
    this.ckinMessage,
    this.attachmentMessage,
  });

  // CopyWith method to create a new instance with updated fields
  ChatMessage copyWith({
    String? id,
    int? senderId,
    String? senderName,
    String? station,
    String? message,
    String? attachment,
    String? fileName,
    String? type,
    String? messageFrom,
    String? time,
    bool? isOwn,
    List<int>? readBy,
    List<StaffService>? staffServicesMessage,
    ArrMessage? arrMessage,
    FhrMessage? fhrMessage,
    SsrMessage? ssrMessage,
    DsrMessage? dsrMessage,
    TrcMessage? trcMessage,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      station: station ?? this.station,
      message: message ?? this.message,
      attachment: attachment ?? this.attachment,
      fileName: fileName ?? this.fileName,
      type: type ?? this.type,
      messageFrom: messageFrom ?? this.messageFrom,
      time: time ?? this.time,
      isOwn: isOwn ?? this.isOwn,
      readBy: readBy ?? this.readBy,
      staffServicesMessage: staffServicesMessage ?? this.staffServicesMessage,
      arrMessage: arrMessage ?? this.arrMessage,
      fhrMessage: fhrMessage ?? this.fhrMessage,
      ssrMessage: ssrMessage ?? this.ssrMessage,
      dsrMessage: dsrMessage ?? this.dsrMessage,
      trcMessage: trcMessage ?? this.trcMessage,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final currentUserId = DataStorageController.to.user.id;

    // Helper function to safely convert to int
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    }

    // Updated helper function to safely convert read_by array with string handling
    List<int>? toIntList(dynamic value) {
      if (value == null) return null;
      if (value is List) {
        return value.map((item) {
          // Handle both string and int values in the array
          if (item is String) {
            return int.tryParse(item) ?? 0;
          } else if (item is int) {
            return item;
          } else if (item is double) {
            return item.toInt();
          }
          return 0; // Default fallback
        }).toList();
      }
      return null;
    }

    // Add TRC message parsing
    TrcMessage? parseTrcMessage(dynamic messageData) {
      try {
        // Case 1: Already in proper map format
        if (messageData is Map<String, dynamic>) {
          return TrcMessage.fromJson(messageData);
        }

        // Case 2: List of key-value pairs
        if (messageData is List) {
          final map = <String, dynamic>{};
          for (final item in messageData) {
            if (item is Map && item['name'] != null) {
              // Handle both {'name':..., 'value':...} and {'key':..., 'value':...}
              final key = (item['name'] ?? item['key'])?.toString();
              if (key != null) {
                map[key] = item['value'];
              }
            }
          }
          if (map.isNotEmpty) {
            return TrcMessage.fromJson(map);
          }
        }

        // Case 3: String representation that needs parsing
        if (messageData is String) {
          try {
            final decoded = jsonDecode(messageData);
            return parseTrcMessage(decoded); // Recursively handle parsed JSON
          } catch (e) {
            log('[ChatMessage] Error parsing TRC string message: $e');
          }
        }

        return null;
      } catch (e, stack) {
        log('[ChatMessage] Error parsing TRC message: $e');
        log('Stack trace: $stack');
        return null;
      }
    }

    // Add CKIN message parsing
    CkinMessage? parseCkinMessage(dynamic messageData) {
      try {
        final Map<String, dynamic> normalizedData = {};
        // Case 1: Handle List format (from your log)
        if (messageData is List) {
          // Handle list format from logs
          for (final item in messageData) {
            if (item is Map && item['name'] != null) {
              final key = item['name'].toString();
              normalizedData[key] = item['value'];
            }
          }
        } else if (messageData is Map) {
          // Handle if it's already a map (fallback)
          normalizedData.addAll(messageData.cast<String, dynamic>());
        }

        // Debug log to see transformed data
        log('Normalized CKIN data: $normalizedData');

        // Now parse with the normalized data
        return CkinMessage.fromJson(normalizedData);
      } catch (e, stack) {
        log('[ChatMessage] Error parsing CKIN message: $e');
        log('Stack trace: $stack');
        return null;
      }
    }

    // Parse staff services if message type is 'staff'
    List<StaffService>? parseStaffServices(dynamic messageData) {
      if (messageData is! Map) return null;

      try {
        final servicesData = messageData['servicesData'];
        if (servicesData is! Map) return null;
        final services = servicesData['services'];
        if (services is! List) return null;

        // Group entries by their service (CKIN, GATE, TRC, ...). The API sends
        // one entry per staff member, so several entries share the same service.
        final grouped = <String, List<Map>>{};
        for (final item in services) {
          if (item is! Map) continue;
          final service = item['service']?.toString();
          if (service == null || service.isEmpty) continue;
          grouped.putIfAbsent(service, () => []).add(item);
        }

        return grouped.entries.map((e) {
          final first = e.value.first;
          return StaffService(
            service: e.key,
            type: first['type']?.toString() ?? 'Default',
            serviceType: first['service_type']?.toString() ?? '',
            staffRequired:
                int.tryParse(first['staff_required']?.toString() ?? '') ??
                e.value.length,
            slaStart: StaffTime.fromJson(first['start']),
            slaRelease: StaffTime.fromJson(first['release']),
            assignments:
                e.value
                    .map(
                      (s) => StaffAssignment(
                        name: s['staff']?.toString() ?? '',
                        start: StaffTime.fromJson(s['start']),
                        release: StaffTime.fromJson(s['release']),
                      ),
                    )
                    .toList(),
          );
        }).toList();
      } catch (e) {
        log('[ChatMessage] Error parsing staff services: $e');
        return null;
      }
    }

    // New helper function to parse ARR messages
    ArrMessage? parseArrMessage(dynamic messageData) {
      if (messageData is! Map<String, dynamic>) return null;

      try {
        return ArrMessage(
          startTime: messageData['start_time']?.toString() ?? '--',
          endTime: messageData['end_time']?.toString() ?? '--',
          lofoRemarks: messageData['lofo_remarks']?.toString() ?? '--',
          dpr: messageData['dpr']?.toString() ?? '--',
          ohd: messageData['ohd']?.toString() ?? '--',
          mhbAhl: messageData['mhb_ahl']?.toString() ?? '--',
          lofo: messageData['lofo']?.toString() ?? '--',
        );
      } catch (e) {
        log('[ChatMessage] Error parsing ARR message: $e');
        return null;
      }
    }

    FhrMessage? parseFhrMessage(dynamic messageData) {
      if (messageData is! Map<String, dynamic>) return null;
      return FhrMessage(
        checkInIssues: messageData['CHECK-IN/TKTG ISSUES']?.toString() ?? '',
        rampIssues:
            messageData['RAMP/CREWDISRUPTIVE PAX ETC']?.toString() ?? '',
        otherIssues: messageData['OTHER']?.toString() ?? '',
        delayExplanation: messageData['DELAY EXPLANATION']?.toString() ?? '',
        deniedBoarding: messageData['INVOL DENIED BOARDING']?.toString() ?? '',
        missedConnection:
            messageData['MISSED ARTG-5 EXPLANATION']?.toString() ??
            messageData['MISSED ARTSG 5 EXPLANATION']?.toString() ??
            '--',
        safetyIssues: messageData['SAFETY/SECURITY/SYSTEM']?.toString() ?? '',
      );
    }

    // Parse SSR messages - returns null for missing/empty fields
    SsrMessage? parseSsrMessage(dynamic messageData) {
      if (messageData is! Map<String, dynamic>) return null;
      try {
        return SsrMessage(
          bdgp: messageData['BDGP']?.toString(),
          bbsl: messageData['BBSL']?.toString(),
          avih: messageData['AVIH']?.toString(),
        );
      } catch (e) {
        log('[ChatMessage] Error parsing SSR message: $e');
        return null;
      }
    }

    // Add DSR message parsing
    DsrMessage? parseDsrMessage(dynamic messageData) {
      if (messageData is! Map<String, dynamic>) return null;
      try {
        return DsrMessage.fromJson(messageData);
      } catch (e) {
        log('[ChatMessage] Error parsing DSR message: $e');
        return null;
      }
    }

    // Add Attachment message parsing
    AttachmentMessage? parseAttachmentMessage(dynamic messageData) {
      if (messageData is! Map<String, dynamic>) return null;
      try {
        return AttachmentMessage.fromJson(messageData);
      } catch (e) {
        log('[ChatMessage] Error parsing Attachment message: $e');
        return null;
      }
    }

    final senderId = toInt(json['sender_id']);
    final messageType = json['message_type']?.toString();

    return ChatMessage(
      id: 'optimistic-${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      senderName: json['sender_name']?.toString() ?? 'User',
      station: json['station']?.toString() ?? 'Unknown',
      message: json['message']?.toString() ?? '',
      attachment: json['attachment']?.toString(),
      type: messageType,
      messageFrom: json['message_from']?.toString(),
      time: json['created_at']?.toString() ?? '',
      isOwn: senderId == currentUserId,
      readBy: toIntList(json['read_by']),
      trcMessage:
          messageType == 'trc' ? parseTrcMessage(json['message']) : null,
      ckinMessage:
          messageType == 'ckin' ? parseCkinMessage(json['message']) : null,
      staffServicesMessage:
          messageType == 'staff' ? parseStaffServices(json['message']) : null,
      arrMessage:
          messageType == 'arr' ? parseArrMessage(json['message']) : null,
      fhrMessage:
          messageType == 'fhr' ? parseFhrMessage(json['message']) : null,
      ssrMessage:
          messageType == 'ssr' ? parseSsrMessage(json['message']) : null,
      dsrMessage:
          messageType == 'dsr' ? parseDsrMessage(json['message']) : null,
      attachmentMessage:
          messageType == 'attachment'
              ? parseAttachmentMessage(json['message'])
              : null,
    );
  }

  // Helper method to check if message is read by current user
  bool isReadByCurrentUser() {
    final currentUserId = DataStorageController.to.user.id;
    return readBy?.contains(currentUserId) ?? false;
  }

  dynamic toFirestoreMessageData() {
    if (type == 'simple') {
      return message;
    } else {
      // For complex messages, return the structured data
      return {if (fhrMessage != null) 'fhr': fhrMessage!.toMap()};
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_name': senderName,
      'station': station,
      'message': message,
      'attachment': attachment,
      'file_name': fileName,
      'message_type': type,
      'message_from': messageFrom,
      'created_at': time,
      'is_own': isOwn,
      'read_by': readBy,
      if (staffServicesMessage != null)
        'staff_services': staffServicesMessage!.map((s) => s.toMap()).toList(),
      if (trcMessage != null) 'trc_message': trcMessage!.toMap(),
      if (arrMessage != null) 'arr_message': arrMessage!.toMap(),
      if (fhrMessage != null) 'fhr_message': fhrMessage!.toMap(),
      if (ssrMessage != null) 'ssr_message': ssrMessage!.toMap(),
      if (dsrMessage != null) 'dsr_message': dsrMessage!.toMap(),
      if (ckinMessage != null) 'ckin_message': ckinMessage!.toMap(),
      if (attachmentMessage != null)
        'attachment_message': attachmentMessage!.toMap(),
    };
  }
}

class ArrMessage {
  final String startTime;
  final String endTime;
  final String lofoRemarks;
  final String dpr;
  final String ohd;
  final String mhbAhl;
  final String lofo;

  ArrMessage({
    required this.startTime,
    required this.endTime,
    required this.lofoRemarks,
    required this.dpr,
    required this.ohd,
    required this.mhbAhl,
    required this.lofo,
  });

  Map<String, dynamic> toMap() {
    return {
      'start_time': startTime,
      'end_time': endTime,
      'lofo_remarks': lofoRemarks,
      'dpr': dpr,
      'ohd': ohd,
      'mhb_ahl': mhbAhl,
      'lofo': lofo,
    };
  }
}

class SsrMessage {
  final String? bdgp; // Baggage
  final String? bbsl; // Baby stroller
  final String? avih; // Aviation health

  SsrMessage({this.bdgp, this.bbsl, this.avih});

  Map<String, dynamic> toMap() {
    return {
      'BDGP': bdgp,
      'BBSL': bbsl,
      'AVIH': avih,
    };
  }
}

// Add this new class for FHR message data
class FhrMessage {
  final String? checkInIssues;
  final String? rampIssues;
  final String? otherIssues;
  final String? delayExplanation;
  final String? deniedBoarding;
  final String? missedConnection;
  final String? safetyIssues;

  FhrMessage({
    this.checkInIssues,
    this.rampIssues,
    this.otherIssues,
    this.delayExplanation,
    this.deniedBoarding,
    this.missedConnection,
    this.safetyIssues,
  });

  Map<String, dynamic> toMap() {
    return {
      'CHECK-IN/TKTG ISSUES': checkInIssues,
      'RAMP/CREWDISRUPTIVE PAX ETC': rampIssues,
      'OTHER': otherIssues,
      'DELAY EXPLANATION': delayExplanation,
      'INVOL DENIED BOARDING': deniedBoarding,
      'MISSED ARTG-5 EXPLANATION': missedConnection,
      'SAFETY/SECURITY/SYSTEM': safetyIssues,
    };
  }
}

class StaffTime {
  final String? act;
  final String? pln;
  final String? sla;

  StaffTime({this.act, this.pln, this.sla});

  factory StaffTime.fromJson(dynamic json) {
    if (json is! Map) return StaffTime();
    return StaffTime(
      act: json['act']?.toString(),
      pln: json['pln']?.toString(),
      sla: json['sla']?.toString(),
    );
  }
}

class StaffAssignment {
  final String name;
  final StaffTime start;
  final StaffTime release;

  StaffAssignment({
    required this.name,
    required this.start,
    required this.release,
  });
}

class StaffService {
  final String service; // CKIN, GATE, B-COOR ...
  final String type; // Default
  final String serviceType; // DEPARTURE / ARRIVAL
  final int staffRequired;
  final StaffTime slaStart; // service-level SLA times (header row)
  final StaffTime slaRelease;
  final List<StaffAssignment> assignments;

  StaffService({
    required this.service,
    this.type = 'Default',
    this.serviceType = '',
    this.staffRequired = 0,
    StaffTime? slaStart,
    StaffTime? slaRelease,
    this.assignments = const [],
  }) : slaStart = slaStart ?? StaffTime(),
       slaRelease = slaRelease ?? StaffTime();

  String get employeeNames => assignments.map((a) => a.name).join(', ');

  Map<String, dynamic> toMap() {
    return {'service': service, 'employeeNames': employeeNames};
  }
}

class DsrMessage {
  final String date;
  final String paxName;
  final String serviceType;
  final int amount;
  final String flightNo;
  final String pnr;
  final String fop;
  final String currency;
  final String doi;

  const DsrMessage({
    required this.date,
    required this.paxName,
    required this.serviceType,
    required this.amount,
    required this.flightNo,
    required this.pnr,
    required this.fop,
    required this.currency,
    required this.doi,
  });

  factory DsrMessage.fromJson(Map<String, dynamic> json) {
    return DsrMessage(
      date: json['date']?.toString() ?? '--',
      paxName: json['pax_name']?.toString() ?? '--',
      serviceType: json['service_type']?.toString() ?? '--',
      amount: int.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      flightNo: json['flight_no']?.toString() ?? '--',
      pnr: json['pnr']?.toString() ?? '--',
      fop: json['fop']?.toString() ?? '--',
      currency: json['currency']?.toString() ?? '--',
      doi: json['doi']?.toString() ?? '--',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'pax_name': paxName,
      'service_type': serviceType,
      'amount': amount,
      'flight_no': flightNo,
      'pnr': pnr,
      'fop': fop,
      'currency': currency,
      'doi': doi,
    };
  }
}

class TrcMessage {
  final String name;
  final String mobile;
  final String remarks;
  final String pantry;
  final String captain;
  final String dow;
  final String doiTrc;
  final String mtow;
  final String rtow;
  final String taxi;
  final String block;
  final String trip;
  final String eet;
  final String tofFuel;
  final String uplifted;
  final String altn;
  final String beforeArrival;
  final String beforeDeparture;
  final String afterDeparture;
  final String flightId;
  final String aircraftTypeIcao;
  final String aircraftIcao;

  const TrcMessage({
    required this.name,
    required this.mobile,
    required this.remarks,
    required this.pantry,
    required this.captain,
    required this.dow,
    required this.doiTrc,
    required this.mtow,
    required this.rtow,
    required this.taxi,
    required this.block,
    required this.trip,
    required this.eet,
    required this.tofFuel,
    required this.uplifted,
    required this.altn,
    required this.beforeArrival,
    required this.beforeDeparture,
    required this.afterDeparture,
    required this.flightId,
    required this.aircraftTypeIcao,
    required this.aircraftIcao,
  });

  factory TrcMessage.fromJson(Map<String, dynamic> json) {
    return TrcMessage(
      name: json['name']?.toString() ?? '--',
      mobile: json['mobile']?.toString() ?? '--',
      remarks: json['remarks']?.toString() ?? '--',
      pantry: json['pantry']?.toString() ?? '--',
      captain: json['captain']?.toString() ?? '--',
      dow: json['dow']?.toString() ?? '--',
      doiTrc: json['doi_trc']?.toString() ?? '--',
      mtow: json['mtow']?.toString() ?? '--',
      rtow: json['rtow']?.toString() ?? '--',
      taxi: json['taxi']?.toString() ?? '--',
      block: json['block']?.toString() ?? '--',
      trip: json['trip']?.toString() ?? '--',
      eet: json['eet']?.toString() ?? '--',
      tofFuel: json['tof_fuel']?.toString() ?? '--',
      uplifted: json['uplifted']?.toString() ?? '--',
      altn: json['altn']?.toString() ?? '--',
      beforeArrival: json['before_arrival']?.toString() ?? '--',
      beforeDeparture: json['before_departure']?.toString() ?? '--',
      afterDeparture: json['after_departure']?.toString() ?? '--',
      flightId: json['flight_id']?.toString() ?? '--',
      aircraftTypeIcao: json['aircraft_type_icao']?.toString() ?? '--',
      aircraftIcao: json['aircraft_icao']?.toString() ?? '--',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'remarks': remarks,
      'pantry': pantry,
      'captain': captain,
      'dow': dow,
      'doi_trc': doiTrc,
      'mtow': mtow,
      'rtow': rtow,
      'taxi': taxi,
      'block': block,
      'trip': trip,
      'eet': eet,
      'tof_fuel': tofFuel,
      'uplifted': uplifted,
      'altn': altn,
      'before_arrival': beforeArrival,
      'before_departure': beforeDeparture,
      'after_departure': afterDeparture,
      'flight_id': flightId,
      'aircraft_type_icao': aircraftTypeIcao,
      'aircraft_icao': aircraftIcao,
    };
  }
}

class CkinMessage {
  final List<StaffMember> ckinStaff;
  final List<StaffMember> gateStaff;
  final List<StaffMember> gateSpvr;
  final List<StaffMember> spvr;
  final String? spvrRemarks;
  final String? flightSpecial;
  final String? flightBookingStatus;
  final String? flightScheduleInfo;
  final String? flightDocsCheck;
  final String? flightRamp;
  final String? flightOther;
  final String? flightId;
  final String? ckinWeb;
  final String? aircraftTypeIcao;
  final String? aircraftIcao;
  final String? capacityF;
  final String? capacityJ;
  final String? capacityC;
  final String? capacityS;
  final String? capacityW;
  final String? capacityM;
  final String? capacityY;
  final String? depIata;
  final String? arrIata;

  // Additional fields for the new data
  final int? cfgCapacityJ;
  final int? cfgCapacityY;
  final int? baggageGatePcs;
  final int? baggageGateWt;
  final int? baggageCkinPcs;
  final int? baggageCkinWt;
  final int? paxCBooked;
  final int? paxYBooked;
  final int? paxInfBooked;
  final int? paxJumpActual;
  final String? ckinDeskNo;
  final int? ckinDeskUsed;
  final String? ckinSecured;
  final String? securedGate;
  final String? ckinOpened;
  final String? bdgGateStarted;
  final String? ckinClosed;
  final String? bdgGateCompleted;
  final String? bdgGateOpened;
  final String? bdgGateClosed;

  CkinMessage({
    required this.ckinStaff,
    required this.gateStaff,
    required this.gateSpvr,
    required this.spvr,
    this.spvrRemarks,
    this.flightSpecial,
    this.flightBookingStatus,
    this.flightScheduleInfo,
    this.flightDocsCheck,
    this.flightRamp,
    this.flightOther,
    this.flightId,
    this.ckinWeb,
    this.aircraftTypeIcao,
    this.aircraftIcao,
    this.capacityF,
    this.capacityJ,
    this.capacityC,
    this.capacityS,
    this.capacityW,
    this.capacityM,
    this.capacityY,
    this.depIata,
    this.arrIata,
    this.cfgCapacityJ,
    this.cfgCapacityY,
    this.baggageGatePcs,
    this.baggageGateWt,
    this.baggageCkinPcs,
    this.baggageCkinWt,
    this.paxCBooked,
    this.paxYBooked,
    this.paxInfBooked,
    this.paxJumpActual,
    this.ckinDeskNo,
    this.ckinDeskUsed,
    this.ckinSecured,
    this.securedGate,
    this.ckinOpened,
    this.bdgGateStarted,
    this.ckinClosed,
    this.bdgGateCompleted,
    this.bdgGateOpened,
    this.bdgGateClosed,
  });

  factory CkinMessage.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    }

    // Helper to parse staff lists
    List<StaffMember> parseStaffList(dynamic staffData) {
      if (staffData == null) return [];
      if (staffData is List<StaffMember>) return staffData;

      if (staffData is List) {
        return staffData.map((item) {
          if (item is Map) {
            return StaffMember.fromJson(item.cast<String, dynamic>());
          }
          return StaffMember(id: '', name: item.toString());
        }).toList();
      }

      if (staffData is String) {
        try {
          final decoded = jsonDecode(staffData);
          return parseStaffList(decoded);
        } catch (e) {
          return [StaffMember(id: '', name: staffData)];
        }
      }

      if (staffData is Map) {
        return [StaffMember.fromJson(staffData.cast<String, dynamic>())];
      }

      return [];
    }

    return CkinMessage(
      ckinStaff: parseStaffList(json['ckin_staff']),
      gateStaff: parseStaffList(json['gate_staff']),
      gateSpvr: parseStaffList(json['gate_spvr']),
      spvr: parseStaffList(json['spvr']),
      spvrRemarks: json['spvr_remarks']?.toString() ?? '',
      flightSpecial: json['flight_special']?.toString() ?? '',
      flightBookingStatus: json['flight_booking_status']?.toString() ?? '',
      flightScheduleInfo: json['flight_schedule_info']?.toString() ?? '',
      flightDocsCheck: json['flight_docs_check']?.toString() ?? '',
      flightRamp: json['flight_ramp']?.toString() ?? '',
      flightOther: json['flight_other']?.toString() ?? '',
      flightId: json['flight_id']?.toString() ?? '',
      ckinWeb: json['ckin_web']?.toString() ?? '',
      aircraftTypeIcao: json['aircraft_type_icao']?.toString(),
      aircraftIcao: json['aircraft_icao']?.toString(),
      capacityF: json['capacity_f']?.toString(),
      capacityJ: json['capacity_j']?.toString(),
      capacityC: json['capacity_c']?.toString(),
      capacityS: json['capacity_s']?.toString(),
      capacityW: json['capacity_w']?.toString(),
      capacityM: json['capacity_m']?.toString(),
      capacityY: json['capacity_y']?.toString(),
      depIata: json['dep_iata']?.toString() ?? '',
      arrIata: json['arr_iata']?.toString() ?? '',
      cfgCapacityJ: toInt(json['cfg_capacity_j']),
      cfgCapacityY: toInt(json['cfg_capacity_y']),
      baggageGatePcs: toInt(json['baggage_gate_pcs']),
      baggageGateWt: toInt(json['baggage_gate_wt']),
      baggageCkinPcs: toInt(json['baggage_ckin_pcs']),
      baggageCkinWt: toInt(json['baggage_ckin_wt']),
      paxCBooked: toInt(json['pax_c_booked']),
      paxYBooked: toInt(json['pax_y_booked']),
      paxInfBooked: toInt(json['pax_inf_booked']),
      paxJumpActual: toInt(json['pax_jmp_actual']),
      ckinDeskNo: json['ckin_desk_no']?.toString() ?? '',
      ckinDeskUsed: toInt(json['ckin_desk_used']),
      ckinSecured: json['ckin_secured']?.toString() ?? '',
      securedGate: json['secured_gate']?.toString() ?? '',
      ckinOpened: json['ckin_opened']?.toString() ?? '',
      bdgGateStarted: json['bdg_gate_started']?.toString() ?? '',
      ckinClosed: json['ckin_closed']?.toString() ?? '',
      bdgGateCompleted: json['bdg_gate_completed']?.toString() ?? '',
      bdgGateOpened: json['bdg_gate_opened']?.toString() ?? '',
      bdgGateClosed: json['bdg_gate_closed']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ckin_staff': ckinStaff.map((s) => s.toMap()).toList(),
      'gate_staff': gateStaff.map((s) => s.toMap()).toList(),
      'gate_spvr': gateSpvr.map((s) => s.toMap()).toList(),
      'spvr': spvr.map((s) => s.toMap()).toList(),
      'spvr_remarks': spvrRemarks,
      'flight_special': flightSpecial,
      'flight_booking_status': flightBookingStatus,
      'flight_schedule_info': flightScheduleInfo,
      'flight_docs_check': flightDocsCheck,
      'flight_ramp': flightRamp,
      'flight_other': flightOther,
      'flight_id': flightId,
      'ckin_web': ckinWeb,
      'aircraft_type_icao': aircraftTypeIcao,
      'aircraft_icao': aircraftIcao,
      'capacity_f': capacityF,
      'capacity_j': capacityJ,
      'capacity_c': capacityC,
      'capacity_s': capacityS,
      'capacity_w': capacityW,
      'capacity_m': capacityM,
      'capacity_y': capacityY,
      'dep_iata': depIata,
      'arr_iata': arrIata,
      'cfg_capacity_j': cfgCapacityJ,
      'cfg_capacity_y': cfgCapacityY,
      'baggage_gate_pcs': baggageGatePcs,
      'baggage_gate_wt': baggageGateWt,
      'baggage_ckin_pcs': baggageCkinPcs,
      'baggage_ckin_wt': baggageCkinWt,
      'pax_c_booked': paxCBooked,
      'pax_y_booked': paxYBooked,
      'pax_inf_booked': paxInfBooked,
      'pax_jmp_actual': paxJumpActual,
      'ckin_desk_no': ckinDeskNo,
      'ckin_desk_used': ckinDeskUsed,
      'ckin_secured': ckinSecured,
      'secured_gate': securedGate,
      'ckin_opened': ckinOpened,
      'bdg_gate_started': bdgGateStarted,
      'ckin_closed': ckinClosed,
      'bdg_gate_completed': bdgGateCompleted,
      'bdg_gate_opened': bdgGateOpened,
      'bdg_gate_closed': bdgGateClosed,
    };
  }
}

class StaffMember {
  final String id;
  final String name;

  StaffMember({required this.id, required this.name});

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    return StaffMember(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class AttachmentMessage {
  final String messageAttach;
  final String filePath;
  final String fileExtension;
  final String? type;

  AttachmentMessage({
    required this.messageAttach,
    required this.filePath,
    required this.fileExtension,
    this.type,
  });

  factory AttachmentMessage.fromJson(Map<String, dynamic> json) {
    return AttachmentMessage(
      messageAttach: json['message_attach']?.toString() ?? '',
      filePath: json['file_path']?.toString() ?? '',
      fileExtension: json['file_extension']?.toString() ?? '',
      type: json['type']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message_attach': messageAttach,
      'file_path': filePath,
      'file_extension': fileExtension,
      'type': type,
    };
  }

  // Helper to determine file type category
  String getFileTypeCategory() {
    final ext = fileExtension.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'].contains(ext)) {
      return 'image';
    } else if (['pdf'].contains(ext)) {
      return 'pdf';
    } else if (['doc', 'docx', 'txt'].contains(ext)) {
      return 'document';
    } else if (['xls', 'xlsx', 'csv'].contains(ext)) {
      return 'spreadsheet';
    } else if (['mp4', 'mov', 'avi', 'mkv'].contains(ext)) {
      return 'video';
    } else if (['mp3', 'wav', 'aac'].contains(ext)) {
      return 'audio';
    } else {
      return 'file';
    }
  }
}
