import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/cart.dart';
import 'package:shop/pages/orders.dart';
import 'package:shop/pages/product_detail.dart';
import 'package:shop/pages/product_overview.dart';
import 'package:shop/pages/user_product.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart()
        ),
        ChangeNotifierProvider(
          create: (context) => Orders()
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primaryColor: Colors.purple,
          colorScheme: const ColorScheme.light(
            onPrimary: Colors.deepOrange
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white
          ),
          fontFamily: 'Lato',
        ),
        home: const ProductOverview(),
        routes: {
          ProductDetail.routeName: (context) => const ProductDetail(),
          CartPage.routeName: (context) => const CartPage(),
          OrdersPage.routename: (context) => const OrdersPage(),
          UserProductPage.routeName : (context) => const UserProductPage()
        },
      ),
    );
  }
}
