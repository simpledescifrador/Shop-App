import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products.dart';

import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/product_detail.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({
    this.id,
    this.title,
    this.imageUrl,
  });

  Future<void> _deleteProduct(BuildContext context) async {
    try {
      await Provider.of<Products>(
        context,
        listen: false,
      ).removeProduct(id);
    } catch (error) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: id),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: ListTile(
            title: Text(title),
            leading: Container(
              width: 50,
              child: FittedBox(
                fit: BoxFit.cover,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
            ),
            trailing: Container(
              width: 100,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          EditProductScreen.routeName,
                          arguments: id);
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text('Are you sure?'),
                            content:
                                Text('Do you want to remove this product?'),
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
                                  _deleteProduct(context);
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    color: Theme.of(context).errorColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
