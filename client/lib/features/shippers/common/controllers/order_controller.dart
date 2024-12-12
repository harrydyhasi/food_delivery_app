import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/address_controller.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/views/delivery_screen.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  var newOrders = <Order>[].obs; // Observable list of orders
  var orders = <Order>[].obs; // Observable list of orders
  var isLoading = true.obs;
  OrderRepository orderRepository = Get.put(OrderRepository());
  final addressController = Get.put(AddressController());
  final orderHandler = OrderSocketHandler();

  @override
  void onInit() {
    super.onInit();
    fetchNewOrders();
    fetchAllOrders();
  }

  Future<void> fetchNewOrders() async {
    try {
      isLoading(true);

      if (LoginController.instance.currentUser.workingStatus) {
        final fetchedOrders =
            await orderRepository.getOrdersByStatus(driverStatus: "waiting");

        List<Order> ordersWithFullAddress = await Future.wait(
          fetchedOrders.map((order) async {
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
      } else {
        newOrders.clear();
      }
      // print(newOrders);
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAllOrders() async {
    try {
      isLoading(true);

      final fetchedOrders = await orderRepository
          .getOrdersByDriverId(LoginController.instance.currentUser.driverId);

      List<Order> ordersWithFullAddress = await Future.wait(
        fetchedOrders.map((order) async {
          order.restAddress = await addressController.getFullAddress(
            order.restProvinceId,
            order.restDistrictId,
            order.restCommuneId,
            order.restDetailAddress,
          );
          return order;
        }),
      );

      orders.assignAll(ordersWithFullAddress);
      orders.sort((a, b) => b.orderDatetime.compareTo(a.orderDatetime));
      print(orders);
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateOrderStatus(
    String? driverId, {
    required String orderId,
    required Map<String, dynamic> newStatus,
  }) async {
    try {
      await orderRepository.updateOrderStatus(
          orderId, driverId, newStatus, null);

      final orderIndex = orders.indexWhere((o) => o.id == orderId);
      if (orderIndex != -1) {
        orders[orderIndex].custStatus = newStatus['custStatus'];
        orders[orderIndex].driverStatus = newStatus['driverStatus'];
        orders[orderIndex].restStatus = newStatus['restStatus'];
        orders[orderIndex].assignedShipperId = driverId;
        orders.refresh();
      }
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại!", message: "Đã xảy ra lỗi.");
      rethrow;
    }
  }

  Future<void> acceptOrder(Order order) async {
    final invalidOrders = orders.where((order) =>
        order.driverStatus != 'delivered' && order.driverStatus != 'cancelled');

    if (invalidOrders.isNotEmpty) {
      Loaders.errorSnackBar(
        title: "Nhận đơn thất bại",
        message: "Bạn không thể nhận đơn vì có đơn hàng chưa hoàn thành.",
      );
      return;
    }
    try {
      ApiResponse<Order> orderResponse =
          await OrderRepository.instance.getOrderById(order.id);
      Order? newOrder = orderResponse.data!;
      if (newOrder.assignedShipperId == null ||
          newOrder.driverStatus != 'cancelled') {
        Map<String, dynamic> newStatus = {
          "custStatus": "heading_to_rest",
          "driverStatus": "heading_to_rest",
          "restStatus": "new"
        };

        await updateOrderStatus(
          LoginController.instance.currentUser.driverId,
          orderId: order.id,
          newStatus: newStatus,
        );

        orderHandler.updateStatusOrder(order.id, newStatus);

        newOrders.removeWhere((o) => o.id == order.id);
        Get.to(() => DeliveryScreen(order: order));
      } else {
        Loaders.errorSnackBar(
          title: "Nhận đơn thất bại",
          message: "Đã có tài xế nhận đơn này. Vui lòng nhận đơn khác.",
        );
        return;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to accept the order: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
