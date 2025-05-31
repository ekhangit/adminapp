import 'package:aviation_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:aviation_app/screens/flightcomm/form/widget/single_selected_dropdown.dart';
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
                    onChanged:
                        (val) => controller.selectedTimeMode.value = val!,
                  ),
                  const SizedBox(width: 20),
                  _timeRadio(
                    label: "LOCAL TIME",
                    value: "Local",
                    groupValue: controller.selectedTimeMode.value,
                    onChanged:
                        (val) => controller.selectedTimeMode.value = val!,
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

              // 👉 1. Render all dropdowns first
              for (final field in dropdowns) {
                widgets.add(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SingleSelectDropdown(
                      showSearchField: false,
                      label: field.toUpperCase().replaceAll('_', ' '),
                      options: ['Yes', 'No'],
                      selectedItem:
                          controller.ptsDropdownSelections[field]!.obs,
                      hint: 'Select $field',
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.ptsDropdownSelections[field] = newValue;
                        }
                      },
                    ),
                  ),
                );
              }

              // 👉 2. Render timerFields in pairs
              for (int i = 0; i < nonDropdowns.length; i += 2) {
                final first = nonDropdowns[i];
                final second =
                    i + 1 < nonDropdowns.length ? nonDropdowns[i + 1] : null;

                widgets.add(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: timerField(
                            label: first.toUpperCase().replaceAll('_', ' '),
                            controller: controller.ptsTimeControllers[first]!,

                            // labelMaxLines: 2,
                            onTap: () => controller.pickTimePTS(first),
                          ),
                        ),
                        if (second != null) const SizedBox(width: 20),
                        if (second != null)
                          Expanded(
                            child: timerField(
                              label: second.toUpperCase().replaceAll('_', ' '),
                              controller:
                                  controller.ptsTimeControllers[second]!,

                              // labelMaxLines: 2,
                              onTap: () => controller.pickTimePTS(second),
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

  Widget _timeRadio({
    required String label,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
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
