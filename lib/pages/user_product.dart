import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/edit_product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductPage extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductPage({super.key});

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //this provider will create an infine loop
    // final productsPrv = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductPage.routeName);
            },
            icon: const Icon(Icons.add)
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting 
        ? const Center(
          child: CircularProgressIndicator(),
        )
        : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<Products>(
            builder: (context, products, child) => Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: products.productsCount,
                itemBuilder: (context, index) => 
                  Column(
                    children: [
                      UserProductItem(products.items[index].id, products.items[index].title, products.items[index].imageUrl),
                      const Divider(color: Colors.grey, thickness: 0.5,)
                    ],
                  )
              ),
            ),
          )
        ),
      ),
    );
  }
}