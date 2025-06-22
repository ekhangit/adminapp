import 'package:flutter/material.dart';

import '../../../../models/chat_model.dart';

Widget buildMessageContent(ChatMessage message) {
  if (message.type == 'staff') {
    return _buildStaffMessage(message.staffServicesMessage ?? []);
  }
  return _buildRegularMessage(message);
}

Widget _buildRegularMessage(ChatMessage message) {
  return Text(
    message.message,
    style: const TextStyle(color: Colors.black87, fontSize: 15),
  );
}

Widget _buildStaffMessage(List<StaffService> services) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Staff',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 15,
        ),
      ),
      const SizedBox(height: 4),
      ...services.map(
        (service) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• ${service.service}: ',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 15,
                ),
              ),
              Expanded(
                child: Text(
                  service.employeeNames,
                  style: const TextStyle(color: Colors.black87, fontSize: 15),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
