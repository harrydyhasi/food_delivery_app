import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/appbar.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class CustomerAppbar extends StatelessWidget {
  const CustomerAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MyAppBar(
      padding: const EdgeInsets.only(left: MySizes.xs),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: MySizes.lg-2),
            child: Text(
              "Giao đến:",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: MySizes.xs,
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: MySizes.iconMs,
                ),
                const SizedBox(
                  width: MySizes.xs,
                ),
                SizedBox(
                  width: 280,
                  child: Text(
                    "Võ Văn Ngân, Linh Chiểu, TP Thủ Đức, TP Hồ Chí Minh",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: Colors.white),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: MySizes.iconXs,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
