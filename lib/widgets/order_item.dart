import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/orders.dart' as order_prv;

class OrderItem extends StatefulWidget {
  final order_prv.OrderItem order;
  const OrderItem(this.order, {super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if(_expanded) Container(
            height: min(widget.order.products.length * 20 + 10, 180),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: ListView(
              children: widget.order.products
                .map((product) =>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        '${product.quantity}x \$${product.price}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey
                        ),
                      )
                    ],
                  )
                ).toList(),
            ),
          )
        ],
      ),
    );
  }
}