import 'package:asg_app/screens/flightcomm/form/widget/single_selected_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/flight/flight_info_controller.dart';
import '../../../utils/app_colors.dart';

class PTSForm extends StatelessWidget {
  const PTSForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightInfoController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _timeRadio(
                    label: "UTC TIME",
                    value: "UTC",
                    groupValue: controller.selectedTimeMode.value,
                    controller: controller,
                  ),
                  const SizedBox(width: 20),
                  _timeRadio(
                    label: "LOCAL TIME",
                    value: "Local",
                    groupValue: controller.selectedTimeMode.value,
                    controller: controller,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Obx(() {
              final List<Widget> widgets = [];

              final dropdowns =
                  controller.getPTSOptions
                      .where((field) => _isDropdownField(field))
                      .toList();

              final nonDropdowns =
                  controller.getPTSOptions
                      .where((field) => !_isDropdownField(field))
                      .toList();

              // 1. Render dropdowns two in a row
              for (int i = 0; i < dropdowns.length; i += 2) {
                final dropdownsInRow = dropdowns.sublist(
                  i,
                  i + 2 > dropdowns.length ? dropdowns.length : i + 2,
                );

                widgets.add(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        // First dropdown
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: dropdownsInRow.length > 1 ? 8 : 0,
                            ),
                            child: SingleSelectDropdown(
                              labelFontSize: 10.5,
                              showSearchField: false,
                              label: dropdownsInRow[0].toUpperCase().replaceAll(
                                '_',
                                ' ',
                              ),
                              options: ['Yes', 'No'],
                              selectedItem:
                                  controller
                                      .ptsDropdownSelections[dropdownsInRow[0]]!
                                      .obs,
                              hint: 'Select',
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller
                                          .ptsDropdownSelections[dropdownsInRow[0]] =
                                      newValue;
                                }
                              },
                            ),
                          ),
                        ),

                        // Second dropdown if exists
                        if (dropdownsInRow.length > 1)
                          Expanded(
                            child: SingleSelectDropdown(
                              labelFontSize: 10.5,
                              showSearchField: false,
                              label: dropdownsInRow[1].toUpperCase().replaceAll(
                                '_',
                                ' ',
                              ),
                              options: ['Yes', 'No'],
                              selectedItem:
                                  controller
                                      .ptsDropdownSelections[dropdownsInRow[1]]!
                                      .obs,
                              hint: 'Select',
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller
                                          .ptsDropdownSelections[dropdownsInRow[1]] =
                                      newValue;
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }

              // 2. Render timerField2 widgets in rows of up to 3
              for (int i = 0; i < nonDropdowns.length; i += 3) {
                final fieldsInRow = nonDropdowns.sublist(
                  i,
                  i + 3 > nonDropdowns.length ? nonDropdowns.length : i + 3,
                );

                // Find the maximum lines needed in this row
                // final maxLinesInRow = fieldsInRow.fold(1, (max, field) {
                //   final label = field.toUpperCase().replaceAll('_', ' ');
                //   final lineCount = '\n'.allMatches(label).length + 1;
                //   return lineCount > max ? lineCount : max;
                // });

                widgets.add(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        // First field (always exists)
                        _buildTimeField(fieldsInRow[0], controller, 2),

                        // Second field (if exists)
                        if (fieldsInRow.length > 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _buildTimeField(
                              fieldsInRow[1],
                              controller,
                              2,
                            ),
                          ),

                        // Third field (if exists)
                        if (fieldsInRow.length > 2)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _buildTimeField(
                              fieldsInRow[2],
                              controller,
                              2,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }

              return Column(children: widgets);
            }),
          ],
        ),
      ),
    );
  }

  // Helper widget for consistent time field styling
  Widget _buildTimeField(
    String field,
    FlightInfoController controller,
    int maxLines,
  ) {
    return SizedBox(
      width: _calculateFieldWidth(), // Calculate width based on field count
      height: 110,
      child: Obx(
        () => timerField2(
          label: field.toUpperCase().replaceAll('_', ' '),
          controller: controller.ptsTimeControllers[field]!,
          onTap: () => controller.pickTimePTS(field),
          iconSize: 24,
          labelMaxLines: maxLines,
          flightInfoController: controller,
        ),
      ),
    );
  }

  // Calculate width based on screen size and field count
  double _calculateFieldWidth() {
    final screenWidth = Get.width;
    final padding = 16 * 2; // Total horizontal padding
    final spacing = 8 * 2; // Total spacing between fields
    return (screenWidth - padding - spacing) / 3;
  }

  Widget _timeRadio({
    required String label,
    required String value,
    required String groupValue,
    required FlightInfoController controller,
  }) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: (val) {
            if (val != null) {
              controller.updateTimeMode(val);
            }
          },
          activeColor: AppColors.colorSuccess,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 13.5, color: Colors.red)),
      ],
    );
  }

  bool _isDropdownField(String field) {
    return field == 'jetway/steps' || field == 'back_steps_used';
  }
}

Widget timerField2({
  required String label,
  required TextEditingController controller,
  required FlightInfoController flightInfoController,
  VoidCallback? onTap,
  int labelMaxLines = 1,
  Color iconColor = Colors.white,
  Color borderColor = Colors.grey,
  double borderWidth = 0.2,
  double iconSize = 24,
  TextStyle? timeTextStyle,
  EdgeInsetsGeometry? padding,
  BuildContext? context,
}) {
  // Calculate heights based on line count
  final labelHeight = 28.0;
  final containerHeight = 70.0;
  final iconSectionHeight = containerHeight * 0.55;
  // final timeSectionHeight = containerHeight * 0.35;

  return GestureDetector(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label with calculated height
        SizedBox(
          height: labelHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10.5,
                color: AppColors.colorPrimary,
                height: 1.1, // Line height
              ),
              maxLines: labelMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Time container with dynamic height
        Container(
          width: double.infinity,
          height: containerHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon section (top 40%)
              Container(
                height: iconSectionHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.colorPrimary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: Icon(
                    Icons.access_time,
                    size: iconSize,
                    color: iconColor,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap:
                      () =>
                          flightInfoController.showManualTimeInput(controller),
                  child: GetBuilder<FlightInfoController>(
                    builder: (ctr) {
                      final currentTime = controller.text;
                      final displayTime = flightInfoController.getDisplayTime(
                        currentTime,
                      );
                      return Center(
                        child: Text(
                          displayTime.isEmpty ? '00:00' : displayTime,
                          style:
                              timeTextStyle ??
                              const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
