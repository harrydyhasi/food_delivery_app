import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/driver/driver_repository.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/models/rating_restaurant_model.dart';
import 'package:get/get.dart';

class DriverRatingController extends GetxController {
  static DriverRatingController get instance => Get.find();
  var selectedFilter = 0.obs;
  var value = 0.0.obs;
  var count = 0.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  final _repository = DriverRepository();
  var ratingList = <RatingModel>[].obs;

  Future<void> fetchRating(String id) async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = "No internet connection";
        return;
      }

      final data = await _repository.fetchDriverRating(id);
      
      print("id user$id");
      ratingList.value = data;
      await calculateAverageRating();
      await countComments();
    } catch (e) {
      errorMessage.value = "Error fetching driver details: ${e.toString()}";
    } finally {
      isLoading(false);
    }
  }

  Future<void> calculateAverageRating() async {
    if (ratingList.isNotEmpty) {
      double totalStars =
          ratingList.fold(0, (sum, rating) => sum + rating.custShipperRating);
      value.value = totalStars / ratingList.length;
    } else {
      value.value = 0.0;
    }
  }

  Future<void> countComments() async {
    count.value = ratingList.length;
  }

  List<RatingModel> get filteredRatings {
    if (selectedFilter.value == 0) {
      return ratingList;
    }
    return ratingList
        .where((rating) => rating.custShipperRating == selectedFilter.value)
        .toList();
  }

  void updateFilter(int newFilter) {
    selectedFilter.value = newFilter;
    print("Updated selectedFilter: ${selectedFilter.value}"); // Log giá trị mới
    print(
        "Filtered ratings count: ${filteredRatings.length}"); // Log số lượng đánh giá đã lọc
  }
}
