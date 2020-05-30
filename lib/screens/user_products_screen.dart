import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-product';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (ctx, index) => UserProductItem(
              id: productsData.items[index].id,
              title: productsData.items[index].title,
              imageUrl: productsData.items[index].imageUrl,
            ),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
