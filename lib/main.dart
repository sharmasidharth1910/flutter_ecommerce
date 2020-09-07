import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/pages/cart_page.dart';
import 'package:flutter_ecommerce/pages/login_page.dart';
import 'package:flutter_ecommerce/pages/products_page.dart';
import 'package:flutter_ecommerce/pages/register_page.dart';
import 'package:flutter_ecommerce/redux/actions.dart';
import 'package:flutter_ecommerce/redux/reducers.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [
      thunkMiddleware,
      LoggingMiddleware.printer(),
    ],
  );
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({
    this.store,
  });

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Flutter E-Commerce',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.cyan[400],
          accentColor: Colors.deepOrange[200],
          textTheme: TextTheme(
            headline1: TextStyle(
              fontSize: 72.0,
              fontWeight: FontWeight.bold,
            ),
            // subtitle1: TextStyle(
            //   fontSize: 36.0,
            //   fontStyle: FontStyle.italic,
            // ),
            // bodyText1: TextStyle(
            //   fontSize: 18.0,
            // ),
          ),
        ),
        routes: {
          '/': (context) => ProductsPage(
                onInit: () {
                  // dispatch an action (UserAction) to grab user data
                  StoreProvider.of<AppState>(context).dispatch(getUserAction);
                  StoreProvider.of<AppState>(context)
                      .dispatch(getProductsAction);
                },
              ),
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          CartPage.id: (context) => CartPage(),
        },
      ),
    );
  }
}
