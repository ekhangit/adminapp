import 'package:aviation_app/screens/flightcomm/info/widget/chat_message_card.dart';
import 'package:aviation_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../controllers/flight/chat_controller.dart';
import '../../../models/chat_model.dart';
import 'package:intl/intl.dart';

class ChatInfo extends StatelessWidget {
  const ChatInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return CustomScrollView(
      controller: controller.scrollController,
      reverse: true,
      slivers: [
        // 🔵 Chat Messages
        Obx(() {
          final groupedMessages = _groupMessagesByDate(controller.messages);
          final dateKeys =
              groupedMessages.keys.toList()..sort(
                (a, b) => b.compareTo(a),
              ); // Sort dates descending for reverse view

          // Return empty widget if there are no messages
          // if (dateKeys.isEmpty) {
          //   return SliverToBoxAdapter(
          //     child: Center(
          //       child: Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Text(
          //           'No messages yet',
          //           style: TextStyle(color: Colors.grey[600], fontSize: 16),
          //         ),
          //       ),
          //     ),
          //   );
          // }

          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= dateKeys.length) return const SizedBox.shrink();

              final date = dateKeys[index];
              final messages = groupedMessages[date]!;

              // final message = controller.messages[index];
              // final isSentMe = message.isOwn;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Messages for this date (in order for bottom-up display)
                  ...messages.asMap().entries.map((entry) {
                    final isFirstMessage = index == 0 && entry.key == 0;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: isFirstMessage ? 12.0 : 0.0,
                      ),
                      child: _buildMessageItem(controller, entry.value),
                    );
                  }),
                ],
              );

              // return VisibilityDetector(
              //   key: Key('${message.senderId}-${message.time}'),
              //   onVisibilityChanged: (info) {
              //     if (info.visibleFraction > 0.5) {
              //       controller.markSingleMessageRead(message);
              //     }
              //   },
              //   child: Container(
              //     // color: Colors.yellow,
              //     margin: EdgeInsets.only(
              //       top: index == 0 ? 16 : 2,
              //       bottom: index == controller.messages.length - 1 ? 16 : 0,
              //     ),
              //     padding: const EdgeInsets.symmetric(horizontal: 12),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment:
              //           isSentMe
              //               ? MainAxisAlignment.end
              //               : MainAxisAlignment.start,
              //       children: [
              //         // Incoming: Show avatar
              //         if (!isSentMe) ...[
              //           _buildAvatar(context, controller, message),
              //           // const SizedBox(width: 8),
              //         ],
              //         // if (!isSentMe) const SizedBox(width: 8),
              //         if (isSentMe) const SizedBox(width: 60),
              //         // Chat bubble
              //         Flexible(
              //           child: Column(
              //             mainAxisSize: MainAxisSize.min,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Container(
              //                 padding: const EdgeInsets.only(
              //                   top: 4,
              //                   bottom: 4,
              //                   left: 12,
              //                   right: 12,
              //                 ),
              //                 decoration: BoxDecoration(
              //                   // color: Colors.yellow,
              //                   borderRadius: BorderRadius.only(
              //                     topLeft:
              //                         isSentMe
              //                             ? const Radius.circular(12)
              //                             : const Radius.circular(0),
              //                     topRight:
              //                         isSentMe
              //                             ? Radius.circular(0)
              //                             : const Radius.circular(12),
              //                     bottomLeft: Radius.circular(12),
              //                     bottomRight: Radius.circular(12),
              //                   ),
              //                   border:
              //                       message.messageFrom != null
              //                           ? Border.all(
              //                             color: AppColors.chatCardColor,
              //                             width: 2.5,
              //                           )
              //                           : null,
              //                 ),
              //                 child: Column(
              //                   mainAxisSize: MainAxisSize.min,
              //                   crossAxisAlignment:
              //                       isSentMe
              //                           ? CrossAxisAlignment.end
              //                           : CrossAxisAlignment.start,
              //                   children: [
              //                     if (!isSentMe) ...[
              //                       _buildSenderInfo(
              //                         context,
              //                         controller,
              //                         message,
              //                       ),
              //                     ],

              //                     if (!isSentMe) SizedBox(height: 4),
              //                     // Message content
              //                     buildMessageContent(message),
              //                     // Timestamp
              //                     // Padding(
              //                     //   padding: const EdgeInsets.only(top: 8),
              //                     //   child: Align(
              //                     //     alignment:
              //                     //         isSentMe
              //                     //             ? Alignment.centerRight
              //                     //             : Alignment.centerLeft,
              //                     //     child: Text(
              //                     //       formatChatTimestamp(message.time),
              //                     //       style: TextStyle(
              //                     //         fontSize: 11,
              //                     //         color: Colors.grey.shade600,
              //                     //       ),
              //                     //     ),
              //                     //   ),
              //                     // ),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         if (!isSentMe) const SizedBox(width: 60),
              //       ],
              //     ),
              //   ),
              // );
            }, childCount: controller.messages.length),
          );
        }),
      ],
    );
  }

  // Build individual message item
  Widget _buildMessageItem(ChatController controller, ChatMessage message) {
    final isSentMe = message.isOwn;

    // Parse message time string to DateTime
    DateTime messageDateTime;
    try {
      messageDateTime = DateTime.parse(message.time).toLocal();
    } catch (e) {
      messageDateTime = DateTime.now().toLocal();
    }

    return VisibilityDetector(
      key: Key('${message.senderId}-${message.time}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          controller.markSingleMessageRead(message);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isSentMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isSentMe) _buildAvatar(Get.context!, controller, message),
            if (isSentMe) const SizedBox(width: 60),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft:
                        isSentMe
                            ? const Radius.circular(8)
                            : const Radius.circular(4),
                    topRight:
                        isSentMe
                            ? const Radius.circular(4)
                            : const Radius.circular(8),
                    bottomLeft: const Radius.circular(8),
                    bottomRight: const Radius.circular(8),
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
                    if (!isSentMe)
                      _buildSenderInfo(Get.context!, controller, message),
                    if (!isSentMe) const SizedBox(height: 4),
                    buildMessageContent(message),
                  ],
                ),
              ),
            ),
            if (!isSentMe) const SizedBox(width: 60),
          ],
        ),
      ),
    );
  }

  // Group messages by date (Today, Yesterday, or formatted date)
  Map<DateTime, List<ChatMessage>> _groupMessagesByDate(
    List<ChatMessage> messages,
  ) {
    final grouped = <DateTime, List<ChatMessage>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final message in messages) {
      // Parse string to DateTime and convert to local time
      DateTime messageTime;
      try {
        // Try parsing as ISO format
        messageTime = DateTime.parse(message.time).toLocal();
      } catch (e) {
        // If parsing fails, use current time as fallback
        messageTime = DateTime.now().toLocal();
      }

      final messageDay = DateTime(
        messageTime.year,
        messageTime.month,
        messageTime.day,
      );

      grouped.putIfAbsent(messageDay, () => []).add(message);
    }

    // Sort messages within each group by time (newest first for reverse view)
    grouped.forEach((key, value) {
      value.sort((a, b) {
        try {
          final timeA = DateTime.parse(a.time);
          final timeB = DateTime.parse(b.time);
          return timeB.compareTo(timeA); // Descending order
        } catch (e) {
          return 0;
        }
      });
    });

    return grouped;
  }

  // Build date header widget
  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    String dateText;
    if (date == today) {
      dateText = 'Today';
    } else if (date == yesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('dd MMM').format(date);
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300]!.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          dateText,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
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
