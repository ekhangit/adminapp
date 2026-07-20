import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constant.dart';
import '../../../../controllers/flight/chat_controller.dart';
import '../../../../models/chat_model.dart';

Widget buildMessageContent(ChatMessage message) {
  if (message.type == 'trc') {
    return _buildTrcMessage(message);
  } else if (message.type == 'ckin' && message.ckinMessage != null) {
    return _buildCkinMessage(message.ckinMessage!, isOwn: message.isOwn);
  } else if (message.type == 'staff') {
    return _buildStaffMessage(
      message.staffServicesMessage ?? [],
      isOwn: message.isOwn,
    );
  } else if (message.type == 'arr') {
    return _buildArrMessage(message.arrMessage!, isOwn: message.isOwn);
  } else if (message.type == 'pts') {
    return _buildPtsMessage(message, isOwn: message.isOwn);
  } else if (message.type == 'fhr' && message.fhrMessage != null) {
    return _buildFhrMessage(message.fhrMessage!, isOwn: message.isOwn);
  } else if (message.type == 'ssr' && message.ssrMessage != null) {
    return _buildSsrMessage(message.ssrMessage!, isOwn: message.isOwn);
  } else if (message.type == 'dsr' && message.dsrMessage != null) {
    return _buildDsrMessage(message.dsrMessage!, isOwn: message.isOwn);
  } else if (message.type == 'attachment' &&
      message.attachmentMessage != null) {
    return _buildAttachmentMessage(
      message.attachmentMessage!,
      time: message.time,
      isOwn: message.isOwn,
    );
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
            color: message.isOwn ? const Color(0xFFCAE9FF) : Colors.white,
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
      // Only show timestamp for own messages
      if (message.isOwn)
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

Widget _buildTrcMessage(ChatMessage message) {
  // Prefer values carried in the TRC message payload itself; fall back to the
  // current flight detail (same source the TRC form uses) for anything the
  // payload doesn't include (gate/stand/belt/regn).
  final detail =
      Get.isRegistered<ChatController>()
          ? Get.find<ChatController>().flightDetail.value
          : null;
  final basic = detail?.basicDetails;
  final trc = message.trcMessage;

  // Picks the first meaningful value, ignoring nulls, empties and the '--' sentinel.
  String pick(List<String?> values) {
    for (final v in values) {
      if (v != null && v.isNotEmpty && v != '--') return v;
    }
    return '--';
  }

  final acType = pick([trc?.aircraftTypeIcao, detail?.aircraftType?.icao]);
  final acRegn = pick([trc?.aircraftIcao, detail?.aircraft?.name]);

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: message.isOwn ? const Color(0xFFCAE9FF) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TRC',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 8),

        _buildExpandRow('FLT Type', pick([basic?.flightInfo])),
        _buildExpandRow('A/C TYPE', acType),
        _buildExpandRow('A/C REGN', acRegn),
        _buildExpandRow('GATE', pick([basic?.gate])),
        _buildExpandRow('STAND', pick([basic?.pos])),
        _buildExpandRow('BAGGAGE BELT', pick([basic?.beggageBelt])),
      ],
    ),
  );
}

Widget _buildCkinMessage(CkinMessage ckin, {bool isOwn = false}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isOwn ? const Color(0xFFCAE9FF) : Colors.white,
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

Widget _buildArrMessage(ArrMessage arrMessage, {bool isOwn = false}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isOwn ? const Color(0xFFCAE9FF) : Colors.white,
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

Widget _buildFhrMessage(FhrMessage fhrMessage, {bool isOwn = false}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isOwn ? const Color(0xFFCAE9FF) : Colors.white,
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

Widget _buildSsrMessage(SsrMessage ssrMessage, {bool isOwn = false}) {
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
      color: isOwn ? const Color(0xFFCAE9FF) : Colors.white,
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

// Column widths for the staff roster table.
const double _wSla = 78;
const double _wType = 66;
const double _wStaff = 170;
const double _wTime = 138;
const double _wDur = 58;

// Palette (matches staff_chat.png)
const Color _staffTeal = Color(0xFF1AA394); // service abbr badge
const Color _staffBlue = Color(0xFF3793F4); // Type badge
const Color _staffDepBlue = Color(0xFF5AA9F0); // service type badge
const Color _staffOrange = Color(0xFFE8833A); // SLA badge
const Color _staffGreen = Color(0xFF2E9E4F); // PLN badge

String _fmtStaffTime(String? t) {
  if (t == null || t.isEmpty) return '';
  try {
    return DateFormat('dd MMM HH:mm').format(DateTime.parse(t));
  } catch (_) {
    return t;
  }
}

String _staffDuration(String? start, String? end) {
  if (start == null || end == null || start.isEmpty || end.isEmpty) return '';
  try {
    final diff = DateTime.parse(end).difference(DateTime.parse(start));
    if (diff.isNegative) return '';
    final h = diff.inHours.toString().padLeft(2, '0');
    final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  } catch (_) {
    return '';
  }
}

Widget _staffBadge(String text, Color bg) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  decoration: BoxDecoration(
    color: bg,
    borderRadius: BorderRadius.circular(4),
  ),
  child: Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    ),
  ),
);

Widget _staffCell(
  double width,
  Widget child, {
  Alignment align = Alignment.centerLeft,
}) => Container(
  width: width,
  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
  alignment: align,
  child: child,
);

Widget _staffTimeCell(String time, String label, Color labelColor) {
  if (time.isEmpty) return const SizedBox.shrink();
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
        child: Text(
          time,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(width: 4),
      _staffBadge(label, labelColor),
    ],
  );
}

Widget _buildStaffMessage(List<StaffService> services, {bool isOwn = false}) {
  if (services.isEmpty) return const SizedBox.shrink();

  const headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  final rows = <Widget>[
    // Column titles
    Container(
      color: const Color(0xFFE8F0FE),
      child: Row(
        children: [
          _staffCell(_wSla, const Text('SLA', style: headerStyle),
              align: Alignment.center),
          _staffCell(_wType, const Text('Type', style: headerStyle),
              align: Alignment.center),
          _staffCell(_wStaff, const Text('Staff', style: headerStyle),
              align: Alignment.center),
          _staffCell(_wTime, const Text('Start Time', style: headerStyle),
              align: Alignment.center),
          _staffCell(_wTime, const Text('Release Time', style: headerStyle),
              align: Alignment.center),
          _staffCell(_wDur, const Text('Duration', style: headerStyle),
              align: Alignment.center),
        ],
      ),
    ),
  ];

  for (final s in services) {
    // Service header row (SLA times)
    rows.add(
      Container(
        color: const Color(0xFFEAF8EE),
        child: Row(
          children: [
            _staffCell(_wSla, _staffBadge(s.service, _staffTeal)),
            _staffCell(_wType, _staffBadge(s.type, _staffBlue)),
            _staffCell(
              _wStaff,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (s.serviceType.isNotEmpty)
                    _staffBadge(s.serviceType, _staffDepBlue),
                  const SizedBox(width: 6),
                  Text(
                    'Required : ${s.staffRequired}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            _staffCell(
              _wTime,
              _staffTimeCell(_fmtStaffTime(s.slaStart.sla), 'SLA', _staffOrange),
            ),
            _staffCell(
              _wTime,
              _staffTimeCell(
                _fmtStaffTime(s.slaRelease.sla),
                'SLA',
                _staffOrange,
              ),
            ),
            _staffCell(
              _wDur,
              Text(
                _staffDuration(s.slaStart.sla, s.slaRelease.sla),
                style: const TextStyle(fontSize: 11, color: Colors.black87),
              ),
              align: Alignment.center,
            ),
          ],
        ),
      ),
    );

    // Per-staff rows (PLN times)
    for (int i = 0; i < s.assignments.length; i++) {
      final a = s.assignments[i];
      rows.add(
        Row(
          children: [
            _staffCell(
              _wSla,
              Text(
                '${i + 1}',
                style: const TextStyle(fontSize: 11, color: Colors.black87),
              ),
              align: Alignment.center,
            ),
            _staffCell(_wType, const SizedBox.shrink()),
            _staffCell(
              _wStaff,
              Text(
                a.name,
                style: const TextStyle(fontSize: 11, color: Colors.black87),
              ),
            ),
            _staffCell(
              _wTime,
              _staffTimeCell(_fmtStaffTime(a.start.pln), 'PLN', _staffGreen),
            ),
            _staffCell(
              _wTime,
              _staffTimeCell(_fmtStaffTime(a.release.pln), 'PLN', _staffGreen),
            ),
            _staffCell(
              _wDur,
              Text(
                _staffDuration(a.start.pln, a.release.pln),
                style: const TextStyle(fontSize: 11, color: Colors.black87),
              ),
              align: Alignment.center,
            ),
          ],
        ),
      );
    }
  }

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    clipBehavior: Clip.antiAlias,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(height: 1, thickness: 0.5),
            rows[i],
          ],
        ],
      ),
    ),
  );
}

Widget _buildPtsMessage(ChatMessage message, {bool isOwn = false}) {
  // Parse PTS data from message
  Map<String, dynamic> ptsData = {};

  if (message.message is Map) {
    ptsData = Map<String, dynamic>.from(message.message as Map);
  } else if (message.message is String) {
    // Parse the string format: {key1: value1, key2: value2, ...}
    try {
      final str = message.message.toString();
      // Remove the curly braces
      final cleaned = str.substring(1, str.length - 1);
      // Split by comma
      final pairs = cleaned.split(', ');

      for (final pair in pairs) {
        final keyValue = pair.split(': ');
        if (keyValue.length == 2) {
          ptsData[keyValue[0].trim()] = keyValue[1].trim();
        }
      }
    } catch (e) {
      // Fallback: display as raw string
      ptsData = {'raw_data': message.message.toString()};
    }
  }

  // Format field names for display
  String formatFieldName(String key) {
    return key.replaceAll('_', ' ').toUpperCase();
  }

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isOwn ? const Color(0xFFCAE9FF) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PTS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),

        // Display all fields in simple list
        ...ptsData.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    formatFieldName(entry.key),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  entry.value?.toString() ?? '',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }),

        // Timestamp at the bottom
        if (message.isOwn)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formatChatTimestamp(message.time),
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ),
          ),
      ],
    ),
  );
}

Widget _buildDsrMessage(DsrMessage dsr, {bool isOwn = false}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isOwn ? const Color(0xFFCAE9FF) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('DSR', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 8),
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
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: message.isOwn ? const Color(0xFFCAE9FF) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Occ', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 8),
        _buildRegularMessage(message),
      ],
    ),
  );
}

Widget _buildAttachmentMessage(
  AttachmentMessage attachment, {
  required String time,
  bool isOwn = false,
}) {
  final fileType = attachment.getFileTypeCategory();

  return Column(
    crossAxisAlignment:
        isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap: () => _openAttachment(attachment.filePath),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
            color: isOwn ? const Color(0xFFCAE9FF) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image preview for images
              if (fileType == 'image')
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CachedNetworkImage(
                      imageUrl: attachment.filePath,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: 140,
                      placeholder:
                          (context, url) => Container(
                            height: 140,
                            color: Colors.grey[200],
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            height: 140,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                    ),
                  ),
                ),

              // File icon for non-images
              if (fileType != 'image')
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getFileIcon(fileType),
                        size: 28,
                        color: _getFileColor(fileType),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            attachment.fileExtension.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            _getFileTypeLabel(fileType),
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Message text and type badge
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Type badge at bottom
                    if (attachment.type != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          attachment.type!,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),

                    // Message text
                    if (attachment.messageAttach.isNotEmpty) ...[
                      SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                          attachment.messageAttach,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Timestamp
      if (isOwn)
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 4),
          child: Text(
            formatChatTimestamp(time),
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ),
    ],
  );
}

IconData _getFileIcon(String fileType) {
  switch (fileType) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'document':
      return Icons.description;
    case 'spreadsheet':
      return Icons.table_chart;
    case 'video':
      return Icons.video_file;
    case 'audio':
      return Icons.audio_file;
    default:
      return Icons.insert_drive_file;
  }
}

Color _getFileColor(String fileType) {
  switch (fileType) {
    case 'pdf':
      return Colors.red.shade400;
    case 'document':
      return Colors.blue.shade400;
    case 'spreadsheet':
      return Colors.green.shade400;
    case 'video':
      return Colors.purple.shade400;
    case 'audio':
      return Colors.orange.shade400;
    default:
      return Colors.grey.shade400;
  }
}

String _getFileTypeLabel(String fileType) {
  switch (fileType) {
    case 'pdf':
      return 'PDF Document';
    case 'document':
      return 'Document';
    case 'spreadsheet':
      return 'Spreadsheet';
    case 'video':
      return 'Video File';
    case 'audio':
      return 'Audio File';
    default:
      return 'File';
  }
}

Future<void> _openAttachment(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
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
