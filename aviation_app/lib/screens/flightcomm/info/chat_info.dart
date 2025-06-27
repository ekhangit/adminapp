import 'package:aviation_app/screens/flightcomm/info/widget/chat_message_card.dart';
import 'package:aviation_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../controllers/flight/chat_controller.dart';
import '../../../models/chat_model.dart';

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

              return VisibilityDetector(
                key: Key('${message.senderId}-${message.time}'),
                onVisibilityChanged: (info) {
                  if (info.visibleFraction > 0.5) {
                    controller.markSingleMessageRead(message);
                  }
                },
                child: Container(
                  // color: Colors.yellow,
                  margin: EdgeInsets.only(
                    top: index == 0 ? 16 : 2,
                    bottom: index == controller.messages.length - 1 ? 16 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        isSentMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      // Incoming: Show avatar
                      if (!isSentMe) ...[
                        _buildAvatar(context, controller, message),
                        // const SizedBox(width: 8),
                      ],
                      // if (!isSentMe) const SizedBox(width: 8),
                      if (isSentMe) const SizedBox(width: 60),
                      // Chat bubble
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                top: 4,
                                bottom: 4,
                                left: 12,
                                right: 12,
                              ),
                              decoration: BoxDecoration(
                                // color: Colors.yellow,
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
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    isSentMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                children: [
                                  // if (!isSentMe)
                                  // LayoutBuilder(
                                  //   builder: (context, constraints) {
                                  //     final maxWidth = constraints.maxWidth;

                                  //     return Row(
                                  //       children: [
                                  //         ConstrainedBox(
                                  //           constraints: BoxConstraints(
                                  //             maxWidth: maxWidth * 0.9,
                                  //           ),
                                  //           child: Text(
                                  //             "${message.senderName} - ${message.station}",
                                  //             style: TextStyle(
                                  //               color: controller
                                  //                   .getAvatarColor(
                                  //                     _getInitials(
                                  //                       message.senderName,
                                  //                     ),
                                  //                   ),
                                  //               fontSize: 14,
                                  //               fontWeight: FontWeight.w600,
                                  //             ),
                                  //             overflow:
                                  //                 TextOverflow.ellipsis,
                                  //             maxLines: 1,
                                  //           ),
                                  //         ),
                                  //         const Spacer(),
                                  //         if (message.messageFrom !=
                                  //             null) ...[
                                  //           Container(
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //                   horizontal: 8,
                                  //                   vertical: 2.5,
                                  //                 ),
                                  //             decoration: BoxDecoration(
                                  //               border: Border.all(
                                  //                 color: controller
                                  //                     .getAvatarColor(
                                  //                       _getInitials(
                                  //                         message
                                  //                             .senderName,
                                  //                       ),
                                  //                     ),
                                  //                 width: 1.0,
                                  //               ),
                                  //               borderRadius:
                                  //                   BorderRadius.circular(
                                  //                     6,
                                  //                   ),
                                  //             ),
                                  //             child: Text(
                                  //               message.messageFrom!,
                                  //               style: TextStyle(
                                  //                 fontSize: 13,
                                  //                 color: Colors.black87,
                                  //                 fontWeight:
                                  //                     FontWeight.w500,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ],
                                  //     );
                                  //   },
                                  // ),
                                  if (!isSentMe) ...[
                                    _buildSenderInfo(
                                      context,
                                      controller,
                                      message,
                                    ),
                                  ],

                                  if (!isSentMe) SizedBox(height: 4),
                                  // Message content
                                  buildMessageContent(message),
                                  // Container(
                                  //   alignment: Alignment.centerRight,
                                  //   padding: const EdgeInsets.only(
                                  //     top: 8,
                                  //     left: 4,
                                  //     right: 4,
                                  //   ),
                                  //   child: Text(
                                  //     formatChatTimestamp(message.time),
                                  //     style: TextStyle(
                                  //       fontSize: 11,
                                  //       color: Colors.grey.shade600,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Timestamp
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 8),
                                  //   child: Align(
                                  //     alignment:
                                  //         isSentMe
                                  //             ? Alignment.centerRight
                                  //             : Alignment.centerLeft,
                                  //     child: Text(
                                  //       formatChatTimestamp(message.time),
                                  //       style: TextStyle(
                                  //         fontSize: 11,
                                  //         color: Colors.grey.shade600,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // if (isSentMe) ...[
                      //   _buildAvatar(context, controller, message),
                      // ],
                      if (!isSentMe) const SizedBox(width: 60),
                    ],
                  ),
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

  Widget _buildAvatar(
    BuildContext context,
    ChatController controller,
    ChatMessage message,
  ) {
    return Container(
      height: 35,
      width: 35,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: controller.getAvatarColor(_getInitials(message.senderName)),
      ),
      child: FittedBox(
        child: Text(
          _getInitials(message.senderName),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildSenderInfo(
    BuildContext context,
    ChatController controller,
    ChatMessage message,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${message.senderName} - ${message.station}",
            style: TextStyle(
              color: controller.getAvatarColor(
                _getInitials(message.senderName),
              ),
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        if (message.messageFrom != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
            decoration: BoxDecoration(
              border: Border.all(
                color: controller.getAvatarColor(
                  _getInitials(message.senderName),
                ),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              message.messageFrom!,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
