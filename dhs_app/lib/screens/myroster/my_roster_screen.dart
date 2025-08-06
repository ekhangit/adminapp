import 'package:dhs_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/my_roster/my_roster_controller.dart';

import 'package:intl/intl.dart';

class MyRosterScreen extends StatelessWidget {
  MyRosterScreen({super.key});

  final controller = Get.put(MyRosterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Roster", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.colorPrimary,
        actions: [
          Obx(
            () =>
                controller.selectedDuties.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {},
                    )
                    : const SizedBox(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tab Buttons
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTabButton('Today', 0),
                  const SizedBox(width: 8),
                  _buildTabButton('Monthly Roster', 1),
                  const SizedBox(width: 8),
                  _buildTabButton('Custom Range', 2),
                ],
              ),
            ),

            // View switcher
            Obx(() {
              switch (controller.selectedTabIndex.value) {
                case 0:
                  return _buildTodayView();
                case 1:
                  return _buildMonthlyRoster();
                case 2:
                  return SizedBox();
                default:
                  return _buildTodayView();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectedTabIndex.value = index,
        child: Container(
          decoration: BoxDecoration(
            color:
                controller.selectedTabIndex.value == index
                    ? AppColors.colorPrimary.withOpacity(0.1)
                    : Colors.white,
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                color:
                    controller.selectedTabIndex.value == index
                        ? AppColors.colorPrimary.withOpacity(0.75)
                        : Colors.black87,
                fontWeight:
                    controller.selectedTabIndex.value == index
                        ? FontWeight.w600
                        : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // In your _buildDateHeader() method, update to:
  Widget _buildDateHeader() {
    // Get current date
    final now = DateTime.now();
    // Format date as "YYYY-MM-DD DayOfWeek"
    final formattedDate = DateFormat('yyyy-MM-dd EEEE').format(now);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(formattedDate, style: const TextStyle(fontSize: 14)),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.colorPrimary),
            onPressed: controller.showAddOptionsBottomSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildDutyCard(Duty duty) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.toggleDutySelection(duty.id),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: duty.color.withValues(
              alpha: controller.selectedDuties.contains(duty.id) ? 0.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
            border:
                controller.selectedDuties.contains(duty.id)
                    ? Border.all(color: Colors.red, width: 3)
                    : null,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    duty.title,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    duty.time,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
              if (controller.selectedDuties.contains(duty.id))
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      controller.showMarkDutyBottomSheet();
                    },
                    child: const Text(
                      'MARK DUTY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDutyTag(
    String label,
    Color backColor,
    Color borderColor, {
    Color textColor = Colors.black,
  }) {
    return Container(
      width: 120.0,
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTodayView() {
    return Column(
      children: [
        _buildDateHeader(),
        // Duties Grid
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          padding: const EdgeInsets.all(12.0),
          childAspectRatio: 2.2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children:
              controller.duties.map((duty) => _buildDutyCard(duty)).toList(),
        ),

        const Divider(),

        // Duty Type Tags
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              _buildDutyTag(
                'Office Duties',
                const Color(0xFF8ecae6),
                const Color(0xFF369ebc),
              ),
              _buildDutyTag(
                'Marked Duties',
                const Color(0xFF5e96de),
                const Color(0xFF0e2680),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'Leave',
                const Color(0xFFe77f7f),
                const Color(0xFFf30104),
              ),
              _buildDutyTag(
                'Day Off',
                const Color(0xFFf0a640),
                const Color(0xFFf69502),
              ),
              _buildDutyTag(
                'Unassigned',
                const Color(0xFFf8e500),
                const Color(0xFFf8e500),
              ),
            ],
          ),
        ),

        // Duty Category Tags
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              _buildDutyTag(
                'ARR-A',
                const Color(0xFFa14a73),
                const Color(0xFFa14a73),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'GATE',
                const Color(0xFF1f456e),
                const Color(0xFF1f456e),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'GATE-T',
                const Color(0xFF5a2b2a),
                const Color(0xFF5a2b2a),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'TRG-B',
                const Color(0xFF1a47ab),
                const Color(0xFF1a47ab),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'CKIN',
                const Color(0xFF369eac),
                const Color(0xFF369eac),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'CKIN-T',
                const Color(0xFF425d67),
                const Color(0xFF425d67),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'C-COOR',
                const Color(0xFFa18567),
                const Color(0xFFa18567),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'TRG-C',
                const Color(0xFF5d4483),
                const Color(0xFF5d4483),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'GBAG',
                const Color(0xFF924386),
                const Color(0xFF924386),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'B-COOR',
                const Color(0xFF175503),
                const Color(0xFF175503),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'LDCL',
                const Color(0xFFcd6d00),
                const Color(0xFFcd6d00),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'LOFO',
                const Color(0xFF8f8c2b),
                const Color(0xFF8f8c2b),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'SVC-C',
                const Color(0xFF19545c),
                const Color(0xFF19545c),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'TRC',
                const Color(0xFF8f5e04),
                const Color(0xFF8f5e04),
                textColor: Colors.white,
              ),
              _buildDutyTag(
                'TRC-T',
                const Color(0xFF2c635a),
                const Color(0xFF2c635a),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyRoster() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month navigation header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(controller.currentMonth.value),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: controller.previousMonth,
                      splashRadius: 20,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: controller.nextMonth,
                      splashRadius: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Week list with horizontal date boxes
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.weeksInMonth.length,
            itemBuilder: (context, weekIndex) {
              final week = controller.weeksInMonth[weekIndex];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Week header
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(
                      'Week ${week.number}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Horizontal date boxes
                  SizedBox(
                    height: 150, // Reduced height for compact view
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: week.days.length,
                      itemBuilder: (context, dayIndex) {
                        final day = week.days[dayIndex];
                        return Container(
                          width: 130, // Slightly wider for better text display
                          margin: EdgeInsets.only(
                            left: dayIndex == 0 ? 16 : 8,
                            right: dayIndex == week.days.length - 1 ? 16 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.colorWhite,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Line 1: Date
                                Text(
                                  DateFormat('yyyy-MM-dd EEE').format(day.date),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),

                                // Line 2: Status or duty info
                                if (day.duties.isEmpty)
                                  const Text(
                                    'Unassigned',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  )
                                else
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Start ${day.duties[0].time}',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      Text(
                                        'End ${day.duties[1].time}',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),

                                Spacer(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
