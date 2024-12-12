import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/cart_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/restaurant_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_detail/menu_restaurant_detail.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class MenuRestaurantTile extends StatelessWidget {
  final Item item;

  const MenuRestaurantTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    final restaurantController = Get.put(RestaurantController());

    return InkWell(
      onTap: () {
        Get.to(MenuRestaurantDetail(item: item));
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: MySizes.sm, right: MySizes.sm, top: MySizes.sm),
        child: SizedBox(
          height: 135,
          child: Card(
            elevation: 4,
            shadowColor: MyColors.darkPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: MySizes.sm,
                  left: MySizes.md,
                  bottom: MySizes.sm,
                  right: MySizes.sm),
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius:
                          BorderRadius.circular(MySizes.borderRadiusMd),
                      child: CachedNetworkImage(
                        imageUrl: item.itemImage,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )),
                  const SizedBox(
                    width: MySizes.spaceBtwItems,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.itemName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(color: MyColors.primaryTextColor),
                        ),
                        const SizedBox(
                          height: MySizes.xs,
                        ),
                        Text(
                          item.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .apply(color: MyColors.secondaryTextColor),
                        ),
                        const SizedBox(
                          height: MySizes.xs,
                        ),
                        Row(
                          children: [
                            Text(
                              "Còn lại: ${item.quantity.toString()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .apply(color: MyColors.primaryTextColor),
                            ),
                            const SizedBox(
                              width: MySizes.sm,
                            ),
                            Container(
                                color: MyColors.dividerColor,
                                width: 0.8,
                                height: 15),
                            const SizedBox(
                              width: MySizes.sm,
                            ),
                            Text(
                              "Đã bán: ${item.sales.toString()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .apply(color: MyColors.primaryTextColor),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              MyFormatter.formatCurrency(item.price),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .apply(color: MyColors.darkPrimaryTextColor),
                            ),
                            Obx(() {
                              var quantity = cartController
                                      .itemQuantities[item.itemName] ??
                                  0;
                              if (item.quantity == 0) {
                                return Text(
                                  "Đã hết món",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .apply(color: MyColors.primaryColor),
                                );
                              }
                              if (quantity > 0) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        cartController.removeFromCart(item);
                                      },
                                      icon: const Icon(
                                          Icons.remove_circle_outline_rounded,
                                          color: MyColors.darkPrimaryTextColor),
                                    ),
                                    Text(quantity.toString()),
                                    IconButton(
                                      onPressed: () {
                                        if (quantity < item.quantity) {
                                          cartController.addToCart(item);
                                        }
                                      },
                                      icon: const Icon(Icons.add_circle,
                                          color: MyColors.darkPrimaryTextColor),
                                    ),
                                  ],
                                );
                              }
                              if (restaurantController
                                      .detailPartner.value?.status ==
                                  false) {
                                return const Icon(
                                  Icons.add_box,
                                  color: MyColors.secondaryTextColor,
                                );
                              } else {
                                return InkWell(
                                  onTap: () {
                                    if (quantity < item.quantity) {
                                      cartController.addToCart(item);
                                    }
                                  },
                                  child: const Icon(
                                    Icons.add_box,
                                    color: MyColors.darkPrimaryTextColor,
                                  ),
                                );
                              }
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
