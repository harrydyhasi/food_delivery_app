import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/widgets/changePassword.dart';
import 'package:food_delivery_h2d/features/customers/profile/views/widgets/profile_customer_header.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class ProfileCustomerScreen extends StatelessWidget {
  const ProfileCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final profileRestaurantController = Get.put(ProfileRestaurantController());
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("Hồ sơ của tôi"),
        showBackArrow: false,
        actions: [
          ChangingPassword(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileCustomerHeader(),
            const SizedBox(
              height: MySizes.spaceBtwSections,
            ),
            Padding(
              padding: const EdgeInsets.all(MySizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: MySizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Họ tên",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(color: MyColors.darkPrimaryTextColor),
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(
                          LoginController.instance.currentUser.name,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: MyColors.primaryTextColor,
                                    height: 2,
                                  ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: MySizes.spaceBtwItems),
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
                        child: Text(
                          LoginController.instance.currentUser.phone,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: MyColors.primaryTextColor,
                                    height: 2,
                                  ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: MySizes.spaceBtwItems),
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
                        child: Text(
                          LoginController.instance.currentUser.email,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: MyColors.primaryTextColor,
                                    height: 2,
                                  ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //Get.to(ProfileRestaurantDetailScreen());
                      },
                      child: const Text("Chỉnh sửa thông tin"),
                    ),
                  ),
                  const SizedBox(
                    height: MySizes.spaceBtwItems,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        LoginController.instance.logout();
                      },
                      child: const Text("Đăng xuất"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
