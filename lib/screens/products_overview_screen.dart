import 'package:flutter/material.dart';

import 'package:shop_app/widgets/products_grid.dart';

enum FilterMenu { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
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
      body: ProductsGrid(
        onlyFavorites: _showOnlyFavorites,
      ),
    );
  }
}
