import 'package:gsrm_live_app/screens/flightcomm/info/widget/message_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';

class PsmInfo extends StatelessWidget {
  const PsmInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    final messages = controller.flightDetail.value?.messages;
    final psmMessages = messages?.psm ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (psmMessages.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No messages available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          if (psmMessages.isNotEmpty)
            ...psmMessages.map(
              (msg) => buildMessageCard(msg, Colors.yellow.shade100),
            ),
        ],
      ),
    );
  }
}
