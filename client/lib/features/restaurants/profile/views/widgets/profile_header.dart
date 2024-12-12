import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/header/image_header.dart';
import 'package:food_delivery_h2d/common/widgets/images/circle_image.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.showEdit = false});
  final bool showEdit;

  @override
  Widget build(BuildContext context) {
    const double heightImageHeader = 180.0;
    const top = heightImageHeader - 40.0;
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ImageHeader(
                  imageUrl: LoginController.instance.currentUser.storeFront,
                  height: heightImageHeader)),
          if (showEdit)
            Positioned(
              top: heightImageHeader - 30,
              right: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.rectangle,
                  ),
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Sửa ảnh",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ),
          Positioned(
              top: top,
              child: Stack(
                children: [
                  CircleImage(
                    imageUrl: LoginController.instance.currentUser.avatarUrl,
                  ),
                  if (showEdit)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: MyColors.darkPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              )),
        ]);
  }
}
