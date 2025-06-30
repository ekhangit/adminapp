import 'package:asg_app/screens/flightcomm/info/widget/message_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';

class LirInfo extends StatelessWidget {
  const LirInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final messages = controller.flightDetail.value?.messages;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (messages?.lir.isNotEmpty ?? false) ...[
            ...messages!.lir.map(
              (msg) => buildMessageCard(msg, Colors.yellow.shade100),
            ),
          ],
        ],
      ),
    );
  }
}
