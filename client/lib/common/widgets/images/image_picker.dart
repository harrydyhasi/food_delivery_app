
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class DottedBorderImagePicker extends StatelessWidget {
  const DottedBorderImagePicker(
      {super.key,
      this.imageFile,
      required this.onTap,
      this.height = 100,
      this.width = 100});

  final File? imageFile;
  final VoidCallback onTap;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          padding: const EdgeInsets.all(6),
          color: MyColors.darkPrimaryColor,
          dashPattern: const [6, 3], // Color of the dotted border
          strokeWidth: 2,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(MySizes.cardRadiusMd),
            ),
            child: SizedBox(
              width: width,
              height: height,
              child: imageFile != null
                  ? Stack(children: [
                      Image.file(
                        imageFile!,
                         fit: BoxFit.cover,
                        width: width,
                        height: height,
                      ),
                    ])
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          size: 40,
                          color: MyColors.primaryColor,
                        ),
                        const SizedBox(height: MySizes.spaceBtwItems),
                        Text(
                          "Thêm",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .apply(color: MyColors.primaryColor),
                        )
                      ],
                    ),
            ),
          )),
    );
  }
}
