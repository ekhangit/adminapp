import 'package:flutter/material.dart';

class TrcInfo extends StatelessWidget {
  const TrcInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        children: [
          InfoSection(
            data: {
              "Flight No": "IB 1332",
              "Callsign": "IBE1332",
              "Date": "29 APR 2025",
              "A/C Type": "A320",
              "A/C Regn": "EC-MNR",
              "Gate": "B37",
              "Stand": "804",
              "Baggage Belt": "2",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "TRC Info",
            data: {
              "TRC": "Yes",
              "Mobile No": "+34 655 555 555",
              "TRC RMKS": "TRC staff waiting at Gate B37",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "A/Data",
            data: {
              "CREW": "6",
              "PANTRY": "Yes",
              "CAPTAIN": "CPT John Doe",
              "DOW": "35,000 kg",
              "DOI": "1,000 kg",
              "MTOW": "73,500 kg",
              "RTOW": "72,800 kg",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Fuel Data",
            data: {
              "TAXI+APU": "300 kg",
              "BLOCK": "4,500 kg",
              "TRIP": "3,800 kg",
              "EET": "2:10",
              "TAKE OFF": "4,200 kg",
              "UPLIFTED": "5,000 kg",
              "ALTN": "800 kg",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "F.O.D",
            data: {
              "Before Arrival": "Clean",
              "Before Departure": "Checked",
              "After Departure": "Pending",
            },
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "Total Onboard",
            data: {"PAX": "98 + 0 INF + 0 JMP"},
          ),
        ],
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  String? title;
  final Map<String, String> data;

  InfoSection({super.key, this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          if (title != null) const SizedBox(height: 10),
          ...data.entries.map((entry) => _infoRow(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
