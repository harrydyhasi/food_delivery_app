import 'package:food_delivery_h2d/features/admin/user_management/models/driver_model.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/partner_model.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/user_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final response = await HttpHelper.get("user");
      List<dynamic> data = response['data'] as List<dynamic>;
      return data.map((item) => UserModel.fromJson(item)).toList();
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<UserModel>> fetchUserByRole({String? role}) async {
    try {
      String url = "user/approve";
      if (role != null) {
        url += "?role=$role";
      }

      final response = await HttpHelper.get(url);
      List<dynamic> data = response['data'] as List<dynamic>;

      return data.map((item) => UserModel.fromJson(item)).toList();
    } on Exception catch (e) {
      print("Error fetching users by role: $e");
      rethrow;
    }
  }

  Future<DriverModel> fetchDriverById(String driverId) async {
    try {
      final response = await HttpHelper.get("driver/$driverId");
      return DriverModel.fromJson(response);
    } on Exception catch (e) {
      print("Error fetching driver by ID: $e");
      rethrow;
    }
  }

  Future<PartnerModel> fetchPartnerById(String partnerId) async {
    try {
      final response = await HttpHelper.get("partner/$partnerId");
      print(response);
      return PartnerModel.fromJson(response);
    } on Exception catch (e) {
      print("Error fetching partner by ID: $e");
      rethrow;
    }
  }

  Future<bool> approveUser(String userId) async {
    try {
      final response = await HttpHelper.put(
        "user/approve/$userId",
      );

      if (response['statusCode'] == 200) {
        return true;
      } else {
        print("Failed to approve user: ${response['message']}");
        return false;
      }
    } on Exception catch (e) {
      print("Error approving user: $e");
      rethrow;
    }
  }

  Future<UserModel> updateUser(
      String userId, Map<String, dynamic> updateData) async {
    try {
      final response = await HttpHelper.put("user/$userId", updateData);
      print(response);

      return UserModel.fromJson(response['data']);
    } on Exception catch (e) {
      print("Error updating user: $e");
      rethrow;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      final response = await HttpHelper.put(
        "user/delete/$userId",
      );

      if (response['statusCode'] == 200) {
        return true;
      } else {
        print("Failed to approve user: ${response['message']}");
        return false;
      }
    } on Exception catch (e) {
      print("Error approving user: $e");
      rethrow;
    }
  }

  Future<void> deleteApprove(String id) async {
    try {
      await HttpHelper.delete("user/$id");
    } on Exception catch (_) {
      rethrow;
    }
  }
}
