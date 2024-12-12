import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/order/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/history_order_tile_cancelled.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/history_order_tile_delivered.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/ongoing_order_tile.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/tab_item.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class CustomerOrderListScreen extends StatelessWidget {
  const CustomerOrderListScreen({super.key});

  Future<void> _refreshOrders() async {
    await CustomerOrderController.instance.fetchAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(CustomerOrderController());
    orderController.fetchAllOrders();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: Text("Đơn hàng"),
          showBackArrow: false,
        ),
        backgroundColor: MyColors.primaryBackgroundColor,
        body: Column(
          children: [
            const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicatorPadding:
                  EdgeInsets.only(left: MySizes.sm, right: MySizes.sm),
              tabs: [
                TabItem(title: "Đang đến"),
                TabItem(title: "Lịch sử"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Obx(() {
                    if (orderController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
              
                    final onGoingOrders = orderController.orders
                        .where((order) =>
                            order.custStatus == 'waiting' ||
                            order.custStatus == 'heading_to_rest' ||
                            order.custStatus == 'preparing' ||
                            order.custStatus == 'delivering')
                        .toList();
              
                    if (onGoingOrders.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: _refreshOrders,
                        child: const Center(
                            child: Text("Không có lịch sử đơn hàng!")),
                      );
                    }
              
                    return RefreshIndicator(
                      onRefresh: _refreshOrders,
                      child: ListView.builder(
                        itemCount: onGoingOrders.length,
                        itemBuilder: (context, index) {
                          final order = onGoingOrders[index];
                          return OngoingOrderTile(order: order);
                        },
                      ),
                    );
                  }),
                  Obx(() {
                    if (orderController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
              
                    final historyOrders = orderController.orders
                        .where((order) =>
                            order.custStatus == 'delivered' ||
                            order.custStatus == 'cancelled')
                        .toList();
              
                    if (historyOrders.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: _refreshOrders,
                        child: const Center(
                            child: Text("Không có lịch sử đơn hàng!")),
                      );
                    }
              
                    return RefreshIndicator(
                      onRefresh: _refreshOrders,
                      child: ListView.builder(
                        itemCount: historyOrders.length,
                        itemBuilder: (context, index) {
                          final order = historyOrders[index];
                          if (order.custStatus == 'delivered') {
                            return HistoryOrderTileDelivered(order: order);
                          } else {
                            return HistoryOrderTileCancelled(order: order);
                          }
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
