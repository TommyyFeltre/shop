import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({ 
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false
  });

  Future<void> toggleFavoriteStatus(String authToken, userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse('https://shop-app-flutter-6f48e-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$authToken');
    final response = await http.put(url, body: json.encode(isFavorite));
    if(response.statusCode >= 400) {
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpException('Could not add to favorite.');
    }
  }
}