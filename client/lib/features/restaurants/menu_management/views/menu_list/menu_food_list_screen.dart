import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/controllers/update_menu_food_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/category_model.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/arrange_category/arrange_category_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/category_list/category_list_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/menu_food_detail/menu_food_detail.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/menu_list/widgets/menu_food_tile.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/menu_list/widgets/menu_search_bar.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/controllers/menu_food_controller.dart';

class MenuFoodListScreen extends StatelessWidget {
  const MenuFoodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuFoodController = Get.put(MenuFoodController());
    final updateMenuFoodController = Get.put(UpdateMenuFoodController());

    Future<void> reloadPage() async {
      menuFoodController.reload();
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Thực đơn'),
      ),
      body: Column(
        children: [
          const MenuSearchBar(),
          const Padding(
            padding: EdgeInsets.only(
                top: MySizes.sm, left: MySizes.sm, right: MySizes.sm),
            child: Divider(
              color: MyColors.dividerColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: MySizes.md - 2),
                child: PopupMenuButton(
                    child: const Text("Danh mục món ăn",
                        style: TextStyle(
                          color: MyColors.darkPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        )),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Get.to(const ArrangeCategoryScreen());
                                },
                                child: const Text("Sắp xếp vị trí danh mục")),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Get.to(const CategoryListScreen());
                                },
                                child: const Text("Chỉnh sửa danh mục")),
                          )
                        ]),
              ),
              TextButton(
                  onPressed: () {
                    updateMenuFoodController.isAdd.value = true;
                    updateMenuFoodController.isEditting.value = false;
                    Get.to(MenuFoodDetailScreen(
                      selectedItem: Item(),
                    ));
                  },
                  child: const Text("Thêm món mới")),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: MySizes.sm, right: MySizes.sm),
            child: Divider(
              color: MyColors.dividerColor,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await reloadPage();
              },
              child: Obx(
                () => menuFoodController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: menuFoodController.allCategories.length,
                        itemBuilder: (context, index) {
                          Category category =
                              menuFoodController.allCategories[index];
                          List<Item> categoryItems = menuFoodController
                              .getItemsForCategory(category.categoryId);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: MySizes.sm, left: MySizes.md),
                                child: Text(category.categoryName,
                                    style: const TextStyle(
                                      color: MyColors.darkPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )),
                              ),
                              Column(
                                children: List.generate(categoryItems.length,
                                    (itemIndex) {
                                  Item item = categoryItems[itemIndex];
                                  return MenuFoodTile(item: item);
                                }),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: MySizes.sm,
                                    left: MySizes.sm,
                                    right: MySizes.sm),
                                child: Divider(color: MyColors.dividerColor),
                              )
                            ],
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
