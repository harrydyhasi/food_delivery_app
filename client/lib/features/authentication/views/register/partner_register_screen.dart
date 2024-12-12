
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_h2d/common/widgets/images/image_picker.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/keyboard_hider.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/partner_register_controller.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/partner_tab_controller.dart';
import 'package:food_delivery_h2d/features/authentication/views/register/widgets/user_register_form.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/tabbar.dart';

class PartnerRegisterScreen extends StatelessWidget {
  PartnerRegisterScreen({super.key});

  final PartnerRegisterController _partnerRegisterController =
      Get.put(PartnerRegisterController());

  final PartnerTabController _tabController = Get.put(PartnerTabController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: KeyboardHider(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: MyColors.primaryTextColor,
                  size: MySizes.iconMd,
                )),
            title: Text(
              "Đăng ký đối tác",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            bottom: MyTabbar(
                controller: _tabController.controller,
                tabs: _tabController.myTabs),
          ),
          body: Obx(
            () => (_partnerRegisterController.isLoading.value)
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(controller: _tabController.controller, children: [
                    // Thông tin cơ bản
                    Padding(
                        padding: const EdgeInsets.all(MySizes.defaultSpace),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              UserRegisterForm(
                                  emailController: _partnerRegisterController
                                      .emailController,
                                  nameController:
                                      _partnerRegisterController.nameController,
                                  phoneNumbController:
                                      _partnerRegisterController
                                          .phoneNumbController,
                                  passwordController: _partnerRegisterController
                                      .passwordController),
                              const SizedBox(
                                height: MySizes.spaceBtwInputFields,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "CCCD (mặt trước)",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(
                                        height: MySizes.spaceBtwInputFields,
                                      ),
                                      DottedBorderImagePicker(
                                        imageFile: _partnerRegisterController
                                            .CCCDFrontUrlImage.value,
                                        onTap: () => _partnerRegisterController
                                            .pickImage(
                                                _partnerRegisterController
                                                    .CCCDFrontUrlImage),
                                      ),
                                      const SizedBox(
                                        height: MySizes.spaceBtwItems,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "CCCD (mặt sau)",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(
                                        height: MySizes.spaceBtwInputFields,
                                      ),
                                      DottedBorderImagePicker(
                                        imageFile: _partnerRegisterController
                                            .CCCDBackUrlImage.value,
                                        onTap: () => _partnerRegisterController
                                            .pickImage(
                                                _partnerRegisterController
                                                    .CCCDBackUrlImage),
                                      ),
                                      const SizedBox(
                                        height: MySizes.spaceBtwItems,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    _tabController.next();
                                  },
                                  child: const Text("Tiếp tục"))
                            ],
                          ),
                        )),
                    // Thông tin hoạt động
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(MySizes.defaultSpace),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    labelText: "Tỉnh/Thành phố"),
                                value: _partnerRegisterController
                                        .selectedProvinceId.value.isNotEmpty
                                    ? _partnerRegisterController
                                        .selectedProvinceId.value
                                    : null,
                                items: _partnerRegisterController.provinces
                                    .map((province) {
                                  return DropdownMenuItem<String>(
                                      value: province.id,
                                      child: Text(province.fullName));
                                }).toList(),
                                onChanged: (value) {
                                  _partnerRegisterController
                                      .updateSelectedProvinceId(
                                          value.toString());
                                }),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            Obx(
                              () => DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                      labelText: "Quận/Huyện"),
                                  value: _partnerRegisterController
                                          .selectedDistrictId.value.isNotEmpty
                                      ? _partnerRegisterController
                                          .selectedDistrictId.value
                                      : null,
                                  items: _partnerRegisterController.districts
                                      .map((district) {
                                    return DropdownMenuItem<String>(
                                        value: district.id,
                                        child: Text(district.fullName));
                                  }).toList(),
                                  onChanged: (value) {
                                    _partnerRegisterController
                                        .updateSelectedDistrictId(
                                            value.toString());
                                  }),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            Obx(
                              () => DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                      labelText: "Phường/Xã"),
                                  value: _partnerRegisterController
                                          .selectedCommuneId.value.isNotEmpty
                                      ? _partnerRegisterController
                                          .selectedCommuneId.value
                                      : null,
                                  items: _partnerRegisterController.communes
                                      .map((commune) {
                                    return DropdownMenuItem<String>(
                                        value: commune.id,
                                        child: Text(commune.fullName));
                                  }).toList(),
                                  onChanged: (value) {
                                    _partnerRegisterController
                                        .updateSelectedCommuneId(
                                            value.toString());
                                  }),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            Obx(
                              () => TextFormField(
                                controller: _partnerRegisterController
                                    .detailAddressController,
                                decoration: InputDecoration(
                                    labelText: "Địa chỉ",
                                    suffixText:
                                        "${_partnerRegisterController.lenghtDetailAddress}/255"),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(255),
                                ],
                                onChanged: (value) {
                                  _partnerRegisterController
                                      .handleDetailAddressChange(value);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  _tabController.next();
                                },
                                child: const Text("Tiếp tục"))
                          ],
                        ),
                      ),
                    ),
                    // Ảnh và Danh mục món
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(MySizes.defaultSpace),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ảnh đại diện quán",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            DottedBorderImagePicker(
                              imageFile: _partnerRegisterController
                                  .avatarUrlImage.value,
                              onTap: () => _partnerRegisterController.pickImage(
                                  _partnerRegisterController.avatarUrlImage),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwItems,
                            ),
                            Text(
                              "Ảnh mặt tiền",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            DottedBorderImagePicker(
                              imageFile: _partnerRegisterController
                                  .storeFrontUrlImage.value,
                              onTap: () => _partnerRegisterController.pickImage(
                                  _partnerRegisterController
                                      .storeFrontUrlImage),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwItems,
                            ),
                            TextFormField(
                              controller: _partnerRegisterController
                                  .descriptionController,
                              decoration: const InputDecoration(
                                  hintText: "Nhập mô tả quán"),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwSections,
                            ),
                            ElevatedButton(
                                onPressed: _partnerRegisterController.register
                                ,
                                child: const Text("Đăng ký"))
                          ],
                        ),
                      ),
                    )
                  ]),
          ),
        ),
      ),
    );
  }
}
