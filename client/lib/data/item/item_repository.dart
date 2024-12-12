import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_item_model.dart';
import 'package:food_delivery_h2d/features/customers/search/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/models/rating_restaurant_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class ItemRepository extends GetxController {
  static ItemRepository get instance => Get.find();

  Future<List<Item>> getItemsByCategoryID(String categoryId) async {
    try {
      final res =
          await HttpHelper.get("item/category/${categoryId.toString()}");
      final list = (res["data"] as List)
          .map((category) => Item.fromJson(category))
          .toList();
      return list;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<Item>> getItemsByCategoryIDInCustomer(String categoryId) async {
    try {
      final res = await HttpHelper.get(
          "item/customer/category/${categoryId.toString()}");
      final list = (res["data"] as List)
          .map((category) => Item.fromJson(category))
          .toList();
      return list;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<ApiResponse<Item>> updateItem(
      Item oldItem, List<http.MultipartFile>? files) async {
    try {
      final res = await HttpHelper.putWithFiles(
          "item/${oldItem.itemId.toString()}", oldItem.toJson(), files ?? []);
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      final result = Item.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<void> removeItem(String itemId) async {
    try {
      await HttpHelper.put("item/delete/${itemId.toString()}");
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<ApiResponse<Item>> addItem(
      Item newItem, List<http.MultipartFile> files) async {
    try {
      final res =
          await HttpHelper.postWithFiles("item", newItem.toJson(), files);
      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      final result = Item.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<List<ItemModel>> searchItems(String query) async {
    try {
      final response =
          await HttpHelper.get("item/customer/search?query=$query");

      List<dynamic> data = response['data'] as List<dynamic>;

      return data.map((item) => ItemModel.fromJson(item)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Item>> searchItemInHome(String query) async {
    try {
      final response =
          await HttpHelper.get("item/customer/home?keySearch=$query");

      List<dynamic> data = response['data'] as List<dynamic>;

      return data.map((item) => Item.fromJson(item)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<ApiResponse<Item>> decreaseQuantity(
      String orderId, int quantity) async {
    try {
      final res = await HttpHelper.patch(
          "item/${orderId.toString()}/quantity", {"quantity": quantity});

      print("GIAM SO LUONG ${res.toString()}");

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      final result = Item.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }

  Future<ApiResponse<Item>> increaseSales(String orderId, int quantity) async {
    try {
      final res = await HttpHelper.patch(
          "item/${orderId.toString()}/sales", {"quantity": quantity});

      if (res["hasError"] == true) {
        return ApiResponse.error(res["message"]);
      }
      final result = Item.fromJson(res["data"]);
      return ApiResponse.completed(result, res["message"]);
    } catch (e) {
      print(e);
      return ApiResponse.error("An unknown error occurred.");
    }
  }
  Future<List<RatingModel>> fecthRatingItem(String itemId) async {
    try {
      final response = await HttpHelper.get("item/rating/$itemId");

      List<dynamic> data = response['data'] as List<dynamic>;
      print("rating partner ${data}");
      return data.map((item) => RatingModel.fromJson(item)).toList();
    } on Exception catch (e) {
      print("error $e");
      rethrow;
    }
  }
  Future<List<TopItemModel>> fetchTopItems() async {
    try {
      final response = await HttpHelper.get("item/customer/topItem");

      List<dynamic> data = response['data'] as List<dynamic>;
      print("rating partner $data");
      return data.map((item) => TopItemModel.fromJson(item)).toList();
    } on Exception catch (e) {
      print("error $e");
      rethrow;
    }
  }
}
