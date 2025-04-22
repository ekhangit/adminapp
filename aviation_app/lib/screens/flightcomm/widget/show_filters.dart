import 'package:flutter/material.dart';

import '../../../controllers/flight/flightcomm_controller.dart';
import '../../../utils/app_colors.dart';

void showFilterBottomSheet(
  BuildContext context,
  FlightCommController controller,
) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder:
        (_) => ListView(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          children:
              controller.filters.map((filter) {
                final isSelected = controller.selectedFilter.value == filter;
                return ListTile(
                  title: Text(
                    filter,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                          isSelected ? AppColors.colorPrimary : Colors.black87,
                    ),
                  ),
                  onTap: () {
                    controller.selectFilter(filter);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
        ),
  );
}
