import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:conf_store/provider/Order_provider.dart';

class OrderItem extends StatefulWidget {
  final OrderData order;
  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItem> {
  bool _expands = false;

  @override
  Widget build(BuildContext context) {
    // Builds a card with a list of order details
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(children: [
        // Display order total and date in a list tile
        ListTile(
          title: Text("\FRW${widget.order.total}"),
          subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(
            // Toggle expand state of the order item
            onPressed: () {
              setState(() {
                _expands = !_expands;
              });
            },
            // Display collapse or expand icon
            icon: Icon(_expands ? Icons.expand_less : Icons.expand_more),
          ),
        ),
        // Show a divider and order items list if expanded state is true
        if (_expands)
          Divider(
            indent: 10,
            endIndent: 10,
          ),
        if (_expands)
          Container(
            // Set the height of the list based on number of items
            height: min(30 + widget.order.cartItems.length * 30.0, 200),
            child: ListView(
              // Display each order item in a list tile
              children: widget.order.cartItems.map((cart) {
                return ListTile(
                  // Display item price as a chip
                  leading: Chip(label: Text("\FRW${cart.price}")),
                  title: Text(cart.title),
                  // Display total price for the item based on quantity
                  subtitle: Text("Total : \FRW${cart.quantity * cart.price}"),
                  // Display item quantity as a chip
                  trailing: Chip(label: Text("FRW{cart.quantity} x ")),
                );
              }).toList(),
            ),
          ),
      ]),
    );
  }
}
