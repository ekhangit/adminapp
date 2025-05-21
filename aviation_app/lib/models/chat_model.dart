class ChatMessage {
  final String senderInitial;
  final String senderName;
  final String message;
  final String time;
  final bool isSentByMe;
  final String? type;
  final Map<String, dynamic>? metadata;


  ChatMessage({
    required this.senderInitial,
    required this.senderName,
    required this.message,
    required this.time,
    this.isSentByMe = false,
    this.type,
    this.metadata,
  });
}


