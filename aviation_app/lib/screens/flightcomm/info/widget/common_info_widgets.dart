import 'package:flutter/material.dart';
import '../../../../constant.dart';
import '../../../../controllers/flight/chat_controller.dart';

/// Common card widget for info screens
class InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const InfoCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// Info row widget for displaying label-value pairs
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoRow(this.label, this.value, {super.key, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final displayValue = (value.isEmpty || value == '') ? '-' : value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              displayValue,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid row widget for displaying items in a horizontal row
class InfoGridRow extends StatelessWidget {
  final List<Widget> items;

  const InfoGridRow(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => Expanded(child: item)).toList(),
    );
  }
}

/// Grid item widget for displaying label-value pairs in grid layout
class InfoGridItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isPlaceholder;

  const InfoGridItem(
    this.label,
    this.value, {
    super.key,
    this.valueColor,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPlaceholder) {
      return const SizedBox.shrink();
    }

    final displayValue = (value.isEmpty || value == '') ? '-' : value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              displayValue,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Flight Details Grid widget - Common for all info screens
class FlightDetailsGrid extends StatelessWidget {
  final ChatController controller;

  const FlightDetailsGrid({super.key, required this.controller});

  String getValueOrDash(String? value) {
    return (value?.isNotEmpty ?? false) ? value! : '-';
  }

  @override
  Widget build(BuildContext context) {
    final flight = controller.flightDetail.value;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfoRow(
                "Flight No",
                getValueOrDash(flight?.basicDetails.flightInfo),
              ),
            ),
            Expanded(
              child: InfoRow(
                "Callsign",
                getValueOrDash(flight?.basicDetails.callSign),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InfoRow(
                "Date",
                getValueOrDash(formatDate(flight?.basicDetails.date ?? "")),
              ),
            ),
            Expanded(
              child: InfoRow(
                "A/C Type",
                getValueOrDash(flight?.aircraftType?.icao),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InfoRow(
                "A/C Regn",
                getValueOrDash(flight?.aircraft?.name),
              ),
            ),
            Expanded(
              child: InfoRow("Stand", getValueOrDash(flight?.basicDetails.pos)),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InfoRow("Gate", getValueOrDash(flight?.basicDetails.gate)),
            ),
            Expanded(
              child: InfoRow(
                "Baggage Belt",
                getValueOrDash(flight?.basicDetails.beggageBelt),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
