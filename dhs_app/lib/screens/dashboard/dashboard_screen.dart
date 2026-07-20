import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';
import '../../controllers/flight/airline_controller.dart';
import '../../controllers/storage/data_storage_controller.dart';
import '../../models/user_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_box.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/initials_avatar.dart';
import '../attendance/attendence_screen.dart';
import '../flightcomm/flight_comm_screen.dart';
import '../leave/leave_request_screen.dart';
import '../library/library_screen.dart';
import '../library/read_sign_screen.dart';
import '../myroster/my_roster_screen.dart';
import '../pts/pts_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DataStorageController.to.user;

    // Initialize AirlineController to cache airlines
    if (!Get.isRegistered<AirlineController>()) {
      Get.put(AirlineController());
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Column(
        children: [
          _buildHeader(user),
          Expanded(child: _buildGrid(context)),
        ],
      ),
    );
  }

  /// 🔵 Top header: avatar + name + attendance shortcut.
  Widget _buildHeader(UserModel user) {
    return Container(
      color: AppColors.colorWhite,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              user.hasPhoto
                  ? CustomImage(
                    imageUrl: user.photoUrl,
                    size: 48,
                    isNetwork: true,
                    isCircular: false,
                    borderRadius: 8,
                  )
                  : InitialsAvatar(
                    initials: user.initials,
                    size: 48,
                    borderRadius: 8,
                  ),
              const SizedBox(width: 15.0),
              Expanded(
                child: Obx(() {
                  final emp = DataStorageController.to.empProfile.value;
                  final name =
                      (emp?.fullName.isNotEmpty ?? false)
                          ? emp!.fullName
                          : user.name;
                  final position =
                      (emp?.position?.isNotEmpty ?? false)
                          ? emp!.position!
                          : '-';
                  final city =
                      (emp?.airport?.isNotEmpty ?? false)
                          ? emp!.airport!
                          : '-';
                  final subStyle = GoogleFonts.roboto(
                    color: AppColors.colorPrimary.withValues(alpha: 0.75),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          color: AppColors.colorPrimary,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        position,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: subStyle,
                      ),
                      Text(
                        city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: subStyle,
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(width: 12),
              // Attendance shortcut
              GestureDetector(
                onTap: () => Get.to(() => const AttendanceScreen()),
                child: Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.colorPrimary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/svg/clock.svg',
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.colorPrimary,
                      BlendMode.srcIn,
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

  /// ⚪ Grid of feature tiles (3 per row, fills the remaining height).
  Widget _buildGrid(BuildContext context) {
    void comingSoon() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Coming Soon — this feature will be available soon.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.colorPrimary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    final tiles = <Widget>[
      CustomBox2(
        title: 'Flight Comms',
        iconPath: 'assets/images/flight_comm_final.png',
        onTap: () => Get.to(() => const FlightCommScreen()),
      ),
      CustomBox2(
        title: 'PTS',
        iconPath: 'assets/images/airlines_final.png',
        onTap: () => Get.to(() => const PtsScreen()),
      ),
      CustomBox2(
        title: 'Licenses & Approvals',
        iconPath: 'assets/images/read_and_sign_final.png',
        onTap: comingSoon,
      ),
      CustomBox2(
        title: 'Read & Sign',
        iconPath: 'assets/images/read_and_sign_final.png',
        onTap: () => Get.to(() => const ReadSignScreen()),
      ),
      CustomBox2(
        title: 'Library',
        iconPath: 'assets/images/library_final.png',
        onTap: () => Get.to(() => LibraryScreen()),
      ),
      CustomBox2(
        title: 'My Leaves',
        iconPath: 'assets/images/airlines_final.png',
        onTap: () => Get.to(() => const LeaveRequestScreen()),
      ),
      CustomBox2(
        title: 'HR',
        iconPath: 'assets/images/hr_final.png',
        onTap: () => Get.to(() => const AttendanceScreen()),
      ),
      CustomBox2(
        title: 'My Duties',
        iconPath: 'assets/images/my_duties_final.png',
        onTap: () => Get.to(() => MyRosterScreen()),
      ),
      CustomBox2(
        title: 'Airlines',
        iconPath: 'assets/images/airlines_final.png',
        onTap: comingSoon,
      ),
      CustomBox2(
        title: 'Staff Watch',
        iconPath: 'assets/images/staff_watch_final.png',
        onTap: comingSoon,
      ),
      CustomBox2(
        title: 'Flight Tracker',
        iconPath: 'assets/images/flight_tracker_final.png',
        onTap: comingSoon,
      ),
      CustomBox2(
        title: 'Flight Watch',
        iconPath: 'assets/images/flight_watch_final.png',
        onTap: comingSoon,
      ),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: appThemeGradientSoft2),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 28, bottom: 10),
        child: Column(
          children: [
            for (int i = 0; i < tiles.length; i += 3)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int j = i; j < i + 3; j++)
                      Expanded(
                        child:
                            j < tiles.length
                                ? tiles[j]
                                : const SizedBox.shrink(),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
