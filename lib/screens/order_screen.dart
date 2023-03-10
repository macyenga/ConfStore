import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:conf_store/provider/Order_provider.dart';
import 'package:conf_store/widgets/drawer.dart';
import 'package:conf_store/widgets/orderItem.dart';

class OrderScreen extends StatelessWidget {
  static const routName = '/order-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Orders")),
        drawer: MyDrawer(Draweritems.order),
        body: FutureBuilder(
          future: Provider.of<Order_Provider>(context, listen: false)
              .fetchAndSetOrders(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                //Error Handling
                return Center(
                  child: Text("No orders yet!"),
                );
              } else {
                return Consumer<Order_Provider>(
                    builder: ((context, orderData, child) {
                  return orderData.itemCount <= 0
                      ? Center(
                          child: Text("No orders yet!"),
                        )
                      : ListView.builder(
                          itemCount: orderData.itemCount,
                          itemBuilder: ((context, index) {
                            return OrderItem(orderData.items[index]);
                          }));
                }));
              }
            }
          }),
        ));
  }
}
