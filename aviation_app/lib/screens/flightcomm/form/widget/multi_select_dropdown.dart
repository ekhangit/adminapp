import 'package:aviation_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../models/flight_no_model.dart';

class MultiSelectDropdown extends StatelessWidget {
  final String label;
  final List<String> options;
  final RxList<String> selectedItems;
  final String hint;

  const MultiSelectDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedItems,
    this.hint = "Select options",
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => _showMultiSelect(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedItems.isEmpty ? hint : selectedItems.join(', '),
                      style: TextStyle(
                        color:
                            selectedItems.isEmpty ? Colors.grey : Colors.black,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMultiSelect(BuildContext context) {
    final RxString searchTerm = ''.obs;
    final TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Obx(() {
                final filteredOptions =
                    options
                        .where(
                          (option) => option.toLowerCase().contains(
                            searchTerm.value.toLowerCase(),
                          ),
                        )
                        .toList();

                final allSelected = selectedItems.length == options.length;

                return ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 🔍 Search Field
                    TextField(
                      controller: searchController,
                      onChanged: (value) => searchTerm.value = value,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        isDense: true,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // ✅ Select All
                    CheckboxListTile(
                      title: const Text(
                        "Select All",
                        style: TextStyle(color: AppColors.colorPrimary),
                      ),
                      value: allSelected,
                      activeColor: AppColors.colorPrimary,
                      onChanged: (value) {
                        if (value == true) {
                          selectedItems.assignAll(options);
                        } else {
                          selectedItems.clear();
                        }
                      },

                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(height: 20),
                    // ☑ Filtered Options
                    ...filteredOptions.map((item) {
                      final isChecked = selectedItems.contains(item);
                      return CheckboxListTile(
                        activeColor: AppColors.colorPrimary,
                        title: Text(item),
                        value: isChecked,
                        onChanged: (val) {
                          if (val == true) {
                            selectedItems.add(item);
                          } else {
                            selectedItems.remove(item);
                          }
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                );
              }),
            );
          },
        );
      },
    );
  }
}

class FlightNoSelectDropdown extends StatelessWidget {
  final String label;
  final List<FlightNoModel> options;
  final Rx<FlightNoModel?> selectedItem;
  final String hint;

  const FlightNoSelectDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedItem,
    this.hint = "Select flight",
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => _showSelectionDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedItem.value?.flightInfo ?? hint,
                      style: TextStyle(
                        color:
                            selectedItem.value == null
                                ? Colors.grey
                                : Colors.black,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSelectionDialog(BuildContext context) {
    final RxString searchTerm = ''.obs;
    final TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final filteredOptions =
                    options
                        .where(
                          (f) => f.flightInfo.toLowerCase().contains(
                            searchTerm.value.toLowerCase(),
                          ),
                        )
                        .toList();

                return ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      onChanged: (value) => searchTerm.value = value,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        isDense: true,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...filteredOptions.map((item) {
                      final isSelected = selectedItem.value?.id == item.id;

                      return Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.colorPrimary.withValues(alpha: .1)
                                  : null,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          title: Text(
                            item.flightInfo,
                            style: TextStyle(
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color:
                                  isSelected
                                      ? AppColors.colorPrimary
                                      : Colors.black,
                            ),
                          ),
                          trailing:
                              isSelected
                                  ? const Icon(
                                    Icons.check,
                                    color: AppColors.colorPrimary,
                                  )
                                  : null,
                          onTap: () {
                            selectedItem.value = item;
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }),
                  ],
                );
              }),
            );
          },
        );
      },
    );
  }
}

class SingleSelectDropdown extends StatelessWidget {
  final String label;
  final List<String> options;
  final RxString selectedItem;
  final String hint;

  const SingleSelectDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedItem,
    this.hint = "Select option",
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => _showSelectionDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedItem.value.isEmpty ? hint : selectedItem.value,
                      style: TextStyle(
                        color:
                            selectedItem.value.isEmpty
                                ? Colors.grey
                                : Colors.black,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSelectionDialog(BuildContext context) {
    final RxString searchTerm = ''.obs;
    final TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final filteredOptions =
                    options
                        .where(
                          (f) => f.toLowerCase().contains(
                            searchTerm.value.toLowerCase(),
                          ),
                        )
                        .toList();

                return ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      onChanged: (value) => searchTerm.value = value,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        isDense: true,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...filteredOptions.map((item) {
                      final isSelected = selectedItem.value == item;

                      return Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.colorPrimary.withOpacity(0.1)
                                  : null,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color:
                                  isSelected
                                      ? AppColors.colorPrimary
                                      : Colors.black,
                            ),
                          ),
                          trailing:
                              isSelected
                                  ? const Icon(
                                    Icons.check,
                                    color: AppColors.colorPrimary,
                                  )
                                  : null,
                          onTap: () {
                            selectedItem.value = item;
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }),
                  ],
                );
              }),
            );
          },
        );
      },
    );
  }
}
