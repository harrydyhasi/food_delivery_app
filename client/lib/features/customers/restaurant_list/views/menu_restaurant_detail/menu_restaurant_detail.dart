import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/confirm_order/views/confirm_order_screen.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/cart_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/rating_item_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/controllers/restaurant_controller.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/views/menu_restaurant_list/widgets/detail_cart.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/rating_management/views/rating_list/widgets/rating_tile.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class MenuRestaurantDetail extends StatelessWidget {
  final Item item;

  const MenuRestaurantDetail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    //final partner = Get.arguments as DetailPartnerModel?;
    final cartController = Get.put(CartController());
    final restaurantController = Get.put(RestaurantController());
    final ratingItemController = Get.put(RatingItemController());
    ratingItemController.fetchRating(item.itemId);
    print("iteemmm${item.itemId}");
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("Chi tiết món ăn"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: item.itemImage,
              width: MediaQuery.of(context).size.width,
              height: 170,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(MySizes.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: const TextStyle(
                          color: MyColors.primaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: MySizes.sm),
                      Text(
                        item.description,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .apply(color: MyColors.secondaryTextColor),
                      ),
                      const SizedBox(height: MySizes.sm),
                      Row(
                        children: [
                          Text(
                            "Còn lại: ${item.quantity.toString()}",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .apply(color: MyColors.secondaryTextColor),
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
                                .labelMedium!
                                .apply(color: MyColors.secondaryTextColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: MySizes.sm),
                      Padding(
                        padding: const EdgeInsets.only(right: MySizes.sm),
                        child: Row(
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
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: MySizes.sm,
                            left: MySizes.md,
                            right: MySizes.md),
                        child: Divider(color: MyColors.dividerColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Obx(() {
              if (ratingItemController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (ratingItemController.ratingList.isEmpty) {
                return const Center(child: Text("Không có đánh giá nào"));
              }
              final ratings = ratingItemController.ratingList;
              if (ratings.isEmpty) {
                return const Center(child: Text("Không có đánh giá nào"));
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: ratings.length,
                itemBuilder: (context, index) {
                  return RatingTile(rating: ratings[index]);
                },
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (cartController.totalItems == 0) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () {
            Get.bottomSheet(DetailCart());
          },
          child: Container(
            padding: const EdgeInsets.all(MySizes.md),
            decoration: BoxDecoration(
              color: MyColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 40,
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        size: 26,
                      ),
                      Positioned(
                        top: 0,
                        left: 16,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: MyColors.darkPrimaryTextColor,
                          child: Text(
                            cartController.totalItems.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .apply(color: MyColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  MyFormatter.formatCurrency(cartController.totalPrice),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: MyColors.darkPrimaryTextColor),
                ),
                const SizedBox(
                  width: MySizes.md,
                ),
                InkWell(
                  onTap: () {
                    Get.to(ConfirmOrderScreen());
                  },
                  child: Text(
                    "Đặt hàng",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(
                          color: MyColors.darkPrimaryTextColor,
                          fontWeightDelta: 2,
                        )
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
