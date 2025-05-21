import 'package:flutter/material.dart';

import 'widget/into_widget.dart';

class MvtInfo extends StatelessWidget {
  const MvtInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        children: [
          InfoSection(
            title: "DEPARTURE",
            data: {"": ""},
            backgroundColor: Colors.lightGreen.shade100,
          ),
          SizedBox(height: 12),
          InfoSection(
            title: "ARRIVAL",
            data: {"": ""},

            backgroundColor: Colors.blue.shade100,
          ),
        ],
      ),
    );
  }
}
