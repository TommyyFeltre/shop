import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart' show Cart;
import 'package:shop/widgets/cart_item.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text('\$${cartProvider.totalAmount}'),
                    labelStyle: const TextStyle(color: Colors.white),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('ORDER NOW')
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child:ListView.builder(
              itemCount: cartProvider.itemCount,
              itemBuilder: (context, index) => CartItem(
                cartProvider.items.values.toList()[index].id,
                cartProvider.items.keys.toList()[index],
                cartProvider.items.values.toList()[index].title,
                cartProvider.items.values.toList()[index].price,
                cartProvider.items.values.toList()[index].quantity
              )
            ),
          )
        ]
      ),
    );
  }
}