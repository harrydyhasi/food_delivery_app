import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdateProfileRestaurantController extends GetxController {
  static UpdateProfileRestaurantController get instance => Get.find();
  TextEditingController joinDateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
}
