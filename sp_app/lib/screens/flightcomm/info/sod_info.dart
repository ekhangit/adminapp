import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/flight/chat_controller.dart';
import '../../../models/flight_detail_model.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  sod.serviceAbbr!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                sod.type ?? '',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              // Chip(
              //   label: Text('${sod.employees.length}/${sod.requiredStaff}'),
              //   backgroundColor:
              //       sod.employees.length >= sod.requiredStaff
              //           ? Colors.green.shade100
              //           : Colors.orange.shade100,
              // ),
            ],
          ),
          const SizedBox(height: 8),
          // _buildTimeRow('Start Time', sod.startTime!),
          // _buildTimeRow('Release Time', sod.endTime!),
          _buildTimeRow('Start Time', _formatDateTime(sod.startTime)),
          _buildTimeRow('Release Time', _formatDateTime(sod.endTime)),
          _buildTimeRow('Duration', sod.duration!),
          if (sod.employees != null && sod.employees!.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Assigned Staff:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            ...sod.employees!.map(
              (emp) => Padding(
                padding: const EdgeInsets.only(left: 0, top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${emp.airport} - ${emp.name}'),
                    SizedBox(height: 6),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,

                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'PLN',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${emp.plannedTimeIn} - ${emp.plannedTimeOut}',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'ACT',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${emp.actualTimeIn} - ${emp.actualTimeOut}',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.black87, fontSize: 12),
          ),
        ],
      ),
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
}
