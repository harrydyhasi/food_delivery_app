import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/history/views/widgets/history_order_tile.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});
  final orderController = Get.put(OrderController());

  Future<void> _refreshOrders() async {
    await orderController.fetchAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    orderController.fetchAllOrders();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng'),
        centerTitle: true,
        backgroundColor: MyColors.darkPrimaryColor,
      ),
      backgroundColor: MyColors.primaryBackgroundColor,
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _refreshOrders,
          child: orderController.orders.isEmpty
              ? const Center(child: Text("Không có đơn hàng nào."))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: orderController.orders.length,
                  itemBuilder: (context, index) {
                    return HistoryOrderTile(
                        order: orderController.orders[index]);
                  },
                ),
        );
      }),
    );
  }
}
