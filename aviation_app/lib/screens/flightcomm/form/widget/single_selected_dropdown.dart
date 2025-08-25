import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/aircraft_model.dart';
import '../../../../models/flight_no_model.dart';
import '../../../../utils/app_colors.dart';

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

class AircraftTypeSelectDropdown extends StatelessWidget {
  final String label;
  final List<AircraftTypeModel> options;
  final Rx<AircraftTypeModel?> selectedItem;
  final String hint;

  const AircraftTypeSelectDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedItem,
    this.hint = "Select A/C Type",
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
                      selectedItem.value?.icao ?? hint,
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
                          (f) => f.icao!.toLowerCase().contains(
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
                            item.icao!,
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

class AircraftRegSelectDropdown extends StatelessWidget {
  final String label;
  final List<AircraftRegModel> options;
  final Rx<AircraftRegModel?> selectedItem;
  final String hint;

  const AircraftRegSelectDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedItem,
    this.hint = "Select A/C Regin",
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
                      selectedItem.value?.name ?? hint,
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
                          (f) => f.name!.toLowerCase().contains(
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
                            item.name!,
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
  final double labelFontSize;
  final List<String> options;
  final RxString selectedItem;
  final String hint;
  final bool showSearchField;
  final ValueChanged<String?>? onChanged; // Add onChanged callback

  const SingleSelectDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedItem,
    this.showSearchField = true,
    this.hint = "Select option",
    this.onChanged, // Add to constructor
    this.labelFontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: labelFontSize,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap:
                () => _showSelectionDialog(
                  context,
                  showSearchField: showSearchField,
                ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedItem.value.isEmpty ? hint : selectedItem.value,
                      style: GoogleFonts.roboto(
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

  void _showSelectionDialog(
    BuildContext context, {
    bool showSearchField = true,
  }) {
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
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (showSearchField) const SizedBox(height: 12),
                    if (showSearchField)
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
                                  ? AppColors.colorPrimary.withValues(
                                    alpha: 0.1,
                                  )
                                  : null,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          title: Text(
                            item,
                            style: GoogleFonts.roboto(
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
                            onChanged?.call(
                              item,
                            ); // Call onChanged with the selected item
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

class GenericSelectDropdown<T> extends StatelessWidget {
  final String? label;
  final List<T> options;
  final Rx<T?> selectedItem;
  final String hint;
  final Widget Function(T) displayText;
  final Widget Function(T)? leadingIcon;
  final bool Function(T, String) filterCondition;
  final bool Function(T, T) isSelected;
  final Function(T)? onChanged;

  const GenericSelectDropdown({
    super.key,
    this.label,
    required this.options,
    required this.selectedItem,
    required this.displayText,
    this.leadingIcon,
    required this.filterCondition,
    required this.isSelected,
    this.hint = "Select item",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          if (label != null) const SizedBox(height: 6),
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
                    child: Row(
                      children: [
                        // if (selectedItem.value != null && leadingIcon != null)
                        //   Padding(
                        //     padding: const EdgeInsets.only(right: 6),
                        //     child: leadingIcon!(selectedItem.value!),
                        //   ),
                        if (selectedItem.value != null)
                          Expanded(child: displayText(selectedItem.value!)),
                        if (selectedItem.value == null)
                          Text(
                            hint,
                            style: GoogleFonts.roboto(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
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
          minChildSize: 0.50,
          maxChildSize: 0.75,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Non-scrolling header section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (label != null)
                        Text(
                          label!,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      if (label != null) const SizedBox(height: 12),
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
                    ],
                  ),

                  // Scrollable list section
                  Expanded(
                    child: Obx(() {
                      final filteredOptions =
                          options
                              .where(
                                (item) =>
                                    filterCondition(item, searchTerm.value),
                              )
                              .toList();

                      return ListView(
                        controller: scrollController,
                        children: [
                          ...filteredOptions.map((item) {
                            final selected =
                                selectedItem.value != null &&
                                isSelected(selectedItem.value!, item);

                            return Container(
                              decoration: BoxDecoration(
                                color:
                                    selected
                                        ? AppColors.colorPrimary.withValues(
                                          alpha: .1,
                                        )
                                        : null,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: ListTile(
                                leading:
                                    leadingIcon != null
                                        ? leadingIcon!(item)
                                        : null,
                                title: displayText(item),
                                trailing:
                                    selected
                                        ? const Icon(
                                          Icons.check,
                                          color: AppColors.colorPrimary,
                                        )
                                        : null,
                                onTap: () {
                                  selectedItem.value = item;
                                  if (onChanged != null) {
                                    onChanged!(item);
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          }),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
