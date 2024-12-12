import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/appbar.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/notification_icon.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class RestaurantHomeAppbar extends StatelessWidget {
  const RestaurantHomeAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print(
        'TRANG THAI HD: +${LoginController.instance.currentUser!.workingStatus}');
    return MyAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LoginController.instance.currentUser!.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: Colors.white),
          ),
          const SizedBox(
            height: MySizes.xs,
          ),
          Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: MySizes.xs),
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: LoginController.instance.currentUser!.workingStatus
                          ? MyColors.openColor
                          : MyColors.greyWhite)),
              Text(
                LoginController.instance.currentUser!.workingStatus
                    ? "Đang mở cửa"
                    : "Đã đóng cửa",
                style: LoginController.instance.currentUser!.workingStatus
                    ? Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .apply(color: MyColors.openColor)
                    : Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .apply(color: MyColors.greyWhite),
              ),
            ],
          ),
        ],
      ),
      actions: [
        MyNotificationIcon(
          onPressed: () {},
        ),
      ],
    );
  }
}
