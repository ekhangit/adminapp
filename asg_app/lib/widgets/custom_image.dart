import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCircularImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool isNetwork;
  final Color? borderColor;
  final double borderWidth;
  final BoxFit? boxFit;

  const CustomCircularImage({
    super.key,
    required this.imageUrl,
    this.size = 60.0,
    this.isNetwork = true,
    this.borderColor,
    this.borderWidth = 2.0,
    this.boxFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(1.0),
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
                  fit: boxFit,
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
