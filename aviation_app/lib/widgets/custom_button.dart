import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final bool isLoading;
  final bool disabled; // New flag for disabled state
  final Widget loadingWidget;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.isLoading,
    required this.loadingWidget,
    this.disabled = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    final isButtonDisabled = isLoading || disabled;

    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: isButtonDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(
            isButtonDisabled ? 0.6 : 1,
          ), // Slightly faded if disabled
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child:
            isLoading
                ? loadingWidget
                : Text(
                  text,
                  style: TextStyle(
                    color:
                        isButtonDisabled ? Colors.grey.shade600 : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
      ),
    );
  }
}
