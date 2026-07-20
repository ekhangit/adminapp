import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

enum NotificationType { general, flight, license, readSign }

extension NotificationTypeX on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.general:
        return 'General';
      case NotificationType.flight:
        return 'Flight';
      case NotificationType.license:
        return 'License';
      case NotificationType.readSign:
        return 'Read & Sign';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.general:
        return Icons.notifications_outlined;
      case NotificationType.flight:
        return Icons.flight_outlined;
      case NotificationType.license:
        return Icons.badge_outlined;
      case NotificationType.readSign:
        return Icons.edit_document;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.general:
        return AppColors.colorPrimary;
      case NotificationType.flight:
        return const Color(0xFF3793F4);
      case NotificationType.license:
        return const Color(0xFFE8833A);
      case NotificationType.readSign:
        return const Color(0xFF2E9E4F);
    }
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final bool isRead;

  const NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  // No notifications for now — populate from the API later.
  static const List<NotificationItem> sample = [];
}
