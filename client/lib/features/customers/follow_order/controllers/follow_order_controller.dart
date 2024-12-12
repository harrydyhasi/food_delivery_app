import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/controllers/order_controller.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';

class FollowOrderController extends GetxController {
  static FollowOrderController get instance => Get.find();
  // final orderController = Get.put(OrderController());
  final orderRepository = Get.put(OrderRepository());

  late Order order; // Observable order

  var isLoading = true.obs;
  var isButtonClicked = false.obs; // Observable for loading state

  @override
  void onInit() {
    super.onInit();
    // order = Get.arguments['order'];
    // fetchOrder();
  }

  Future<void> updateCustAddress(String orderId, String newAddress) async {
    try {
      ApiResponse<Order> response =
          await orderRepository.updateCustAddress(orderId, newAddress);

      if (response.status == Status.OK) {
        // addressController.text = newAddress;

        Loaders.successSnackBar(
          title: "Thành công",
          message: "Bạn đã thay đổi địa chỉ giao hàng.",
        );
      } else {
        Loaders.errorSnackBar(
          title: "Thất bại",
          message: response.message ?? "Failed to update address.",
        );
      }
    } catch (e) {
      Loaders.errorSnackBar(
        title: "Đã xảy ra lỗi",
        message: "An unknown error occurred.",
      );
    }
  }
}
