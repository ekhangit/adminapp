import 'dart:math';

import 'package:flutter/material.dart';

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
