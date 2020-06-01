import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/cart.dart';
import 'package:shop_app/screens/product_detail.dart';

class CartItem extends StatelessWidget {
  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.productImage,
    @required this.price,
    @required this.quantity,
  });

  final String id;
  final double price;
  final String productId;
  final String productImage;
  final int quantity;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: productId,
            );
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: Container(
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image.network(
                    productImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text('\$$price'),
              trailing: Text('$quantity x'),
            ),
          ),
        ),
      ),
      builder: (_, cart, childWidget) {
        return Dismissible(
          child: childWidget,
          key: ValueKey(id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            cart.removeCartItem(productId);
          },
          confirmDismiss: (_) {
            return showDialog<bool>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                      Text('Do you want to remove the item from the cart?'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text('No'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Yes'),
                    ),
                  ],
                );
              },
            );
          },
          background: Container(
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
          ),
        );
      },
    );
  }
}
