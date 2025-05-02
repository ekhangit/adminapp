import 'package:aviation_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:flutter/material.dart';

class OCCForm extends StatelessWidget {
  const OCCForm({super.key});

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
            formRow("From", "To"),
            const SizedBox(height: 12),

            singleField('Airline', showSelect: true),
            const SizedBox(height: 12),
            singleField('Flight No', showSelect: true),
            const SizedBox(height: 12),
            singleField('Airport', showSelect: true),
            const SizedBox(height: 12),
            singleField('Type', showSelect: true),
            const SizedBox(height: 12),
            singleField('Broadcast Message', maxLines: 5),
          ],
        ),
      ),
    );
  }
}
