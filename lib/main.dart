import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/product_detail.dart';
import 'package:shop/pages/product_overview.dart';
import 'package:shop/providers/products.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Products(),
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
        home: ProductOverview(),
        routes: {
          ProductDetail.routeName: (context) => const ProductDetail(),
        },
      ),
    );
  }
}
