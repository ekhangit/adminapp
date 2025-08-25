import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../controllers/myroster/my_roster_controller.dart';
import '../../../models/roster_models.dart';
import '../../../widgets/custom_loader.dart';
import '../widgets/duty_card.dart';

class TodayRosterTab extends StatelessWidget {
  const TodayRosterTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyRosterController>();

    return Obx(() {
      if (controller.isLoadingTodayRoster.value) {
        return Padding(
          padding: const EdgeInsets.only(top: 30),
          child: CustomLoader(),
        );
      }

      final todayData = controller.todayRoster.value;

      if (todayData == null) {
        return Center(
          child: Text(
            'No roster data available',
            style: GoogleFonts.roboto(fontSize: 16),
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12),
            _buildDateHeader(todayData),
            // Check if duties are empty or user is on leave/day off
            _shouldShowEmptyState(todayData)
                ? _buildEmptyState(todayData)
                : Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Column(
                    children: [
                      // Time Info Section
                      _buildTimeInfoSection(todayData, controller),
                      const SizedBox(height: 20),
                      // Duties Grid
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s Roster',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 12),
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 12.0,
                              childAspectRatio: 1.5,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children:
                                  todayData.duties
                                      .map(
                                        (duty) => DutyCard(
                                          duty: duty,
                                          controller: controller,
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      );
    });
  }

  bool _shouldShowEmptyState(TodayRoster todayData) {
    return todayData.duties.isEmpty ||
        todayData.isOnLeave ||
        todayData.isDayOff;
  }

  Widget _buildDateHeader(TodayRoster todayData) {
    final date = DateTime.parse(todayData.date);
    final formattedDate = DateFormat('yyyy-MM-dd EEEE').format(date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withValues(alpha: 0.9),
                ),
              ),
              if (todayData.isOnLeave || todayData.isDayOff)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        todayData.isOnLeave
                            ? Colors.orange.withValues(alpha: 0.2)
                            : Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: todayData.isOnLeave ? Colors.orange : Colors.green,
                    ),
                  ),
                  child: Text(
                    todayData.isOnLeave ? 'On Leave' : 'Day Off',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: todayData.isOnLeave ? Colors.orange : Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfoSection(
    TodayRoster todayData,
    MyRosterController controller,
  ) {
    final startTime =
        todayData.startTime != null
            ? todayData.startTime!.split(' ').last.substring(0, 5)
            : '';
    final endTime =
        todayData.endTime != null
            ? todayData.endTime!.split(' ').last.substring(0, 5)
            : '';

    final breakTime =
        todayData.breakHours > 0 || todayData.breakMinutes > 0
            ? '${todayData.breakHours}h ${todayData.breakMinutes}m'
            : '--:--';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTimeInfoItem(
                  'Add Break Time',
                  breakTime,
                  Icons.add_circle_outline,
                  Colors.deepPurple,
                  isTappable: true,
                  onTap: () => controller.showAddBreakTimeBottomSheet(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimeInfoItem(
                  'Start Time',
                  startTime,
                  null,
                  Colors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTimeInfoItem(
                  'End Time',
                  endTime,
                  null,
                  Colors.indigo,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimeInfoItem(
                  'Total duty Time',
                  todayData.formattedDutyTime,
                  null,
                  Colors.amber[700]!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfoItem(
    String label,
    String value,
    IconData? icon,
    Color color, {
    bool isTappable = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isTappable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  if (value.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(TodayRoster todayData) {
    String title;
    String subtitle;
    String description;
    IconData icon;
    List<Color> gradientColors;
    Color borderColor;

    if (todayData.isOnLeave) {
      title = 'On Leave';
      subtitle = 'You are on leave today';
      description = 'Enjoy your time off!';
      icon = Icons.beach_access;
      gradientColors = [Colors.orange.shade300, Colors.orange.shade100];
      borderColor = Colors.orange.shade400;
    } else if (todayData.isDayOff) {
      title = 'Day Off';
      subtitle = 'It\'s your day off';
      description = 'Relax and recharge for the upcoming workdays';
      icon = Icons.weekend;
      gradientColors = [Colors.green.shade300, Colors.green.shade100];
      borderColor = Colors.green.shade400;
    } else {
      title = 'Unassigned';
      subtitle = 'No duties assigned for today';
      description = 'Your schedule will appear here once duties are assigned';
      icon = Icons.assignment_outlined;
      gradientColors = [Colors.yellow.shade300, Colors.yellow.shade100];
      borderColor = Colors.yellow.shade400;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: Colors.yellow),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.black.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.black.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
