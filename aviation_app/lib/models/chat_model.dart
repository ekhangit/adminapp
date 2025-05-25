class ChatMessage {
  final int flightId;
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

  ChatMessage({
    required this.flightId,
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
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      flightId: json['flight_id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      senderName: json['sender_name'] ?? '',
      station: json['station'] ?? '',
      message: json['message'] ?? '',
      attachment: json['attachment'],
      fileName: json['file_name'],
      type: json['type'],
      messageFrom: json['message_from'],
      chatMetadata:
          json['chat'] != null ? Map<String, dynamic>.from(json['chat']) : null,
      time: json['created_at'] ?? '',
    );
  }
}
