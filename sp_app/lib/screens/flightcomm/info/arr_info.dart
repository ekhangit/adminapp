import 'package:sp_app/screens/flightcomm/info/widget/into_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/flight/chat_controller.dart';

class ArrInfo extends StatelessWidget {
  const ArrInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final arrData = controller.flightDetail.value?.arr;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        children: [
          if (arrData == null)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No ARR data available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          if (arrData != null)
            InfoSection(
              title: "LOFO",
              data: {
                "STAFF": arrData.staff ?? '--',
                "RMKS": arrData.remarks ?? '--',
                "START TIME": arrData.startTime ?? '--',
                "END TIME": arrData.endTime ?? '--',
                "MHB AHL": arrData.mhb ?? '--',
                "OHD": arrData.ohd ?? '--',
                "DPR": arrData.dpr ?? '--',
              },
            ),
        ],
      ),
    );
  }
}
