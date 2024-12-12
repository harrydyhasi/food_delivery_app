import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/rating/controllers/customer_rating_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/status_helper.dart';
import 'package:get/get.dart';

class RatingView extends StatelessWidget {
  final Order order;
  const RatingView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final ratingController = Get.put(CustomerRatingController());

    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("Đánh giá"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: MySizes.sm, right: MySizes.sm, top: MySizes.md),
          child: Column(
            children: [
              SizedBox(
                height: 105,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 4,
                  shadowColor: MyColors.darkPrimaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(MySizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Đơn hàng #${order.id}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                        const SizedBox(
                          height: MySizes.sm,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: MyColors.openColor.withOpacity(0.3),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(MySizes.xs),
                                child: Text(
                                  StatusHelper.custStatusTranslations[
                                          order.custStatus] ??
                                      'Unknown status',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .apply(color: MyColors.successColor),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(MyFormatter.formatTime(
                                order.orderDatetime.toString())),
                            const SizedBox(
                              width: MySizes.sm,
                            ),
                            Text(MyFormatter.formatDate(
                                order.orderDatetime.toString())),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: MySizes.sm,
              ),
              SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 4,
                  shadowColor: MyColors.darkPrimaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(MySizes.md),
                    child: Column(
                      children: [
                        Text(
                          "Đánh giá đơn hàng",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .apply(color: MyColors.primaryTextColor),
                        ),
                        const SizedBox(
                          height: MySizes.sm,
                        ),
                        Obx(() => RatingStars(
                              axis: Axis.horizontal,
                              value: ratingController
                                  .selectedRatingRestaurant.value,
                              onValueChanged: (v) {
                                ratingController
                                    .selectedRatingRestaurant.value = v;
                              },
                              starCount: 5,
                              starSize: 24,
                              maxValue: 5,
                              starSpacing: 8,
                              maxValueVisibility: true,
                              valueLabelVisibility: false,
                              starOffColor: MyColors.starOffColor,
                              starColor: MyColors.starColor,
                            )),
                        const SizedBox(
                          height: MySizes.md,
                        ),
                        TextFormField(
                          controller: ratingController.commentRestaurant,
                          obscureText: false,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Nhập đánh giá",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: MySizes.sm,
              ),
              SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 4,
                  shadowColor: MyColors.darkPrimaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(MySizes.md),
                    child: Column(
                      children: [
                        Text(
                          "Đánh giá tài xế",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .apply(color: MyColors.primaryTextColor),
                        ),
                        const SizedBox(
                          height: MySizes.sm,
                        ),
                        Obx(() => RatingStars(
                              axis: Axis.horizontal,
                              value:
                                  ratingController.selectedRatingDriver.value,
                              onValueChanged: (v) {
                                ratingController.selectedRatingDriver.value = v;
                              },
                              starCount: 5,
                              starSize: 24,
                              maxValue: 5,
                              starSpacing: 8,
                              maxValueVisibility: true,
                              valueLabelVisibility: false,
                              starOffColor: MyColors.starOffColor,
                              starColor: MyColors.starColor,
                            )),
                        const SizedBox(
                          height: MySizes.md,
                        ),
                        TextFormField(
                          controller: ratingController.commentDriver,
                          obscureText: false,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Nhập đánh giá",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: MySizes.sm,
                    bottom: MySizes.sm,
                    right: MySizes.xs,
                    left: MySizes.xs),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {ratingController.rating(order.id);},
                    child: const Text("Gửi đánh giá"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
