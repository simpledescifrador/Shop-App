import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/models/auth.dart';

import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/orders.dart';
import 'package:shop_app/models/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_detail.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (_, auth, prevProducts) {
            prevProducts.userId = auth.userId;
            prevProducts.authToken = auth.token;
            return prevProducts;
          },
          create: (_) => Products(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, auth, prevOrders) {
            prevOrders.authToken = auth.token;
            prevOrders.userId = auth.userId;
            return prevOrders;
          },
          create: (_) => Orders(),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        // ChangeNotifierProvider(create: (_) => Products()),
        // ChangeNotifierProvider(create: (_) => Orders()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop App',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            OrderScreen.routename: (_) => OrderScreen(),
            UserProductsScreen.routeName: (_) => UserProductsScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
