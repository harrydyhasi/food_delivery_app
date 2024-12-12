import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/views/widgets/customer_tab.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/views/widgets/restaurant_tab.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class DeliveryScreen extends StatelessWidget {
  final Order order;
  const DeliveryScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final OrderController ordersController = Get.find();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Giao hàng'),
          centerTitle: true,
          backgroundColor: MyColors.darkPrimaryColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 24,
            ),
            onPressed: () async {
              Get.back();
              await ordersController.fetchNewOrders();
            },
          ),
          bottom: const TabBar(
            dividerColor: Colors.white,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Nhà hàng'),
              Tab(text: 'Khách hàng'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RestaurantTab(order: order), // Pass order to RestaurantTab
            CustomerTab(order: order), // Pass order to CustomerTab
          ],
        ),
      ),
    );
  }
}
