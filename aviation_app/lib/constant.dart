import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


// Server Configuration
const apiUrl = "https://staging.avsysdev.com";

const String appName = "AvBIS";
const String fontFamily = "Helvetica";

const LinearGradient appThemeGradientSoft = LinearGradient(
  colors: [Color(0xFF003862), Color.fromARGB(255, 78, 135, 179)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient appThemeGradientSoft2 = LinearGradient(
  colors: [Color(0xFF003862), Color.fromARGB(255, 78, 135, 179)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

/// Generates a random color
Color getRandomColor() {
  final colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.indigo,
  ];
  return colors[Random().nextInt(colors.length)];
}

String formatFlightTime(String dateTimeStr) {
  try {
    final dateTime = DateTime.parse(dateTimeStr);
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day $hour:$minute';
  } catch (_) {
    return dateTimeStr; // fallback if parsing fails
  }
}

String formatDate(String rawDate) {
  final date = DateTime.parse(rawDate);
  final formatter = DateFormat('dd MMM yy'); // → 21 May 25
  return formatter.format(date);
}

String formatChatTimestamp(String raw) {
  try {
    final parsed = DateTime.parse(raw); // "2025-05-22 21:22:57"
    final formatted = DateFormat("dd MMM yy  HH:mm").format(parsed);
    return formatted;
  } catch (_) {
    return raw; // fallback if parsing fails
  }
}