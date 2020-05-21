import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/cart.dart' show Cart;
import 'package:shop_app/models/orders.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return CartItem(
                  id: cart.cartItems.values.toList()[index].id,
                  productId: cart.cartItems.keys.toList()[index],
                  title: cart.cartItems.values.toList()[index].title,
                  productImage:
                      cart.cartItems.values.toList()[index].productImageUrl,
                  price: cart.cartItems.values.toList()[index].price,
                  quantity: cart.cartItems.values.toList()[index].quantity,
                );
              },
              itemCount: cart.cartItems.length,
            ),
          ),
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$ ${cart.totalCartAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Orders>(
                        context,
                        listen: false,
                      ).addOrder(
                        cart.cartItems.values.toList(),
                        cart.totalCartAmount,
                      );
                      cart.clearCartItems();

                      Navigator.of(context)
                          .pushReplacementNamed(OrderScreen.routename);
                    },
                    child: Text(
                      'Order Now',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
