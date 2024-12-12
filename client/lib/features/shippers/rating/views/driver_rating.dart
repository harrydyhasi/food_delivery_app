import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/rating/controllers/driver_rating_controller.dart';
import 'package:food_delivery_h2d/features/shippers/rating/views/driver_rating_tile.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class DriverRating extends StatelessWidget {
  const DriverRating({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverRatingController());
    controller.fetchRating(LoginController.instance.currentUser.driverId);
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("Đánh giá"),
      ),
      body: SingleChildScrollView(child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: MySizes.sm),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Obx(() => Text(
                              "${MyFormatter.formatDouble(controller.value.value)}/5",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .apply(color: MyColors.primaryTextColor),
                            )),
                        const SizedBox(
                          height: MySizes.xs,
                        ),
                        Obx(() => RatingStars(
                              axis: Axis.horizontal,
                              value: controller.value.value,
                              onValueChanged: (v) {},
                              starCount: 5,
                              starSize: 20,
                              maxValue: 5,
                              starSpacing: 8,
                              maxValueVisibility: true,
                              valueLabelVisibility: false,
                              animationDuration: const Duration(milliseconds: 1000),
                              starOffColor: MyColors.starOffColor,
                              starColor: MyColors.starColor,
                            )),
                        const SizedBox(height: MySizes.spaceBtwItems / 2),
                        Obx(() => Text(
                              "${controller.count.value} đánh giá",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .apply(color: MyColors.primaryTextColor),
                            )),
                        const SizedBox(height: MySizes.spaceBtwItems / 2),
                      ],
                    ),
                    
                  ],
                ),
              ),
            ),
            Obx(() {
                      if (controller.ratingList.isEmpty) {
                        return const Center(
                            child: Text("Không có đánh giá nào"));
                      }
                      final ratings = controller.ratingList;
                      if (ratings.isEmpty) {
                        return const Center(
                            child: Text("Không có đánh giá nào"));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: ratings.length,
                        itemBuilder: (context, index) {
                          return DriverRatingTile(rating: ratings[index]);
                        },
                      );
                    }),
          ],
        );
      })),
    );
  }
}
