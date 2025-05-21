import 'package:aviation_app/screens/flightcomm/info/widget/into_widget.dart';
import 'package:flutter/material.dart';

class LdmInfo extends StatelessWidget {
  const LdmInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        children: [
          InfoSection(data: {"": ""}, backgroundColor: Colors.yellow.shade100),
        ],
      ),
    );
  }
}
