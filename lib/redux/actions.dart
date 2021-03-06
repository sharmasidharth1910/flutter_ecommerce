import 'dart:convert';
import 'package:flutter_ecommerce/models/order.dart';
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
  print("Products data: $responseData");
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

ThunkAction<AppState> clearCartProductsAction = (Store<AppState> store) async {
  final User user = store.state.user;
  await http.put(
    "http://10.0.2.2:1337/carts/${user.cartId}",
    body: json.encode({
      "products": [],
    }),
    headers: {
      "Authorization": "Bearer ${user.jwt}",
    },
  );
  store.dispatch(ClearCartProductsAction(List(0)));
};

class ClearCartProductsAction {
  final List<Product> _cartProducts;

  ClearCartProductsAction(this._cartProducts);

  List<Product> get cartProducts => this._cartProducts;
}

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

// Card Actions

ThunkAction<AppState> getCardsAction = (Store<AppState> store) async {
  final String customerId = store.state.user.customerId;
  print("Customer ID : $customerId");
  http.Response response =
      await http.get("http://10.0.2.2:1337/card?$customerId");
  final responseData = json.decode(response.body);
  store.dispatch(GetCardsAction(responseData));
};

class GetCardsAction {
  final List<dynamic> _cards;

  GetCardsAction(this._cards);

  List<dynamic> get cards => this._cards;
}

class AddCardAction {
  final dynamic _card;

  AddCardAction(this._card);

  dynamic get card => this._card;
}

// Card Token actions

ThunkAction<AppState> getCardTokenAction = (Store<AppState> store) async {
  final String jwt = store.state.user.jwt;
  final http.Response response =
      await http.get("http://10.0.2.2:1337/users/me", headers: {
    "Authorization": "Bearer $jwt",
  });
  final responseData = json.decode(response.body);
  print("Response from get user data: $responseData");
  final http.Response response1 =
      await http.get("http://10.0.2.2:1337/orders", headers: {
    "Authorization": "Bearer $jwt",
  });
  final responseData1 = json.decode(response1.body);
  List<Order> orders = [];
  print("Response from get orders Data : $responseData1");
  responseData['orders'].forEach((orderData) {
    final Order order = Order.fromJson(orderData);
    orders.add(order);
  });
  final String cardToken = responseData['card_token'];
  store.dispatch(GetCardTokenAction(cardToken));
  store.dispatch(GetOrdersAction(orders));
};

class GetOrdersAction {
  final List<Order> _orders;

  GetOrdersAction(this._orders);

  List<Order> get orders => this._orders;
}

class UpdateCardTokenAction {
  final String _cardToken;

  String get cardToken => this._cardToken;

  UpdateCardTokenAction(this._cardToken);
}

class GetCardTokenAction {
  final String _cardToken;

  String get cardToken => this._cardToken;

  GetCardTokenAction(this._cardToken);
}

//Orders actions

class AddOrderAction {
  final Order _order;

  AddOrderAction(this._order);

  Order get order => this._order;
}
