import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/views/widgets/line_chart.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/views/widgets/list_item.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/views/widgets/order_status_chart.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/views/widgets/pie_chart.dart';
import 'package:food_delivery_h2d/features/admin/web_layout.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return WebLayout(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 130,
              child: ListItemCount(),
            ),
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 400,
                    child: UserRoleChart(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 28),
                    child: SizedBox(
                      height: 400,
                      child: Card(
                        elevation: 4,
                        shadowColor: MyColors.darkPrimaryColor,
                        child: OrderStatusChart(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 400,
              child: StatisticLineChart()
            ),
          ],
        ),
      ),
    );
  }
}
