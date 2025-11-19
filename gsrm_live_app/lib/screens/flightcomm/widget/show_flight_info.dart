import 'package:gsrm_live_app/screens/flightcomm/form/arr_form.dart';
import 'package:gsrm_live_app/screens/flightcomm/form/checkin_form.dart';
import 'package:gsrm_live_app/screens/flightcomm/form/dsr_form.dart';
import 'package:gsrm_live_app/screens/flightcomm/form/fhr_form.dart';
import 'package:gsrm_live_app/screens/flightcomm/form/occ_form.dart';
import 'package:gsrm_live_app/screens/flightcomm/form/pts_form.dart';
import 'package:gsrm_live_app/screens/flightcomm/form/ssr_form.dart';
import 'package:gsrm_live_app/screens/flightcomm/form/trc_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showFlightInfoBottomSheet(BuildContext context) {
  final RxInt selectedIndex = 0.obs;
  final List<String> tabTitles = [
    "TRC",
    "CHECK IN",
    "SSR",
    "ARR",
    "PTS",
    "DSR",
    "FHR",
    "STAFF",
    "OCC",
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Obx(
              () => Column(
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Custom Chips instead of TabBar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // 🔹 Chips section (70%)
                        Expanded(
                          flex: 8,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(tabTitles.length, (
                                index,
                              ) {
                                return GestureDetector(
                                  onTap: () => selectedIndex.value = index,
                                  child: _chip(
                                    tabTitles[index],
                                    isSelected: selectedIndex.value == index,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        // 🔹 Save Changes Button (30%)
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: GestureDetector(
                              onTap: () => Get.back(),
                              child: Center(
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Dynamic View Content
                  Expanded(
                    child: _buildTabContent(tabTitles[selectedIndex.value]),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
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
