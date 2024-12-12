import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/images/circle_image.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/views/widgets/map.dart';
import 'package:food_delivery_h2d/features/shippers/home/views/widgets/orders_list.dart';
import 'package:food_delivery_h2d/features/shippers/notification/views/notification_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class ShipperHomeScreen extends StatelessWidget {
  const ShipperHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderController.instance.fetchNewOrders();

    return Scaffold(
      body: Stack(
        children: [
          const MapWidget(),
          Container(
            padding: const EdgeInsets.only(
                left: 20, top: 40, right: 20, bottom: 6.0),
            color: MyColors.darkPrimaryColor,
            height: 100,
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          Colors.grey.shade200, // Fallback background color
                      child: ClipOval(
                        child:
                            LoginController.instance.currentUser.profileUrl !=
                                        "Unknown" &&
                                    LoginController.instance.currentUser
                                        .profileUrl!.isNotEmpty
                                ? Image.network(
                                    LoginController
                                        .instance.currentUser.profileUrl!,
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.person,
                                          size: 40, color: Colors.grey);
                                    },
                                  )
                                : const Icon(Icons.person,
                                    size: 30, color: Colors.grey),
                      ),
                    ),
                    if (LoginController.instance.currentUser.workingStatus)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 22, 230, 36),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      )
                    else
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LoginController.instance.currentUser.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: MyColors.iconColor),
                    ),
                    if (LoginController.instance.currentUser.workingStatus)
                      Text(
                        'Đang hoạt động',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: MyColors.iconColor),
                      )
                    else
                      Text(
                        'Không hoạt động',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: MyColors.iconColor),
                      )
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.to(() => const NotificationScreen());
                        },
                        icon: const Icon(
                          Icons.notifications,
                          size: 24,
                          color: MyColors.iconColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const OrdersList()
        ],
      ),
    );
  }
}
