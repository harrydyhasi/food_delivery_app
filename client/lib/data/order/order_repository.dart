import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/models/order_status_chart.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/models/order_model.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  Future<List<Order>> getAllOrders() async {
    try {
      final res = await HttpHelper.get("order");
      if (res["hasError"] == true) {
        throw Exception(res["message"]);
      }
      final list =
          (res["data"] as List).map((order) => Order.fromJson(order)).toList();
      return list;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<Order>> getOrdersByStatus({String? driverStatus}) async {
    try {
      String url = "order/orders/status";
      if (driverStatus != null) {
        url += "?status=$driverStatus";
      }

      final response = await HttpHelper.get(url);
      List<dynamic> data = response['data'] as List<dynamic>;

      return data.map((item) => Order.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches all orders for a specific customer.
  Future<List<Order>> getOrdersByCustomerID(String customerId) async {
    try {
      final res =
          await HttpHelper.get("order/customer/${customerId.toString()}");
      final list =
          (res["data"] as List).map((order) => Order.fromJson(order)).toList();
      return list;
    } on Exception catch (_) {
      rethrow;
    }
  }

  /// Places a new order.
  Future<ApiResponse<Order>> placeOrder(OrderModel newOrder) async {
    try {
      final res = await HttpHelper.post("order", newOrder.toJson());
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      final result = Order.fromJson(res["data"]);
      print('result: $result');
      Get.back();
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<Order>> updateOrderStatus(
    String? orderId,
    String? driverId,
    Map<String, dynamic>? statusUpdates,
    String? reason,
  ) async {
    try {
      final updatedStatus = {
        ...?statusUpdates,
        "assignedShipperId": driverId,
        "reason": reason,
      };
      print("order/$orderId/status");
      final res = await HttpHelper.patch(
        "order/$orderId/status",
        updatedStatus,
      );

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }

      final result = Order.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<Order>> updateCustAddress(
    String? orderId,
    String? newAddress,
  ) async {
    try {
      final addressUpdate = {
        "newAddress": newAddress,
      };

      print("order/$orderId/address");

      final res = await HttpHelper.put(
        "order/$orderId/address",
        addressUpdate,
      );

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }

      final result = Order.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  /// Deletes an order by its ID.
  Future<ApiResponse<String>> deleteOrder(String orderId) async {
    try {
      final res = await HttpHelper.delete("order/${orderId.toString()}");
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(orderId, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  /// Fetches a specific order by its ID.
  Future<ApiResponse<Order>> getOrderById(String id) async {
    try {
      final res = await HttpHelper.get("order/$id");
      print('RESPONSE:$res');

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }

      final order = Order.fromJson(res["data"]);
      print(order);
      return ApiResponse.completed(order, res["message"]);
    } catch (e) {
      print(e); // Debug unexpected errors
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<List<Order>> getOrdersByDriverId(String driverId) async {
    try {
      final url = "order/driver/$driverId";
      final response = await HttpHelper.get(url);

      if (response["hasError"] == true) {
        throw Exception(response["message"]);
      }

      final list = (response["data"] as List)
          .map((order) => Order.fromJson(order))
          .toList();
      return list;
    } catch (e) {
      print("Error fetching orders by driver ID: $e");
      rethrow;
    }
  }

  Future<ApiResponse<List<Order>>> getOrdersByPartnerStatus(
      String partnerId, String status) async {
    try {
      final res = await HttpHelper.get(
          "order/orders/partner?partnerId=${partnerId.toString()}&status=${status.toString()}");

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }

      final list =
          (res["data"] as List).map((order) => Order.fromJson(order)).toList();

      return ApiResponse.completed(list, res["message"]);
    } catch (e) {
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<Order>> updateRating(String orderId, double custResRating,
      {String? custResRatingComment,
      double? custShipperRating,
      String? custShipperRatingComment}) async {
    try {
      final Map<String, dynamic> payload = {
        "custResRating": custResRating,
        "custResRatingComment": custResRatingComment,
        "custShipperRating": custShipperRating,
        "custShipperRatingComment": custShipperRatingComment,
      };

      final res = await HttpHelper.patch(
        "order/rating/${orderId.toString()}",
        payload,
      );

      print("Update rating response: ${res.toString()}");

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }

      final result = Order.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print("Error in updateRating: $e");
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<OrderStatusChartModel> fetchStatistic() async {
    try {
      final response = await HttpHelper.get("order/admin/statistics");

      var data = response['data'];
      print("Driver income data: $data");

      return OrderStatusChartModel.fromJson(data);
    } on Exception catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
