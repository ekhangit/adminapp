import 'package:aviation_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:flutter/material.dart';

class DSRForm extends StatelessWidget {
  const DSRForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            singleField("Flight No", showSelect: true),
            const SizedBox(height: 12),
            singleField("DOI"),
            const SizedBox(height: 12),
            singleField("DATE"),
            const SizedBox(height: 12),
            singleField("PAX NAME"),
            const SizedBox(height: 12),
            singleField("SELECT CURRENCY", showSelect: true),
            const SizedBox(height: 12),
            singleField("AMOUNT"),
            const SizedBox(height: 12),
            singleField("PNR"),
            const SizedBox(height: 12),
            singleField("FOP", showSelect: true),
            const SizedBox(height: 12),
            singleField("SERVICE TYPE", showSelect: true),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
