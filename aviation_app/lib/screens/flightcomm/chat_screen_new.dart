import 'package:aviation_app/controllers/flight/chat_controller.dart';
import 'package:aviation_app/models/chat_model.dart';
import 'package:aviation_app/screens/flightcomm/info/arr_info.dart';
import 'package:aviation_app/screens/flightcomm/info/chat_info.dart';
import 'package:aviation_app/screens/flightcomm/info/chkin_info.dart';
import 'package:aviation_app/screens/flightcomm/info/cpm_info.dart';
import 'package:aviation_app/screens/flightcomm/info/ldm_info.dart';
import 'package:aviation_app/screens/flightcomm/info/lds_info.dart';
import 'package:aviation_app/screens/flightcomm/info/lir_info.dart';
import 'package:aviation_app/screens/flightcomm/info/mvt_info.dart';
import 'package:aviation_app/screens/flightcomm/info/pic_info.dart';
import 'package:aviation_app/screens/flightcomm/info/psm_info.dart';
import 'package:aviation_app/screens/flightcomm/info/ptm_info.dart';
import 'package:aviation_app/screens/flightcomm/info/sod_info.dart';
import 'package:aviation_app/screens/flightcomm/info/trc_info.dart';
import 'package:aviation_app/screens/flightcomm/info/widget/chat_bottom_view.dart';
import 'package:aviation_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

  /// Modern Header with Flight Info
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

      return Container(
        padding: const EdgeInsets.fromLTRB(4, 12, 12, 12),
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
            // Back arrow (vertically centered)
            GestureDetector(
              onTap: () => Get.back(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black87,
                  size: 18,
                ),
              ),
            ),
            // All flight info in a column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Flight info and aircraft details
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Flight Number and Route
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                flight.basicDetails.flightInfo,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${flight.departureAirport.iataCode} - ${flight.arrivalAirport.iataCode}",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Aircraft info on right
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (flight.aircraftType != null) ...[
                              Text(
                                flight.aircraftType!.icao,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                            if (flight.aircraft?.name.isNotEmpty ?? false) ...[
                              const SizedBox(width: 6),
                              Text(
                                "|",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                flight.aircraft!.name,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Row 2: Gate, POS on left and CFG on right
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      children: [
                        // Left side: Gate and POS
                        Expanded(
                          child: Row(
                            children: [
                              if (flight.basicDetails.gate?.isNotEmpty ??
                                  false) ...[
                                Text(
                                  "GATE: ${flight.basicDetails.gate}",
                                  style: const TextStyle(
                                    color: Color(0xFF1976D2),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              if (flight.basicDetails.pos?.isNotEmpty ?? false)
                                Text(
                                  "POS: ${flight.basicDetails.pos}",
                                  style: const TextStyle(
                                    color: Color(0xFF1976D2),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Row 3: Time badges (STD/ATD or STA/ATA - show ATD/ATA if exists, otherwise STD/STA)
                  Row(
                    children: [
                      if (flight.isDeparture) ...[
                        if (flight.basicDetails.atd?.isNotEmpty ?? false)
                          _buildTimeBadgeWithLabelBg(
                            "ATD",
                            formatFlightTime(flight.basicDetails.atd!),
                            const Color(0xFFD32F2F),
                          )
                        else if (flight.basicDetails.std?.isNotEmpty ?? false)
                          _buildTimeBadgeWithLabelBg(
                            "STD",
                            formatFlightTime(flight.basicDetails.std!),
                            const Color(0xFF1976D2),
                          ),
                      ] else ...[
                        if (flight.basicDetails.ata?.isNotEmpty ?? false)
                          _buildTimeBadgeWithLabelBg(
                            "ATA",
                            formatFlightTime(flight.basicDetails.ata!),
                            const Color(0xFFD32F2F),
                          )
                        else if (flight.basicDetails.sta?.isNotEmpty ?? false)
                          _buildTimeBadgeWithLabelBg(
                            "STA",
                            formatFlightTime(flight.basicDetails.sta!),
                            const Color(0xFF1976D2),
                          ),
                      ],
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

  Widget _buildSmallInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTimeBadge(String label, String time, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label $time',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTimeBadgeWithLabelBg(String label, String time, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildFlightDetailsBadges(dynamic flight) {
    return Row(
      children: [
        // STD/ATD or STA/ATA
        if (flight.isDeparture) ...[
          if (flight.basicDetails.std?.isNotEmpty ?? false) ...[
            _buildBadge("STD", Colors.blue.shade700),
            const SizedBox(width: 4),
            _buildTimeText(flight.basicDetails.std),
            const SizedBox(width: 8),
          ],
          if (flight.basicDetails.atd?.isNotEmpty ?? false) ...[
            _buildBadge("ATD", Colors.green.shade700),
            const SizedBox(width: 4),
            _buildTimeText(flight.basicDetails.atd),
            const SizedBox(width: 8),
          ],
        ] else ...[
          if (flight.basicDetails.sta?.isNotEmpty ?? false) ...[
            _buildBadge("STA", Colors.blue.shade700),
            const SizedBox(width: 4),
            _buildTimeText(flight.basicDetails.sta),
            const SizedBox(width: 8),
          ],
          if (flight.basicDetails.ata?.isNotEmpty ?? false) ...[
            _buildBadge("ATA", Colors.green.shade700),
            const SizedBox(width: 4),
            _buildTimeText(flight.basicDetails.ata),
            const SizedBox(width: 8),
          ],
        ],
        const Spacer(),
        // Aircraft Type and Registration
        if (flight.aircraft != null) ...[
          _buildBadge("ACT", AppColors.colorPrimary),
          const SizedBox(width: 4),
          Text(
            flight.aircraftType?.icao ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            flight.aircraft?.name ?? '',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTimeText(String? time) {
    return Text(
      time ?? '--',
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  /// Tab Bar
  Widget _buildTabBar(ChatController controller) {
    final tabs = [
      'Chat',
      'TRC',
      'CHKIN',
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
      height: 44,
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

      case 'CHKIN':
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
          child: const Center(
            child: Text(
              "NOTOC view not implemented yet",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );

      case 'CPM':
        return Container(color: const Color(0xFFF5F5F5), child: CPMInfo());

      case 'PAL/CAL':
        return Container(
          color: const Color(0xFFF5F5F5),
          child: const Center(
            child: Text(
              "PAL/CAL view not implemented yet",
              style: TextStyle(color: Colors.grey),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      maxLines: 1,
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
                  GestureDetector(
                    onTap: () {
                      // Handle attachment
                    },
                    child: SvgPicture.asset(
                      'assets/svg/attachment.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        Colors.grey.shade600,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
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
}
