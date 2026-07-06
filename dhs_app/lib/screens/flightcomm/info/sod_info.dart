import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/flight/chat_controller.dart';
import '../../../models/flight_detail_model.dart';
import '../../../utils/app_colors.dart';
import 'package:intl/intl.dart';

class SodInfo extends StatelessWidget {
  const SodInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    // Get SOD data from your flight details
    final sodData = controller.flightDetail.value?.sodData ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sodData.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No SOD data available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          if (sodData.isNotEmpty) ...sodData.map((sod) => _buildSodCard(sod)),
        ],
      ),
    );
  }

  Widget _buildSodCard(SodData sod) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service and Type
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.colorPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  sod.serviceAbbr ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  sod.type?.toUpperCase() ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 12),
          // Info rows
          _buildSimpleRow('Staff Required', '${sod.requiredStaff ?? 0}'),
          const SizedBox(height: 10),
          _buildSimpleRow('Start Time', _formatSimpleTime(sod.startTime), showSLA: true),
          const SizedBox(height: 10),
          _buildSimpleRow('Release Time', _formatSimpleTime(sod.endTime), showSLA: true),
          const SizedBox(height: 10),
          _buildSimpleRow('Duration', sod.duration ?? '00:00', showSLA: true),
        ],
      ),
    );
  }

  Widget _buildSimpleRow(String label, String value, {bool showSLA = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          children: [
            if (showSLA) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  'SLA',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmployeeCard(SodEmployee emp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.colorPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  emp.airport,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  emp.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTimeChip(
                  'PLN',
                  '${emp.plannedTimeIn} - ${emp.plannedTimeOut}',
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _buildTimeChip(
                  'ACT',
                  '${emp.actualTimeIn} - ${emp.actualTimeOut}',
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String label, String time, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRow(String label, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'SLA',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.purple.shade900,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              time,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return '--';

    try {
      final dateTime = DateTime.tryParse(dateTimeString);
      if (dateTime == null) return '--';

      return DateFormat('dd MMM yyyy HH:mm').format(dateTime);
    } catch (e) {
      return '--';
    }
  }

  String _formatTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return '--';

    try {
      final dateTime = DateTime.tryParse(dateTimeString);
      if (dateTime == null) return '--';

      return DateFormat('dd MMM HH:mm').format(dateTime);
    } catch (e) {
      return '--';
    }
  }

  String _formatMobileTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return '--';

    try {
      final dateTime = DateTime.tryParse(dateTimeString);
      if (dateTime == null) return '--';

      return DateFormat('HH:mm\ndd MMM').format(dateTime);
    } catch (e) {
      return '--';
    }
  }

  String _formatSimpleTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return '--';

    try {
      final dateTime = DateTime.tryParse(dateTimeString);
      if (dateTime == null) return '--';

      return DateFormat('dd MMM HH:mm').format(dateTime);
    } catch (e) {
      return '--';
    }
  }
}
