import 'dart:developer';

import '../controllers/storage/data_storage_controller.dart';

class ChatMessage {
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
  final List<int>? readBy;
  final List<StaffService>? staffServicesMessage;

  ChatMessage({
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
  });

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

    final senderId = toInt(json['sender_id']);

    return ChatMessage(
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
          json['message_type']?.toString() == 'staff'
              ? parseStaffServices(json['message'])
              : null,
    );
  }

  // Helper method to check if message is read by current user
  bool isReadByCurrentUser() {
    final currentUserId = DataStorageController.to.user.id;
    return readBy?.contains(currentUserId) ?? false;
  }
}

class StaffService {
  final String service;
  final String employeeNames;

  StaffService({required this.service, required this.employeeNames});
}
