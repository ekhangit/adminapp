import 'package:get/get.dart';
import '../../models/roster_models.dart';
import '../../services/my_roster_service.dart';

mixin TodayRosterMixin on GetxController {
  final isLoadingTodayRoster = false.obs;
  final todayRoster = Rxn<TodayRoster>();
  final duties = <Duty>[].obs;

  // Load today roster from API
  Future<void> loadTodayRosterFromAPI() async {
    isLoadingTodayRoster.value = true;
    try {
      final response = await MyRosterService.instance.todayRoster();

      if (response.isSuccess) {
        todayRoster.value = response.data;
        duties.clear();
        duties.addAll(todayRoster.value!.duties);
      } else {
        print('Failed to load today roster: ${response.errorMessage}');
        Get.snackbar('Error', response.errorMessage);
      }
    } catch (e) {
      print('Error loading today roster: $e');
      Get.snackbar('Error', 'Failed to load roster: $e');
    } finally {
      isLoadingTodayRoster.value = false;
    }
  }
}
