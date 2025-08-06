import 'package:dhs_app/screens/flightcomm/update_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/flight/chat_controller.dart';
import '../../../../utils/app_colors.dart';

class ChatBottomView extends StatelessWidget {
  const ChatBottomView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.colorPrimary,
            child: IconButton(
              icon: const Icon(Icons.arrow_upward, color: Colors.white),

              onPressed:
                  () => Get.to(
                    () => UpdateInfoScreen(),
                    arguments: controller.flightDetail.value!.basicDetails.id,
                  ),
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
                        hintStyle: TextStyle(color: Color(0xff8E8E93)),
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
          Obx(
            () => CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.colorPrimary,
              child:
                  controller.isSendingMessage.value
                      ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: controller.sendMessage,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
