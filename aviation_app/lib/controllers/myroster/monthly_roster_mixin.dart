import 'package:get/get.dart';

import '../../models/roster_models.dart';
import '../../services/my_roster_service.dart';

mixin MonthlyRosterMixin on GetxController {
  final isLoadingMonthlyRoster = false.obs;
  final currentMonth = DateTime.now().obs;
  final currentWeek = 0.obs; // Initialize with week 34
  final weeksInMonth = <Week>[].obs;

  // Expand/collapse state for each week
  final expandedWeeks = <int, bool>{}.obs;

  Future<void> loadMonthlyRosterFromAPI() async {
    isLoadingMonthlyRoster.value = true;
    try {
      final response = await MyRosterService.instance.monthlyRoster();

      if (response.isSuccess) {
        // Extract weeks from MonthlyRoster object
        final result = response.data as List<Week>;
        weeksInMonth.value = result; // Access the weeks list

        // Update current week if available
        if (weeksInMonth.isNotEmpty) {
          currentWeek.value = weeksInMonth.first.number;
        }
      } else {
        print('Failed to load monthly roster: ${response.errorMessage}');
        Get.snackbar('Error', response.errorMessage);
      }
    } catch (e) {
      print('Error loading today roster: $e');
      Get.snackbar('Error', 'Failed to load roster: $e');
    } finally {
      isLoadingMonthlyRoster.value = false;
    }
  }
}
