import 'package:food_delivery_h2d/features/shippers/home/models/order_item_model.dart';

class Order {
  String id;
  String customerName;
  String restaurantName;
  String? restaurantId;
  String? restDetailAddress;
  String? assignedShipperId;
  double? custShipperRating;
  int? deliveryFee;
  DateTime orderDatetime;
  String note;
  double? custResRating;
  String reason;
  String custStatus;
  String? driverStatus;
  String? restStatus;
  List<OrderItem> orderItems;
  String? restAddress;
  String? custAddress;
  String custPhone;
  int? totalPrice;
  String? driverName;
  String? driverPhone;
  String? driverLicensePlate;
  String? driverProfileUrl;
  String? restProvinceId;
  String? restDistrictId;
  String? restCommuneId;
  String? custResRatingComment;
  String? custShipperRatingComment;

  Order(
      {this.id = '',
      required this.customerName,
      required this.restaurantName,
      this.restaurantId,
      this.restDetailAddress,
      required this.custPhone,
      this.assignedShipperId,
      this.custShipperRating,
      required this.deliveryFee,
      this.totalPrice,
      DateTime? orderDatetime,
      this.note = '',
      this.custResRating,
      this.reason = '',
      required this.custStatus,
      this.driverStatus,
      this.restStatus,
      this.orderItems = const [],
      this.restAddress,
      this.custAddress, // Initialize custAddress
      this.restProvinceId, // Initialize restProvinceId
      this.restDistrictId, // Initialize restDistrictId
      this.restCommuneId, // Initialize restCommuneId
      this.driverName,
      this.driverPhone,
      this.driverLicensePlate,
      this.driverProfileUrl,
      this.custResRatingComment,
      this.custShipperRatingComment,})
      : orderDatetime = orderDatetime ?? DateTime.now();

  // Convert an Order object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'restaurantName': restaurantName,
      'restDetailAddress': restDetailAddress,
      'assignedShipperId': assignedShipperId,
      'custShipperRating': custShipperRating,
      'deliveryFee': deliveryFee,
      'orderDatetime': orderDatetime.toIso8601String(),
      'note': note,
      'custResRating': custResRating,
      'reason': reason,
      'custStatus': custStatus,
      'driverStatus': driverStatus,
      'restStatus': restStatus,
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
      'restAddress': restAddress,
      'custAddress': custAddress,
      'restProvinceId': restProvinceId,
      'restDistrictId': restDistrictId,
      'restCommuneId': restCommuneId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'driverLicensePlate': driverLicensePlate,
      'driverProfileUrl': driverProfileUrl,
      'custShipperRatingComment': custShipperRatingComment,
      'custResRatingComment': custResRatingComment,
    };
  }

  // Factory constructor to create an Order object from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: (json['_id'] == null) ? json['id'] : json['_id'],
      customerName: json['customerName'] ?? '',
      custPhone: json['custPhone'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      restDetailAddress: json['restDetailAddress'] ?? '',
      assignedShipperId: json['assignedShipperId'],
      custShipperRating: json['custShipperRating'] != null
          ? (json['custShipperRating'] as num).toDouble()
          : null,
      deliveryFee: (json['deliveryFee'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toInt(),
      orderDatetime: DateTime.parse(json['orderDatetime']),
      note: json['note'] ?? '',
      custResRating: json['custResRating'] != null
          ? (json['custResRating'] as num).toDouble()
          : null,
      reason: json['reason'] ?? '',
      custStatus: json['custStatus'] ?? 'waiting',
      driverStatus: json['driverStatus'],
      restStatus: json['restStatus'],
      orderItems: (json['orderItems'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      restAddress: json['restAddress'], // Parse the restAddress field
      custAddress: json['custAddress'], // Parse the custAddress field
      restProvinceId: json['restProvinceId'], // Parse the new field
      restDistrictId: json['restDistrictId'], // Parse the new field
      restCommuneId: json['restCommuneId'], // Parse the new field
      driverName: json['driverName'] ?? 'Unknow',
      driverPhone: json['driverPhone'],
      driverLicensePlate: json['driverLicensePlate'],
      driverProfileUrl: json['driverProfileUrl'],
      custResRatingComment: json['custResRatingComment'],
      custShipperRatingComment: json['custShipperRatingComment']
    );
  }

  @override
  String toString() {
    return 'Order('
        'id: $id, '
        'customerName: $customerName, '
        'restaurantName: $restaurantName, '
        'restaurantId: $restaurantId, '
        'assignedShipperId: $assignedShipperId, '
        'custShipperRating: $custShipperRating, '
        'deliveryFee: $deliveryFee, '
        'orderDatetime: $orderDatetime, '
        'note: $note, '
        'custResRating: $custResRating, '
        'reason: $reason, '
        'custStatus: $custStatus, '
        'driverStatus: $driverStatus, '
        'restStatus: $restStatus, '
        'orderItems: $orderItems, '
        'restAddress: $restAddress, '
        'custAddress: $custAddress, '
        'restProvinceId: $restProvinceId, '
        'restDistrictId: $restDistrictId, '
        'restCommuneId: $restCommuneId, '
        'driverName: $driverName, '
        'driverPhone: $driverPhone, '
        'driverLicensePlate: $driverLicensePlate, '
        'driverProfileUrl: $driverProfileUrl, '
        'custShipperRatingComment: $custShipperRatingComment, '
        'custResRatingComment: $custResRatingComment, '
        ')';
  }

  int getToTalPrice() {
    int result = 0;
    for (var x in orderItems) {
      result += x.totalPrice;
    }
    return result;
  }
}
