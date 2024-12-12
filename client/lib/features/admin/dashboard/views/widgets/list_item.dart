import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/item/item_dashboard.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/helpers/convert_role.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/admin/user_management/controllers/user_management_controller.dart';

class ListItemCount extends StatelessWidget {
  ListItemCount({super.key});
  final _controller = Get.put(UserManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage.value.isNotEmpty) {
          return Center(
              child: Text('Error: ${_controller.errorMessage.value}'));
        }

        final List<String> allRoles = [
          'admin',
          'customer',
          'partner',
          'driver'
        ];

        final Map<String, int> roleCounts = {};
        for (var role in allRoles) {
          roleCounts[role] = _controller.roleCounts[role] ?? 0;
        }

        return Padding(
          padding: const EdgeInsets.only(top: MySizes.lg),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: roleCounts.entries.map((entry) {
                String role = entry.key;
                int count = entry.value;

                return ItemDashboard(
                  role: ConvertEnumRole.roleToDisplayName(role),
                  img: AssetImage(ConvertEnumRole.toImagePath(
                      ConvertEnumRole.convertToEnum(role))),
                  count: count.toString(),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}
