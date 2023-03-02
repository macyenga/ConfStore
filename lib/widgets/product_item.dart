import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conf_store/provider/auth_provider.dart';
import 'package:conf_store/provider/cart_provider.dart';
import 'package:conf_store/screens/product_details_screen.dart';

import '../provider/product.dart';
import 'badge.dart' as badges;

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the current product and authentication data from the Provider
    Product product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<auth_Provider>(context, listen: false);

    // Define the UI for a product item
    return GestureDetector(
      onTap: () {
        // Navigate to the product details screen when tapped
        Navigator.of(context).pushNamed(
          ProductDetailsScreen.routName,
          arguments: product.id,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Lato'),
            ),
            // Use a Consumer to rebuild only the favourite button when its state changes
            leading: Consumer<Product>(builder: (ctx, product, _) {
              return IconButton(
                icon: Icon(
                  product.favourite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  // Toggle the favourite status of the product and show a snackbar if an error occurs
                  product
                      .toggleFavourite(
                          product.id, authData.Token!, authData.UserId!)
                      .catchError((err) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Could Not able to Favourite"),
                      duration: Duration(seconds: 3),
                    ));
                  });
                  print("Favourite Pressed");
                },
              );
            }),
            // Use a Consumer to rebuild the cart button and badge only when the cart state changes
            trailing: Consumer<Cart_Provider>(
              builder: (ctx, cart, _) {
                // Show a badge with the quantity in cart if the product is in the cart
                return cart.indexCount(product.id) == 0
                    ? cartButton(
                        cart,
                        product,
                        context,
                      )
                    : badges.Badge(
                        color: Colors.yellow,
                        value: cart.indexCount(product.id).toString(),
                        child: cartButton(
                          cart,
                          product,
                          context,
                        ),
                      );
              },
            ),
          ),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/loading.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  // Returns a cart button with a snackbar that can be shown when pressed
  IconButton cartButton(
      Cart_Provider cart, Product product, BuildContext context) {
    return IconButton(
      onPressed: () {
        // Add the product to the cart and show a snackbar with an undo action
        cart.addToCart(product.id, product.title, product.price);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Item added to Cart"),
              duration: Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              action: SnackBarAction(
                  onPressed: () {
                    // Remove the product from the cart if the undo action is pressed
                    cart.removeItemQuantity(product.id);
                  },
                  label: "UNDO")),
        );
        print("Cart Pressed");
      },
      icon: Icon(
        Icons.shopping_cart,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
