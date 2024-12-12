class OrderItem {
  String itemId;
  String itemName;
  int quantity;
  int price;
  int totalPrice;
  String foodId;

  OrderItem({
    required this.itemId,
    required this.foodId,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  // Convert OrderItem object to JSON
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
    };
  }

  // Factory constructor to create an OrderItem from JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: json['id'] ?? '',
      itemName: json['itemName'] ?? 'Unknow',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toInt(),
      foodId: json['foodId'] ?? '',
    );
  }

  @override
  String toString() {
    return 'OrderItem('
        'itemId: $itemId, '
        'itemName: $itemName, '
        'quantity: $quantity, '
        'price: $price, '
        'totalPrice: $totalPrice'
        ')';
  }
}
