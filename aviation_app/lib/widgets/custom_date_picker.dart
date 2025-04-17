import 'package:flutter/material.dart';

class DatePickerFieldWithLabel extends StatelessWidget {
  final String label;
  final String selectedDate;
  final VoidCallback onTap;

  const DatePickerFieldWithLabel({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate.isEmpty ? "Select date" : selectedDate,
                    style: TextStyle(
                      color: selectedDate.isEmpty ? Colors.grey : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_month_rounded,
                  color: Color(0xFF003862), // or AppColors.colorPrimary
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
