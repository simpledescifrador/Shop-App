import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterMenu { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = '/products-overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, child) {
              return Badge(
                child: child,
                value: cart.itemCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterMenu.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterMenu.All,
              ),
            ],
            onSelected: (selectedMenu) {
              setState(() {
                if (selectedMenu == FilterMenu.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  //FilterMenu.All
                  _showOnlyFavorites = false;
                }
              });
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false,).loadProducts(),
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapShot.error != null) {
                //Do Error Handling here
                return Center(
                  child: Text('Error Loading Products!'),
                );
              } else {
                return ProductsGrid(
                  onlyFavorites: _showOnlyFavorites,
                );
              }
            }
          }),
    );
  }
}
