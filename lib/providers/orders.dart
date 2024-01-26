import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime
  });
}


class Orders with ChangeNotifier {
  Orders(this.authToken, this._orders);

  final String authToken;

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }
  
  int get ordersCount {
    return _orders.length;
  }

  Future<void> getOrders() async {
    final url = Uri.parse('https://shop-app-flutter-6f48e-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$authToken');
    final response = await http.get(url)
      .catchError((err) {
        throw HttpException(err.toString());
      });
    final List<OrderItem> loadedOrders = [];
    final orders = json.decode(response.body);
    if(orders == null) {
      return;
    }
    orders.forEach((id, order) {
      loadedOrders.add(
        OrderItem(
          id: id, 
          amount: order['amount'], 
          dateTime: DateTime.parse(order['dateTime']), 
          products: (order['products'] as List<dynamic>).map((item) => 
            CartItem(
              id: item['id'], 
              title: item['title'], 
              quantity: item['quantity'], 
              price: item['price']
            )
          ).toList()
        )
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
   final url = Uri.parse('https://shop-app-flutter-6f48e-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$authToken');
    final response = await http.post(url, body: json.encode({
      'amount': total,
      'dateTime': DateTime.now().toIso8601String(),
      'products': cartProducts.map((item) => {
        'id': item.id,
        'title': item.title,
        'quantity': item.quantity,
        'price': item.price
      }).toList()
    }))
    .catchError((err) {
      throw HttpException(err.toString());
    });
    _orders.insert(0, OrderItem(id: json.decode(response.body)['name'], amount: total, products: cartProducts, dateTime: DateTime.now()));
    notifyListeners();
  }
}