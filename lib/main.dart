import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/products.dart';
import 'package:shop_app/screens/product_detail.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'MyShop App',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
        },
      ),
    );
  }
}
