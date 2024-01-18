import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart' show Orders;
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersPage extends StatefulWidget {
  static const routename = '/orders';
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
bool _isLoading = true;

  @override
  void initState() {
    // _isLoading = true;
    // Provider.of<Orders>(context, listen: false)
    //   .getOrders()
    //   .then((_) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).getOrders(),
        builder: (ctx, snapshot) {
          
        },
      )
      
      _isLoading 
      ? const Center(child: CircularProgressIndicator(),)
      : ListView.builder(
        itemCount: ordersProvider.ordersCount,
        itemBuilder: (context, index) => OrderItem(ordersProvider.orders[index])
      ),
    );
  }
}