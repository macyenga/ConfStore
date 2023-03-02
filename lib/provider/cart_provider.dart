// Import the material library from the flutter package
import 'package:flutter/material.dart';

// Create a class called CartData
class CartData{
// Declare instance variables for CartData class
final String id; // Declare an instance variable called id
final String title; // Declare an instance variable called title
final double price; // Declare an instance variable called price
int quantity; // Declare an instance variable called quantity

// Constructor for the CartData class
CartData({
required this.id,
required this.title,
required this.price,
this.quantity=1,
});
}

// Create a class called Cart_Provider which extends the ChangeNotifier class from the flutter package
class Cart_Provider with ChangeNotifier{
// Declare an instance variable called _items which is a Map of type String and CartData
Map<String,CartData> _items = Map<String,CartData>();

// Getter method to get the number of items in the cart
int get itemCount {
return _items.length;
}

// Getter method to get the total amount of all the items in the cart
double get totalAmount{
double total=0;
_items.forEach((key, cartItem) {
total += cartItem.price * cartItem.quantity;
});
return total;
}

// Getter method to get all the items in the cart as a Map
Map<String, CartData> get items {
return {..._items};
}

// Getter method to get all the keys of the items in the cart as a List
List<String> get keyList{
return _items.keys.toList();
}

// Getter method to get all the values of the items in the cart as a List
List<CartData> get valuesList{
return _items.values.toList();
}

// Method to get the number of items with a specific id
int indexCount(String id){
return _items.containsKey(id) ?_items[id]!.quantity : 0;
notifyListeners();
}

// Method to add an item to the cart
void addToCart(String itemId,String itemTitle,double itemPrice){
if(_items.containsKey(itemId)){
_items[itemId]?.quantity++;
print(_items[itemId]?.quantity);
}else{
_items.putIfAbsent(
itemId,
() => CartData(
id: DateTime.now().toString(),
title: itemTitle,
price: itemPrice,
),
);
}


notifyListeners();
}

// Method to remove one quantity of an item from the cart
void removeItemQuantity(String porductId){
if(_items.containsKey(porductId)){
if(_items[porductId]!.quantity>1){
_items[porductId]!.quantity-=1;
}else{
_items.remove(porductId);
}
notifyListeners();
}
}

// Method to delete an item from the cart
void deleteItem(String productId){
_items.remove(productId);
notifyListeners();
}

// Method to clear the cart
void clean(){
_items={};
notifyListeners();
}
}