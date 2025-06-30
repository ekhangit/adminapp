import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';
import 'widget/message_card.dart';

class LdmInfo extends StatelessWidget {
  const LdmInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final messages = controller.flightDetail.value?.messages;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (messages?.ldm.isNotEmpty ?? false) ...[
            ...messages!.ldm.map(
              (msg) => buildMessageCard(msg, Colors.yellow.shade100),
            ),
          ],
        ],
      ),
    );
  }
}
