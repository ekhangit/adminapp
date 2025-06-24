import 'package:aviation_app/screens/flightcomm/info/widget/chat_message_card.dart';
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
      controller: controller.scrollController,
      slivers: [
        // 🔵 Chat Messages
        Obx(
          () => SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final message = controller.messages[index];

              final isSentMe = message.isOwn;

              return Container(
                margin: EdgeInsets.only(
                  top: index == 0 ? 16 : 8,
                  bottom: index == controller.messages.length - 1 ? 32 : 0,
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
                        height: 35,
                        width: 35,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.getAvatarColor(
                            _getInitials(message.senderName),
                          ),
                        ),
                        child: FittedBox(
                          child: Text(
                            _getInitials(message.senderName),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    if (!isSentMe) const SizedBox(width: 8),
                    if (isSentMe) const SizedBox(width: 60),
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
                                topLeft:
                                    isSentMe
                                        ? const Radius.circular(12)
                                        : const Radius.circular(0),
                                topRight:
                                    isSentMe
                                        ? Radius.circular(0)
                                        : const Radius.circular(12),
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
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       // "${message.senderName} - ${message.station}",
                                  //       "Muhammad Ahmed Farooqi Muhammad Ahmed Farooqi",
                                  //       style: TextStyle(
                                  //         color: controller.getAvatarColor(
                                  //           _getInitials(message.senderName),
                                  //         ),
                                  //         fontSize: 15,
                                  //         fontWeight: FontWeight.w600,
                                  //       ),
                                  //     ),
                                  //     Spacer(),
                                  //     if (message.messageFrom != null) ...[
                                  //       const SizedBox(height: 8),
                                  //       Container(
                                  //         padding: const EdgeInsets.symmetric(
                                  //           horizontal: 8,
                                  //           vertical: 2.5,
                                  //         ),
                                  //         decoration: BoxDecoration(
                                  //           border: Border.all(
                                  //             color: controller.getAvatarColor(
                                  //               _getInitials(
                                  //                 message.senderName,
                                  //               ),
                                  //             ),
                                  //             width: 1.0,
                                  //           ),
                                  //           borderRadius: BorderRadius.circular(
                                  //             6,
                                  //           ),
                                  //         ),
                                  //         child: Text(
                                  //           message.messageFrom!,
                                  //           style: TextStyle(
                                  //             fontSize: 13,
                                  //             color: Colors.black87,
                                  //             fontWeight: FontWeight.w500,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ],
                                  // ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final maxWidth = constraints.maxWidth;

                                      return Row(
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: maxWidth * 0.9,
                                            ),
                                            child: Text(
                                              "${message.senderName} - ${message.station}",
                                              style: TextStyle(
                                                color: controller
                                                    .getAvatarColor(
                                                      _getInitials(
                                                        message.senderName,
                                                      ),
                                                    ),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          const Spacer(),
                                          if (message.messageFrom != null) ...[
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2.5,
                                                  ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: controller
                                                      .getAvatarColor(
                                                        _getInitials(
                                                          message.senderName,
                                                        ),
                                                      ),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
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
                                      );
                                    },
                                  ),

                                if (!isSentMe) SizedBox(height: 4),
                                // if (message.type == 'simple') ...[
                                //   Text(
                                //     message.message,
                                //     style: TextStyle(
                                //       color: Colors.black87,
                                //       fontSize: 15,
                                //     ),
                                //   ),
                                // ],
                                buildMessageContent(message),
                                // 🟡 Metadata if exists
                                // if (message.chatMetadata != null &&
                                //     message.chatMetadata!.isNotEmpty) ...[
                                //   const SizedBox(height: 8),
                                //   ...message.chatMetadata!.entries.map(
                                //     (entry) => Column(
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       children: [
                                //         Padding(
                                //           padding: const EdgeInsets.only(
                                //             bottom: 2.0,
                                //           ),
                                //           child: Text(
                                //             "${entry.key}: ${entry.value}",
                                //             style: const TextStyle(
                                //               fontSize: 13,
                                //               color: Colors.black87,
                                //               fontWeight: FontWeight.w600,
                                //             ),
                                //           ),
                                //         ),
                                //         if (entry.key !=
                                //             message
                                //                 .chatMetadata!
                                //                 .entries
                                //                 .last
                                //                 .key)
                                //           const Divider(
                                //             color: Colors.grey,
                                //             thickness: 0.4,
                                //             height: 8,
                                //           ),
                                //       ],
                                //     ),
                                //   ),
                                // ],
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    left: 4,
                                    right: 4,
                                  ),
                                  child: Text(
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
                    if (isSentMe) const SizedBox(width: 8),
                    if (isSentMe)
                      Container(
                        height: 35,
                        width: 35,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.getAvatarColor(
                            _getInitials(message.senderName),
                          ),
                        ),
                        child: FittedBox(
                          child: Text(
                            _getInitials(message.senderName),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    if (!isSentMe) const SizedBox(width: 60),
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

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    if (parts.length > 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }
}
