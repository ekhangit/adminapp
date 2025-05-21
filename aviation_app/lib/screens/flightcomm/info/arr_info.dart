import 'package:aviation_app/screens/flightcomm/info/widget/into_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';

class ArrInfo extends StatelessWidget {
  const ArrInfo({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<ChatController>();

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        children: [
          InfoSection(
            title: "LOFO",
            data: {
              "STAFF": '--',
              "RMKS": '--',
              "START TIME": '--',
              "END TIME": '--',
              "MHB AHL": '--',
              "OHD": '--',
              "DPR": '--',
            },
          ),
        ],
      ),
    );
  }
}
