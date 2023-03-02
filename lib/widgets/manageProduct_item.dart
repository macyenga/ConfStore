import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conf_store/provider/product.dart';
import 'package:conf_store/provider/products_provider.dart';
import 'package:conf_store/screens/addEdit_product_screen.dart';

// This is a StatelessWidget which displays the item information of a product in the ManageProductScreen
class ManageProductItem extends StatelessWidget {
  final Product product;

// Constructor to initialize the product for this item
  ManageProductItem(this.product);

// Builds the UI for the item with the product information
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
// A stack containing the product image and an edit button
          Stack(
            children: [
              Container(
                height: size.height * .3 < 150 ? 150 : size.height * .3,
                width: size.width,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 0.0,
                bottom: 0.0,
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black, Colors.transparent])),
                  height: 100,
                  width: size.width,
                ),
              ),
              Positioned(
                right: 1.0,
                top: 1.0,
                child: IconButton(
                    onPressed: () {
// Navigates to the AddEditProductScreen with the current product to edit
                      Navigator.of(context).pushNamed(
                          AddEditProductScreen.routName,
                          arguments: product);
                    },
                    icon: Icon(Icons.edit)),
              )
            ],
          ),
// A container with a black background and product details
          Container(
              color: Colors.black,
              child: ListTile(
                leading: Text(
                  "${product.price}",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                title: Text(product.title,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                trailing: IconButton(
                  onPressed: () async {
                    try {
// Deletes the current product from the provider
                      await Provider.of<Product_Provider>(context,
                              listen: false)
                          .deleteProduct(product.id);
                    } catch (_) {
// Displays a snackbar if the product could not be deleted
                      print("ERROR");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Could Not able to delete"),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
