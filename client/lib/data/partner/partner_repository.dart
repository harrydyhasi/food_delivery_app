import 'package:food_delivery_h2d/features/authentication/models/PartnerModel.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/detail_partner_model.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/top_restaurant_model.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/models/rating_restaurant_model.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/models/statistic_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class PartnerRepository extends GetxController {
  static PartnerRepository get instance => Get.find();

  static const String _driverApi = "partner";

  Future<PartnerModel> getCurrentPartner(String userId) async {
    try {
      final res = await HttpHelper.get("$_driverApi/${userId.toString()}");
      return PartnerModel.fromJson(res["data"]);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<DetailPartnerModel> getPartnerByPartnerId(String partnerId) async {
    try {
      final response = await HttpHelper.get("partner/customer/$partnerId");
      return DetailPartnerModel.fromJson(response);
    } on Exception catch (e) {
      print("Error fetching partner by ID: $e");
      rethrow;
    }
  }

  Future<void> updatePartnerStatus(String userId, bool status) async {
    try {
      final data = {
        'status': status,
      };
      print('REPO STATUS: $data');

      final res = await HttpHelper.put("partner/updateStatus/$userId", data);

      print("Response from API: $res");

      if (res["hasError"] == false && res["statusCode"] == 200) {
        print("Partner status updated successfully.");
      } else {
        throw Exception("Failed to update partner status: ${res["message"]}");
      }
    } catch (error) {
      print("Error in updatePartnerStatus: $error");
      rethrow;
    }
  }

  Future<List<RatingModel>> fetchPartnerRating(String partnerId) async {
    try {
      final response = await HttpHelper.get("partner/rating/$partnerId");

      List<dynamic> data = response['data'] as List<dynamic>;
      print("rating partner $data");
      return data.map((item) => RatingModel.fromJson(item)).toList();
    } on Exception catch (e) {
      print("error $e");
      rethrow;
    }
  }

  Future<List<TopRestaurantModel>> fetchTopRestaurant() async {
    try {
      final response = await HttpHelper.get("order/restaurants/high-rated");

      List<dynamic> data = response['data'] as List<dynamic>;
      print("rating partner $data");
      return data.map((item) => TopRestaurantModel.fromJson(item)).toList();
    } on Exception catch (e) {
      print("error $e");
      rethrow;
    }
  }

  Future<List<StatisticModel>> fetchStatistic(String partnerId,
      {String? dateFrom, String? dateTo}) async {
    try {
      String url = "partner/statistic/$partnerId";
      if (dateFrom != null && dateTo != null) {
        url += "?query_dateFrom=$dateFrom&query_dateTo=$dateTo";
      }
      print("urrl $url");
      final response = await HttpHelper.get(url);

      List<dynamic> data = response['data'] as List<dynamic>;
      print("rating partner $data");

      return data
          .map<StatisticModel>((json) => StatisticModel.fromJson(json))
          .toList();
    } on Exception catch (e) {
      print("error $e");
      rethrow;
    }
  }
}
