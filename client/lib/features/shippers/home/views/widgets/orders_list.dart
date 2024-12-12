import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/address_controller.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/views/widgets/order_tile.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.put(OrderController());
    final addressController = Get.put(AddressController());
    final orderSocket = Get.put(OrderSocketHandler());

    orderSocket.listenNewOrderDriver((newOrder) async {
      if (newOrder.custStatus == "waiting") {
        newOrder.restAddress = await addressController.getFullAddress(
          newOrder.restProvinceId,
          newOrder.restDistrictId,
          newOrder.restCommuneId,
          newOrder.restDetailAddress,
        );
        if (!controller.newOrders.any((order) => order.id == newOrder.id)) {
          controller.newOrders.insert(0, newOrder);
        }
      }
    });

    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.1,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: const EdgeInsets.only(top: 16),
          decoration: const BoxDecoration(
            color: MyColors.primaryBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.newOrders.isEmpty) {
              if (!LoginController.instance.currentUser.workingStatus) {
                return const Center(
                    child: Text("Bật trạng thái hoạt động để tìm đơn mới."));
              }

              return const Center(child: Text("Không có đơn hàng nào."));
            }

            return ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: controller.newOrders.length,
              itemBuilder: (context, index) {
                return OrderTile(order: controller.newOrders[index]);
              },
            );
          }),
        );
      },
    );
  }
}
