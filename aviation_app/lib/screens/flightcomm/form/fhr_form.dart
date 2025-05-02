import 'package:aviation_app/screens/flightcomm/form/widget/form_widgets.dart';
import 'package:flutter/material.dart';


class FHRForm extends StatelessWidget {
  const FHRForm({super.key});

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
            singleField("MISSED ARTG-5 EXPLANATION", maxLines: 3),

            const SizedBox(height: 12),
            singleField("DELAY EXPLANATION", maxLines: 3),

            const SizedBox(height: 12),
            singleField("CHECK-IN/TKTG ISSUES", maxLines: 3),

            const SizedBox(height: 12),
            singleField("RAMP/CREWDISRUPTIVE PAX ETC", maxLines: 3),

            const SizedBox(height: 12),
            singleField("SAFETY/SECURITY/SYSTEM", maxLines: 3),

            const SizedBox(height: 12),
            singleField("OTHER", maxLines: 3),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
