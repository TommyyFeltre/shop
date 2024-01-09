import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductPage extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productsPrv = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.add)
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsPrv.productsCount,
          itemBuilder: (context, index) => 
            Column(
              children: [
                UserProductItem(productsPrv.items[index].title, productsPrv.items[index].imageUrl),
                const Divider(color: Colors.grey, thickness: 0.5,)
              ],
            )
        ),
      ),
    );
  }
}