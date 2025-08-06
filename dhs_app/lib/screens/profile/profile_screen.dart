import 'package:dhs_app/controllers/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/storage/data_storage_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DataStorageController.to.user;
    final ProfileController controller = Get.put(ProfileController());

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
                  user.profilePhotoPath != null &&
                          user.profilePhotoPath!.isNotEmpty
                      ? NetworkImage(user.profilePhotoPath!)
                      : null,
              child:
                  user.profilePhotoPath == null ||
                          user.profilePhotoPath!.isEmpty
                      ? Text(
                        user.name.isNotEmpty ? user.name[0] : "?",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorPrimary,
                        ),
                      )
                      : null,
            ),
            const SizedBox(height: 20),

            // Name
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.matteBlackColor,
              ),
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              user.email,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const Spacer(),

            // 🔒 Logout Button
            CustomButton(
              text: "Logout",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(); // Close dialog
                            controller.logout(); // Perform logout
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    );
                  },
                );
              },
              color: AppColors.buttonColor1,
              isLoading: false,
              loadingWidget: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
