import 'package:dhs_app/controllers/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant.dart';
import '../../controllers/storage/data_storage_controller.dart';
import '../../models/user_model.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/initials_avatar.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _scroll = ScrollController();
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final collapsed = _scroll.hasClients && _scroll.offset > 24;
    if (collapsed != _collapsed) setState(() => _collapsed = collapsed);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = DataStorageController.to.user;
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      body: Column(
        children: [
          Obx(() => _buildHeader(user)),
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              children: [
                Obx(() => _buildReportsToCard()),
                _buildTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () => Get.to(() => const EditProfileScreen()),
                ),
                _buildTile(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () => Get.to(() => const ChangePasswordScreen()),
                ),
                // Push notification toggle
                Obx(
                  () => _buildTile(
                    icon: Icons.notifications_outlined,
                    title: 'Push Notification',
                    trailing: Switch.adaptive(
                      value: controller.pushEnabled.value,
                      activeThumbColor: AppColors.colorPrimary,
                      onChanged: controller.togglePush,
                    ),
                  ),
                ),
                // Dark mode toggle
                Obx(
                  () => _buildTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    trailing: Switch.adaptive(
                      value: controller.darkMode.value,
                      activeThumbColor: AppColors.colorPrimary,
                      onChanged: controller.toggleDarkMode,
                    ),
                  ),
                ),
                _buildTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  color: AppColors.colorWarning,
                  showChevron: false,
                  onTap: () => _confirmLogout(context, controller),
                ),
                const SizedBox(height: 24),
                // Logo + version / copyright
                Column(
                  children: [
                    Image.asset('assets/images/logo_new.png', height: 22),
                    const SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '2026© All Rights Reserved',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                // Extra scroll room so the collapsed header stays put.
                const SizedBox(height: 180),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(UserModel user, double size) {
    return user.hasPhoto
        ? CustomImage(
          imageUrl: user.photoUrl,
          size: size,
          isNetwork: true,
          isCircular: true,
          borderColor: Colors.white,
          borderWidth: 2,
        )
        : InitialsAvatar(
          initials: user.initials,
          size: size,
          borderRadius: size / 2,
          backgroundColor: Colors.white24,
          textColor: Colors.white,
        );
  }

  /// Dark header that collapses to avatar + name as the list scrolls.
  Widget _buildHeader(UserModel user) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: appThemeGradientSoft2),
      child: SafeArea(
        bottom: false,
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 450),
          sizeCurve: Curves.easeInOut,
          firstCurve: Curves.easeInOut,
          secondCurve: Curves.easeInOut,
          alignment: Alignment.center,
          crossFadeState:
              _collapsed
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
          firstChild: _expandedHeader(user),
          secondChild: _collapsedHeader(user),
        ),
      ),
    );
  }

  /// Full header: avatar + name + info rows + role badge.
  Widget _expandedHeader(UserModel user) {
    final emp = DataStorageController.to.empProfile.value;
    final name =
        (emp?.fullName.isNotEmpty ?? false) ? emp!.fullName : user.name;
    final email = (emp?.email.isNotEmpty ?? false) ? emp!.email : user.email;
    final position = (emp?.position?.isNotEmpty ?? false) ? emp!.position! : '-';
    final city = (emp?.airport?.isNotEmpty ?? false) ? emp!.airport! : '-';
    final phone =
        (emp?.phoneCompany?.isNotEmpty ?? false) ? emp!.phoneCompany! : '-';
    final type = (emp?.type?.isNotEmpty ?? false) ? emp!.type! : '-';
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _avatar(user, 76),
          const SizedBox(height: 12),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _infoRow(Icons.email_outlined, email),
          _infoRow(Icons.person_outline, position),
          _infoRow(Icons.location_on_outlined, city),
          _infoRow(Icons.phone_outlined, phone),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFDDF5E0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  size: 15,
                  color: Color(0xFF2E9E4F),
                ),
                const SizedBox(width: 5),
                Text(
                  type,
                  style: const TextStyle(
                    color: Color(0xFF2E9E4F),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  /// Collapsed header: small avatar + name only.
  Widget _collapsedHeader(UserModel user) {
    final emp = DataStorageController.to.empProfile.value;
    final name =
        (emp?.fullName.isNotEmpty ?? false) ? emp!.fullName : user.name;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _avatar(user, 40),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A centered icon + text row for a single profile field.
  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.8)),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// "Reports To" (manager / approver) info card.
  Widget _buildReportsToCard() {
    final rt = DataStorageController.to.empProfile.value?.reportsTo;
    final reportsTo = (rt?.isNotEmpty ?? false) ? rt! : '-';
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.colorPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.supervisor_account_outlined,
                  color: AppColors.colorPrimary,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Reports To',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.matteBlackColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _cardInfoRow(Icons.account_circle_outlined, reportsTo),
        ],
      ),
    );
  }

  /// Dark-on-white icon + text row used inside cards.
  Widget _cardInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 17, color: AppColors.colorPrimary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.matteBlackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    Color? color,
    bool showChevron = true,
  }) {
    final accent = color ?? AppColors.colorPrimary;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accent, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: color ?? AppColors.matteBlackColor,
                    ),
                  ),
                ),
                if (trailing != null)
                  trailing
                else if (showChevron)
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _confirmLogout(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.colorWarning.withValues(alpha: 0.1),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: AppColors.colorWarning,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.matteBlackColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                          foregroundColor: AppColors.matteBlackColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          controller.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: AppColors.colorWarning,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Logout'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
