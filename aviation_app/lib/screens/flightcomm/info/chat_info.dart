import 'package:aviation_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';

class ChatInfo extends StatelessWidget {
  const ChatInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return CustomScrollView(
      slivers: [
        // 🔵 Chat Messages
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final reversedMessages = controller.messages.reversed.toList();
            final message = reversedMessages[index];

            final isSentMe = message.isSentByMe;

            return Container(
              margin: EdgeInsets.only(
                top: index == 0 ? 16 : 8,
                bottom: index == controller.messages.length - 1 ? 16 : 0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    isSentMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  // Incoming: Show avatar
                  if (!isSentMe)
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 6),
                    //   child: CircleAvatar(
                    //     backgroundColor: controller.getAvatarColor(
                    //       message.senderInitial,
                    //     ),
                    //     radius: 17.5,
                    //     child: Text(
                    //       message.senderInitial,
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.w600,
                    //         fontSize: 14,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.getAvatarColor(message.senderInitial),
                      ),
                      child: Text(
                        message.senderInitial,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  if (!isSentMe) const SizedBox(width: 8),
                  if (isSentMe) const SizedBox(width: 50),
                  // Chat bubble
                  Flexible(
                    child: Column(
                      crossAxisAlignment:
                          isSentMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSentMe
                                    ? AppColors.chatCardColor
                                    : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(isSentMe ? 12 : 0),
                              topRight: Radius.circular(isSentMe ? 0 : 12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isSentMe)
                                Text(
                                  message.senderName,
                                  style: TextStyle(
                                    color: controller.getAvatarColor(
                                      message.senderInitial,
                                    ),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              if (!isSentMe) SizedBox(height: 4),
                              Text(
                                message.message,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(
                                  top: 4,
                                  left: 4,
                                  right: 4,
                                ),
                                child: Text(
                                  message.time,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSentMe) const SizedBox(width: 4),
                  if (!isSentMe) const SizedBox(width: 50),
                ],
              ),
            );
          }, childCount: controller.messages.length),
        ),
      ],
    );
  }
}
