import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/auth.dart';
import 'package:shop/pages/cart.dart';
import 'package:shop/pages/edit_product.dart';
import 'package:shop/pages/orders.dart';
import 'package:shop/pages/product_detail.dart';
import 'package:shop/pages/product_overview.dart';
import 'package:shop/pages/user_product.dart';
import 'package:shop/providers/auth.dart';
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
          create: (context) => Auth()
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', [], ''),
          update: (context, auth, previous) => Products(auth.token!, previous!.items, auth.userId),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart()
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', []), 
          update: (context, auth, previous) => Orders(auth.token!, previous!.orders),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => 
          MaterialApp(
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
            home: auth.isAuth ? const ProductOverview() :  AuthPage(),
            routes: {
              ProductOverview.routeName:(context) => const ProductOverview(),
              ProductDetail.routeName: (context) => const ProductDetail(),
              CartPage.routeName: (context) => const CartPage(),
              OrdersPage.routename: (context) => const OrdersPage(),
              UserProductPage.routeName : (context) => const UserProductPage(),
              EditProductPage.routeName : (context) => const EditProductPage()
            },
          ),
      ) 
    );
  }
}
