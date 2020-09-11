import 'dart:convert';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/users.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Users Action
ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedUser = prefs.getString('user');
  final User user =
      storedUser != null ? User.fromJson(json.decode(storedUser)) : null;
  store.dispatch(GetUserAction(
    user,
  ));
};

ThunkAction<AppState> logoutUserAction = (Store<AppState> store) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  User user;
  store.dispatch(LogoutUserAction(user));
};

class LogoutUserAction {
  final User _user;

  User get user => this._user;

  LogoutUserAction(
    this._user,
  );
}

class GetUserAction {
  final User _user;

  User get user => this._user;

  GetUserAction(
    this._user,
  );
}

// Products Actions
ThunkAction<AppState> getProductsAction = (Store<AppState> store) async {
  http.Response response = await http.get("http://10.0.2.2:1337/products");
  final List<dynamic> responseData = json.decode(response.body);
  List<Product> products = [];
  responseData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    products.add(product);
  });
  store.dispatch(GetProductsAction(products));
};

class GetProductsAction {
  final List<Product> _products;

  GetProductsAction(this._products);

  List<Product> get products => this._products;
}

// Cart Products Actions

ThunkAction<AppState> toggleCartProductAction(Product cartProduct) {
  return (Store<AppState> store) async {
    final List<Product> cartProducts = store.state.cartProducts;
    final User user = store.state.user;
    final int index =
        cartProducts.indexWhere((element) => element.id == cartProduct.id);
    bool isInCart = index > -1 == true;
    List<Product> updatedCartProducts = List.from(cartProducts);
    if (isInCart) {
      updatedCartProducts.removeAt(index);
    } else {
      updatedCartProducts.add(cartProduct);
    }
    print("Button 2 Pressed");
    final List<String> cartProductsIds =
        updatedCartProducts.map((product) => product.id).toList();
    final http.Response result = await http.put(
      "http://10.0.2.2:1337/carts/${user.cartId}",
      body: json.encode({
        "products": cartProductsIds,
      }),
      headers: {
        "Authorization": "Bearer ${user.jwt}",
      },
    );
    print("Result of cartPut : ${json.decode(result.body)}");
    store.dispatch(ToggleCartProductAction(updatedCartProducts));
  };
}

ThunkAction<AppState> getCartProductsAction = (Store<AppState> store) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  if (storedUser == null) {
    return;
  }
  final User user = User.fromJson(json.decode(storedUser));
  final http.Response response = await http.get(
    "http://10.0.2.2:1337/carts/${user.cartId}",
    headers: {
      "Authorization": "Bearer ${user.jwt}",
    },
  );
  final responseData = json.decode(response.body)['products'];
  final List<Product> cartProducts = [];
  responseData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    cartProducts.add(product);
  });
  store.dispatch(GetCartProductsAction(cartProducts));
};

class GetCartProductsAction {
  final List<Product> _cartProducts;

  List<Product> get cartProducts => this._cartProducts;

  GetCartProductsAction(this._cartProducts);
}

class ToggleCartProductAction {
  final List<Product> _cartProducts;

  List<Product> get cartProducts => this._cartProducts;

  ToggleCartProductAction(this._cartProducts);
}
