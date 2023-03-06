import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import '../widgets/product_item.dart';

class ItemGrid extends StatelessWidget {
  final bool showFavourites;

  //Constructor to receive value to show only favourites
  const ItemGrid(this.showFavourites);

  @override
  Widget build(BuildContext context) {
    //Accessing object of ProductProvider to get data
    final productProvider = Provider.of<Product_Provider>(context);

    //Filtering products list based on value received
    final loadedProducts = showFavourites
        ? productProvider.favouriteOnlyList
        : productProvider.list;

    //Returning GridView based on data availability
    return (loadedProducts.isEmpty)
        ? const Center(child: Text('No Products \nFound !'))
        : GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 350,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: loadedProducts.length,
            itemBuilder: (ctx, index) {
              //Registering Provider for each of the item.
              return ChangeNotifierProvider.value(
                  value: loadedProducts[index], child:  ProductItem());
            },
          );
  }
}
