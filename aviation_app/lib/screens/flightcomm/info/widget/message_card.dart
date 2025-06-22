import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../../../../models/flight_detail_model.dart';

Widget buildMessageCard(MessageData message, Color backgroundColor) {
  final formattedMessage = message.message.replaceAll('\r\n', '\n');
  final receivedTime = DateTime.parse(message.receivedDatetime);
  final updatedTime = DateTime.parse(message.updatedAt);

  final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formattedMessage),
        Divider(color: Colors.black54, thickness: 0.25, height: 30),
        Text(
          'Source: ${message.source}\n'
          'Received: ${dateFormat.format(receivedTime)}\n'
          'Updated: ${dateFormat.format(updatedTime)}',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ),
  );
}
