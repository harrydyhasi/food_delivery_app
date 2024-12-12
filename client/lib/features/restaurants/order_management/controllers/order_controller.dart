import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/item/item_repository.dart';
import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import '../../../authentication/controllers/address_controller.dart';
import '../../../shippers/home/models/order_model.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  var isLoading = false.obs;
  var newOrders = <Order>[].obs;
  var preparingOrders = <Order>[].obs;
  var doneOrders = <Order>[].obs; // contain cancel orders

  final _orderRespository = Get.put(OrderRepository());
  final addressController = Get.put(AddressController());
  final _orderRepository = Get.put(OrderRepository());
  final _itemRepository = Get.put(ItemRepository());

  final _reasonController = TextEditingController();

  final _orderSocketHandler = OrderSocketHandler();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  void onInit() async {
    await initLoad();
    super.onInit();
  }

  Future initLoad() async {
    try {
      isLoading.value = true;
      await fetchNewOrders();
      await fetchPreparingOrders();
      await fetchCompletedOrders();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNewOrders() async {
    try {
      isLoading(true);

      // Fetch orders from the repository
      final fetchedOrders = await _orderRespository.getOrdersByPartnerStatus(
          LoginController.instance.currentUser.partnerId, "new");

      final List<Order> ordersWithFullAddress = await Future.wait(
        fetchedOrders.data!.map((order) async {
          order.restAddress = await addressController.getFullAddress(
            order.restProvinceId,
            order.restDistrictId,
            order.restCommuneId,
            order.restDetailAddress,
          );
          return order;
        }),
      );

      newOrders.assignAll(ordersWithFullAddress);
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchPreparingOrders() async {
    try {
      isLoading(true);

      // Fetch orders from the repository
      final fetchedOrders = await _orderRespository.getOrdersByPartnerStatus(
          LoginController.instance.currentUser.partnerId, "preparing");

      final List<Order> ordersWithFullAddress = await Future.wait(
        fetchedOrders.data!.map((order) async {
          order.restAddress = await addressController.getFullAddress(
            order.restProvinceId,
            order.restDistrictId,
            order.restCommuneId,
            order.restDetailAddress,
          );
          return order;
        }),
      );

      preparingOrders.assignAll(ordersWithFullAddress);
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCompletedOrders() async {
    try {
      isLoading(true);

      // Fetch orders from the repository
      final fetchedCompletedOrders =
          await _orderRespository.getOrdersByPartnerStatus(
              LoginController.instance.currentUser.partnerId, "completed");

      final fetchedCanceledOrders =
          await _orderRespository.getOrdersByPartnerStatus(
              LoginController.instance.currentUser.partnerId, "cancelled");

      var ordersWithFullAddress = <Order>[];

      ordersWithFullAddress =
          await Future.wait(fetchedCompletedOrders.data?.map((order) async {
                order.restAddress = await addressController.getFullAddress(
                  order.restProvinceId,
                  order.restDistrictId,
                  order.restCommuneId,
                  order.restDetailAddress,
                );
                return order;
              }) ??
              []);

      var canceledOrdersWithFullAddress = <Order>[];

      canceledOrdersWithFullAddress = await Future.wait(
        fetchedCanceledOrders.data?.map((order) async {
              order.restAddress = await addressController.getFullAddress(
                order.restProvinceId,
                order.restDistrictId,
                order.restCommuneId,
                order.restDetailAddress,
              );
              return order;
            }) ??
            [],
      );

      doneOrders.assignAll(ordersWithFullAddress);
      doneOrders.addAll(canceledOrdersWithFullAddress);
      doneOrders.sort((a, b) => b.orderDatetime.compareTo(a.orderDatetime));
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }

  void acceptOrder(String orderId) async {
    try {
      Map<String, dynamic> newStatus = {
        "custStatus": "preparing",
        "driverStatus": "heading_to_rest",
        "restStatus": "preparing"
      };
      final res = await _orderRepository.updateOrderStatus(
          orderId, null, newStatus, null);

      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Lỗi", message: res.message);
        return;
      }

      final orderIndex = newOrders.indexWhere((o) => o.id == orderId);
      newOrders[orderIndex].restStatus = "preparing";
      preparingOrders.add(newOrders[orderIndex]);
      newOrders.removeAt(orderIndex);

      Loaders.successSnackBar(
          title: "Thành công!", message: "Nhận đơn hàng thành công!.");

      _orderSocketHandler.updateStatusOrder(orderId, newStatus);
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại!", message: e.toString());
      rethrow;
    }
  }

  void completeOrder(String orderId) async {
    try {
      Map<String, dynamic> newStatus = {
        "custStatus": "preparing",
        "driverStatus": "heading_to_rest",
        "restStatus": "completed"
      };
      final res = await _orderRepository.updateOrderStatus(
          orderId, null, newStatus, null);

      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Lỗi", message: res.message);
        return;
      }

      final orderIndex = preparingOrders.indexWhere((o) => o.id == orderId);
      preparingOrders[orderIndex].restStatus = "completed";
      doneOrders.add(preparingOrders[orderIndex]);

      // Decrease quantity
      await Future.wait(preparingOrders[orderIndex].orderItems.map(
        (e) async {
          _itemRepository.decreaseQuantity(e.foodId, e.quantity);
          _itemRepository.increaseSales(e.foodId, e.quantity);
        },
      ));

      preparingOrders.removeAt(orderIndex);

      Loaders.successSnackBar(
          title: "Thành công!", message: "Đã hàng đã hoàn thành!.");

      _orderSocketHandler.updateStatusOrder(orderId, newStatus);
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại!", message: e.toString());
      rethrow;
    }
  }

  void handleCancelOrder(String orderId) async {
    Get.defaultDialog(
        contentPadding: const EdgeInsets.all(MySizes.md),
        title: "Từ chối đơn hàng",
        middleText: "Bạn có chắc chắn muốn từ chối đơn hàng này!",
        content: TextFormField(
          decoration: const InputDecoration(hintText: "Lý do hủy"),
          controller: _reasonController,
        ),
        confirm: ElevatedButton(
            onPressed: () async {
              try {
                cancelOrder(orderId);
                Navigator.of(Get.overlayContext!).pop();
              } catch (err) {
                Loaders.successSnackBar(title: "Thất bại!", message: "Từ chối");
              }
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                backgroundColor: Colors.red,
                side: const BorderSide(color: Colors.red)),
            child: const Text("Từ chối")),
        cancel: OutlinedButton(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: MySizes.md, vertical: 0)),
            onPressed: () => Navigator.of(Get.overlayContext!).pop(),
            child: const Text("Quay lại")));
  }

  void cancelOrder(String orderId) async {
    try {
      Map<String, dynamic> newStatus = {
        "custStatus": "cancelled",
        "driverStatus": "cancelled",
        "restStatus": "cancelled"
      };
      final res = await _orderRepository.updateOrderStatus(
          orderId, null, newStatus, _reasonController.text);

      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Lỗi", message: res.message);
        return;
      }

      final orderIndex = newOrders.indexWhere((o) => o.id == orderId);
      newOrders[orderIndex].restStatus = "cancelled";
      doneOrders.add(newOrders[orderIndex]);
      newOrders.removeAt(orderIndex);

      Loaders.successSnackBar(title: "Thành công!", message: "Đơn đã hủy!.");

      _orderSocketHandler.updateStatusOrder(orderId, newStatus);
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại!", message: e.toString());
      rethrow;
    }
  }
}
