import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_model.dart';

class ChatController extends GetxController {
  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messages.add(
      ChatMessage(
        message: text,
        isSentByMe: true,
        timestamp: DateTime.now(),
      ),
    );

    messageController.clear();

    // Simulate a reply
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(
        ChatMessage(
          message: "Auto reply to: $text",
          isSentByMe: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }
}
