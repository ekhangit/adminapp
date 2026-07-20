import 'dart:io';

import 'package:dhs_app/controllers/flight/chat_controller.dart';
import 'package:dhs_app/screens/flightcomm/file_preview_screen.dart';
import 'package:dhs_app/screens/flightcomm/image_preview_screen.dart';
import 'package:dhs_app/screens/flightcomm/info/arr_info.dart';
import 'package:dhs_app/screens/flightcomm/info/chat_info.dart';
import 'package:dhs_app/screens/flightcomm/info/chkin_info.dart';
import 'package:dhs_app/screens/flightcomm/info/cpm_info.dart';
import 'package:dhs_app/screens/flightcomm/info/ldm_info.dart';
import 'package:dhs_app/screens/flightcomm/info/lds_info.dart';
import 'package:dhs_app/screens/flightcomm/info/lir_info.dart';
import 'package:dhs_app/screens/flightcomm/info/mvt_info.dart';
import 'package:dhs_app/screens/flightcomm/info/pic_info.dart';
import 'package:dhs_app/screens/flightcomm/info/psm_info.dart';
import 'package:dhs_app/screens/flightcomm/info/ptm_info.dart';
import 'package:dhs_app/screens/flightcomm/info/sod_info.dart';
import 'package:dhs_app/screens/flightcomm/info/trc_info.dart';
import 'package:dhs_app/screens/flightcomm/update_info_screen.dart';
import 'package:dhs_app/screens/flightcomm/widgets/animated_attachment_option.dart';
import 'package:dhs_app/utils/app_colors.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../constant.dart';

class ChatScreenNew extends StatelessWidget {
  const ChatScreenNew({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // 🔹 Modern Header
              _buildModernHeader(controller),

              // 🔹 Tab Bar
              _buildTabBar(controller),

              // 🔹 Tab Content
              Expanded(child: Obx(() => _buildTabContent(controller))),
            ],
          ),
        ),
      ),
    );
  }

  /// Modern Header with Flight Info (matches chat_header.png)
  Widget _buildModernHeader(ChatController controller) {
    return Obx(() {
      if (controller.flightDetailLoading.value) {
        return const LinearProgressIndicator(
          backgroundColor: Colors.white,
          color: AppColors.colorPrimary,
          minHeight: 2.5,
        );
      }

      final flight = controller.flightDetail.value;
      if (flight == null) return const SizedBox.shrink();

      final basic = flight.basicDetails;
      final acType = flight.aircraftType?.icao ?? '';
      final aircraftName = flight.aircraft?.name ?? '';
      final hasStd = basic.std?.isNotEmpty ?? false;
      final hasSta = basic.sta?.isNotEmpty ?? false;

      // Second time line (below dotted): actual, else estimated.
      String depSecLabel = '', depSecTime = '';
      if (basic.atd?.isNotEmpty ?? false) {
        depSecLabel = 'ATD';
        depSecTime = formatFlightTime(basic.atd!);
      } else if (basic.etd?.isNotEmpty ?? false) {
        depSecLabel = 'ETD';
        depSecTime = formatFlightTime(basic.etd!);
      }
      String arrSecLabel = '', arrSecTime = '';
      if (basic.ata?.isNotEmpty ?? false) {
        arrSecLabel = 'ATA';
        arrSecTime = formatFlightTime(basic.ata!);
      } else if (basic.eta?.isNotEmpty ?? false) {
        arrSecLabel = 'ETA';
        arrSecTime = formatFlightTime(basic.eta!);
      }

      // CFG from flight_capacity; fall back to aircraft_capacity when it's empty.
      final cap = flight.capacity;
      final cfgFromFlight = [
        cap.f,
        cap.j,
        cap.c,
        cap.s,
        cap.w,
        cap.y,
        cap.m,
      ].where((v) => v != null && v.isNotEmpty && v != 'null').join(' ');
      final cfgText =
          cfgFromFlight.isNotEmpty ? cfgFromFlight : flight.aircraftCapacity;

      // ACT (actual pax): e.g. "Y150 +1 INF"
      final ap = flight.actualPax;
      // A/C/W/Y show whenever they carry a value (incl. "0" -> "C0");
      // infants only when greater than 0.
      bool hasVal(String? v) => v != null && v.isNotEmpty && v != 'null';
      final actParts = <String>[
        if (hasVal(ap.paxA)) 'A${ap.paxA}',
        if (hasVal(ap.paxC)) 'C${ap.paxC}',
        if (hasVal(ap.paxW)) 'W${ap.paxW}',
        if (hasVal(ap.paxY)) 'Y${ap.paxY}',
        if (hasVal(ap.paxInf) && ap.paxInf != '0') '+${ap.paxInf} INF',
      ];
      final actText = actParts.join(' ');

      // Connecting flight badge: inbound if present, otherwise outbound.
      final isInbound = flight.inboundFlight?.isNotEmpty ?? false;
      final connectingFlight =
          isInbound ? flight.inboundFlight! : (flight.outboundFlight ?? '');
      final connectingIcon =
          isInbound
              ? 'assets/svg/arrival_flight.svg'
              : 'assets/svg/departure_flight.svg';

      // Gate / Stand (pos). When present they take line 1 and push CFG/ACT to line 2.
      final gate = basic.gate ?? '';
      final pos = basic.pos ?? '';
      final hasGate = gate.isNotEmpty;
      final hasPos = pos.isNotEmpty;
      final showGatePos = hasGate || hasPos;

      Widget inkDivider() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: 1,
          height: 12,
          color: const Color(0xFF7579D3),
        ),
      );

      // Center of the 2nd time line: TOBT · TSAT · CTOT (ink color)
      Widget timeSpan(String label, String value) => Text.rich(
        TextSpan(
          style: GoogleFonts.inter(
            fontSize: 8,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF7579D3),
          ),
          children: [
            TextSpan(
              text: '$label ',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      );

      final centerParts = <Widget>[
        if (basic.tobt?.isNotEmpty ?? false) timeSpan('TOBT', basic.tobt!),
        if (basic.tsat?.isNotEmpty ?? false) timeSpan('TSAT', basic.tsat!),
        if (basic.ctot?.isNotEmpty ?? false) timeSpan('CTOT', basic.ctot!),
      ];

      // ATD/ETD (left) & ATA/ETA (right) for the 2nd time line.
      Widget sideTime(String label, String value, TextAlign align) => Text.rich(
        textAlign: align,
        TextSpan(
          style: GoogleFonts.inter(
            fontSize: 8,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
          children: [
            TextSpan(
              text: '$label ',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      );

      final secondLineItems = <Widget>[
        if (depSecLabel.isNotEmpty)
          sideTime(depSecLabel, depSecTime, TextAlign.left),
        ...centerParts,
        if (arrSecLabel.isNotEmpty)
          sideTime(arrSecLabel, arrSecTime, TextAlign.right),
      ];

      Widget badgeValue(String label, Color badgeColor, String value) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBadge(label, badgeColor),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7579D3),
            ),
          ),
        ],
      );

      final cfgActItems = <Widget>[
        if (cfgText.isNotEmpty) badgeValue("CFG", const Color(0xFF3793F4), cfgText),
        if (cfgText.isNotEmpty && actText.isNotEmpty) inkDivider(),
        if (actText.isNotEmpty) badgeValue("ACT", const Color(0xFF4BE110), actText),
      ];
      // Plain "GATE: H3" text (no badge background), in ink color.
      Widget labelValue(String label, String value) => Text(
        '$label: $value',
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF7579D3),
        ),
      );

      final gatePosItems = <Widget>[
        if (hasGate) labelValue("GATE", gate),
        if (hasGate && hasPos) inkDivider(),
        if (hasPos) labelValue("STAND", pos),
      ];
      // Line 1 after the ICAO: gate/pos if present, otherwise cfg/act.
      final firstLineItems = showGatePos ? gatePosItems : cfgActItems;

      return Container(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1 (+ optional line 2), with the connecting-flight badge
                  // vertically centered across both lines.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Back arrow before the 1st row
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 2.0, left: 2.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black87,
                            size: 18.5,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Line 1: Flight info + aircraft type + gate/pos or CFG/ACT
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    basic.flightInfo,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: AppColors.colorPrimary,
                                    ),
                                  ),
                                  if (aircraftName.isNotEmpty) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      aircraftName,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        color: const Color(0xFF7579D3),
                                      ),
                                    ),
                                  ],
                                  if (acType.isNotEmpty) ...[
                                    const SizedBox(width: 3),
                                    Text(
                                      '($acType)',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                        color: const Color(0xFF7579D3),
                                      ),
                                    ),
                                  ],
                                  // Ink divider after the ICAO + line-1 content
                                  if (firstLineItems.isNotEmpty) ...[
                                    inkDivider(),
                                    ...firstLineItems,
                                  ],
                                ],
                              ),
                            ),
                            // Line 2: CFG/ACT when gate/pos occupy line 1
                            if (showGatePos && cfgActItems.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(children: cfgActItems),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (connectingFlight.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                connectingIcon,
                                width: 13,
                                height: 13,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                connectingFlight,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 1),

                  // Row 2: dep IATA · [STD · (UTC) · STA over dotted line] · arr IATA
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      
                      children: [
                        // Departure: IATA over ICAO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              flight.departureAirport.iataCode,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            if (flight.departureAirport.icaoCode.isNotEmpty)
                              Text(
                                flight.departureAirport.icaoCode,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Colors.red,
                                ),
                              ),
                            if (flight.stdOffset.isNotEmpty)
                              Text(
                                flight.stdOffset,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 7,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 0.5),
                        // STD · (All times shown are UTC) · STA above a full-width dotted line
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  if (hasStd)
                                    Text.rich(
                                      TextSpan(
                                        style: GoogleFonts.inter(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade700,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'STD ',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          TextSpan(
                                            text: formatFlightTime(basic.std!),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        '(All time UTC)',
                                        style: GoogleFonts.inter(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 9,
                                          height: 1,
                                          color: Colors.red.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (hasSta)
                                    Text.rich(
                                      TextSpan(
                                        style: GoogleFonts.inter(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade700,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'STA ',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          TextSpan(
                                            text: formatFlightTime(basic.sta!),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              DottedLine(
                                dashColor: Colors.green.shade400,
                                lineThickness: 1,
                                dashLength: 4,
                                dashGapLength: 3,
                              ),
                              // Below dotted: ATD/ETD · TOBT/TSAT/CTOT · ATA/ETA
                              if (secondLineItems.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: secondLineItems,
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(width: 0.5),
                        // Arrival: IATA over ICAO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              flight.arrivalAirport.iataCode,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            if (flight.arrivalAirport.icaoCode.isNotEmpty)
                              Text(
                                flight.arrivalAirport.icaoCode,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Colors.red,
                                ),
                              ),
                            if (flight.staOffset.isNotEmpty)
                              Text(
                                flight.staOffset,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 7,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Row 3: Airport city/country (dep left, arr right)
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          flight.departureAirport.cityCountry,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 9,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          flight.arrivalAirport.cityCountry,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 9,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Widget _buildTimeText(String? time) {
  //   return Text(
  //     time ?? '--',
  //     style: const TextStyle(
  //       fontSize: 11,
  //       fontWeight: FontWeight.w600,
  //       color: Colors.black87,
  //     ),
  //   );
  // }

  /// Tab Bar
  Widget _buildTabBar(ChatController controller) {
    final tabs = [
      'Chat',
      'TRC',
      'CKIN',
      'ARR',
      'PIC',
      'MVT',
      'LDM',
      'LIR',
      'LDS',
      'NOTOC',
      'CPM',
      'PAL/CAL',
      'PSM',
      'PTM',
      'SOD',
    ];

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];

          return Obx(() {
            final isSelected = controller.selectedTab.value == tab;
            final hasMessages = controller.hasMessages(tab);

            return GestureDetector(
              onTap: () => controller.selectedTab.value = tab,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.only(right: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      hasMessages
                          ? Colors.lightGreenAccent.shade400
                          : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color:
                          isSelected
                              ? AppColors.colorPrimary
                              : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.colorPrimary : Colors.black54,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  /// Tab Content
  Widget _buildTabContent(ChatController controller) {
    switch (controller.selectedTab.value) {
      case 'Chat':
        return Container(
          color: const Color(0xFFF5F5F5),
          child: Column(
            children: [
              const Expanded(child: ChatInfo()),
              _buildModernMessageInput(controller),
            ],
          ),
        );

      case 'TRC':
        return Container(color: const Color(0xFFF5F5F5), child: TrcInfo());

      case 'CKIN':
        return Container(color: const Color(0xFFF5F5F5), child: ChkinInfo());

      case 'ARR':
        return Container(color: const Color(0xFFF5F5F5), child: ArrInfo());

      case 'PIC':
        return Container(color: const Color(0xFFF5F5F5), child: PicInfo());

      case 'MVT':
        return Container(color: const Color(0xFFF5F5F5), child: MvtInfo());

      case 'LDM':
        return Container(color: const Color(0xFFF5F5F5), child: LdmInfo());

      case 'LIR':
        return Container(color: const Color(0xFFF5F5F5), child: LirInfo());

      case 'LDS':
        return Container(color: const Color(0xFFF5F5F5), child: LdsInfo());

      case 'NOTOC':
        return Container(
          color: const Color(0xFFF5F5F5),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No data available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case 'CPM':
        return Container(color: const Color(0xFFF5F5F5), child: CPMInfo());

      case 'PAL/CAL':
        return Container(
          color: const Color(0xFFF5F5F5),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No data available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case 'PSM':
        return Container(color: const Color(0xFFF5F5F5), child: PsmInfo());

      case 'PTM':
        return Container(color: const Color(0xFFF5F5F5), child: PtmInfo());

      case 'SOD':
        return Container(color: const Color(0xFFF5F5F5), child: SodInfo());

      default:
        return Container(
          color: const Color(0xFFF5F5F5),
          child: const Center(
            child: Text(
              "No view for this tab",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
    }
  }

  /// Modern Message Input (matches screenshot)
  Widget _buildModernMessageInput(ChatController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Flight arrow button (left side) - hide when typing
          Obx(
            () =>
                !controller.isTyping.value
                    ? Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => UpdateInfoScreen(),
                              arguments:
                                  controller
                                      .flightDetail
                                      .value!
                                      .basicDetails
                                      .id,
                            );
                          },
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: appThemeGradientSoft,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/svg/flight_arrow.svg',
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                    : const SizedBox.shrink(),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 12,
                top: 6,
                bottom: 6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      // Grows with the text, up to 5 lines, then scrolls.
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      cursorColor: AppColors.colorPrimary,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Message...',
                        hintStyle: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // One-line-tall box: keeps the icon centered on a single line
                  // and aligned with the last line as the field grows.
                  SizedBox(
                    height: 36,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => _showAttachmentOptions(controller),
                        child: SvgPicture.asset(
                          'assets/svg/attachment_new.svg',
                          width: 22,
                          height: 22,
                          colorFilter: ColorFilter.mode(
                            Colors.grey.shade600,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Camera — hidden while the user is typing.
                  Obx(
                    () =>
                        controller.isTyping.value
                            ? const SizedBox.shrink()
                            : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 12),
                                SizedBox(
                                  height: 36,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap:
                                          () => _handleCameraCapture(controller),
                                      child: SvgPicture.asset(
                                        'assets/svg/camera_new.svg',
                                        width: 22,
                                        height: 22,
                                        colorFilter: ColorFilter.mode(
                                          Colors.grey.shade600,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => GestureDetector(
              onTap:
                  controller.isSendingMessage.value
                      ? null
                      : controller.sendMessage,
              child: Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: appThemeGradientSoft,
                ),
                child:
                    controller.isSendingMessage.value
                        ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Center(
                          child: SvgPicture.asset(
                            'assets/svg/send.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle camera capture
  Future<void> _handleCameraCapture(ChatController controller) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        final File imageFile = File(photo.path);
        final fileName = photo.path.split('/').last;

        // Show preview screen
        Get.to(
          () => ImagePreviewScreen(
            imageFile: imageFile,
            onSend: (file, type) async {
              await controller.sendImageMessage(
                file: file,
                fileName: fileName,
                type: type,
              );
            },
          ),
        );
      }
    } catch (e) {
      debugPrint('Error capturing image: $e');
      Get.snackbar(
        'Error',
        'Failed to capture image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  /// Handle gallery picker
  Future<void> _handleGalleryPicker(ChatController controller) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (photo != null) {
        final File imageFile = File(photo.path);
        final fileName = photo.path.split('/').last;

        // Show preview screen
        Get.to(
          () => ImagePreviewScreen(
            imageFile: imageFile,
            onSend: (file, type) async {
              await controller.sendImageMessage(
                file: file,
                fileName: fileName,
                type: type,
              );
            },
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to select image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  /// Handle file picker
  Future<void> _handleFilePicker(ChatController controller) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;
        final fileSize = _formatFileSize(result.files.single.size);

        // Show preview screen
        Get.to(
          () => FilePreviewScreen(
            file: file,
            fileName: fileName,
            fileSize: fileSize,
            onSend: (file, type) async {
              await controller.sendImageMessage(
                file: file,
                fileName: fileName,
                type: type,
              );
            },
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      Get.snackbar(
        'Error',
        'Failed to select file',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  /// Format file size to human readable format
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Show attachment options bottom sheet
  void _showAttachmentOptions(ChatController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Attachment options
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedAttachmentOption(
                  svgPath: 'assets/svg/chat_camera.svg',
                  label: 'Camera',
                  index: 0,
                  onTap: () async {
                    Get.back();
                    await _handleCameraCapture(controller);
                  },
                ),
                const SizedBox(width: 20),
                AnimatedAttachmentOption(
                  svgPath: 'assets/svg/chat_gallery.svg',
                  label: 'Gallery',
                  index: 1,
                  onTap: () async {
                    Get.back();
                    await _handleGalleryPicker(controller);
                  },
                ),
                const SizedBox(width: 20),
                AnimatedAttachmentOption(
                  svgPath: 'assets/svg/chat_file.svg',
                  label: 'File',
                  index: 2,
                  onTap: () async {
                    Get.back();
                    await _handleFilePicker(controller);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
}
