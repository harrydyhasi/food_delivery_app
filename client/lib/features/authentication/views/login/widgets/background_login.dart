import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class BackGroundLogin extends StatefulWidget {
  const BackGroundLogin({super.key});

  @override
  _BackGroundLoginState createState() => _BackGroundLoginState();
}

class _BackGroundLoginState extends State<BackGroundLogin>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.greyWhite,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // child: AnimatedBackground(
      //   behaviour: RandomParticleBehaviour(
      //     options: ParticleOptions(
      //       image: Image.asset(
      //         MyImagePaths.square,
      //       ),
      //       particleCount: 15,
      //       spawnMaxRadius: 70,
      //       spawnMinRadius: 40,
      //       spawnMaxSpeed: 20,
      //       spawnMinSpeed: 10,
      //     ),
      //   ),
      //   vsync: this,
      //   child: Container(),
      // ),
      child: Stack(
        children: [
          Positioned(
            top: (MediaQuery.of(context).size.height - 120),
            right: (MediaQuery.of(context).size.width - 120),
            child: Image.asset(
              MyImagePaths.square,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height - 150),
            left: (MediaQuery.of(context).size.width - 150),
            child: Image.asset(
              MyImagePaths.square,
              width: 160,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height - 180),
            left: (MediaQuery.of(context).size.width - 180),
            child: Image.asset(
              MyImagePaths.square,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height - 870) / 2,
            right: (MediaQuery.of(context).size.width) / 3,
            child: Image.asset(
              MyImagePaths.square,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height - 870) / 2,
            left: (MediaQuery.of(context).size.width - 100),
            child: Image.asset(
              MyImagePaths.square,
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height - 230),
            right: (MediaQuery.of(context).size.width - 230),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
              child: Image.asset(
                MyImagePaths.square,
                width: 300,
                height: 280,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
