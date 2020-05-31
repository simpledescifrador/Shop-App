import 'package:flutter/foundation.dart';
import 'package:shop_app/data/order_repository.dart';
import 'package:shop_app/models/cart.dart' show CartItem;

class OrderItem {
  String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  Future<void> loadOrders() async {
    try {
      _orders = await OrderRepository().fetchOrderItems();
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
      final id = await OrderRepository().addOrder(orderItem);
      orderItem.id = id; //Set Order ID
      _orders.insert(0, orderItem);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
