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
  final Map<String, dynamic>? chatMetadata;
  final String time;
  final bool isOwn;
  final List<int>? readBy;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.station,
    required this.message,
    this.attachment,
    this.fileName,
    this.type,
    this.messageFrom,
    this.chatMetadata,
    required this.time,
    required this.isOwn,
    this.readBy,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final currentUserId = DataStorageController.to.user.id;

    // Helper function to safely convert to int
    int _toInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    }

    // Updated helper function to safely convert read_by array with string handling
    List<int>? _toIntList(dynamic value) {
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

    final senderId = _toInt(json['sender_id']);

    return ChatMessage(
      senderId: senderId,
      senderName: json['sender_name']?.toString() ?? 'User',
      station:
          json['station']?.toString() ?? 'Unknown', // Use station from JSON
      message: json['message']?.toString() ?? '',
      attachment: json['attachment']?.toString(),
      fileName: json['file_name']?.toString(),
      type: json['message_type']?.toString(),
      messageFrom: json['message_from']?.toString(),
      chatMetadata:
          json['chat'] != null ? Map<String, dynamic>.from(json['chat']) : null,
      time: json['created_at']?.toString() ?? '',
      isOwn: senderId == currentUserId,
      readBy: _toIntList(json['read_by']),
    );
  }

  // Helper method to check if message is read by current user
  bool isReadByCurrentUser() {
    final currentUserId = DataStorageController.to.user.id;
    return readBy?.contains(currentUserId) ?? false;
  }
}
