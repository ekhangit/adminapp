import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';
import 'widget/message_card.dart';

class MvtInfo extends StatelessWidget {
  const MvtInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final messages = controller.flightDetail.value?.messages;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (messages?.mvtDeparture.isNotEmpty ?? false) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "DEPARTURE",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ...messages!.mvtDeparture.map(
              (msg) => buildMessageCard(msg, Colors.green.shade100),
            ),
          ],
          if (messages?.mvtArrival.isNotEmpty ?? false) ...[
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "ARRIVAL",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ...messages!.mvtArrival.map(
              (msg) => buildMessageCard(msg, Colors.blue.shade100),
            ),
          ],
        ],
      ),
    );
  }
}
