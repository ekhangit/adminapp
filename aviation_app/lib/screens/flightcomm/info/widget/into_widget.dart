import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  final String text;
  final Color? textColor;

  const InfoText(this.text, {super.key, this.textColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }
}



class InfoBadge extends StatelessWidget {
  final String label;
  final Color color;

  const InfoBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
