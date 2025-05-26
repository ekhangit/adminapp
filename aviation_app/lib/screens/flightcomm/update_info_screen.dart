import 'package:aviation_app/screens/flightcomm/form/arr_form.dart';
import 'package:aviation_app/screens/flightcomm/form/checkin_form.dart';
import 'package:aviation_app/screens/flightcomm/form/dsr_form.dart';
import 'package:aviation_app/screens/flightcomm/form/fhr_form.dart';
import 'package:aviation_app/screens/flightcomm/form/occ_form.dart';
import 'package:aviation_app/screens/flightcomm/form/pts_form.dart';
import 'package:aviation_app/screens/flightcomm/form/ssr_form.dart';
import 'package:aviation_app/screens/flightcomm/form/trc_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/flight/chat_controller.dart';
import '../../controllers/flight/flight_info_controller.dart';
import '../../utils/app_colors.dart';

class UpdateInfoScreen extends StatelessWidget {
  UpdateInfoScreen({super.key});

  final controller = Get.put(FlightInfoController());

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.grey.shade100,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        floatingActionButton: Obx(() {
          return FloatingActionButton.extended(
            onPressed:
                controller.saveLoading.value ? null : controller.saveChanges,
            icon:
                controller.saveLoading.value
                    ? null
                    : const Icon(Icons.save, color: Colors.white),
            label:
                controller.saveLoading.value
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

            backgroundColor:
                controller.saveLoading.value ? Colors.grey : Colors.green,
          );
        }),

        body: SafeArea(
          child: Column(
            children: [
              // Custom Chips instead of TabBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.clear),
                    ),

                    const SizedBox(width: 15),

                    // 🔹 Chips section (70%)
                    Expanded(
                      flex: 8,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(controller.tabTitles.length, (
                            index,
                          ) {
                            return Obx(
                              () => GestureDetector(
                                onTap:
                                    () =>
                                        controller.selectedIndex.value = index,
                                child: _chip(
                                  controller.tabTitles[index],
                                  isSelected:
                                      controller.selectedIndex.value == index,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    // const SizedBox(width: 15),

                    // // 🔹 Save Changes Button (30%)
                    // Expanded(
                    //   flex: 2,
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(vertical: 10),
                    //     decoration: BoxDecoration(
                    //       color: Colors.green,
                    //       borderRadius: BorderRadius.circular(24),
                    //     ),
                    //     child: GestureDetector(
                    //       onTap: () => Get.back(),
                    //       child: Center(
                    //         child: const Text(
                    //           "Save",
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.w600,
                    //             fontSize: 13.5,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Dynamic View Content
              Expanded(
                child: Obx(
                  () => _buildTabContent(
                    controller.tabTitles[controller.selectedIndex.value],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(String title) {
    switch (title) {
      case "TRC":
        return const TRCForm();
      case "CHECK IN":
        return const CheckInForm();
      case "SSR":
        return const SSRForm();
      case "ARR":
        return const ARRForm();
      case "PTS":
        return const PTSForm();
      case "DSR":
        return const DSRForm();
      case "FHR":
        return const FHRForm();
      case "OCC":
        return const OCCForm();
      default:
        return Center(
          child: Text(
            "$title Content Here",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        );
    }
  }

  Widget _chip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? const LinearGradient(
                    colors: [Color(0xFF003862), Color(0xFF4E87B3)],
                  )
                  : null,
          color: isSelected ? null : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
