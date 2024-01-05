import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = '/product-detail';
  const ProductDetail({super.key});

  @override
  Widget build(BuildContext context) { 
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}