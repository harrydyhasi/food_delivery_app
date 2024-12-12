import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/address/address_repository.dart';
import 'package:food_delivery_h2d/data/authentication/auth_repository.dart';
import 'package:food_delivery_h2d/features/authentication/models/PartnerModel.dart';
import 'package:food_delivery_h2d/features/authentication/views/register/OTP_verification_screen.dart';
import 'package:food_delivery_h2d/utils/constants/enums.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/helpers/multiple_part_file.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;

import 'package:http/http.dart' as http;

class PartnerRegisterController extends GetxController {
  static PartnerRegisterController get instance => Get.find();

  // Repository
  final _addressRepository = Get.put(AddressRepository());

  // TextEdit Controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumbController = TextEditingController();
  final passwordController = TextEditingController();
  final detailAddressController = TextEditingController();
  final descriptionController = TextEditingController();

  // Address
  var provinces = [].obs;
  var districts = [].obs;
  var communes = [].obs;

  var selectedProvinceId = "".obs;
  var selectedDistrictId = "".obs;
  var selectedCommuneId = "".obs;

  var lenghtDetailAddress = RxInt(0);

  // Images
  var CCCDFrontUrlImage = Rx<File?>(null);
  var CCCDBackUrlImage = Rx<File?>(null);
  var avatarUrlImage = Rx<File?>(null);
  var storeFrontUrlImage = Rx<File?>(null);

  //Loading
  final isLoading = false.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    try {
      isLoading.value = true;
      await fetchProvinces();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    phoneNumbController.dispose();
    passwordController.dispose();
    detailAddressController.dispose();
    provinces.clear();
    districts.clear();
    communes.clear();

    // Get.delete<PartnerRegisterController>();

    super.onClose();
  }

  void updateSelectedProvinceId(String value) {
    selectedProvinceId.value = value;
    fetchDistricts(value);
    selectedDistrictId.value = "";
    selectedCommuneId.value = "";
  }

  void updateSelectedDistrictId(String value) {
    selectedDistrictId.value = value;
    fetchCommunes(value);
    selectedCommuneId.value = "";
  }

  void updateSelectedCommuneId(String value) {
    selectedCommuneId.value = value;
  }

  void handleDetailAddressChange(String value) {
    lenghtDetailAddress.value = value.length;
  }

  Future<void> fetchProvinces() async {
    try {
      provinces.assignAll(await _addressRepository.getProvinces());
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchDistricts(String idProvince) async {
    try {
      districts.assignAll(await _addressRepository.getDistrict(idProvince));
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchCommunes(String idDistrict) async {
    try {
      communes.assignAll(await _addressRepository.getCommunes(idDistrict));
    } catch (e) {
      print(e);
    }
  }

  Future pickImage(Rx<File?> imageFile) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      imageFile.value = File(pickedImage.path);
      var extension = path.extension(CCCDFrontUrlImage.value!.path);
      print(extension);

      print(imageFile.value!.path);
      // print(imageFile.value!.path);
    } else {
      print("No image");
    }
  }

  Future register() async {
    final newPartner = getPartnerFromForm();
    try {
      FullScreenLoader.openDialog("Đang xử lý", MyImagePaths.spoonAnimation);

      List<http.MultipartFile> files = [];

      var fields = [
        {'fieldName': 'avatarUrl', 'file': avatarUrlImage.value},
        {'fieldName': 'storeFront', 'file': storeFrontUrlImage.value},
        {'fieldName': 'CCCDFrontUrl', 'file': CCCDFrontUrlImage.value},
        {'fieldName': 'CCCDBackUrl', 'file': CCCDBackUrlImage.value},
      ];

      files = await MultiplePartFileHelper.createMultipleFiles(fields);

      // Print details of the files
      for (var file in files) {
        print('File Field Name: ${file.field}');
        print('File Path: ${file.filename}');
        print('File Size: ${file.length} bytes');
      }

      // await AuthRepository.instance.registerDriver(newDriver);
      await AuthRepository.instance.registerPartner(newPartner, files);

      // registeredUser.printInfo();
      Loaders.successSnackBar(title: "Đăng ký thành công!");
    } catch (error) {
      Loaders.errorSnackBar(title: "Lỗi!", message: error.toString());
    } finally {
      FullScreenLoader.stopLoading();
      Get.to(() => OtpVerificationScreen(
            emailAddress: emailController.text,
            role: UserRole.partner.name.toString(),
          ));
    }
  }

  PartnerModel getPartnerFromForm() {
    return PartnerModel(
        provinceId: selectedProvinceId.value,
        districtId: selectedDistrictId.value,
        communeId: selectedCommuneId.value,
        detailAddress: detailAddressController.text,
        userId: '',
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        status: false,
        role: UserRole.partner.name,
        phone: phoneNumbController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        partnerId: '',
        description: descriptionController.text,
        avatarUrl: '',
        storeFront: '',
        CCCDFrontUrl: '',
        CCCDBackUrl: '');
  }
}
