import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/address_controller.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/models/order_item_model.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/models/order_model.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/views/follow_order_screen.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/cart_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/restaurant_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  final TextEditingController noteController = TextEditingController();
  final orderRepository = Get.put(OrderRepository());
  final CartController cartController = Get.find();
  final AddressController addressController = Get.put(AddressController());
  late final OrderModel order = OrderModel(
    orderItems: [], // Default delivery fee
  );
  double deliveryFee = 15000;

  final _orderSocketHandler = Get.put(OrderSocketHandler());

  var paymentMethod = 'Cash'.obs;

  @override
  void onInit() {
    super.onInit();
    // order = OrderModel(orderItems: []);
    // noteController.text = order.note;
    // handleNoteOnChange();
    convertCartItemToOrderItem();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  // handleNoteOnChange() {
  //   noteController.addListener(() {
  //     order.note = noteController.text;
  //   });
  // }

  void convertCartItemToOrderItem() {
    // order.orderItems.clear();
    if (order.orderItems.isEmpty) {
      for (var cartItem in cartController.cartItems) {
        order.orderItems.add(OrderItem(
          itemName: cartItem.itemName,
          price: cartItem.price,
          quantity: cartController.itemQuantities[cartItem.itemName] ?? 0,
          totalPrice: cartItem.price *
              cartController.itemQuantities[cartItem.itemName]!,
          itemId: cartItem.itemId,
        ));
      }
      order.totalPrice =
          order.orderItems.fold(0, (sum, item) => sum + item.totalPrice);
      order.deliveryFee = deliveryFee;
    }
  }

  Future<void> placeOrder() async {
    convertCartItemToOrderItem();
    OrderModel newOrder = OrderModel(
      custAddress: order.custAddress,
      customerId: LoginController.instance.currentUser.userId,
      restaurantId: RestaurantController.instance.userId,
      deliveryFee: deliveryFee,
      orderItems: order.orderItems,
      totalPrice: order.totalPrice,
      note: noteController.text,
    );

    ApiResponse<Order> createdOrder =
        await orderRepository.placeOrder(newOrder);

    if (createdOrder.status == Status.OK) {
      var orderDetail = createdOrder.data!;
      cartController.removeAllItem();

      ApiResponse<Order> orderResponse =
          await orderRepository.getOrderById(orderDetail.id);
      Loaders.successSnackBar(
          title: "Thành công", message: "Đặt hàng thành công.");
      order.orderItems.clear();

      Order? responseOrder = orderResponse.data;
      responseOrder?.restAddress = await addressController.getFullAddress(
        responseOrder.restProvinceId,
        responseOrder.restDistrictId,
        responseOrder.restCommuneId,
        responseOrder.restDetailAddress,
      );

      Get.to(FollowOrderScreen(
        order: orderResponse.data!,
      ));

      _orderSocketHandler.createOrder(orderResponse.data!);

      if (responseOrder != null) {
        Loaders.successSnackBar(
            title: "Thành công", message: "Đặt hàng thành công.");
      } else {
        Loaders.errorSnackBar(
            title: "Lỗi", message: "Không thể lấy chi tiết đơn hàng.");
      }
    }
  }
}
