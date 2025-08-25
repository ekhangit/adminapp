import 'package:dhs_app/models/roster_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/myroster/my_roster_controller.dart';

class DutyCard extends StatelessWidget {
  final Duty duty;
  final MyRosterController controller;

  const DutyCard({super.key, required this.duty, required this.controller});

  @override
  Widget build(BuildContext context) {
    final hasActTime = duty.actTime != null && duty.actTime!.isNotEmpty;

    return Obx(
      () => GestureDetector(
        onTap: () => controller.toggleDutySelection(duty.id.toString()),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  hasActTime
                      ? // Already has ACT time - show with different appearance
                      [
                        (duty.color ?? Colors.grey).withValues(alpha: 0.6),
                        (duty.color ?? Colors.grey).withValues(alpha: 0.4),
                      ]
                      : // No ACT time - normal or selected appearance
                      [
                        (duty.color ?? Colors.grey).withValues(
                          alpha:
                              controller.selectedDuties.contains(
                                    duty.id.toString(),
                                  )
                                  ? 0.3
                                  : 1.0,
                        ),
                        (duty.color ?? Colors.grey).withValues(
                          alpha:
                              controller.selectedDuties.contains(
                                    duty.id.toString(),
                                  )
                                  ? 0.2
                                  : 0.8,
                        ),
                      ],
            ),
            borderRadius: BorderRadius.circular(16),
            border:
                controller.selectedDuties.contains(duty.id.toString()) &&
                        !hasActTime
                    ? Border.all(color: Colors.deepPurple, width: 1.5)
                    : null,
            boxShadow: [
              BoxShadow(
                color: (duty.color ?? Colors.grey).withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildDutyTitle(),
                    const SizedBox(height: 3),
                    _buildPlnTime(),
                    const SizedBox(height: 2),
                    _buildActTime(),
                  ],
                ),
              ),
              if (controller.selectedDuties.contains(duty.id.toString()) &&
                  !hasActTime)
                _buildMarkDutyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDutyTitle() {
    return Row(
      children: [
        // Extract first character (A or D) and show in circle
        if (duty.type != null && duty.type!.isNotEmpty)
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                duty.type!,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (duty.type != null && duty.type!.isNotEmpty)
          const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${duty.terminal} ${duty.name} ${duty.flightInfo ?? ""}'.trim(),
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPlnTime() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        duty.plnTime,
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActTime() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        duty.actTime ?? 'ACT -',
        style: GoogleFonts.roboto(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMarkDutyButton() {
    return Positioned(
      bottom: 6,
      right: 6,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          minimumSize: const Size(0, 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          controller.showMarkDutyBottomSheet();
        },
        icon: const Icon(
          Icons.check_circle_outline,
          size: 14,
          color: Colors.white,
        ),
        label: const Text(
          'MARK',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
