import 'package:flutter/material.dart';
import 'package:shop/pages/orders.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friends'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersPage.routename);
            },
          )
        ],
      ),
    );
  }
}