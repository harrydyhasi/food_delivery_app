import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/home/customer_home_screen.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/order_list_screen.dart';
import 'package:food_delivery_h2d/features/customers/profile/views/profile_customer_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/notification_restaurant/views/notification_restaurant_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomerNavigationMenu extends StatelessWidget {
  const CustomerNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Container(
        color: MyColors.darkPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: GNav(
            backgroundColor: MyColors.darkPrimaryColor,
            activeColor: Colors.white,
            tabBackgroundColor: MyColors.lightPrimaryColor,
            rippleColor: Colors.white,
            hoverColor: Colors.white,
            gap: 8,
            padding: const EdgeInsets.all(MySizes.defaultSpace / 2),
            tabs: const [
              GButton(
                icon: Icons.home_outlined,
                iconColor: Colors.white,
                text: 'Trang chủ',
              ),
              GButton(
                icon: Icons.inventory_outlined,
                //icon: Icons.feed_outlined,
                text: 'Đơn hàng',
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.notifications_outlined,
                iconColor: Colors.white,
                text: 'Thông báo',
              ),
              GButton(
                icon: Icons.person_outlined,
                text: 'Tài khoản',
                iconColor: Colors.white,
              ),
            ],
            onTabChange: (index) {
              controller.selectedIndex.value = index;
            },
          ),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const CustomerHomeScreen(),
    const CustomerOrderListScreen(),
    const NotificationRestaurantScreen(),
    const ProfileCustomerScreen()
  ];
}
