import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop/models/http_exception.dart'; 

class Products with ChangeNotifier {
  Products(this.authToken, this._items, this.userId);

  final String userId;
  final String authToken;

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

  Future<void> getProducts([bool filterByUser = false]) async {
    final filters = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    Uri url = Uri.parse('https://shop-app-flutter-6f48e-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filters');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      url = Uri.parse('https://shop-app-flutter-6f48e-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
      final favoriteRes = await http.get(url);
      final favoriteData = json.decode(favoriteRes.body);
      print(favoriteData);
      final List<Product> products = [];
      extractedData.forEach((id, prodData) {
        products.add(Product(
          id: id,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: favoriteData == null ? false : favoriteData[id] ?? false
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
    final url = Uri.parse('https://shop-app-flutter-6f48e-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final res = await http.post(url, body: json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'creatorId': userId
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
      final url = Uri.parse('https://shop-app-flutter-6f48e-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken');
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

  Future<void> removeProduct(String id) async {
    final url = Uri.https('shop-app-flutter-6f48e-default-rtdb.europe-west1.firebasedatabase.app', '/products/$id.json?auth=$authToken');
    final index = _items.indexWhere((item) => item.id == id);
    Product? exist = _items[index];
    _items.removeAt(index);
    notifyListeners();
    final response = await http.delete(url);
    if(response.statusCode >= 400) {
      _items.insert(index, exist);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    exist = null;
  }
}