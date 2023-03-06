
// This is a StatelessWidget which displays the item information of a product in the ManageProductScreen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conf_store/provider/product.dart';
import 'package:conf_store/provider/products_provider.dart';
import 'package:conf_store/screens/addEdit_product_screen.dart';

class ManageProductItem extends StatelessWidget {
  final Product product;

  ManageProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
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
                    Navigator.of(context).pushNamed(
                      AddEditProductScreen.routName,
                      arguments: product,
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
            ],
          ),
          Container(
            color: Colors.black,
            child: ListTile(
              leading: Text(
                '${product.price}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              title: Text(
                product.title,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              trailing: IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Product_Provider>(
                      context,
                      listen: false,
                    ).deleteProduct(product.id);
                  } catch (_) {
                    print('ERROR');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could Not able to delete'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
