import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool favourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.favourite = false,
  });

  // Toggle favourite function that takes the id, token, and userId
  Future toggleFavourite(String id, String token, String userId) async {
    // Firebase URL for user favourites
    final url = Uri.parse(
        "https://confstore-ec705-default-rtdb.firebaseio.com/userFavourite/$userId/$id.json?auth=$token");
    // Toggling favourite and notifying listeners
    favourite = !favourite;
    notifyListeners();

    try {
      // Sending a PUT request to update the favourite status of the product in the user's favourite list
      Response res = await http.put(url, body: jsonEncode(favourite));
      // Error detection for HTTP request -> throw a custom HttpException
      if (res.statusCode >= 400) {
        print("ERROR");
        throw (HttpException("Error occurs !!"));
      }
      // Catching the error due to network and PUT request, then throwing it back
    } catch (err) {
      favourite = !favourite;
      notifyListeners();
      rethrow;
    }
  }
}
