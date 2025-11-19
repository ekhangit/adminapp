import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/myroster/my_roster_controller.dart';
import '../../../widgets/custom_loader.dart';
import '../widgets/roster_listview.dart';

class MonthlyRosterTab extends StatelessWidget {
  const MonthlyRosterTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyRosterController>();

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.isLoadingMonthlyRoster.value)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: CustomLoader(),
            ),

          RosterListview(weeksInMonth: controller.weeksInMonth),
        ],
      ),
    );
  }
}
