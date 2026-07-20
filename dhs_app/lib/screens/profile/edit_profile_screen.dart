import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../constant.dart';
import '../../controllers/profile/edit_profile_controller.dart';
import '../../controllers/storage/data_storage_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/initials_avatar.dart';
import '../flightcomm/widgets/animated_attachment_option.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EditProfileController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F8),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: appThemeGradientSoft2),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Edit Profile',
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 2.5,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
            tabs: [Tab(text: 'Profile'), Tab(text: 'Detail')],
          ),
        ),
        body: Obx(() {
          if (c.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.colorPrimary),
            );
          }
          return ScrollConfiguration(
            // Disable the stretch/glow overscroll so the fields don't "drag".
            behavior: ScrollConfiguration.of(context).copyWith(
              overscroll: false,
            ),
            child: TabBarView(
              children: [_profileForm(context, c), _detailForm(context, c)],
            ),
          );
        }),
        bottomNavigationBar: _saveBar(context, c),
      ),
    );
  }

  // ── Forms ────────────────────────────────────────────────────────────
  Widget _profileForm(BuildContext context, EditProfileController c) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      children: [
        _avatarHeader(context, c),
        const SizedBox(height: 20),
        _section('Personal Information', Icons.person_outline, [
          _input('First Name', c.firstName, required: true),
          _input('Last Name', c.lastName, required: true),
          _input('Full Name', c.fullName, required: true),
          _input('Email', c.email, keyboard: TextInputType.emailAddress),
          _radioObx('Gender', const ['Male', 'Female'], c.gender),
          _picker(context, 'Work Type', c.workType, c.workTypes),
          _date(context, 'Date Of Birth', c.dob),
          _date(context, 'Date of Joining', c.doj),
        ]),
        const SizedBox(height: 16),
        _section('Contact', Icons.call_outlined, [
          _phone(context, 'Mobile (Company)', c.mobileCompany,
              c.mobileCompanyCode),
          _phone(context, 'Mobile (Personal)', c.mobilePersonal,
              c.mobilePersonalCode),
          _phone(context, 'Phone (Company)', c.phoneCompany, c.phoneCompanyCode),
          _phone(context, 'Emergency Contact', c.emergencyPhone,
              c.emergencyPhoneCode),
          _input('Emergency Contact Name', c.emergencyName, hint: 'Name'),
        ]),
        const SizedBox(height: 16),
        _section('Work Information', Icons.work_outline, [
          _picker(context, 'Station/Airport', c.station, c.stations,
              hint: 'Select Station/Airport'),
          _picker(context, 'Location (City)', c.locationSel, c.locations,
              hint: 'Select Location'),
          _picker(context, 'Department', c.department, c.departments,
              hint: 'Select Department'),
          _picker(context, 'Position', c.position, c.positions),
          _picker(context, 'Reports To', c.reportsTo, c.reportsToList),
          _picker(context, 'Alternate Report To', c.altReport, c.reportsToList,
              hint: 'Select Alternate Report To'),
          _input('Company', c.company),
          _radioObx('Contractor', const ['Yes', 'No'], c.contractor),
          _input('Annual Leave', c.annualLeave, keyboard: TextInputType.number),
        ]),
      ],
    );
  }

  Widget _detailForm(BuildContext context, EditProfileController c) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      children: [
        _section('Identity & Passport', Icons.badge_outlined, [
          _input('Passport No', c.passportNo),
          _date(context, 'Passport DOI', c.passportDoi),
          _date(context, 'Passport DEX', c.passportDex),
          _input('ID Card No', c.idCardNo),
          _input('Nationality', c.nationality),
          _input('Place of Birth', c.placeOfBirth),
          _input('Tax Code', c.taxCode),
          _input('Staff No', c.staffNo),
        ]),
        const SizedBox(height: 16),
        _section('Employment', Icons.assignment_outlined, [
          _input('Cost Center', c.costCenter),
          _input('City', c.city),
          _input('Min Hours', c.minHours, keyboard: TextInputType.number),
          _input('Max Hours', c.maxHours, keyboard: TextInputType.number),
          _date(context, 'Date Of Termination', c.dateTermination),
          _input('Reason Of Termination', c.reasonTermination),
          _input('Preferred Days Off', c.preferredDaysOff),
          _input('Address', c.address, maxLines: 4),
        ]),
      ],
    );
  }

  // ── Header + section ─────────────────────────────────────────────────
  Widget _avatarHeader(BuildContext context, EditProfileController c) {
    final user = DataStorageController.to.user;
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              user.hasPhoto
                  ? CustomImage(
                    imageUrl: user.photoUrl,
                    size: 88,
                    isNetwork: true,
                    isCircular: true,
                    borderColor: Colors.white,
                    borderWidth: 2,
                  )
                  : InitialsAvatar(
                    initials: user.initials,
                    size: 88,
                    borderRadius: 44,
                  ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => _showPhotoOptions(context),
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.matteBlackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, color: AppColors.colorPrimary, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.matteBlackColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // ── Field builders ───────────────────────────────────────────────────
  Widget _fieldLabel(String text, bool required) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.matteBlackColor,
          ),
          children:
              required
                  ? const [
                    TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                  ]
                  : const [],
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: c),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.5),
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFF6F7F9),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: border(Colors.grey.shade200),
      enabledBorder: border(Colors.grey.shade200),
      focusedBorder: border(AppColors.colorPrimary),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    String? hint,
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(label, required),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboard,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: _decoration(hint ?? 'Enter $label'),
          ),
        ],
      ),
    );
  }

  /// Tappable field that opens a themed bottom-sheet option picker.
  Widget _picker(
    BuildContext context,
    String label,
    Rxn<String> value,
    List<String> options, {
    String? hint,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(label, required),
          GestureDetector(
            onTap:
                () => _showOptionSheet(context, label, options, value),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => Text(
                        value.value ?? (hint ?? 'Select $label'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              value.value == null
                                  ? Colors.grey.shade400
                                  : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.shade500,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionSheet(
    BuildContext context,
    String title,
    List<String> options,
    Rxn<String> value,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.matteBlackColor,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children:
                      options.map((o) {
                        final selected = value.value == o;
                        return ListTile(
                          title: Text(
                            o,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight:
                                  selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                              color:
                                  selected
                                      ? AppColors.colorPrimary
                                      : Colors.black87,
                            ),
                          ),
                          trailing:
                              selected
                                  ? const Icon(
                                    Icons.check_circle,
                                    color: AppColors.colorPrimary,
                                    size: 20,
                                  )
                                  : null,
                          onTap: () {
                            value.value = o;
                            Navigator.of(sheetContext).pop();
                          },
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _date(
    BuildContext context,
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(label, false),
          TextField(
            controller: controller,
            readOnly: true,
            onTap: () => _pickDate(context, controller),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: _decoration('Enter $label').copyWith(
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _phone(
    BuildContext context,
    String label,
    TextEditingController controller,
    RxString code,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(label, false),
          Row(
            children: [
              // Country code selector
              GestureDetector(
                onTap: () => _showCountrySheet(context, code),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F7F9),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Obx(() {
                    final country = EditProfileController.countries.firstWhere(
                      (ct) => ct.dial == code.value,
                      orElse: () => EditProfileController.countries.first,
                    );
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${country.flag} ${country.dial}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    );
                  }),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  decoration: _decoration('Phone number').copyWith(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(10),
                      ),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCountrySheet(BuildContext context, RxString code) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Country',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.matteBlackColor,
                    ),
                  ),
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children:
                      EditProfileController.countries.map((ct) {
                        final selected = code.value == ct.dial;
                        return ListTile(
                          leading: Text(
                            ct.flag,
                            style: const TextStyle(fontSize: 22),
                          ),
                          title: Text(
                            ct.name,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight:
                                  selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                              color:
                                  selected
                                      ? AppColors.colorPrimary
                                      : Colors.black87,
                            ),
                          ),
                          trailing: Text(
                            ct.dial,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          onTap: () {
                            code.value = ct.dial;
                            Navigator.of(sheetContext).pop();
                          },
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _radioObx(String label, List<String> options, Rx<String?> selected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(label, false),
          Obx(
            () => RadioGroup<String>(
              groupValue: selected.value,
              onChanged: (v) => selected.value = v,
              child: Row(
                children:
                    options
                        .map(
                          (o) => Expanded(
                            child: InkWell(
                              onTap: () => selected.value = o,
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: o,
                                    activeColor: AppColors.colorPrimary,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  Text(
                                    o,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveBar(BuildContext context, EditProfileController c) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: Obx(
            () => ElevatedButton(
              onPressed:
                  c.isSaving.value ? null : () => _onSave(context, c),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.colorPrimary,
                disabledBackgroundColor: AppColors.colorPrimary.withValues(
                  alpha: 0.6,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  c.isSaving.value
                      ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                      : const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSave(BuildContext context, EditProfileController c) async {
    final error = await c.save();
    if (!context.mounted) return;
    if (error == null) {
      _toast(context, 'Profile updated successfully.');
    } else {
      _toast(context, error, isError: true);
    }
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedAttachmentOption(
                      svgPath: 'assets/svg/chat_camera.svg',
                      label: 'Camera',
                      index: 0,
                      onTap: () async {
                        Navigator.of(sheetContext).pop();
                        await _pickImage(context, ImageSource.camera);
                      },
                    ),
                    const SizedBox(width: 24),
                    AnimatedAttachmentOption(
                      svgPath: 'assets/svg/chat_gallery.svg',
                      label: 'Gallery',
                      index: 1,
                      onTap: () async {
                        Navigator.of(sheetContext).pop();
                        await _pickImage(context, ImageSource.gallery);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
      );
      if (picked != null && context.mounted) {
        // Later: upload picked.path once the API is available.
        _toast(context, 'Photo selected — uploading will be available soon.');
      }
    } catch (_) {
      if (context.mounted) _toast(context, 'Failed to pick image.');
    }
  }

  void _toast(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor:
            isError ? AppColors.colorWarning : AppColors.colorPrimary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('dd MMM yyyy').format(picked);
    }
  }
}
