import 'package:aviation_app/controllers/flight/chat_controller.dart';
import 'package:aviation_app/screens/flightcomm/info/chat_info.dart';
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
                  Obx(
                    () => Container(
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
                          // 🔹 First Row (Always Visible)
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
                              const SizedBox(width: 5),
                              Expanded(
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 6,
                                  runSpacing: 2,
                                  children: const [
                                    Text(
                                      "IB 1332 | FRA-MAD",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.5,
                                        height: 0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "GATE: B37 | POS: 804",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.5,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => controller.toggleHeaderExpansion(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: AppColors.matteBlackColor,
                                      width: 0.2,
                                    ),
                                  ),
                                  child: Text(
                                    controller.isHeaderExpanded.value
                                        ? "Hide"
                                        : "Show",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // 🔽 Expanded Row (Conditional)
                          if (controller.isHeaderExpanded.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                InfoBadge(label: "ATD", color: Colors.blue),
                                InfoText("24 05:10", textColor: Colors.black),
                                InfoText("CRJX"),
                                InfoText("|"),
                                InfoText("EC-MNR"),
                                InfoText("|"),
                                InfoText("CFG"),
                                InfoText("J6 Y94"),
                                InfoText("|"),
                                InfoText("ACT 3C"),
                                InfoText("J3 Y62"),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // 🔵 Chip Filter Row (Fixed)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                      top: 4,
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
                          return const Center(
                            child: Text("Check-in Data Placeholder"),
                          );

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
