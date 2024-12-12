import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class ItemDashboard extends StatelessWidget {
  final String role;
  final ImageProvider img;
  final Color textColor;
  final String count;

  const ItemDashboard(
      {super.key,
      required this.role,
      required this.img,
      this.textColor = MyColors.darkPrimaryTextColor,
      required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 200,
      margin: const EdgeInsets.only(right: MySizes.md, left: MySizes.lg),
      child: Card(
        elevation: 4,
        shadowColor: MyColors.darkPrimaryColor,
        child: Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: MySizes.lg, right: MySizes.md),
              child: Image(
                image: img,
                width: 32,
                height: 32,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  role,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: MyColors.darkPrimaryColor,
                      ),
                ),
                Text(
                  count,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: MyColors.primaryColor,
                      ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
