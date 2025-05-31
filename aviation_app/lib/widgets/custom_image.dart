import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCircularImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool isNetwork;
  final Color? borderColor;
  final double borderWidth;

  const CustomCircularImage({
    super.key,
    required this.imageUrl,
    this.size = 60.0,
    this.isNetwork = true,
    this.borderColor,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            borderColor != null
                ? Border.all(color: borderColor!, width: borderWidth)
                : null,
      ),
      child: ClipOval(
        child:
            isNetwork
                ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: const Icon(Icons.error_outline, size: 17.5),
                      ),
                )
                : Image.asset(imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
