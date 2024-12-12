import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/keyboard_hider.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/customers/address_selection/controllers/address_selection_controller.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/cart_controller.dart';
import 'package:food_delivery_h2d/features/customers/address_selection/views/address_selection/address_selection_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class ConfirmOrderScreen extends StatelessWidget {
  ConfirmOrderScreen({super.key});
  final CartController cartController = Get.find();
  final orderController = Get.put(OrderController());
  // ignore: unused_local_variable
  final addressController = Get.put(AddressSelectionController());

  @override
  Widget build(BuildContext context) {
    orderController.convertCartItemToOrderItem();
    return KeyboardHider(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Xác nhận đơn hàng'),
          centerTitle: true,
          backgroundColor: MyColors.darkPrimaryColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
            ),
            onPressed: () {
              orderController.order.orderItems.clear();
              Get.back();
            },
          ),
        ),
        backgroundColor: MyColors.primaryBackgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 8.0,
            right: 8.0,
            bottom: 80.0,
            left: 8.0,
          ),
          child: Column(
            children: [
              // Restaurant Information
              GestureDetector(
                onTap: () {
                  Get.to(() => AddressSelectionScreen(
                        isUpdate: false,
                      ));
                },
                child: buildInfoCard(
                  context: context,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: MyColors.primaryColor,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Địa chỉ giao hàng",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${LoginController.instance.currentUser.name}", // Replace with actual user name
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${LoginController.instance.currentUser.phone}", // Replace with actual user name
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Obx(() {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.8, // Set the desired width
                                child: Text(
                                  addressController.fullAddress.value,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: MyColors.dividerColor,
                          size: 20,
                        )
                      ],
                    )
                  ],
                ),
              ),

              // Customer Notes
              buildInfoCard(
                context: context,
                children: [
                  const Text(
                    'Ghi chú',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: orderController.noteController,
                    onChanged: (value) {
                      orderController.order.note = value;
                    },
                    style: const TextStyle(
                      fontSize: 14,
                      color: MyColors.primaryTextColor,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nhập ghi chú...',
                    ),
                    maxLines: null,
                  ),
                ],
              ),
              // Order Details
              buildInfoCard(
                context: context,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chi tiết đơn hàng',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Tên món',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 50, // Fixed width for the second column
                        child: Text(
                          'SL',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Thành tiền',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: MyColors.dividerColor, thickness: 1),
                  const SizedBox(height: 8),
                  ...orderController.order.orderItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              item.itemName,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              MyFormatter.formatCurrency(item.totalPrice),
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(color: MyColors.dividerColor, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng: ',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        MyFormatter.formatCurrency(
                            orderController.order.totalPrice),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Phí vận chuyển: ',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        MyFormatter.formatCurrency(
                            orderController.order.deliveryFee.toInt()),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng tiền: ',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: MyColors.primaryTextColor),
                      ),
                      Text(
                        MyFormatter.formatCurrency(
                            (orderController.order.totalPrice +
                                    orderController.order.deliveryFee)
                                .toInt()),
                        style: const TextStyle(
                            fontSize: 14,
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              // Inside the body of the Column widget
              buildInfoCard(
                context: context,
                children: [
                  const Text(
                    'Phương thức thanh toán',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Thanh toán khi nhận hàng'),
                                Image.asset('assets/icons/ic_cash.png',
                                    width: 32, height: 32),
                              ],
                            ),
                            value: 'Cash',
                            groupValue: orderController.paymentMethod.value,
                            onChanged: (value) {
                              orderController.paymentMethod.value = value!;
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (addressController.fullAddress.value.isEmpty) {
              Loaders.errorSnackBar(
                title: 'Chưa chọn địa chỉ',
                message: 'Vui lòng chọn địa chỉ giao hàng trước khi đặt hàng.',
              );
            } else {
              orderController.placeOrder();
            }
          },
          label: const Text(
            'Đặt hàng',
            style: TextStyle(
              fontSize: 16,
              color: MyColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: MyColors.primaryColor,
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required BuildContext context,
    required List<Widget> children,
  }) {
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
