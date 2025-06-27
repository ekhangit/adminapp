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
  final ArrMessage? arrMessage;
  final FhrMessage? fhrMessage;
  final SsrMessage? ssrMessage;
  final DsrMessage? dsrMessage;

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
    this.staffServicesMessage,
    this.arrMessage,
    this.fhrMessage,
    this.ssrMessage,
    this.dsrMessage,
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

    // Parse staff services if message type is 'staff'
    List<StaffService>? parseStaffServices(dynamic messageData) {
      if (messageData is! Map<String, dynamic>) return null;

      try {
        final servicesData =
            messageData['servicesData'] as Map<String, dynamic>?;
        final services = servicesData?['services'] as List<dynamic>?;

        return services?.map((service) {
          return StaffService(
            service: service['service'] as String,
            employeeNames: service['employeeNames'] as String,
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
        checkInIssues: messageData['CHECK-IN/TKTG ISSUES']?.toString() ?? '--',
        rampIssues:
            messageData['RAMP/CREWDISRUPTIVE PAX ETC']?.toString() ?? '--',
        otherIssues: messageData['OTHER']?.toString() ?? '--',
        delayExplanation: messageData['DELAY EXPLANATION']?.toString() ?? '--',
        deniedBoarding:
            messageData['INVOL DENIED BOARDING']?.toString() ?? '--',
        missedConnection:
            messageData['MISSED ARTG-5 EXPLANATION']?.toString() ?? '--',
        safetyIssues: messageData['SAFETY/SECURITY/SYSTEM']?.toString() ?? '--',
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

    final senderId = toInt(json['sender_id']);
    final messageType = json['message_type']?.toString();

    return ChatMessage(
      id: 'optimistic-${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      senderName: json['sender_name']?.toString() ?? 'User',
      station: json['station']?.toString() ?? 'Unknown',
      message: json['message']?.toString() ?? '',
      attachment: json['attachment']?.toString(),
      type: json['message_type']?.toString(),
      messageFrom: json['message_from']?.toString(),
      time: json['created_at']?.toString() ?? '',
      isOwn: senderId == currentUserId,
      readBy: toIntList(json['read_by']),
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
}

class SsrMessage {
  final String? bdgp; // Baggage
  final String? bbsl; // Baby stroller
  final String? avih; // Aviation health

  SsrMessage({this.bdgp, this.bbsl, this.avih});
}

// Add this new class for FHR message data
class FhrMessage {
  final String checkInIssues;
  final String rampIssues;
  final String otherIssues;
  final String delayExplanation;
  final String deniedBoarding;
  final String missedConnection;
  final String safetyIssues;

  FhrMessage({
    required this.checkInIssues,
    required this.rampIssues,
    required this.otherIssues,
    required this.delayExplanation,
    required this.deniedBoarding,
    required this.missedConnection,
    required this.safetyIssues,
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

class StaffService {
  final String service;
  final String employeeNames;

  StaffService({required this.service, required this.employeeNames});
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
