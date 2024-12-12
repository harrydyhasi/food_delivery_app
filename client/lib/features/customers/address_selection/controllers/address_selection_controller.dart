import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/address/address_repository.dart';
import 'package:get/get.dart';

class AddressSelectionController extends GetxController {
  static AddressSelectionController get instance => Get.find();

  // Observable lists to hold provinces, districts, and communes
  var provinces = [].obs;
  var districts = [].obs;
  var communes = [].obs;

  var selectedProvinceId = ''.obs;
  var selectedDistrictId = ''.obs;
  var selectedCommuneId = ''.obs;
  var fullAddress = ''.obs;

  TextEditingController detailAddressController = TextEditingController();

  var lenghtDetailAddress = 0.obs;

  final AddressRepository _addressRepository = AddressRepository();

  @override
  void onInit() {
    super.onInit();
    fetchProvinces(); // Fetch provinces on controller initialization
  }

  // Fetch provinces from AddressRepository
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

  // Update selected province ID and clear district and commune selections
  void updateSelectedProvinceId(String provinceId) {
    selectedProvinceId.value = provinceId;
    selectedDistrictId.value = '';
    selectedCommuneId.value = '';
    fetchDistricts(provinceId); // Fetch districts based on selected province
    updateFullAddress(); // Update the full address after province selection
  }

  // Update selected district ID and clear commune selection
  void updateSelectedDistrictId(String districtId) {
    selectedDistrictId.value = districtId;
    selectedCommuneId.value = '';
    fetchCommunes(districtId); // Fetch communes based on selected district
    updateFullAddress(); // Update the full address after district selection
  }

  // Update selected commune ID
  void updateSelectedCommuneId(String communeId) {
    selectedCommuneId.value = communeId;
    updateFullAddress(); // Update the full address after commune selection
  }

  // Handle detail address input change and update its length
  void handleDetailAddressChange(String value) {
    lenghtDetailAddress.value = value.length;
    print(lenghtDetailAddress.value);
    updateFullAddress(); // Update full address on detail address change
  }

  @override
  void onClose() {
    detailAddressController.dispose();
    super.onClose();
  }

  // Update the full address whenever components change
  void updateFullAddress() {
    // Ensure all components are selected
    if (selectedProvinceId.value.isEmpty ||
        selectedDistrictId.value.isEmpty ||
        selectedCommuneId.value.isEmpty) {
      fullAddress.value = ''; // Set to empty if any part is missing
      return;
    }

    String provinceName = provinces
            .firstWhere(
              (province) => province.id == selectedProvinceId.value,
              orElse: () => null,
            )
            ?.fullName ??
        '';

    String districtName = districts
            .firstWhere(
              (district) => district.id == selectedDistrictId.value,
              orElse: () => null,
            )
            ?.fullName ??
        '';

    String communeName = communes
            .firstWhere(
              (commune) => commune.id == selectedCommuneId.value,
              orElse: () => null,
            )
            ?.fullName ??
        '';

    // Combine all components to form the full address
    fullAddress.value =
        '${detailAddressController.text}, $communeName, $districtName, $provinceName';
    print(fullAddress.value);
  }
}
