import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/header/wave_header.dart';
import 'package:food_delivery_h2d/common/widgets/item/item_menu.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/home/widgets/restaurant_home_appbar.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/menu_list/menu_food_list_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/order_management/views/order_list/order_list_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/statistic_management/views/statistic_screen.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';

class RestaurantHomeScreen extends StatelessWidget {
  const RestaurantHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 300,
              child: WaveHeader(
                  child: Column(
                children: [
                  RestaurantHomeAppbar(),
                ],
              )),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: MySizes.spaceBtwItems),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: MySizes.spaceBtwItems,
                  mainAxisSpacing: MySizes.spaceBtwItems,
                  children: [
                    ItemMenu(
                        image: MyImagePaths.iconOrder,
                        title: "Đơn hàng",
                        onTap: () {
                          Get.to(const OrderListScreen());
                        }),
                    ItemMenu(
                      title: "Thực đơn",
                      image: MyImagePaths.iconMenu,
                      onTap: () {
                        Get.to(const MenuFoodListScreen());
                      },
                    ),
                    ItemMenu(
                        image: MyImagePaths.iconStatistic,
                        title: "Thống kê",
                        onTap: () {
                          Get.to(const StatisticScreen());
                        }),
                    ItemMenu(
                        image: MyImagePaths.iconLogout,
                        title: "Đăng xuất",
                        onTap: () {
                          LoginController.instance.logout();
                        }),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
