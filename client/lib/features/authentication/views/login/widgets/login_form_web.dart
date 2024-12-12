import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/widgets/background_login.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/widgets/login_form.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class LoginFormWeb extends StatelessWidget {
  const LoginFormWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackGroundLogin(),
        Positioned(
          top: (MediaQuery.of(context).size.height - 470) / 2,
          right: (MediaQuery.of(context).size.width - 650) / 3,
          child: SizedBox(
            width: 400,
            height: 470,
            child: Card(
              elevation: 4,
              shadowColor: MyColors.darkPrimaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
                    child: Image.asset(
                      MyImagePaths.appRed,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: MySizes.spaceBtwItems,),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: MySizes.xl * 2,
                        right: MySizes.xl * 2,
                        bottom: MySizes.xl),
                    child: LoginForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height - 250) / 2,
          left: (MediaQuery.of(context).size.width - 750) / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
            child: Image.asset(
              MyImagePaths.background,
              width: 400,
              height: 250,
              fit: BoxFit.fill,
            ),
          ),
        ),
        
      ],
    );
  }
}
