import 'package:flutter/material.dart';
import 'package:shop/widgets/products_grid.dart';

class ProductOverview extends StatelessWidget {
  ProductOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: ProductsGrid(),
    );
  }
}

