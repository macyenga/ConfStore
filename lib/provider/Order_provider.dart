import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:conf_store/models/http_exception.dart';
import 'package:conf_store/provider/cart_provider.dart';
import 'package:http/http.dart' as http;

// A class to represent an order
class OrderData {
  String id;
  DateTime dateTime;
  String total;
  List<CartData> cartItems;

  OrderData({
    required this.cartItems,
    required this.dateTime,
    required this.id,
    required this.total,
  });
}

// A provider class to manage orders
class Order_Provider with ChangeNotifier {
  List<OrderData> _items = [];

  List<OrderData> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  String? _authToken;
  String? _userId;

  // Setter methods for auth token and user ID
  set authToken(String? value) {
    _authToken = value;
  }

  set userId(String? value) {
    _userId = value;
  }

  // A method to fetch orders from the backend
  Future fetchAndSetOrders() {
    final List<OrderData> loadedOrders = [];

    final url = Uri.parse(
        "https://confstore-ec705-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken");

    return http.get(url).then((responce) {
      // Decode the response body from JSON format
      final eMap = jsonDecode(responce.body) as Map<String, dynamic>;

      if (eMap == null) {
        return;
      }

      // Loop through each order and add it to the list of loaded orders
      eMap.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderData(
            id: orderId,
            total: orderData['total'],
            dateTime: DateTime.parse(orderData['dateTime']),
            cartItems: (orderData['cartItem'] as List<dynamic>)
                .map(
                  (item) => CartData(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ),
                )
                .toList(),
          ),
        );
      });
    }).catchError((err) {
      // If an error occurs while fetching orders, throw an HttpException
      throw HttpException('Failed to fetch orders');
    }).whenComplete(() {
      // Update the list of orders and notify listeners
      _items = loadedOrders.reversed.toList();
      notifyListeners();
    });
  }

  // A method to add an order to the backend
  Future addOrder(List<CartData> cartItems, double total) {
    final time = DateTime.now();

    final url = Uri.parse(
        "https://confstore-ec705-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_authToken");

    // Send a POST request to the backend with the order data
    return http
        .post(url,
            body: jsonEncode({
              'dateTime': time.toIso8601String(),
              'total': total.toStringAsFixed(2),
              'cartItem': cartItems.map((each) {
                return {
                  'id': each.id,
                  'price': each.price,
                  'quantity': each.quantity,
                  "title": each.title,
                };
              }).toList(),
            }))
        .then((responce) {
      // If the request is successful, add the order to the list of orders and notify listeners
      _items.insert(
          0,
          OrderData(
              id: jsonDecode(responce.body)['name'],
              dateTime: time,
              total: total.toStringAsFixed(2),
              cartItems: cartItems));
      notifyListeners();
    }).catchError((err) {
      throw err;
    });
  }
}
