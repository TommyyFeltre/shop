import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart' show Orders;
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersPage extends StatelessWidget {
  static const routename = '/orders';
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: ordersProvider.ordersCount,
        itemBuilder: (context, index) => OrderItem(ordersProvider.orders[index])
      ),
    );
  }
}