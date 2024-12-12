import 'dart:convert';
import 'package:food_delivery_h2d/sockets/socket_service.dart';

import '../../features/shippers/home/models/order_model.dart';

class OrderSocketHandler {
  final _socketService = SocketService.instance;

  void listenForOrderCreates(Function(Order order) onNewOrder) {
    _socketService.socket.on('order:new', (data) {
      final orderData = jsonDecode(jsonEncode(data));
      final order = Order.fromJson(orderData);
      onNewOrder(order);
    });
  }

  void listenNewOrderDriver(Function(Order order) onNewOrder) {
    _socketService.socket.on('order:created', (data) {
      final orderData = jsonDecode(jsonEncode(data));
      final order = Order.fromJson(orderData);
      onNewOrder(order);
    });
  }

  void listenForOrderUpdates(Function(Order order) onOrderUpdated) {
    _socketService.socket.on('order:updatedStatus', (data) {
      try {
        final orderData = jsonDecode(jsonEncode(data));
        final order = Order.fromJson(orderData);
        onOrderUpdated(order);
      } catch (e) {
        print('Error processing order update: $e');
      }
    });
  }

  void createOrder(Order order) {
    final orderData = order.toJson();
    _socketService.socket.emit('order:create', jsonEncode(orderData));
    print('Order created: $orderData');
  }

  void updateStatusOrder(String orderId, Map<String, dynamic> newStatus) {
    // Create payload
    final orderData = {
      'orderId': orderId,
      'newStatus': newStatus,
    };

    // Emit the updateStatusOrder event
    _socketService.socket.emit('order:updateStatus', orderData);

    print('Order status update sent: $orderData');
  }

  void joinOrderRoom(String room) async {
    _socketService.socket.emit('joinRoom', room);
    print('Requested to join room: $room');

    _socketService.socket.on('joinedRoom', (data) {
      print('Successfully joined room: ${data['roomId']}');
    });

    _socketService.socket.on('error', (data) {
      print('Failed to join room: ${data['message']}');
    });
  }

  void removeJoinRoom(String room) async {
    _socketService.socket.emit('leaveRoom', room);
    print('Requested to leave room: $room');

    _socketService.socket.on('leftRoom', (data) {
      print('Successfully left room: ${data['roomId']}');
    });

    _socketService.socket.on('error', (data) {
      print('Failed to leave room: ${data['message']}');
    });
  }

  // Clean up listeners
  void cleanUp() {
    _socketService.socket.off('order:updateStatus');
  }
}
