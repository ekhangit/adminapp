import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';
import 'widget/message_card.dart';

class CPMInfo extends StatelessWidget {
  const CPMInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final messages = controller.flightDetail.value?.messages;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (messages?.cpm.isNotEmpty ?? false) ...[
            ...messages!.cpm.map(
              (msg) => buildMessageCard(msg, Colors.yellow.shade100),
            ),
          ],
        ],
      ),
    );
  }
}
