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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(product.imageUrl, fit: BoxFit.cover,),
            ),
            const SizedBox(height: 10,),
            Text(
              '\$${product.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}