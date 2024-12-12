import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/controllers/statistic_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class StatisticWidget extends StatelessWidget {
  const StatisticWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final incomeController = Get.put(StatisticController());

    return Obx(() {
      if (incomeController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (incomeController.errorMessage.isNotEmpty) {
        return const Center(
          child: Text(
            "Không có đơn hàng trong khoảng thời gian này",
            style: TextStyle(color: Colors.red),
          ),
        );
      }
      return Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              children: [
                const Icon(
                  Icons.savings_outlined,
                  color: MyColors.darkPrimaryTextColor,
                ),
                const SizedBox(
                  width: MySizes.xs,
                ),
                Text(
                  "Tổng doanh thu",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: MyColors.darkPrimaryTextColor),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: MySizes.xl - 2),
              child: Text(
                MyFormatter.formatCurrency(
                    incomeController.totalIncome.toInt()),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .apply(color: MyColors.primaryTextColor),
              ),
            ),
            const SizedBox(
              height: MySizes.sm,
            ),
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outlined,
                  color: MyColors.darkPrimaryTextColor,
                ),
                const SizedBox(
                  width: MySizes.xs,
                ),
                Text(
                  "Đơn hoàn thành",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: MyColors.darkPrimaryTextColor),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: MySizes.xl - 2),
              child: Text(
                incomeController.totalCompletedOrders.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .apply(color: MyColors.primaryTextColor),
              ),
            ),
          ]),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.assignment_outlined,
                    color: MyColors.darkPrimaryTextColor,
                  ),
                  const SizedBox(
                    width: MySizes.xs,
                  ),
                  Text(
                    "Tổng đơn hàng",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: MyColors.darkPrimaryTextColor),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: MySizes.xl - 2),
                child: Text(
                  "${incomeController.totalOrders}",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: MyColors.primaryTextColor),
                ),
              ),
              const SizedBox(
                height: MySizes.sm,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.highlight_remove_rounded,
                    color: MyColors.darkPrimaryTextColor,
                  ),
                  const SizedBox(
                    width: MySizes.xs,
                  ),
                  Text(
                    "Đơn từ chối",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: MyColors.darkPrimaryTextColor),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: MySizes.xl - 2),
                child: Text(
                  incomeController.totalFailedOrders.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: MyColors.primaryTextColor),
                ),
              ),
            ],
          )
        ],
      );
    });
  }
}
