import 'package:flutter/material.dart';

import '../../../../constant.dart';
import '../../../../models/chat_model.dart';

Widget buildMessageContent(ChatMessage message) {
  if (message.type == 'trc') {
    return _buildTrcMessage(message.trcMessage!);
  } else if (message.type == 'ckin' && message.ckinMessage != null) {
    return _buildCkinMessage(message.ckinMessage!);
  } else if (message.type == 'staff') {
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
  return Column(
    crossAxisAlignment:
        message.isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFCAE9FF),
            borderRadius: BorderRadius.only(
              topLeft:
                  message.isOwn
                      ? const Radius.circular(8)
                      : const Radius.circular(4),
              topRight:
                  message.isOwn
                      ? const Radius.circular(4)
                      : const Radius.circular(8),
              bottomLeft: const Radius.circular(8),
              bottomRight: const Radius.circular(8),
            ),
          ),
          child: Text(
            message.message,
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4, right: 4),
        child: Text(
          formatChatTimestamp(message.time),
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ),
    ],
  );
}

Widget _buildTrcMessage(TrcMessage trc) {
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
        _buildExpandRow('Name', trc.name),
        _buildExpandRow('Mobile', trc.mobile),
        _buildExpandRow('Remarks', trc.remarks),

        _buildTrcSection('A/C Data', [
          // _buildTrcRow('CREW', trc.crew),
          _buildExpandRow('PANTRY', trc.pantry),
          _buildExpandRow('CAPTAIN', trc.captain),
          _buildExpandRow('DOW', trc.dow),
          _buildExpandRow('DOI', trc.doiTrc),
          _buildExpandRow('MTOW', trc.mtow),
          _buildExpandRow('RTOW', trc.rtow),
        ]),

        // F.O.D
        _buildTrcSection('F.O.D', [
          _buildExpandRow('Before Arrival', trc.beforeArrival),
          _buildExpandRow('Before Departure', trc.beforeDeparture),
          _buildExpandRow('After Departure', trc.afterDeparture),
        ]),

        // Fuel Data
        _buildTrcSection('Fuel Data', [
          _buildExpandRow('TAXI', trc.taxi),
          _buildExpandRow('BLOCK FUEL', trc.block),
          _buildExpandRow('TRIP', trc.trip),
          _buildExpandRow('E.E.T.', trc.eet),
          _buildExpandRow('TOF', trc.tofFuel),
          _buildExpandRow('UPLIFTED', trc.uplifted),
          _buildExpandRow('ALTN', trc.altn),
        ]),
      ],
    ),
  );
}

Widget _buildCkinMessage(CkinMessage ckin) {
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
        // Flight Information
        if (ckin.ckinStaff.isNotEmpty)
          _buildCkinStaffSection('CKIN', ckin.ckinStaff),

        if (ckin.gateStaff.isNotEmpty)
          _buildCkinStaffSection('GATE', ckin.gateStaff),

        if (ckin.gateSpvr.isNotEmpty)
          _buildCkinStaffSection('GATE SPVR', ckin.gateSpvr),

        if (ckin.spvr.isNotEmpty) _buildCkinStaffSection('SVPR', ckin.spvr),

        // Supervisor Remarks
        if (ckin.spvrRemarks!.isNotEmpty)
          _buildCkinSection('SPVR Remarks', [
            _buildCkinRow('Remarks', ckin.spvrRemarks!),
          ]),

        // Issues
        if (ckin.flightSpecial!.isNotEmpty)
          _builBoxItem('SPECIALS', ckin.flightSpecial!),
        if (ckin.flightBookingStatus!.isNotEmpty)
          _builBoxItem('BOOKING STATUS', ckin.flightBookingStatus!),
        if (ckin.flightScheduleInfo!.isNotEmpty)
          _builBoxItem('SCHEDULE INFO', ckin.flightScheduleInfo!),
        if (ckin.flightDocsCheck!.isNotEmpty)
          _builBoxItem('DOCS CHECK', ckin.flightDocsCheck!),
        if (ckin.flightRamp!.isNotEmpty)
          _builBoxItem('RAMP (SPECIAL)', ckin.flightRamp!),
        if (ckin.flightOther!.isNotEmpty)
          _builBoxItem('OTHERS', ckin.flightOther!),

        _buildTrcSection('Actual Pax', [
          _buildExpandRow('CKIN DESKS NO:', ckin.ckinDeskUsed.toString()),
          _buildExpandRow('CKIN OPENED:', ckin.ckinOpened.toString()),
          _buildExpandRow('CKIN CLOSED:', ckin.ckinClosed.toString()),
          _buildExpandRow('BDG GATE CLOSED:', ckin.bdgGateOpened.toString()),
          _buildExpandRow(
            'ALL MATERIAL SECURED AT GATE:',
            ckin.securedGate.toString(),
          ),
          _buildExpandRow(
            'NO OF CKIN DESKS USED:',
            ckin.ckinDeskUsed.toString(),
          ),
          _buildExpandRow('BDG STARTED:', ckin.bdgGateStarted.toString()),
          _buildExpandRow('BDG COMPLETED:', ckin.bdgGateCompleted.toString()),
          _buildExpandRow('BDG GATE CLOSED:', ckin.bdgGateClosed.toString()),
        ]),

        _buildTrcSection('BAGGAGE AT CKIN', [
          _buildExpandRow('PCS', ckin.baggageCkinPcs.toString()),
          _buildExpandRow('WT', ckin.baggageCkinWt.toString()),
        ]),
        _buildTrcSection('BAGGAGE AT GATE', [
          _buildExpandRow('PCS', ckin.baggageGatePcs.toString()),
          _buildExpandRow('WT', ckin.baggageGateWt.toString()),
        ]),
      ],
    ),
  );
}

Widget _buildCkinSection(String title, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),

      const SizedBox(height: 8),
      const Divider(height: 1, thickness: 1),
      const SizedBox(height: 8),
      const SizedBox(height: 4),
      ...children,
      const SizedBox(height: 12),
    ],
  );
}

Widget _buildCkinRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCkinStaffSection(String title, List<StaffMember> staff) {
  return _buildCkinSection(title, [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          staff
              .map(
                (member) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '• ${member.name}',
                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                ),
              )
              .toList(),
    ),
  ]);
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
        if (fhrMessage.missedConnection!.isNotEmpty)
          _builBoxItem(
            'MISSED ARTG-5 EXPLANATION',
            fhrMessage.missedConnection!,
          ),
        if (fhrMessage.delayExplanation!.isNotEmpty)
          _builBoxItem('DELAY EXPLANATION', fhrMessage.delayExplanation!),
        if (fhrMessage.checkInIssues!.isNotEmpty)
          _builBoxItem('CHECK-IN/TKTG ISSUES', fhrMessage.checkInIssues!),
        if (fhrMessage.rampIssues!.isNotEmpty)
          _builBoxItem('RAMP/CREWDISRUPTIVE PAX ETC', fhrMessage.rampIssues!),
        if (fhrMessage.safetyIssues!.isNotEmpty)
          _builBoxItem('SAFETY/SECURITY/SYSTEM', fhrMessage.safetyIssues!),
        if (fhrMessage.otherIssues!.isNotEmpty)
          _builBoxItem('OTHER', fhrMessage.otherIssues!),
        if (fhrMessage.deniedBoarding!.isNotEmpty)
          _builBoxItem('INVOL DENIED BOARDING', fhrMessage.deniedBoarding!),
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

Widget _buildTrcSection(String title, List<Widget> rows) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),

      const SizedBox(height: 8),
      const Divider(height: 1, thickness: 1),
      const SizedBox(height: 8),
      const SizedBox(height: 4),
      ...rows,
      const SizedBox(height: 12),
    ],
  );
}

Widget _buildExpandRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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

Widget _builBoxItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Add this
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              height: 1.2, // Adjusted line height
            ),
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
