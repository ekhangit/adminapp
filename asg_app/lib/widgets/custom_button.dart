import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final bool isLoading;
  final double borerRadius;
  final bool disabled;
  final Widget loadingWidget;
  final bool isTransparent; // 🔹 New flag

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.isLoading,
    required this.loadingWidget,
    this.disabled = false,
    this.borerRadius = 50,
    this.isTransparent = false, // 🔹 Default to false
  });

  @override
  Widget build(BuildContext context) {
    final isButtonDisabled = isLoading || disabled;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isButtonDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isTransparent
                  ? Colors.transparent
                  : color.withOpacity(isButtonDisabled ? 0.6 : 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borerRadius),
            side:
                isTransparent
                    ? const BorderSide(color: Colors.white, width: 2)
                    : BorderSide.none,
          ),
          elevation: 0, // no shadow for transparent style
        ),
        child:
            isLoading
                ? loadingWidget
                : Text(
                  text,
                  style: TextStyle(
                    color:
                        isTransparent
                            ? Colors.white
                            : isButtonDisabled
                            ? Colors.grey.shade600
                            : Colors.white,
                    fontSize: 20.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      ),
    );
  }
}
