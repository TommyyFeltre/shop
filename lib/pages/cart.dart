import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart' show Cart;
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/cart_item.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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
                    label: Text('\$${cartProvider.totalAmount.toStringAsFixed(2)}'),
                    labelStyle: const TextStyle(color: Colors.white),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartProvider: cartProvider, scaffoldMessenger: scaffoldMessenger)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cartProvider,
    required this.scaffoldMessenger,
  });

  final Cart cartProvider;
  final ScaffoldMessengerState scaffoldMessenger;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartProvider.totalAmount <= 0 || _isLoading) 
      ? null 
      : () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false)
          .addOrder(widget.cartProvider.items.values.toList(), widget.cartProvider.totalAmount)
          .catchError((err) {
            widget.scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text(
                  'Could not complete a order',
                  textAlign: TextAlign.center,
                )
              )
            );
          });
          setState(() {
              _isLoading = false;
            });
        widget.cartProvider.clear();
      },
      child: _isLoading
      ? const CircularProgressIndicator()
      : const Text('ORDER NOW')
    );
  }
}