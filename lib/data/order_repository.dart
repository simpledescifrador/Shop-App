import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/orders.dart';

abstract class _OrderRepositoryEvents {
  Future<String> addOrder(OrderItem newOrderItem);
  Future<List<OrderItem>> fetchOrderItems();
}

class OrderRepository implements _OrderRepositoryEvents {
  static const url = 'https://flutter-shop-8a914.firebaseio.com/orders';

  @override
  Future<String> addOrder(OrderItem newOrderItem) async {
    try {
      final response = await http.post(
        '$url.json',
        body: jsonEncode({
          'amount': newOrderItem.amount,
          'dateTime': newOrderItem.dateTime.toIso8601String(),
          'products': newOrderItem.products
              .map((cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'productImageUrl': cartItem.productImageUrl,
                    'price': cartItem.price,
                    'quantity': cartItem.quantity,
                  })
              .toList(),
        }),
      );
      return jsonDecode(response.body)['name'];
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<List<OrderItem>> fetchOrderItems() async {
    try {
      final response = await http.get('$url.json');
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];

      if (extractedData != null) {
        extractedData.forEach((id, orderData) {
          loadedOrders.insert(
              0,
              OrderItem(
                id: id,
                amount: orderData['amount'],
                dateTime: DateTime.parse(orderData['dateTime']),
                products: (orderData['products'] as List<dynamic>)
                    .map((cartItem) => CartItem(
                          id: cartItem['id'],
                          title: cartItem['title'],
                          productImageUrl: cartItem['productImageUrl'],
                          price: cartItem['price'],
                          quantity: cartItem['quantity'],
                        ))
                    .toList(),
              ));
        });
      }

      return loadedOrders;
    } catch (error) {
      throw error;
    }
  }
}
