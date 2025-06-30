import 'dart:math';
import 'package:flutter/material.dart';

class FlightArc extends StatelessWidget {
  final String duration;

  const FlightArc({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 15,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              CustomPaint(painter: ArcPainter()),

              const Icon(Icons.flight, color: Colors.blue, size: 25),
            ],
          ),
        ),
      ],
    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.shade400
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    const double padding = 10;
    final startX = padding;
    final endX = size.width - padding;
    final centerGap = 30.0; // width of gap for the flight icon

    final centerX = size.width / 2;
    final leftEnd = centerX - centerGap / 2;
    final rightStart = centerX + centerGap / 2;

    // Draw dashed left segment
    drawDashedLine(
      canvas,
      Offset(startX, size.height),
      Offset(leftEnd, size.height),
      paint,
    );

    // Draw dashed right segment
    drawDashedLine(
      canvas,
      Offset(rightStart, size.height),
      Offset(endX, size.height),
      paint,
    );

    // Dots at both ends
    final dotPaint = Paint()..color = Colors.blue.shade700;
    canvas.drawCircle(Offset(startX, size.height), 4, dotPaint);
    canvas.drawCircle(Offset(endX, size.height), 4, dotPaint);
  }

  void drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const double dashWidth = 5;
    const double dashSpace = 4;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final direction = Offset(dx / distance, dy / distance);

    double progress = 0;
    while (progress < distance) {
      final from = start + direction * progress;
      final to = start + direction * min(progress + dashWidth, distance);
      canvas.drawLine(from, to, paint);
      progress += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
