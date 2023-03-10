import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:conf_store/models/http_exception.dart';
import 'package:conf_store/provider/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product_Provider with ChangeNotifier {
  List<Product> _priveteList = [];
  bool isInit = true;
  String? _authToken;
  String? _userId;

  set authToken(String? value) {
    _authToken = value;
  }

  set userId(String? value) {
    _userId = value;
  }

  //
  //
  Future<void> featchAndSetProducts([bool orderByUser = false]) async {
    // print("Token : $_authToken");
    // if (isInit) {
    final orderBy =
        orderByUser ? '&orderBy="creatorId"&equalTo="$_userId"' : '';
    final url = Uri.parse(
        'https://confstore-ec705-default-rtdb.firebaseio.com/products.json?auth=$_authToken$orderBy');
    try {
      final responce = await http.get(url);
      // print(responce.body);
      final eMap = jsonDecode(responce.body) as Map<String, dynamic>;

      final favUrl = Uri.parse(
          "https://confstore-ec705-default-rtdb.firebaseio.com/userFavourite/$_userId.json?auth=$_authToken");
      final favResponce = await http.get(favUrl);
      final decodedFav = jsonDecode(favResponce.body);
      // print(favResponce.body);
      List<Product> newList = [];
      eMap.forEach((prodId, prodData) {
        final pro = Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['url'],
          price: prodData['price'],
          favourite: decodedFav == null ? false : decodedFav[prodId] ?? false,
        );
        newList.insert(0, pro);
      });
      _priveteList = newList;
      notifyListeners();
      // isInit = false;
    } catch (err) {
      rethrow;
    }
    // }
  }

  Future<void> refreshProducts([bool orderByUser = false]) async {
    print("refresh");
    final orderBy =
        orderByUser ? '&orderBy="creatorId"&equalTo="$_userId"' : '';
    final url = Uri.parse(
        "https://confstore-ec705-default-rtdb.firebaseio.com/products.json?auth=$_authToken$orderBy");
    final responce = await http.get(url);
    final eMap = jsonDecode(responce.body) as Map<String, dynamic>;
    final favUrl = Uri.parse(
        "https://confstore-ec705-default-rtdb.firebaseio.com/userFavourite/$_userId.json?auth=$_authToken");
    final favResponce = await http.get(favUrl);
    final decodedFav = jsonDecode(favResponce.body);

    List<Product> newList = [];
    eMap.forEach((prodId, prodData) {
      final pro = Product(
        id: prodId,
        title: prodData['title'],
        description: prodData['description'],
        imageUrl: prodData['url'],
        price: prodData['price'],
        favourite: decodedFav == null ? false : decodedFav[prodId] ?? false,
      );
      newList.insert(0, pro);
    });
    _priveteList = newList;
    print(jsonDecode(responce.body));
    notifyListeners();
  }

  List<Product> get list {
    return [..._priveteList];
  }

  int get productCount {
    return _priveteList.length;
  }

  List<Product> get favouriteOnlyList {
    return _priveteList.where((element) => element.favourite).toList();
  }

  //Methods to update this provider
  Future addProduct(Product product) {
    final url = Uri.parse(
        "https://confstore-ec705-default-rtdb.firebaseio.com/products.json?auth=$_authToken");
    return http
        .post(url,
            body: jsonEncode({
              'creatorId': _userId,
              'title': product.title,
              'price': product.price,
              'description': product.description,
              'url': product.imageUrl,
            }))
        .then((response) {
      final pro = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        favourite: product.favourite,
      );

      _priveteList.insert(0, pro);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(Product product) async {
    final url = Uri.parse(
        "https://confstore-ec705-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$_authToken");
    Response res = await http.patch(url,
        body: jsonEncode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'url': product.imageUrl,
        }));
    if (res.statusCode >= 400) {
      print("update Error ");
      throw HttpException("Update Error!");
    }
    int index = _priveteList.indexWhere((element) => element.id == product.id);
    _priveteList[index] = product;
    notifyListeners();
  }

  Product findById(String Id) {
    return _priveteList.firstWhere((element) => element.id == Id);
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://confstore-ec705-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken");
    final existingIndex =
        _priveteList.indexWhere((element) => element.id == id);
    Product? tempProduct = _priveteList[existingIndex];
    _priveteList.removeWhere((element) => element.id == id);
    notifyListeners();

    try {
      Response responce = await http.delete(url);
      if (responce.statusCode >= 400) {
        _priveteList.insert(existingIndex, tempProduct);
        notifyListeners();
        throw (HttpException("Could not able to delete"));
      } else {
        tempProduct = null;
      }
    } catch (err) {
      rethrow;
    }
  }
}
