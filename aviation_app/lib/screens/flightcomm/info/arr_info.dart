import 'package:aviation_app/screens/flightcomm/info/widget/into_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';

class ArrInfo extends StatelessWidget {
  const ArrInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        children: [
          InfoSection(
            title: "LOFO",
            data: {
              "STAFF": controller.flightDetail.value?.arrData!.staff ?? '--',
              "RMKS": controller.flightDetail.value?.arrData!.remarks ?? '--',
              "START TIME":
                  controller.flightDetail.value?.arrData!.startTime ?? '--',
              "END TIME":
                  controller.flightDetail.value?.arrData!.endTime ?? '--',
              "MHB AHL": controller.flightDetail.value?.arrData!.mhb ?? '--',
              "OHD": controller.flightDetail.value?.arrData!.ohd ?? '--',
              "DPR": controller.flightDetail.value?.arrData!.dpr ?? '--',
            },
          ),
        ],
      ),
    );
  }
}
