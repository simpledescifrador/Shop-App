import 'package:flutter/foundation.dart';
import 'package:shop_app/data/order_repository.dart';
import 'package:shop_app/models/cart.dart' show CartItem;

class OrderItem {
  OrderItem({
    this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });

  final double amount;
  final DateTime dateTime;
  String id;
  final List<CartItem> products;
}

class Orders with ChangeNotifier {
  String authToken;
  String userId;

  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  Future<void> loadOrders() async {
    try {
      _orders = await OrderRepository(authToken, userId).fetchOrderItems();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    var orderItem = OrderItem(
      amount: total,
      dateTime: DateTime.now(),
      products: cartItems,
    );
    try {
      final id = await OrderRepository(authToken, userId).addOrder(orderItem);
      orderItem.id = id; //Set Order ID
      _orders.insert(0, orderItem);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
