import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [];

  // bool _showFavorites = false;

  List<Product> get items {
    // if(_showFavorites){
    //   return _items.where((item) => item.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoritesItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  int get productsCount {
    return _items.length;
  }

  // void showFavorites() {
  //   _showFavorites = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavorites = false;
  //   notifyListeners();
  // }

  Future<void> getProducts() async {
    final url = Uri.https('shop-app-flutter-6f48e-default-rtdb.europe-west1.firebasedatabase.app', '/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> products = [];
      extractedData.forEach((id, prodData) {
        products.add(Product(
          id: id,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite']
          )
        );
      });
      _items = products;
      notifyListeners();
    } catch(err) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {

    final url = Uri.https('shop-app-flutter-6f48e-default-rtdb.europe-west1.firebasedatabase.app', '/products.json');
    try {
      final res = await http.post(url, body: json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite
    }));
    final newProduct = Product(
      id: json.decode(res.body)['name'],
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    _items.add(newProduct);
    notifyListeners();
    } catch(err) {
      rethrow;
    }


  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _items.indexWhere((item) => item.id == id);
    if(index >= 0) {
      final url = Uri.https('shop-app-flutter-6f48e-default-rtdb.europe-west1.firebasedatabase.app', '/products/$id.json');
      await http.patch(url, body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
      }));
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}