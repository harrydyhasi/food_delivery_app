import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/images/image_text_image.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class ItemMenu extends StatelessWidget {
  final String title;
  final String image;
  final Color textColor;
  final VoidCallback? onTap;

  const ItemMenu({
    super.key,
    required this.title,
    required this.image,
    this.textColor = MyColors.darkPrimaryTextColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.darkPrimaryTextColor, width: 1.5),
          borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
        ),
        child: Center(
          child: MyVerticalImageText(
            image: image,
            title: title,
            width: 80,
            height: 85,
            widthImage: 64,
            heightImage: 64,
            textStyle: Theme.of(context).textTheme.titleLarge!.apply(
              color: MyColors.darkPrimaryTextColor
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
