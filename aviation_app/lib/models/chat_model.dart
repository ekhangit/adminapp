class ChatMessage {
  final String senderInitial;
  final String senderName;
  final String message;
  final String time;
  final bool isSentByMe;

  ChatMessage({
    required this.senderInitial,
    required this.senderName,
    required this.message,
    required this.time,
    this.isSentByMe = false,
  });
}


