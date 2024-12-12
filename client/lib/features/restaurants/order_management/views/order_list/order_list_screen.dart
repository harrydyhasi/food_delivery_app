import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_list/widgets/history_order_tile.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_list/widgets/new_order_tile.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_list/widgets/preparing_order_tile.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_list/widgets/tab_item.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../../../../sockets/handlers/order_socket_handler.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrderController());
    final orderHandler = OrderSocketHandler();

    // orderHandler.listenForOrderCreates((newOrder) {
    //   // Add the new order to the allOrders list
    //   if (newOrder.restStatus == "new" &&
    //       newOrder.restaurantId ==
    //           LoginController.instance.currentUser.partnerId &&
    //       newOrder.assignedShipperId != null) {
    //     orderController.newOrders.insert(0, newOrder);
    //   }
    // });

    orderHandler.joinOrderRoom(LoginController.instance.currentUser.partnerId);

    orderHandler.listenForOrderUpdates((newOrder) {
      orderController.newOrders.insert(0, newOrder);
    });

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: Text("Đơn hàng"),
        ),
        body: Obx(
          () => (orderController.isLoading.value)
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicatorPadding:
                          EdgeInsets.only(left: MySizes.sm, right: MySizes.sm),
                      tabs: [
                        TabItem(title: "Đơn mới"),
                        TabItem(title: "Đang chuẩn bị"),
                        TabItem(title: "Lịch sử"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // New orders list

                          Obx(
                            () => orderController.newOrders.isEmpty
                                ? const Center(child: Text("Không có đơn"))
                                : ListView.builder(
                                    itemCount: orderController.newOrders.length,
                                    itemBuilder: (context, index) {
                                      final order =
                                          orderController.newOrders[index];
                                      return NewOrderTile(
                                        order: order,
                                        handleAccept: () {
                                          orderController.acceptOrder(order.id);
                                        },
                                        handleCancel: () {
                                          orderController
                                              .handleCancelOrder(order.id);
                                        },
                                      );
                                    },
                                  ),
                          ),
                          Obx(
                            () => orderController.preparingOrders.isEmpty
                                ? const Center(child: Text("Không có đơn"))
                                : ListView.builder(
                                    itemCount:
                                        orderController.preparingOrders.length,
                                    itemBuilder: (context, index) {
                                      final order = orderController
                                          .preparingOrders[index];
                                      return PreparingOrderTile(
                                        order: order,
                                        handleDone: () {
                                          orderController
                                              .completeOrder(order.id);
                                        },
                                      );
                                    }),
                          ),
                          Obx(
                            () => orderController.doneOrders.isEmpty
                                ? const Center(child: Text("Không có đơn"))
                                : ListView.builder(
                                    itemCount:
                                        orderController.doneOrders.length,
                                    itemBuilder: (context, index) {
                                      final order =
                                          orderController.doneOrders[index];
                                      return HistoryOrderTile(order: order);
                                    }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
