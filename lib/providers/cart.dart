
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {} ;

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, item) { 
      total += item.price * item.quantity;
    });
    return total;
  }

  void addItem(String id, String title, double price) {
    if(_items.containsKey(id)) {
      _items.update(id, (item) => CartItem(id: item.id, title: item.title, quantity: item.quantity + 1, price: item.price));
    } else {
      _items.putIfAbsent(id, () => CartItem(id: DateTime.now().toString(), title: title, quantity: 1, price: price));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();

  }

  void removeSingleItem(String id) {
    if(!_items.containsKey(id)) {
      return;
    }
    if(_items[id]!.quantity > 1) {
      _items.update(id, (item) => CartItem(id: item.id, title: item.title, quantity: (item.quantity - 1), price: item.price));
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}