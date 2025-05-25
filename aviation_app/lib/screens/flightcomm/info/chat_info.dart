import 'package:aviation_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant.dart';
import '../../../controllers/flight/chat_controller.dart';

class ChatInfo extends StatelessWidget {
  const ChatInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return CustomScrollView(
      slivers: [
        // 🔵 Chat Messages
        Obx(
          () => SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final reversedMessages = controller.messages.reversed.toList();
              final message = reversedMessages[index];

              final isSentMe = false;

              return Container(
                margin: EdgeInsets.only(
                  top: index == 0 ? 16 : 8,
                  bottom: index == controller.messages.length - 1 ? 16 : 0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Incoming: Show avatar
                    if (!isSentMe)
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.getAvatarColor(
                            _getInitials(message.senderName),
                          ),
                        ),
                        child: Text(
                          _getInitials(message.senderName),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    if (!isSentMe) const SizedBox(width: 8),
                    // if (isSentMe) const SizedBox(width: 50),
                    // Chat bubble
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              border:
                                  message.messageFrom != null
                                      ? Border.all(
                                        color: AppColors.chatCardColor,
                                        width: 2.5,
                                      )
                                      : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isSentMe)
                                  Row(
                                    children: [
                                      Text(
                                        "${message.senderName} - ${message.station}",
                                        style: TextStyle(
                                          color: controller.getAvatarColor(
                                            _getInitials(message.senderName),
                                          ),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      Spacer(),
                                      if (message.messageFrom != null) ...[
                                        const SizedBox(height: 8),               
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2.5,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: controller.getAvatarColor(
                                                _getInitials(
                                                  message.senderName,
                                                ),
                                              ),
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            message.messageFrom!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                if (!isSentMe) SizedBox(height: 4),
                                if (message.type == null) ...[
                                  Text(
                                    message.message,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],

                                // 🟡 Metadata if exists
                                if (message.chatMetadata != null &&
                                    message.chatMetadata!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  ...message.chatMetadata!.entries.map(
                                    (entry) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 2.0,
                                          ),
                                          child: Text(
                                            "${entry.key}: ${entry.value}",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        if (entry.key !=
                                            message
                                                .chatMetadata!
                                                .entries
                                                .last
                                                .key)
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 0.4,
                                            height: 8,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    left: 4,
                                    right: 4,
                                  ),
                                  child: Text(
                                    // message.time,
                                    formatChatTimestamp(message.time),
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
                    // if (isSentMe) const SizedBox(width: 4),
                    if (!isSentMe) const SizedBox(width: 50),
                  ],
                ),
              );
            }, childCount: controller.messages.length),
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }
}
