import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/pts/pts_controller.dart';
import '../../models/flight_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_loader.dart';
import '../flightcomm/form/widget/single_selected_dropdown.dart';

class PtsScreen extends StatelessWidget {
  const PtsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PtsController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.colorWhite,
      ),
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: AppBar(
          centerTitle: true,
          title: Text("PTS", style: GoogleFonts.roboto(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          actions: [],
          backgroundColor: AppColors.colorPrimary,
        ),
        floatingActionButton: Obx(
          () =>
              controller.selectedPtsFlight.value != null
                  ? FloatingActionButton.extended(
                    label:
                        controller.isSendingPts.value
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
                        controller.isSendingPts.value
                            ? Colors.grey
                            : Colors.green,
                    onPressed:
                        controller.isSendingPts.value
                            ? null
                            : controller.sendPts,
                    icon:
                        controller.isSendingPts.value
                            ? null
                            : const Icon(Icons.save, color: Colors.white),
                  )
                  : SizedBox(),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                backgroundColor: AppColors.colorPrimary,
                color: Colors.white,
                onRefresh: () async {},
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Back arrow
                            IconButton(
                              onPressed: () => controller.navigateDate(-1),
                              icon: Icon(
                                Icons.chevron_left,
                                size: 18,
                                color: Colors.grey.shade700,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 4),

                            // Date part
                            GestureDetector(
                              onTap: () {
                                // Add date picker
                                _showDatePicker(context, controller);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    _getDatePart(
                                      controller.formattedDateTime.value,
                                    ),
                                    style: GoogleFonts.roboto(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.redAccent.shade200,
                                    ),
                                  ),

                                  const SizedBox(width: 4),

                                  Text(
                                    _getTimePart(
                                      controller.formattedDateTime.value,
                                    ),
                                    style: GoogleFonts.roboto(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Forward arrow
                            IconButton(
                              onPressed: () => controller.navigateDate(1),
                              icon: Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: Colors.grey.shade700,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),

                            // Time part (outside the container)
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            GenericSelectDropdown<FlightsModelMini>(
                              hint: 'Select Flight',
                              options: controller.ptsAllFlights,
                              selectedItem: controller.selectedPtsFlight,
                              displayText: (item) => item.flightInfo,
                              filterCondition:
                                  (item, term) => (item.flightInfo)
                                      .toLowerCase()
                                      .contains(term.toLowerCase()),
                              isSelected: (item, selected) => item == selected,
                              onChanged: (selectedFlight) {
                                // This will be called whenever a flight is selected
                                if (selectedFlight != null) {
                                  controller.fetchPTSOptions(selectedFlight.id);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Obx(() {
                        if (controller.selectedPtsFlight.value == null) {
                          return const SizedBox.shrink();
                        }
                        if (controller.isLoadingPtsOptions.value) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: CustomLoader(),
                          );
                        }
                        if (controller.getPTSOptions.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
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
                                      groupValue:
                                          controller.selectedTimeMode.value,
                                      controller: controller,
                                    ),
                                    const SizedBox(width: 20),
                                    _timeRadio(
                                      label: "LOCAL TIME",
                                      value: "Local",
                                      groupValue:
                                          controller.selectedTimeMode.value,
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
                                        .where(
                                          (field) => _isDropdownField(field),
                                        )
                                        .toList();

                                final nonDropdowns =
                                    controller.getPTSOptions
                                        .where(
                                          (field) => !_isDropdownField(field),
                                        )
                                        .toList();

                                // 1. Render dropdowns two in a row
                                for (int i = 0; i < dropdowns.length; i += 2) {
                                  final dropdownsInRow = dropdowns.sublist(
                                    i,
                                    i + 2 > dropdowns.length
                                        ? dropdowns.length
                                        : i + 2,
                                  );

                                  widgets.add(
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          // First dropdown
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right:
                                                    dropdownsInRow.length > 1
                                                        ? 8
                                                        : 0,
                                              ),
                                              child: SingleSelectDropdown(
                                                labelFontSize: 10.5,
                                                showSearchField: false,
                                                label: dropdownsInRow[0]
                                                    .toUpperCase()
                                                    .replaceAll('_', ' '),
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
                                                label: dropdownsInRow[1]
                                                    .toUpperCase()
                                                    .replaceAll('_', ' '),
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
                                for (
                                  int i = 0;
                                  i < nonDropdowns.length;
                                  i += 3
                                ) {
                                  final fieldsInRow = nonDropdowns.sublist(
                                    i,
                                    i + 3 > nonDropdowns.length
                                        ? nonDropdowns.length
                                        : i + 3,
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
                                          _buildTimeField(
                                            fieldsInRow[0],
                                            controller,
                                            2,
                                            context,
                                          ),

                                          // Second field (if exists)
                                          if (fieldsInRow.length > 1)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8,
                                              ),
                                              child: _buildTimeField(
                                                fieldsInRow[1],
                                                controller,
                                                2,
                                                context,
                                              ),
                                            ),

                                          // Third field (if exists)
                                          if (fieldsInRow.length > 2)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8,
                                              ),
                                              child: _buildTimeField(
                                                fieldsInRow[2],
                                                controller,
                                                2,
                                                context,
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
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, PtsController controller) async {
    final initialDate = controller.selectedDate.value ?? DateTime.now().toUtc();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.colorPrimary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.colorPrimary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      await controller.handleDateChange(pickedDate);
    }
  }

  // Helper widget for consistent time field styling
  Widget _buildTimeField(
    String field,
    PtsController controller,
    int maxLines,
    BuildContext context,
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
          ptsController: controller,
          context: context,
        ),
      ),
    );
  }

  // Calculate width based on screen size and field count
  double _calculateFieldWidth() {
    final screenWidth = Get.width;
    final padding = 16 * 2.5; // Total horizontal padding
    final spacing = 8 * 2; // Total spacing between fields
    return (screenWidth - padding - spacing) / 3;
  }

  Widget _timeRadio({
    required String label,
    required String value,
    required String groupValue,
    required PtsController controller,
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

String _getDatePart(String value) {
  final split = value.split(' ');
  if (split.length < 5) return value;
  return '${split[0].replaceAll(',', '')}, ${split[1]} ${split[2]} ${split[3]}';
}

String _getTimePart(String value) {
  final split = value.split(' ');
  if (split.length < 5) return '';
  return '${split[4]} ${split[5]}';
}

Widget timerField2({
  required String label,
  required TextEditingController controller,

  required PtsController ptsController,
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
                  onTap: () => ptsController.showManualTimeInput(controller),
                  child: GetBuilder<PtsController>(
                    builder: (ctr) {
                      final currentTime = controller.text;
                      final displayTime = ptsController.getDisplayTime(
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
