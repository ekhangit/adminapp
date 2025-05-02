import 'package:aviation_app/controllers/flight/chat_controller.dart';
import 'package:aviation_app/screens/flightcomm/widget/show_flight_info.dart';
import 'package:aviation_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'widget/show_attachment_option.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            // 🔹 Background
            Positioned.fill(child: Container(color: Colors.grey.shade200)),

            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        // 🔵 Top Info Header
                        SliverToBoxAdapter(
                          child: Obx(
                            () => Container(
                              padding: const EdgeInsets.only(
                                top: 16,
                                left: 16,
                                right: 16,
                                bottom: 8,
                              ),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 🔹 First Row (Always Visible)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Get.back(),
                                        child: const Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "IB 1332 | FRA-MAD",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17.5,
                                                height: 0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "GATE: B37 | POS: 804",
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13.5,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap:
                                            () =>
                                                controller
                                                    .toggleHeaderExpansion(),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            border: Border.all(
                                              color: AppColors.matteBlackColor,
                                              width: 0.2,
                                            ),
                                          ),
                                          child: Text(
                                            controller.isHeaderExpanded.value
                                                ? "Hide"
                                                : "Show",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // 🔽 Expanded Row (Conditional)
                                  if (controller.isHeaderExpanded.value) ...[
                                    const SizedBox(height: 8),
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 6.5,
                                      runSpacing: 6,
                                      children: [
                                        _InfoBadge(
                                          label: "ATD",
                                          color: Colors.blue,
                                        ),
                                        _InfoText(
                                          "24 05:10",
                                          textColor: Colors.black,
                                        ),
                                        _InfoText("CRJX"),
                                        _InfoText("|"),
                                        _InfoText("EC-MNR"),
                                        _InfoText("|"),
                                        _InfoText("CFG"),
                                        _InfoText("J6 Y94"),
                                        _InfoText("|"),
                                        _InfoText("ACT 3C"),
                                        _InfoText("J3 Y62"),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),

                        // 🔵 Chip Filter Row
                        SliverToBoxAdapter(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(
                              top: 4,
                              left: 12,
                              right: 0,
                              bottom: 8,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _chip("TRC"),
                                  _chip("CHKIN"),
                                  _chip("ARR"),
                                  _chip("PIC"),
                                  _chip("MVT"),
                                  _chip("LDM"),
                                  _chip("LIR"),
                                  _chip("LDS"),
                                  _chip("NOTOC"),
                                  _chip("CPM"),
                                  _chip("PAL/CAL"),
                                  _chip("PSM"),
                                  _chip("PTM"),
                                  _chip("SOD"),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // 🔵 Chat Messages
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final message =
                                controller.messages.reversed.toList()[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: Align(
                                alignment:
                                    message.isSentByMe
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        message.isSentByMe
                                            ? AppColors.colorPrimary
                                            : Colors.grey.shade200,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(12),
                                      topRight: const Radius.circular(12),
                                      bottomLeft: Radius.circular(
                                        message.isSentByMe ? 12 : 0,
                                      ),
                                      bottomRight: Radius.circular(
                                        message.isSentByMe ? 0 : 12,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    message.message,
                                    style: TextStyle(
                                      color:
                                          message.isSentByMe
                                              ? Colors.white
                                              : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }, childCount: controller.messages.length),
                        ),
                      ],
                    ),
                  ),

                  // 💬 Message Input
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.colorPrimary,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                            ),
                            onPressed: () => showFlightInfoBottomSheet(context),
                          ),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: controller.messageController,
                                    minLines: 1,
                                    maxLines: 6,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.matteBlackColor,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 0,
                                      ),
                                      hintText: "Message...",
                                      hintStyle: TextStyle(
                                        color: Color(0xff8E8E93),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => (),
                                  child: const Icon(Icons.attach_file),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 6),

                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.colorPrimary,
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: controller.sendMessage,
                          ),
                        ),
                      ],
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

  Widget _chip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String text;
  final Color? textColor;

  const _InfoText(this.text, {this.textColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }
}
