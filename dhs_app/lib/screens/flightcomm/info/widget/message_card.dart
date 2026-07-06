import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../../../models/flight_detail_model.dart';

Widget buildMessageCard(MessageData message, Color backgroundColor, {String? title}) {
  final formattedMessage = message.message.replaceAll('\r\n', '\n');
  final receivedTime = DateTime.parse(message.receivedDatetime);
  final updatedTime = DateTime.parse(message.updatedAt);

  final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dynamic Header (only show if title is provided)
        if (title != null) ...[
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Message Content
        Text(
          formattedMessage,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 16),

        // Source, Received and Updated info
        Text(
          'Source: ${message.source}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Received: ${dateFormat.format(receivedTime)}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Updated: ${dateFormat.format(updatedTime)}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}
