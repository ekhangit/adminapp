import 'dart:io';

import 'package:aviation_app/controllers/flight/chat_controller.dart';
import 'package:aviation_app/screens/flightcomm/file_preview_screen.dart';
import 'package:aviation_app/screens/flightcomm/image_preview_screen.dart';
import 'package:aviation_app/screens/flightcomm/info/arr_info.dart';
import 'package:aviation_app/screens/flightcomm/info/chat_info.dart';
import 'package:aviation_app/screens/flightcomm/info/chkin_info.dart';
import 'package:aviation_app/screens/flightcomm/info/cpm_info.dart';
import 'package:aviation_app/screens/flightcomm/info/ldm_info.dart';
import 'package:aviation_app/screens/flightcomm/info/lds_info.dart';
import 'package:aviation_app/screens/flightcomm/info/lir_info.dart';
import 'package:aviation_app/screens/flightcomm/info/mvt_info.dart';
import 'package:aviation_app/screens/flightcomm/info/pic_info.dart';
import 'package:aviation_app/screens/flightcomm/info/psm_info.dart';
import 'package:aviation_app/screens/flightcomm/info/ptm_info.dart';
import 'package:aviation_app/screens/flightcomm/info/sod_info.dart';
import 'package:aviation_app/screens/flightcomm/info/trc_info.dart';
import 'package:aviation_app/screens/flightcomm/update_info_screen.dart';
import 'package:aviation_app/screens/flightcomm/widgets/animated_attachment_option.dart';
import 'package:aviation_app/utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../constant.dart';

class ChatScreenNew extends StatelessWidget {
  const ChatScreenNew({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // 🔹 Modern Header
              _buildModernHeader(controller),

              // 🔹 Tab Bar
              _buildTabBar(controller),

              // 🔹 Tab Content
              Expanded(child: Obx(() => _buildTabContent(controller))),
            ],
          ),
        ),
      ),
    );
  }

  /// Modern Header with Flight Info
  Widget _buildModernHeader(ChatController controller) {
    return Obx(() {
      if (controller.flightDetailLoading.value) {
        return const LinearProgressIndicator(
          backgroundColor: Colors.white,
          color: AppColors.colorPrimary,
          minHeight: 2.5,
        );
      }

      final flight = controller.flightDetail.value;
      if (flight == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.fromLTRB(4, 12, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back arrow (vertically centered)
            GestureDetector(
              onTap: () => Get.back(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black87,
                  size: 18,
                ),
              ),
            ),
            // All flight info in a column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Flight info and aircraft details
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Flight Number and Route
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                flight.basicDetails.flightInfo,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${flight.departureAirport.iataCode} - ${flight.arrivalAirport.iataCode}",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Aircraft info on right
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (flight.aircraftType != null) ...[
                              Text(
                                flight.aircraftType!.icao,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                            if (flight.aircraft?.name.isNotEmpty ?? false) ...[
                              const SizedBox(width: 6),
                              Text(
                                "|",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                flight.aircraft!.name,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Row 2 & 3: Gate, POS, Times on left | CFG and ACT on right (vertically aligned)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side: Time badges
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Time badges
                              Row(
                                children: [
                                  if (flight.isDeparture) ...[
                                    // Show STD first
                                    if (flight.basicDetails.std?.isNotEmpty ??
                                        false) ...[
                                      _buildTimeBadgeWithLabelBg(
                                        "STD",
                                        formatFlightTime(
                                          flight.basicDetails.std!,
                                        ),
                                        const Color(0xFF1976D2),
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    // Then show ATD if exists, else show STA
                                    if (flight.basicDetails.atd?.isNotEmpty ??
                                        false)
                                      _buildTimeBadgeWithLabelBg(
                                        "ATD",
                                        formatFlightTime(
                                          flight.basicDetails.atd!,
                                        ),
                                        const Color(0xFFD32F2F),
                                      )
                                    else if (flight
                                            .basicDetails
                                            .sta
                                            ?.isNotEmpty ??
                                        false)
                                      _buildTimeBadgeWithLabelBg(
                                        "STA",
                                        formatFlightTime(
                                          flight.basicDetails.sta!,
                                        ),
                                        const Color(0xFF1976D2),
                                      ),
                                  ] else ...[
                                    if (flight.basicDetails.sta?.isNotEmpty ??
                                        false) ...[
                                      _buildTimeBadgeWithLabelBg(
                                        "STA",
                                        formatFlightTime(
                                          flight.basicDetails.sta!,
                                        ),
                                        const Color(0xFF1976D2),
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    if (flight.basicDetails.ata?.isNotEmpty ??
                                        false) ...[
                                      _buildTimeBadgeWithLabelBg(
                                        "ATA",
                                        formatFlightTime(
                                          flight.basicDetails.ata!,
                                        ),
                                        const Color(0xFFD32F2F),
                                      ),
                                    ],
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Right side: CFG and ACT vertically aligned
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CFG
                            if (_buildCfgString(flight.capacity).isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildBadge("CFG", AppColors.colorPrimary),
                                  const SizedBox(width: 4),
                                  Text(
                                    _buildCfgString(flight.capacity),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.colorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 4),
                            // ACT
                            if (_buildActString(flight.actualPax).isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildBadge("ACT", AppColors.colorPrimary),
                                  const SizedBox(width: 4),
                                  Text(
                                    _buildActString(flight.actualPax),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.colorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                          ],
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

  Widget _buildTimeBadgeWithLabelBg(String label, String time, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Widget _buildTimeText(String? time) {
  //   return Text(
  //     time ?? '--',
  //     style: const TextStyle(
  //       fontSize: 11,
  //       fontWeight: FontWeight.w600,
  //       color: Colors.black87,
  //     ),
  //   );
  // }

  /// Build CFG string from capacity data
  /// Example: "C12" or "C12 M162" or "Y174"
  String _buildCfgString(dynamic capacity) {
    if (capacity == null) return '';

    final List<String> parts = [];

    // Check each capacity field and add if not empty
    if (capacity.f?.isNotEmpty == true && capacity.f != 'null') {
      parts.add(capacity.f!);
    }
    if (capacity.j?.isNotEmpty == true && capacity.j != 'null') {
      parts.add(capacity.j!);
    }
    if (capacity.c?.isNotEmpty == true && capacity.c != 'null') {
      parts.add(capacity.c!);
    }
    if (capacity.s?.isNotEmpty == true && capacity.s != 'null') {
      parts.add(capacity.s!);
    }
    if (capacity.w?.isNotEmpty == true && capacity.w != 'null') {
      parts.add(capacity.w!);
    }
    if (capacity.y?.isNotEmpty == true && capacity.y != 'null') {
      parts.add(capacity.y!);
    }
    if (capacity.m?.isNotEmpty == true && capacity.m != 'null') {
      parts.add(capacity.m!);
    }

    return parts.join(' ');
  }

  /// Build ACT string from actual passenger data
  /// Example: "C12 M158 +1 INF" or "Y174"
  String _buildActString(dynamic actualPax) {
    if (actualPax == null) return '';

    final List<String> parts = [];

    // Helper to check if value is not empty and not "0"
    bool hasValue(String? value) {
      return value?.isNotEmpty == true &&
          value != 'null' &&
          value != '0' &&
          value != '';
    }

    // Check each passenger class and add if not empty and not zero
    if (hasValue(actualPax.paxA)) {
      parts.add('A${actualPax.paxA}');
    }
    if (hasValue(actualPax.paxC)) {
      parts.add('C${actualPax.paxC}');
    }
    if (hasValue(actualPax.paxW)) {
      parts.add('W${actualPax.paxW}');
    }
    if (hasValue(actualPax.paxY)) {
      parts.add('Y${actualPax.paxY}');
    }

    // Add infants separately with "+X INF" format
    if (hasValue(actualPax.paxInf)) {
      parts.add('+${actualPax.paxInf} INF');
    }

    return parts.join(' ');
  }

  /// Tab Bar
  Widget _buildTabBar(ChatController controller) {
    final tabs = [
      'Chat',
      'TRC',
      'CKIN',
      'ARR',
      'PIC',
      'MVT',
      'LDM',
      'LIR',
      'LDS',
      'NOTOC',
      'CPM',
      'PAL/CAL',
      'PSM',
      'PTM',
      'SOD',
    ];

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];

          return Obx(() {
            final isSelected = controller.selectedTab.value == tab;
            final hasMessages = controller.hasMessages(tab);

            return GestureDetector(
              onTap: () => controller.selectedTab.value = tab,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.only(right: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      hasMessages
                          ? Colors.lightGreenAccent.shade400
                          : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color:
                          isSelected
                              ? AppColors.colorPrimary
                              : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.colorPrimary : Colors.black54,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  /// Tab Content
  Widget _buildTabContent(ChatController controller) {
    switch (controller.selectedTab.value) {
      case 'Chat':
        return Container(
          color: const Color(0xFFF5F5F5),
          child: Column(
            children: [
              const Expanded(child: ChatInfo()),
              _buildModernMessageInput(controller),
            ],
          ),
        );

      case 'TRC':
        return Container(color: const Color(0xFFF5F5F5), child: TrcInfo());

      case 'CKIN':
        return Container(color: const Color(0xFFF5F5F5), child: ChkinInfo());

      case 'ARR':
        return Container(color: const Color(0xFFF5F5F5), child: ArrInfo());

      case 'PIC':
        return Container(color: const Color(0xFFF5F5F5), child: PicInfo());

      case 'MVT':
        return Container(color: const Color(0xFFF5F5F5), child: MvtInfo());

      case 'LDM':
        return Container(color: const Color(0xFFF5F5F5), child: LdmInfo());

      case 'LIR':
        return Container(color: const Color(0xFFF5F5F5), child: LirInfo());

      case 'LDS':
        return Container(color: const Color(0xFFF5F5F5), child: LdsInfo());

      case 'NOTOC':
        return Container(
          color: const Color(0xFFF5F5F5),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No data available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case 'CPM':
        return Container(color: const Color(0xFFF5F5F5), child: CPMInfo());

      case 'PAL/CAL':
        return Container(
          color: const Color(0xFFF5F5F5),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No data available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case 'PSM':
        return Container(color: const Color(0xFFF5F5F5), child: PsmInfo());

      case 'PTM':
        return Container(color: const Color(0xFFF5F5F5), child: PtmInfo());

      case 'SOD':
        return Container(color: const Color(0xFFF5F5F5), child: SodInfo());

      default:
        return Container(
          color: const Color(0xFFF5F5F5),
          child: const Center(
            child: Text(
              "No view for this tab",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
    }
  }

  /// Modern Message Input (matches screenshot)
  Widget _buildModernMessageInput(ChatController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Flight arrow button (left side) - hide when typing
          Obx(
            () =>
                !controller.isTyping.value
                    ? Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => UpdateInfoScreen(),
                              arguments:
                                  controller
                                      .flightDetail
                                      .value!
                                      .basicDetails
                                      .id,
                            );
                          },
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: appThemeGradientSoft,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/svg/flight_arrow.svg',
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    )
                    : const SizedBox.shrink(),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      maxLines: 1,
                      cursorColor: AppColors.colorPrimary,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Message...',
                        hintStyle: TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showAttachmentOptions(controller),
                    child: SvgPicture.asset(
                      'assets/svg/attachment.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        Colors.grey.shade600,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Obx(
            () => GestureDetector(
              onTap:
                  controller.isSendingMessage.value
                      ? null
                      : controller.sendMessage,
              child: Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: appThemeGradientSoft,
                ),
                child:
                    controller.isSendingMessage.value
                        ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Center(
                          child: SvgPicture.asset(
                            'assets/svg/send.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle camera capture
  Future<void> _handleCameraCapture(ChatController controller) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        final File imageFile = File(photo.path);
        final fileName = photo.path.split('/').last;

        // Show preview screen
        Get.to(
          () => ImagePreviewScreen(
            imageFile: imageFile,
            onSend: (file, type) async {
              await controller.sendImageMessage(
                file: file,
                fileName: fileName,
                type: type,
              );
            },
          ),
        );
      }
    } catch (e) {
      debugPrint('Error capturing image: $e');
      Get.snackbar(
        'Error',
        'Failed to capture image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  /// Handle gallery picker
  Future<void> _handleGalleryPicker(ChatController controller) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (photo != null) {
        final File imageFile = File(photo.path);
        final fileName = photo.path.split('/').last;

        // Show preview screen
        Get.to(
          () => ImagePreviewScreen(
            imageFile: imageFile,
            onSend: (file, type) async {
              await controller.sendImageMessage(
                file: file,
                fileName: fileName,
                type: type,
              );
            },
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to select image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  /// Handle file picker
  Future<void> _handleFilePicker(ChatController controller) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;
        final fileSize = _formatFileSize(result.files.single.size);

        // Show preview screen
        Get.to(
          () => FilePreviewScreen(
            file: file,
            fileName: fileName,
            fileSize: fileSize,
            onSend: (file, type) async {
              await controller.sendImageMessage(
                file: file,
                fileName: fileName,
                type: type,
              );
            },
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      Get.snackbar(
        'Error',
        'Failed to select file',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  /// Format file size to human readable format
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Show attachment options bottom sheet
  void _showAttachmentOptions(ChatController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Attachment options
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedAttachmentOption(
                  svgPath: 'assets/svg/chat_camera.svg',
                  label: 'Camera',
                  index: 0,
                  onTap: () async {
                    Get.back();
                    await _handleCameraCapture(controller);
                  },
                ),
                const SizedBox(width: 20),
                AnimatedAttachmentOption(
                  svgPath: 'assets/svg/chat_gallery.svg',
                  label: 'Gallery',
                  index: 1,
                  onTap: () async {
                    Get.back();
                    await _handleGalleryPicker(controller);
                  },
                ),
                const SizedBox(width: 20),
                AnimatedAttachmentOption(
                  svgPath: 'assets/svg/chat_file.svg',
                  label: 'File',
                  index: 2,
                  onTap: () async {
                    Get.back();
                    await _handleFilePicker(controller);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
}
