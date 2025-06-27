import 'package:flutter/material.dart';

import '../../../../constant.dart';
import '../../../../models/chat_model.dart';

Widget buildMessageContent(ChatMessage message) {
  if (message.type == 'staff') {
    return _buildStaffMessage(message.staffServicesMessage ?? []);
  } else if (message.type == 'arr') {
    return _buildArrMessage(message.arrMessage!);
  } else if (message.type == 'fhr' && message.fhrMessage != null) {
    return _buildFhrMessage(message.fhrMessage!);
  } else if (message.type == 'ssr' && message.ssrMessage != null) {
    return _buildSsrMessage(message.ssrMessage!);
  } else if (message.type == 'dsr' && message.dsrMessage != null) {
    return _buildDsrMessage(message.dsrMessage!);
  } else if (message.type == 'occ') {
    return _buildOccMessage(message);
  }
  return _buildRegularMessage(message);
}

Widget _buildRegularMessage(ChatMessage message) {
  return IntrinsicWidth(
    child: Container(
      padding: EdgeInsets.only(
        right: message.isOwn ? 12 : 16,
        left: message.isOwn ? 16 : 12,
        top: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.only(
          topLeft:
              message.isOwn
                  ? const Radius.circular(12)
                  : const Radius.circular(0),
          topRight:
              message.isOwn ? Radius.circular(0) : const Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),

      child: Column(
        children: [
          Text(
            message.message,
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),

          const SizedBox(height: 1),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              formatChatTimestamp(message.time),
              style: TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildArrMessage(ArrMessage arrMessage) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Text(
          'ARR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 8),

        // Time Information
        _buildRow('Start Time', arrMessage.startTime),
        _buildRow('End Time', arrMessage.endTime),
        const SizedBox(height: 8),

        // LOFO Information
        _buildRow('LOFO Remarks', arrMessage.lofoRemarks),
        _buildRow('LOFO', arrMessage.lofo),
        const SizedBox(height: 8),

        // Other Details
        _buildRow('DPR', arrMessage.dpr),
        _buildRow('OHD', arrMessage.ohd),
        _buildRow('MHB/AHL', arrMessage.mhbAhl),
      ],
    ),
  );
}

Widget _buildFhrMessage(FhrMessage fhrMessage) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Text(
          'FHR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 8),

        // Issues
        _builFhrItem('MISSED ARTG-5 EXPLANATION', fhrMessage.missedConnection),
        _builFhrItem('DELAY EXPLANATION', fhrMessage.delayExplanation),
        _builFhrItem('CHECK-IN/TKTG ISSUES', fhrMessage.checkInIssues),
        _builFhrItem('RAMP/CREWDISRUPTIVE PAX ETC', fhrMessage.rampIssues),
        _builFhrItem('SAFETY/SECURITY/SYSTEM', fhrMessage.safetyIssues),
        _builFhrItem('OTHER', fhrMessage.otherIssues),
        _builFhrItem('INVOL DENIED BOARDING', fhrMessage.deniedBoarding),
      ],
    ),
  );
}

Widget _buildSsrMessage(SsrMessage ssrMessage) {
  // Create a map of field keys and values
  final fields = {
    if (ssrMessage.bdgp != null && ssrMessage.bdgp!.isNotEmpty)
      'BDGP': ssrMessage.bdgp!,
    if (ssrMessage.bbsl != null && ssrMessage.bbsl!.isNotEmpty)
      'BBSL': ssrMessage.bbsl!,
    if (ssrMessage.avih != null && ssrMessage.avih!.isNotEmpty)
      'AVIH': ssrMessage.avih!,
  };

  // Return empty if no valid fields
  if (fields.isEmpty) return const SizedBox.shrink();

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SSR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 8),
        ...fields.entries.map((entry) => _buildSsrRow(entry.key, entry.value)),
      ],
    ),
  );
}

Widget _buildSsrRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
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

Widget _buildDsrMessage(DsrMessage dsr) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('DSR', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Divider(height: 1),
        SizedBox(height: 8),
        _buildRow('Date', dsr.date),
        _buildRow('Passenger', dsr.paxName),
        _buildRow('Service', dsr.serviceType),
        _buildRow('Amount', '${dsr.amount} ${dsr.currency}'),
        _buildRow('Flight', dsr.flightNo),
        _buildRow('PNR', dsr.pnr),
        _buildRow('Payment', dsr.fop),
        _buildRow('DOI', dsr.doi),
      ],
    ),
  );
}

Widget _buildOccMessage(ChatMessage message) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Occ', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Divider(height: 1),
        SizedBox(height: 8),

        _buildRegularMessage(message),
      ],
    ),
  );
}

Widget _buildRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget _builFhrItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Add this
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            height: 1.2, // Adjusted line height
          ),
        ),
        const SizedBox(height: 2), // Reduced spacing
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8), // Reduced padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.grey[50], // Optional background
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12.5,
                height: 0.1, // Consistent line height
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
