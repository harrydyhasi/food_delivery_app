import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/text_field/my_text_filed.dart';
import 'package:food_delivery_h2d/features/restaurants/profile/controllers/update_profile_restaurant_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/profile/views/widgets/profile_header.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class ProfileRestaurantDetailScreen extends StatelessWidget {
  ProfileRestaurantDetailScreen({super.key});
  final updateProfileRestaurantController =
      Get.put(UpdateProfileRestaurantController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: const Text("Chỉnh sửa thông tin"),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.done,
                  size: MySizes.iconMd,
                ),
                onPressed: () {}),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const ProfileHeader(showEdit: true,),
              const SizedBox(
                height: MySizes.spaceBtwSections,
              ),
              Padding(
                padding: const EdgeInsets.all(MySizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ngày tham gia",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                        SizedBox(
                          width: 200,
                          child: MyTextFiled(
                            textController: updateProfileRestaurantController
                                .joinDateController,
                            label: "Ngày tham gia",
                            readOnly: true,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tên quán ăn",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                        SizedBox(
                          width: 200,
                          child: MyTextFiled(
                            textController: updateProfileRestaurantController
                                .nameController,
                            label: "Tên quán ăn",
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số điện thoại",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                        SizedBox(
                          width: 200,
                          child: MyTextFiled(
                            textController: updateProfileRestaurantController
                                .joinDateController,
                            label: "Số điện thoại",
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .apply(color: MyColors.darkPrimaryTextColor),
                        ),
                        SizedBox(
                          width: 200,
                          child: MyTextFiled(
                            textController: updateProfileRestaurantController
                                .joinDateController,
                            label: "Email",
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: MySizes.spaceBtwItems),
                    Text(
                      "Địa chỉ",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    const SizedBox(height: MySizes.spaceBtwItems),
                    MyTextFiled(
                      textController:
                          updateProfileRestaurantController.joinDateController,
                      textAlign: TextAlign.left,
                      label: "Địa chỉ",
                      maxLines: 2,
                    ),
                    Text(
                      "Mô tả",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.darkPrimaryTextColor),
                    ),
                    const SizedBox(height: MySizes.spaceBtwItems),
                    MyTextFiled(
                      textController:
                          updateProfileRestaurantController.joinDateController,
                      textAlign: TextAlign.left,
                      label: "Mô tả",
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
