import 'package:aviation_app/controllers/flight/chat_controller.dart';
import 'package:aviation_app/screens/flightcomm/info/arr_info.dart';
import 'package:aviation_app/screens/flightcomm/info/chat_info.dart';
import 'package:aviation_app/screens/flightcomm/info/chkin_info.dart';
import 'package:aviation_app/screens/flightcomm/info/cpm_info.dart';
import 'package:aviation_app/screens/flightcomm/info/ldm_info.dart';
import 'package:aviation_app/screens/flightcomm/info/lds_info.dart';
import 'package:aviation_app/screens/flightcomm/info/lir_info.dart';
import 'package:aviation_app/screens/flightcomm/info/mvt_info.dart';
import 'package:aviation_app/screens/flightcomm/info/psm_info.dart';
import 'package:aviation_app/screens/flightcomm/info/ptm_info.dart';
import 'package:aviation_app/screens/flightcomm/info/sod_info.dart';
import 'package:aviation_app/screens/flightcomm/info/trc_info.dart';
import 'package:aviation_app/screens/flightcomm/info/widget/chat_bottom_view.dart';
import 'package:aviation_app/screens/flightcomm/info/widget/into_widget.dart';
import 'package:aviation_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constant.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.grey.shade100,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Stack(
          children: [
            // 🔹 Background
            Positioned.fill(child: Container(color: Colors.grey.shade100)),

            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // 🔵 Top Info Header (Fixed)
                  Obx(() {
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
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                        bottom: 8,
                      ),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Row 1: Flight Info & Route
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          flight.basicDetails.flightInfo,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.5,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        _divider(Colors.red),
                                        const SizedBox(width: 6),
                                        Text(
                                          "${flight.departureAirport.iataCode}-${flight.arrivalAirport.iataCode}",
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.5,
                                          ),
                                        ),
                                        const SizedBox(width: 6),

                                        // Text(
                                        //   "GATE: ${flight.basicDetails.gate ?? '--'}  |  POS: ${flight.basicDetails.pos ?? '--'}",
                                        //   style: const TextStyle(
                                        //     color: Colors.blue,
                                        //     fontWeight: FontWeight.w500,
                                        //     fontSize: 12.5,
                                        //   ),
                                        // ),
                                        Row(
                                          children: [
                                            Text(
                                              "GATE: ${flight.basicDetails.gate ?? '--'}",
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.5,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            _divider(Colors.blue),
                                            const SizedBox(width: 6),
                                            Text(
                                              "POS: ${flight.basicDetails.pos ?? '--'}",
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),

                                    // 🔽 Row 2: Operational Details
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            if (flight
                                                .basicDetails
                                                .atd!
                                                .isNotEmpty) ...[
                                              InfoBadge(
                                                label: "ATD",
                                                color: Colors.green,
                                              ),
                                              const SizedBox(width: 6),
                                              InfoText(
                                                formatFlightTime(
                                                  flight.basicDetails.atd!,
                                                ),
                                                textColor: Colors.black87,
                                              ),
                                              const SizedBox(width: 6),
                                            ],

                                            if (flight.aircraft != null) ...[
                                              InfoText(
                                                flight
                                                    .aircraft!
                                                    .aircraftType
                                                    .icao,
                                              ),
                                              const SizedBox(width: 6),
                                              _divider(Colors.blue),
                                              const SizedBox(width: 6),
                                              InfoText(flight.aircraft!.name),
                                              const SizedBox(width: 6),
                                              _divider(Colors.blue),
                                              const SizedBox(width: 6),
                                            ],

                                            if ([
                                              flight.capacity.f,
                                              flight.capacity.j,
                                              flight.capacity.c,
                                              flight.capacity.s,
                                              flight.capacity.w,
                                              flight.capacity.y,
                                              flight.capacity.m,
                                            ].any(
                                              (e) => e != null && e.isNotEmpty,
                                            )) ...[
                                              InfoBadge(
                                                label: "CFG",
                                                color: AppColors.colorPrimary,
                                              ),
                                              const SizedBox(width: 6),
                                              InfoText(
                                                [
                                                      flight.capacity.f,
                                                      flight.capacity.j,
                                                      flight.capacity.c,
                                                      flight.capacity.s,
                                                      flight.capacity.w,
                                                      flight.capacity.y,
                                                      flight.capacity.m,
                                                    ]
                                                    .where(
                                                      (e) =>
                                                          e != null &&
                                                          e.isNotEmpty,
                                                    )
                                                    .join(' '),
                                              ),
                                              const SizedBox(width: 6),
                                            ],

                                            if ([
                                              flight.actualPax.paxC,
                                              flight.actualPax.paxY,
                                              flight.actualPax.paxInf,
                                            ].any(
                                              (e) => e != null && e.isNotEmpty,
                                            )) ...[
                                              _divider(Colors.blue),
                                              const SizedBox(width: 6),
                                              InfoBadge(
                                                label: "ACT",
                                                color: AppColors.colorPrimary,
                                              ),
                                              if (flight
                                                  .actualPax
                                                  .paxC!
                                                  .isNotEmpty) ...[
                                                const SizedBox(width: 6),
                                                InfoText(
                                                  "J${flight.actualPax.paxC}",
                                                ),
                                              ],
                                              if (flight
                                                  .actualPax
                                                  .paxY!
                                                  .isNotEmpty) ...[
                                                const SizedBox(width: 6),
                                                InfoText(
                                                  "Y${flight.actualPax.paxY}",
                                                ),
                                              ],
                                              if (flight
                                                  .actualPax
                                                  .paxInf!
                                                  .isNotEmpty) ...[
                                                const SizedBox(width: 6),
                                                InfoText(
                                                  "+ ${flight.actualPax.paxInf} INF",
                                                ),
                                              ],
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  // 🔵 Chip Filter Row (Fixed)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 12,
                      right: 0,
                      bottom: 8,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _chip("Chat"),
                          _chip("TRC"),
                          _chip("CHKIN"),
                          _chip("ARR"),
                          _chip("PIC"),
                          _chip("MVT"),
                          _chip("LDM"),
                          _chip("LIR"),
                          _chip("LDS"),
                          _chip("NOTOC"),
                          _chip("CPM"),
                          _chip("PAL/CAL"),
                          _chip("PSM"),
                          _chip("PTM"),
                          _chip("SOD"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      switch (controller.selectedTab.value) {
                        case 'Chat':
                          return Column(
                            children: const [
                              Expanded(child: ChatInfo()),
                              ChatBottomView(),
                            ],
                          );

                        case 'TRC':
                          return TrcInfo();

                        case 'CHKIN':
                          return ChkinInfo();

                        case 'ARR':
                          return ArrInfo();

                        case 'MVT':
                          return MvtInfo();

                        case 'LDM':
                          return LdmInfo();

                        case 'LIR':
                          return LirInfo();

                        case 'LDS':
                          return LdsInfo();

                        case 'NOTOC':
                          return const Center(
                            child: Text("NOTOC view not implemented yet"),
                          );

                        case 'CPM':
                          return CPMInfo();

                        case 'PAL/CAL':
                          return const Center(
                            child: Text("PAL/CAL view not implemented yet"),
                          );

                        case 'PSM':
                          return PsmInfo();

                        case 'PTM':
                          return PtmInfo();

                        case 'SOD':
                          return SodInfo();

                        default:
                          return const Center(
                            child: Text("No view for this tab"),
                          );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(Color color) =>
      Container(width: 1.0, height: 17.5, color: color);

  Widget _chip(String label) {
    final controller = Get.find<ChatController>();

    return Obx(() {
      final isSelected = controller.selectedTab.value == label;

      return GestureDetector(
        onTap: () => controller.selectedTab.value = label,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            gradient: isSelected ? appThemeGradientSoft : null,
            color: isSelected ? null : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.colorPrimary : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      );
    });
  }
}
