import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';

class CircleImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final double? width;
  final double? height;

  const CircleImage({
    super.key,
    required this.imageUrl,
    this.radius = 40.0,
    this.width,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: FadeInImage.assetNetwork(
        placeholder: MyImagePaths.iconImage, // Placeholder while loading
        image: imageUrl,
        width: width ?? radius * 2,
        height: height ?? radius * 2,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) {
          return _errorPlaceholder();
        },
      ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Gray background for the placeholder
        borderRadius: BorderRadius.circular(radius),
      ),
      child: const Icon(
        Icons.person, // Default icon as fallback
        color: Colors.white,
        size: 40.0,
      ),
    );
  }
}

