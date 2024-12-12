import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/order_status_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/handle_status_text.dart';
import 'package:food_delivery_h2d/utils/helpers/status_helper.dart';
import 'package:get/get.dart';

class CustomerOrderDetail extends StatelessWidget {
  const CustomerOrderDetail({super.key, required this.selectedOrder});
  final Order selectedOrder;

  @override
  Widget build(BuildContext context) {
    final orderStatusController = Get.put(OrderStatusController());
    orderStatusController.orderStatus.value = selectedOrder.custStatus;
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("Chi tiết đơn hàng"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: MySizes.md,
              right: MySizes.md,
              top: MySizes.lg,
              bottom: MySizes.lg),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildInfoCard(
              context: context,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trạng thái đơn  -  ${(StatusHelper.custStatusTranslations[selectedOrder.custStatus])}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (selectedOrder.custStatus == 'cancelled')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lý do hủy: ",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: MyColors.errorColor,
                                    ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              selectedOrder.reason,
                              softWrap:
                                  true, // Ensures text wraps to the next line if it's too long
                              overflow: TextOverflow
                                  .ellipsis, // Adds "..." if the text is too long
                              maxLines:
                                  3, // Optional: Limits the number of lines
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: MyColors.primaryTextColor,
                                  ),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(
                            Icons.inventory_outlined,
                            size: 18,
                            color: MyColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Obx(() => AnimatedContainer(
                                duration: const Duration(milliseconds: 1),
                                curve: Curves.linear,
                                width: 55,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: orderStatusController
                                      .getContainerColor(1),
                                ),
                                child: LinearProgressIndicator(
                                  value: orderStatusController
                                      .container1Progress.value,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          MyColors.primaryColor),
                                ),
                              )),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.local_dining,
                            size: 18,
                            color: MyColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Obx(() => AnimatedContainer(
                                duration: const Duration(milliseconds: 1),
                                curve: Curves.linear,
                                width: 55,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: orderStatusController
                                      .getContainerColor(2),
                                ),
                                child: LinearProgressIndicator(
                                  value: orderStatusController
                                      .container2Progress.value,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          MyColors.primaryColor),
                                ),
                              )),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.delivery_dining,
                            size: 18,
                            color: MyColors.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Obx(() => AnimatedContainer(
                                duration: const Duration(milliseconds: 1),
                                curve: Curves.linear,
                                width: 55,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: orderStatusController
                                      .getContainerColor(3),
                                ),
                                child: LinearProgressIndicator(
                                  value: orderStatusController
                                      .container3Progress.value,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          MyColors.primaryColor),
                                ),
                              )),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.home,
                            size: 18,
                            color: MyColors.primaryColor,
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Trạng thái",
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodySmall!
            //           .apply(color: MyColors.darkPrimaryTextColor),
            //     ),
            //     Text(
            //       StatusHelper
            //               .custStatusTranslations[selectedOrder.custStatus] ??
            //           'Unknown status',
            //       style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            //             color: MyColors.primaryTextColor,
            //             height: 2,
            //           ),
            //     )
            //   ],
            // ),
            const SizedBox(
              height: MySizes.spaceBtwItems,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mã đơn hàng",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: MyColors.darkPrimaryTextColor),
                ),
                Text(
                  "#${selectedOrder.id.toString()}",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: MyColors.primaryTextColor,
                        height: 2,
                      ),
                )
              ],
            ),
            const SizedBox(
              height: MySizes.spaceBtwItems,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Thời gian đặt hàng",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: MyColors.darkPrimaryTextColor),
                ),
                Text(
                  MyFormatter.formatTime(
                      selectedOrder.orderDatetime.toString()),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: MyColors.primaryTextColor,
                        height: 2,
                      ),
                )
              ],
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            const Divider(
              color: MyColors.dividerColor,
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            Text(
              "Tài xế",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: MyColors.secondaryTextColor),
            ),
            const SizedBox(
              height: MySizes.xs,
            ),
            Text(
              "${selectedOrder.driverName}",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .apply(color: MyColors.darkPrimaryTextColor),
            ),
            const SizedBox(
              height: MySizes.xs,
            ),
            Row(
              children: [
                Text(
                  "${selectedOrder.driverPhone}",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: MyColors.secondaryTextColor),
                ),
                const SizedBox(
                  width: MySizes.sm,
                ),
                Container(color: MyColors.dividerColor, width: 0.8, height: 15),
                const SizedBox(
                  width: MySizes.sm,
                ),
                Text(
                  "${selectedOrder.driverLicensePlate}",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: MyColors.secondaryTextColor),
                ),
              ],
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            const Divider(
              color: MyColors.dividerColor,
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(right: MySizes.xs),
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: MyColors.primaryColor)),
                Text(
                  "Từ",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: MyColors.secondaryTextColor),
                ),
              ],
            ),
            const SizedBox(height: MySizes.xs),
            Text(
              selectedOrder.restaurantName,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .apply(color: MyColors.darkPrimaryTextColor),
            ),
            const SizedBox(height: MySizes.xs),
            Text(
              selectedOrder.restAddress.toString(),
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: MyColors.secondaryTextColor),
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(right: MySizes.xs),
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: MyColors.openColor)),
                Text(
                  "Đến",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: MyColors.secondaryTextColor),
                ),
              ],
            ),
            const SizedBox(height: MySizes.xs),
            Text(
              selectedOrder.custAddress.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .apply(color: MyColors.darkPrimaryTextColor),
            ),
            const SizedBox(height: MySizes.xs),
            Text(
              "${selectedOrder.customerName} - ${selectedOrder.custPhone}",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: MyColors.secondaryTextColor),
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            const Divider(
              color: MyColors.dividerColor,
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        'Tên món',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 50, // Fixed width for the second column
                      child: Text(
                        'SL',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Thành tiền',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: MyColors.primaryTextColor,
                              height: 2,
                            ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                ...selectedOrder.orderItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 150, // Matches the header column width
                          child: Text(
                            item.itemName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .apply(color: MyColors.secondaryTextColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: 50, // Matches the header column width
                          child: Text(
                            '${item.quantity}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .apply(color: MyColors.secondaryTextColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            MyFormatter.formatCurrency(item.totalPrice),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .apply(color: MyColors.secondaryTextColor),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: MySizes.spaceBtwItems),
                const Divider(
                  color: MyColors.dividerColor,
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tổng món ăn",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    Text(
                      MyFormatter.formatCurrency(selectedOrder.getToTalPrice()),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: MyColors.primaryTextColor,
                            height: 2,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phí vận chuyển",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    Text(
                      MyFormatter.formatCurrency(
                        selectedOrder.deliveryFee ?? 0,
                      ),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: MyColors.primaryTextColor,
                            height: 2,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tổng tiền",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    Text(
                      MyFormatter.formatCurrency(
                        (selectedOrder.totalPrice ?? 0) +
                            (selectedOrder.deliveryFee ?? 0),
                      ),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: MyColors.primaryTextColor,
                            height: 2,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Text(
                  "Ghi chú",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(color: MyColors.darkPrimaryTextColor),
                ),
                const SizedBox(height: MySizes.spaceBtwItems),
                Text(
                  selectedOrder.note,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: MyColors.primaryTextColor,
                        height: 2.5,
                      ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildInfoCard(
      {required BuildContext context, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
