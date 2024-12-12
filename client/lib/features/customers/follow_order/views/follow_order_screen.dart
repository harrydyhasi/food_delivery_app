import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/address_selection/views/address_selection/address_selection_screen.dart';
import 'package:food_delivery_h2d/features/customers/follow_order/controllers/order_status_controller.dart';
import 'package:food_delivery_h2d/features/customers/order/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/features/shippers/rating/controllers/driver_rating_controller.dart';
import 'package:food_delivery_h2d/sockets/handlers/order_socket_handler.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/handle_status_text.dart';
import 'package:food_delivery_h2d/utils/helpers/status_helper.dart';
import 'package:get/get.dart';

class FollowOrderScreen extends StatefulWidget {
  final Order order;
  const FollowOrderScreen({super.key, required this.order});

  @override
  State<FollowOrderScreen> createState() => _FollowOrderScreenState();
}

class _FollowOrderScreenState extends State<FollowOrderScreen> {
  final orderSocketHandler = OrderSocketHandler();
  @override
  void dispose() {
    orderSocketHandler.removeJoinRoom(widget.order.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderStatusController = Get.put(OrderStatusController());
    final customerOrderController = Get.put(CustomerOrderController());
    final ratingControler = Get.put(DriverRatingController());

    var currentOrder = widget.order.obs;

    orderStatusController.orderStatus.value = widget.order.custStatus;
    orderSocketHandler.joinOrderRoom(widget.order.id);

    orderSocketHandler.listenForOrderUpdates((newOrder) {
      orderStatusController.orderStatus.value = newOrder.custStatus;
      currentOrder.value = newOrder;
    });

    return Scaffold(
      appBar: const CustomAppBar(
        title: Text("Theo dõi đơn hàng"),
      ),
      body: Obx(
        () => currentOrder.value.custStatus == "cancelled"
            ? Center(
                child: Text(
                    "${currentOrder.value.restaurantName} đã hủy đơn vì ${currentOrder.value.reason}"))
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0, bottom: 68.0, right: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: MyColors.primaryBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              buildInfoCard(
                                context: context,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () => Text(
                                          'Trạng thái đơn  -  ${StatusHelper.custStatusTranslations[orderStatusController.orderStatus.value]}...',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Icon(
                                            Icons.inventory_outlined,
                                            size: 18,
                                            color: MyColors.primaryColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Obx(() => AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 1),
                                                curve: Curves.linear,
                                                width: 55,
                                                height: 2.5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: orderStatusController
                                                      .getContainerColor(1),
                                                ),
                                                child: LinearProgressIndicator(
                                                  value: orderStatusController
                                                      .container1Progress.value,
                                                  minHeight: 6,
                                                  backgroundColor:
                                                      Colors.grey.shade300,
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                              Color>(
                                                          MyColors
                                                              .primaryColor),
                                                ),
                                              )),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.local_dining,
                                            size: 18,
                                            color: MyColors.primaryColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Obx(() => AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 1),
                                                curve: Curves.linear,
                                                width: 55,
                                                height: 2.5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: orderStatusController
                                                      .getContainerColor(2),
                                                ),
                                                child: LinearProgressIndicator(
                                                  value: orderStatusController
                                                      .container2Progress.value,
                                                  minHeight: 6,
                                                  backgroundColor:
                                                      Colors.grey.shade300,
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                              Color>(
                                                          MyColors
                                                              .primaryColor),
                                                ),
                                              )),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.delivery_dining,
                                            size: 18,
                                            color: MyColors.primaryColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Obx(() => AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 1),
                                                curve: Curves.linear,
                                                width: 55,
                                                height: 2.5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: orderStatusController
                                                      .getContainerColor(3),
                                                ),
                                                child: LinearProgressIndicator(
                                                  value: orderStatusController
                                                      .container3Progress.value,
                                                  minHeight: 6,
                                                  backgroundColor:
                                                      Colors.grey.shade300,
                                                  valueColor:
                                                      const AlwaysStoppedAnimation<
                                                              Color>(
                                                          MyColors
                                                              .primaryColor),
                                                ),
                                              )),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.home,
                                            size: 18,
                                            color: MyColors.primaryColor,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              buildInfoCard(context: context, children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.grey
                                              .shade200, // Fallback background color
                                          child: Obx(
                                            () => ClipOval(
                                              child: currentOrder.value
                                                              .driverProfileUrl !=
                                                          "Unknown" &&
                                                      currentOrder
                                                          .value
                                                          .driverProfileUrl!
                                                          .isNotEmpty
                                                  ? Image.network(
                                                      currentOrder.value
                                                          .driverProfileUrl!,
                                                      fit: BoxFit.cover,
                                                      width: 40,
                                                      height: 40,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Icon(
                                                            Icons.person,
                                                            size: 40,
                                                            color: Colors.grey);
                                                      },
                                                    )
                                                  : const Icon(Icons.person,
                                                      size: 30,
                                                      color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(
                                              () => Text(
                                                currentOrder.value.driverName ==
                                                        "Unknown"
                                                    ? "Đang tìm tài xế..."
                                                    : currentOrder
                                                        .value.driverName
                                                        .toString(),
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: MyColors.warningColor,
                                                  size: 18,
                                                ),
                                                Obx(() {
                                                  print(
                                                      'DRIVER ID: ${currentOrder.value.assignedShipperId.toString()}');
                                                  print(
                                                      'CURRENT ORDER: ${currentOrder.value}');
                                                  ratingControler.fetchRating(
                                                      currentOrder.value
                                                          .assignedShipperId
                                                          .toString());
                                                  return Text(
                                                      MyFormatter.formatDouble(
                                                          ratingControler
                                                              .value.value));
                                                }),
                                                const SizedBox(
                                                  width: 8.0,
                                                ),
                                                Obx(
                                                  () => Text(
                                                    currentOrder.value
                                                                .driverLicensePlate ==
                                                            "Unknown"
                                                        ? ""
                                                        : currentOrder.value
                                                            .driverLicensePlate
                                                            .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ]),
                              buildInfoCard(context: context, children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Lấy hàng: ${widget.order.restaurantName}',
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.order.restAddress.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(color: MyColors.dividerColor),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Giao hàng: ${widget.order.customerName}',
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: widget.order.custStatus ==
                                              "waiting"
                                          ? () async {
                                              var updatedAddress = await Get.to(
                                                () => AddressSelectionScreen(
                                                  isUpdate: true,
                                                  orderId: widget.order.id,
                                                ),
                                              );
                                              if (updatedAddress != null) {
                                                setState(() {
                                                  widget.order.custAddress =
                                                      updatedAddress;
                                                });
                                              }
                                            }
                                          : null, // Disable tap if status is not "waiting"
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.order.custAddress
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                // Grey out text if not editable
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (widget.order.custStatus ==
                                              "waiting")
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.order.customerName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.order.custPhone,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildInfoCard(
                                    context: context,
                                    children: [
                                      const Text(
                                        'Chi tiết đơn hàng',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Mã đơn hàng:',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            child: Text(
                                              '#${widget.order.id}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Số lượng món: ${widget.order.orderItems.length}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: MyColors.primaryTextColor),
                                      ),
                                      const Divider(
                                          color: MyColors.dividerColor,
                                          thickness: 1),
                                      const SizedBox(height: 8),
                                      // Table Headers
                                      const Row(
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              'Tên món',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                50, // Fixed width for the second column
                                            child: Text(
                                              'SL',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Thành tiền',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Order Items List
                                      ...widget.order.orderItems.map((item) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width:
                                                    150, // Matches the header column width
                                                child: Text(
                                                  item.itemName,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    50, // Matches the header column width
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  MyFormatter.formatCurrency(
                                                      item.totalPrice),
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                      const Divider(
                                          color: MyColors.dividerColor,
                                          thickness: 1),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Tổng: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            MyFormatter.formatCurrency(
                                                widget.order.totalPrice ?? 0),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Phí vận chuyển: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            MyFormatter.formatCurrency(
                                                widget.order.deliveryFee ?? 0),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Tổng tiền: ',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    MyColors.primaryTextColor),
                                          ),
                                          Text(
                                            MyFormatter.formatCurrency(
                                              (widget.order.totalPrice ?? 0) +
                                                  (widget.order.deliveryFee ??
                                                      0),
                                            ),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: MyColors.primaryColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: double
                                        .infinity, // Simplified instead of MediaQuery
                                    padding: const EdgeInsets.all(16),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Hóa đơn quán',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Tổng hóa đơn',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              MyFormatter.formatCurrency(
                                                  widget.order.totalPrice ?? 0),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Quán giảm giá',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              '0 VND',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const Divider(
                                          color: MyColors.dividerColor,
                                          thickness: 1,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Tổng tiền thanh toán',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              MyFormatter.formatCurrency(
                                                  widget.order.totalPrice ?? 0),
                                              style: const TextStyle(
                                                  color: MyColors.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Floating action button
                  // if (!controller.isCustButtonClicked.value)
                  //   Positioned(
                  //     bottom: 16,
                  //     right: 16,
                  //     child: FloatingActionButton.extended(
                  //       onPressed: ()  {

                  //       },
                  //       label: const Text(
                  //         'Đã giao đơn hàng',
                  //         style: TextStyle(
                  //           color: MyColors.white,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       icon: const Icon(
                  //         Icons.check_circle,
                  //         color: MyColors.white,
                  //       ),
                  //       backgroundColor: MyColors.primaryColor,
                  //     ),
                  //   ),
                ],
              ),
      ),
      floatingActionButton: Obx(
        () {
          if (currentOrder.value.custStatus == 'waiting') {
            return FloatingActionButton.extended(
              onPressed: () {
                customerOrderController.showCancelDialog(
                    context, currentOrder.value.id);
              },
              label: const Text(
                'Hủy đơn',
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: MyColors.primaryColor,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget buildInfoCard(
      {required BuildContext context, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
