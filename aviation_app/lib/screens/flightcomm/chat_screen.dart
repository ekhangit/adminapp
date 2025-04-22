import 'package:aviation_app/controllers/flight/chat_controller.dart';
import 'package:aviation_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widget/show_attachment_option.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Chat", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppColors.colorPrimary,
      ),
      body: Stack(
        children: [
          // 🔹 Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/chatback.jpg', // Make sure to add this image to your assets
              fit: BoxFit.cover,
            ),
          ),

          Column(
            children: [
              // 🔄 Message List
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    itemCount: controller.messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message =
                          controller.messages.reversed.toList()[index];
                      return Align(
                        alignment:
                            message.isSentByMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
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
                      );
                    },
                  ),
                ),
              ),

              // 💬 Input Field
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: controller.messageController,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.matteBlackColor,
                                    ),

                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 0.0,
                                      ),
                                      hintText: 'Message...',
                                      hintStyle: TextStyle(
                                        color: Color(0xff8E8E93),
                                      ),
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => showAttachmentOptions(context),
                                  child: const Icon(Icons.attach_file),
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
        ],
      ),
    );
  }
}
