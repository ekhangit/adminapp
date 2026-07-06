import 'package:dhs_app/screens/flightcomm/info/widget/chat_message_card.dart';
import 'package:dhs_app/utils/app_colors.dart';
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

    // Calculate 7.5% of screen height for bottom padding
    final screenHeight = MediaQuery.of(context).size.height;
    final topAndBottomPadding = screenHeight * 0.025;

    return CustomScrollView(
      controller: controller.scrollController,
      reverse: true,
      slivers: [
        // Add bottom padding
        SliverToBoxAdapter(child: SizedBox(height: topAndBottomPadding)),

        // 🔵 Chat Messages
        Obx(() {
          final groupedMessages = _groupMessagesByDate(controller.messages);
          final dateKeys =
              groupedMessages.keys.toList()..sort(
                (a, b) => b.compareTo(a),
              ); // Sort dates descending (newest first in array, appears at bottom with reverse)

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
                    final isLastDate = index == dateKeys.length - 1;
                    final isLastMessage = entry.key == messages.length - 1;
                    final isLastOverall = isLastDate && isLastMessage;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: isLastOverall ? 12.0 : 0.0,
                      ),
                      child: _buildMessageItem(controller, entry.value),
                    );
                  }),
                ],
              );
            }, childCount: dateKeys.length),
          );
        }),

        SliverToBoxAdapter(child: SizedBox(height: topAndBottomPadding)),
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
            if (!isSentMe) ...[
              _buildAvatar(Get.context!, controller, message),
              const SizedBox(width: 8),
            ],
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
    // final now = DateTime.now();
    // final today = DateTime(now.year, now.month, now.day);
    // final yesterday = today.subtract(const Duration(days: 1));

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

    // Sort messages within each group by time (oldest first in array, appears at bottom with reverse)
    grouped.forEach((key, value) {
      value.sort((a, b) {
        try {
          final timeA = DateTime.parse(a.time);
          final timeB = DateTime.parse(b.time);
          return timeA.compareTo(
            timeB,
          ); // Ascending order (oldest first, newest last)
        } catch (e) {
          return 0;
        }
      });
    });

    return grouped;
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
      height: 30.0,
      width: 30.0,
      padding: const EdgeInsets.all(6),
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
            fontSize: 13.5,
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
    // Parse message time
    DateTime messageDateTime;
    try {
      // print('[ChatInfo] Raw message time: ${message.time}');
      // print('[ChatInfo] Message from: ${message.senderName}');
      messageDateTime = DateTime.parse(message.time).toLocal();
      // print('[ChatInfo] Parsed DateTime (local): $messageDateTime');
    } catch (e) {
      print('[ChatInfo] Error parsing time: $e');
      messageDateTime = DateTime.now().toLocal();
    }

    // Format date and time
    final timeStr = DateFormat('HH:mm').format(messageDateTime);
    final dateStr = DateFormat('MMM dd, yyyy').format(messageDateTime);
    // print('[ChatInfo] Formatted: $timeStr $dateStr');

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          Flexible(
            child: Text(
              message.station.isNotEmpty && message.station != 'Unknown'
                  ? '${message.senderName} - ${message.station}'
                  : message.senderName,
              style: TextStyle(
                color: controller.getAvatarColor(
                  _getInitials(message.senderName),
                ),
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$timeStr $dateStr',
            style: TextStyle(
              color: Color(0xFF676666),
              fontSize: 10,
              fontWeight: FontWeight.w400,
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
      ),
    );
  }
}
