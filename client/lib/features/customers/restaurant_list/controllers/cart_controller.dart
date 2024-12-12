
import 'package:food_delivery_h2d/features/customers/confirm_order/controllers/order_controller.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  var cartItems = <Item>[].obs;
  var itemQuantities = <String, int>{}.obs;
  int deliveryFee = 15000;

  int get totalItems {
    return itemQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  }

  int get totalPrice {
    return cartItems.fold(0, (sum, item) {
      var quantity = itemQuantities[item.itemName] ?? 1;
      return sum + (item.price * quantity);
    });
  }

  int get orderPrice {
    OrderController.instance.order.totalPrice = totalPrice;
    return totalPrice + deliveryFee;
  }

  void addToCart(Item item) {
    var existingItem = cartItems
        .firstWhereOrNull((element) => element.itemName == item.itemName);
    if (existingItem != null) {
      itemQuantities[existingItem.itemName] =
          (itemQuantities[existingItem.itemName] ?? 0) + 1;
    } else {
      cartItems.add(item);
      itemQuantities[item.itemName] = 1;
    }
  }

  void removeFromCart(Item item) {
    if (itemQuantities[item.itemName] == 1) {
      cartItems.remove(item);
      itemQuantities.remove(item.itemName);
    } else {
      itemQuantities[item.itemName] = (itemQuantities[item.itemName] ?? 0) - 1;
    }
  }

  void removeAllItem() {
    cartItems.clear();
    itemQuantities.clear();
  }
}
