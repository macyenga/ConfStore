import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conf_store/provider/Order_provider.dart';
import 'package:conf_store/provider/auth_provider.dart';
import 'package:conf_store/screens/addEdit_product_screen.dart';
import 'package:conf_store/screens/auth_screen.dart';
import 'package:conf_store/screens/cart_screen.dart';
import 'package:conf_store/screens/manage_product_screen.dart';
import 'package:conf_store/screens/order_screen.dart';
import 'package:conf_store/screens/splash_screen.dart';
import '../provider/cart_provider.dart';
import '../provider/products_provider.dart';
import '../screens/product_details_screen.dart';
import '../screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  MaterialColor mycolor = MaterialColor(
    Color.fromRGBO(255, 255, 0, 1).value,
    <int, Color>{
      50: Color.fromRGBO(0, 255, 136, 0.098),
      100: Color.fromRGBO(0, 204, 255, 0.2),
      200: Color.fromRGBO(0, 255, 191, 0.298),
      300: Color.fromRGBO(0, 174, 255, 0.4),
      400: Color.fromRGBO(0, 162, 255, 0.498),
      500: Color.fromRGBO(0, 60, 255, 0.6),
      600: Color.fromRGBO(0, 89, 255, 0.698),
      700: Color.fromRGBO(0, 60, 255, 0.8),
      800: Color.fromRGBO(0, 68, 255, 0.894),
      900: Color.fromRGBO(0, 17, 255, 1),
    },
  );
  @override
  Widget build(BuildContext context) {
    print("Build main\n\n");
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => auth_Provider(),
          ),
          ChangeNotifierProxyProvider<auth_Provider, Product_Provider>(
              create: (_) => Product_Provider(),
              update: (_, auth, products) {
                products!.authToken = auth.Token;
                products.userId = auth.UserId;
                return products;
              }),
          ChangeNotifierProvider(
            create: (ctx) => Cart_Provider(),
          ),
          ChangeNotifierProxyProvider<auth_Provider, Order_Provider>(
              create: (_) => Order_Provider(),
              update: (_, auth, orders) {
                orders!.authToken = auth.Token;
                orders.userId = auth.UserId;
                return orders;
              }),
        ],
        child: Consumer<auth_Provider>(
          builder: ((context, authObject, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Conf  Store',
                theme: ThemeData(
                    primarySwatch: mycolor,
                    accentColor: Colors.lightGreenAccent,
                    canvasColor: Colors.grey[300],
                    fontFamily: 'Lato'),
                home: authObject.auth
                    ? ProductOverviewScreen()
                    : FutureBuilder(
                        future: authObject.tryAutoLogIn(),
                        builder: ((context, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen();
                        }),
                      ),
                routes: {
                  AuthScreen.routeName: (ctx) => AuthScreen(),
                  ProductOverviewScreen.routeName: (ctx) =>
                      ProductOverviewScreen(),
                  ProductDetailsScreen.routName: (ctx) =>
                      ProductDetailsScreen(),
                  CartScreen.routName: (ctx) => CartScreen(),
                  OrderScreen.routName: (ctx) => OrderScreen(),
                  ManageProductScreen.routName: (ctx) => ManageProductScreen(),
                  AddEditProductScreen.routName: (ctx) =>
                      AddEditProductScreen(),
                },
              )),
        ));
  }
}
