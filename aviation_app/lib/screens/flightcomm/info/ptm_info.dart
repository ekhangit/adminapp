import 'package:aviation_app/screens/flightcomm/info/widget/message_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';

class PtmInfo extends StatelessWidget {
  const PtmInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final messages = controller.flightDetail.value?.messages;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PTM Section
          if (messages?.ptm.isNotEmpty ?? false) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      "PTM",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  ...messages!.ptm.map(
                    (msg) => buildMessageCard(msg, Colors.yellow.shade100),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
