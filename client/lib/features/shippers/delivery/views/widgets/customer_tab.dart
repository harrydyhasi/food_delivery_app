import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/controllers/tabs_controller.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/handle_status_text.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class CustomerTab extends StatelessWidget {
  final Order order;

  const CustomerTab({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final TabsController controller = Get.put(TabsController());
    final OrderController ordersController = Get.find();
    final orderHandler = OrderSocketHandler();

    var currentOrder = order.obs;

    orderHandler.joinOrderRoom(order.id);

    orderHandler.listenForOrderUpdates((newOrder) {
      currentOrder.value = newOrder;
    });

    // Wrap the widget to observe changes in the order or status
    return Obx(() {
      return Stack(
        children: [
          currentOrder.value.custStatus == "cancelled"
              ? Center(
                  child: Text(
                      "${currentOrder.value.restaurantName} đã hủy đơn vì ${currentOrder.value.reason}"))
              : SingleChildScrollView(
                  // Wrap the entire content with SingleChildScrollView
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, bottom: 68.0, right: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
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
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.customerName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        order.custPhone,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        order.custAddress ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Text(
                                            'Thu: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            MyFormatter.formatCurrency(
                                              (order.totalPrice ?? 0) +
                                                  (order.deliveryFee ?? 0),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(16),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
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
                                  child: Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Obx(
                                          () => Text(
                                            "Trạng thái - ${getDriverStatusText(currentOrder.value.driverStatus)}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: MyColors.primaryTextColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                buildInfoCard(
                                  context: context,
                                  children: [
                                    const Text(
                                      'Chi tiết đơn hàng',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Mã đơn hàng:',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          child: Text(
                                            '#${order.id}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Số lượng món: ${order.orderItems.length}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: MyColors.primaryTextColor),
                                    ),
                                    const Divider(
                                        color: MyColors.dividerColor,
                                        thickness: 1),
                                    const SizedBox(height: 8),
                                    // Table Headers
                                    const Row(
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            'Tên món',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              50, // Fixed width for the second column
                                          child: Text(
                                            'SL',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Thành tiền',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Order Items List
                                    ...order.orderItems.map((item) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width:
                                                  150, // Matches the header column width
                                              child: Text(
                                                item.itemName,
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  50, // Matches the header column width
                                              child: Text(
                                                '${item.quantity}',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                MyFormatter.formatCurrency(
                                                    item.totalPrice),
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                    const Divider(
                                        color: MyColors.dividerColor,
                                        thickness: 1),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Tổng: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          MyFormatter.formatCurrency(
                                              order.totalPrice ?? 0),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Phí vận chuyển: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          MyFormatter.formatCurrency(
                                              order.deliveryFee ?? 0),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            (order.totalPrice ?? 0) +
                                                (order.deliveryFee ?? 0),
                                          ),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: MyColors.primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: double
                                      .infinity, // Simplified instead of MediaQuery
                                  padding: const EdgeInsets.all(16),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Hóa đơn quán',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Tổng hóa đơn',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            MyFormatter.formatCurrency(
                                                order.totalPrice ?? 0),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Quán giảm giá',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            '0 VND',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      const Divider(
                                        color: MyColors.dividerColor,
                                        thickness: 1,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Tổng tiền thanh toán',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            MyFormatter.formatCurrency(
                                                order.totalPrice ?? 0),
                                            style: const TextStyle(
                                                color: MyColors.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          // Floating action button
          if (!controller.isCustButtonClicked.value &&
              currentOrder.value.driverStatus == "delivering")
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  try {
                    Map<String, dynamic> newStatus = {
                      "custStatus": "delivered",
                      "driverStatus": "delivered",
                      "restStatus": "completed"
                    };

                    await ordersController.updateOrderStatus(
                      null,
                      orderId: order.id,
                      newStatus: newStatus,
                    );

                    controller.isCustButtonClicked.value = true;

                    Loaders.successSnackBar(
                        title: "Hoàn thành",
                        message: "Đã hoàn thành đơn hàng.");

                    orderHandler.updateStatusOrder(order.id, newStatus);
                  } catch (e) {
                    Loaders.errorSnackBar(title: "Đã xảy ra lỗi", message: e);
                  }
                },
                label: const Text(
                  'Đã giao đơn hàng',
                  style: TextStyle(
                    color: MyColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(
                  Icons.check_circle,
                  color: MyColors.white,
                ),
                backgroundColor: MyColors.primaryColor,
              ),
            ),
        ],
      );
    });
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
