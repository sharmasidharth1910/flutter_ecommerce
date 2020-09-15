import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/users.dart';
import 'package:flutter_ecommerce/widgets/credit_card.dart';
import 'package:flutter_ecommerce/widgets/product_item.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ecommerce/redux/actions.dart';

class CartPage extends StatefulWidget {
  static const String id = "CartPage";
  final void Function() onInit;

  CartPage({
    this.onInit,
  });

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    widget.onInit();
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            "pk_test_51HQQNzAHq1q1hh4yC2IdADgk9859QJPeam7gXDAg0YwtDJ5yt2clWpbnco3kVtGvw4eneMYbm8Jq90xBiUFHq61H00neUhEaEr",
      ),
    );
  }

  Widget _cartTab(state) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            top: false,
            bottom: false,
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: state.cartProducts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio:
                    orientation == Orientation.portrait ? 1.0 : 1.3,
              ),
              itemBuilder: (context, index) => ProductItem(
                item: state.cartProducts[index],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cardsTab(state) {
    dynamic _addCard(List<String> cardToken) async {
      final User user = state.user;
      // Update user's data to include the card token
      print("UserId: ${user.id}");
      print("UserJWT: ${user.jwt}");
      http.Response statusData = await http.put(
        "http://10.0.2.2:1337/users/${user.id}",
        body: {
          "card_token": cardToken[1],
        },
        headers: {
          "Authorization": "Bearer ${user.jwt}",
        },
      );
      print("status: ${statusData.statusCode}");
      // Associate the added card with the stripe customer
      http.Response response = await http.post(
        "http://10.0.2.2:1337/card/add",
        body: {
          "source": cardToken[0],
          "customer": user.customerId,
        },
      );
      final responseData = json.decode(response.body);
      return responseData;
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 10.0,
          ),
        ),
        RaisedButton(
          onPressed: () async {
            final List<String> cardToken = await Navigator.push<List<String>>(
              context,
              MaterialPageRoute(
                builder: (context) => CreditCardScreen(),
                fullscreenDialog: true,
              ),
            );
            print(cardToken);
            final card = await _addCard(cardToken);
            // Action to add card
            StoreProvider.of<AppState>(context).dispatch(AddCardAction(card));
            // Action to update token
            StoreProvider.of<AppState>(context)
                .dispatch(UpdateCardTokenAction(card["id"]));
            // Show SnackBar
            final SnackBar snackBar = SnackBar(
              content: Text(
                "Card Added",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
          },
          elevation: 8.0,
          child: Text("Add Card"),
        ),
        Expanded(
          child: ListView(
            children: state.cards
                .map<Widget>(
                  (c) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      child: Icon(
                        Icons.credit_card,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "${c["exp_month"]}/${c["exp_year"]}, ${c["last4"]}",
                    ),
                    subtitle: Text(c["brand"]),
                    trailing: state.cardToken == c["id"]
                        ? Chip(
                            label: Text("Primary Card"),
                            avatar: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : FlatButton(
                            onPressed: () {
                              print(c["id"]);
                              StoreProvider.of<AppState>(context)
                                  .dispatch(UpdateCardTokenAction(c["id"]));
                            },
                            child: Text(
                              "Set as primary",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _ordersTab(state) {
    return Text("Orders");
  }

  String calculateTotalPrice(cartProducts) {
    double totalPrice = 0.0;
    cartProducts.forEach((cartProduct) {
      totalPrice += cartProduct.price;
    });
    return totalPrice.toStringAsFixed(2);
  }

  Future _showCheckoutDialog(state) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          if (state.cards.length == 0) {
            return AlertDialog(
              title: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: 10.0,
                    ),
                    child: Text("Add Card"),
                  ),
                  Icon(Icons.credit_card, size: 60.0),
                ],
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      "Provide a credit card before checking out",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            );
          }
          String cartSummary = "";
          state.cartProducts.forEach((cartProduct) {
            cartSummary += ". ${cartProduct.name}, \$${cartProduct.price}\n";
          });
          final primaryCard = state.cards.singleWhere(
            (card) => card['id'] == state.cardToken,
          );
          print(primaryCard.toString());
          return AlertDialog(
            title: Text("Checkout"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    "CART ITEMS (${state.cartProducts.length})\n",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    "$cartSummary",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    "Card Details\n",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    "Brand: ${primaryCard['brand']}",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    "Card Number: ${primaryCard['last4']}",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    "Expires On: ${primaryCard['exp_month']}/${primaryCard['exp_year']}\n",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    "Order Total: \$${calculateTotalPrice(state.cartProducts)}",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context, false),
                color: Colors.red,
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              RaisedButton(
                color: Colors.green,
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "Checkout",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        }).then((value) async {
      _checkoutCartProducts() async {
        // Create new order in strapi
        http.post("http://10.0.2.2:1337/orders", body: {
          "amount": calculateTotalPrice(state.cartProducts),
          "products": json.encode(state.cartProducts),
          "source": state.cardToken,
          "customer": state.user.customerId,
        }, headers: {
          "Authorization": "Bearer ${state.user.jwt}",
        });
      }

      if (value == true) {
        print("Cart Checked Out");
        // Show Loading spinner
        setState(() {
          _isSubmitting = true;
        });
        // Checkout cart products
        await _checkoutCartProducts();
        // Create new order data in strapi
        // Make payment in stripe
        // Create order instance
        // Pass order instance to a new action (AddOrderAction)
        // Hide loading spinner
        // Show a success dialog
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) {
          return ModalProgressHUD(
            inAsyncCall: _isSubmitting,
            child: DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Scaffold(
                key: _scaffoldKey,
                floatingActionButton: state.cartProducts.length > 0
                    ? FloatingActionButton(
                        child: Icon(
                          Icons.local_atm,
                          size: 30.0,
                        ),
                        onPressed: () => _showCheckoutDialog(state),
                      )
                    : null,
                appBar: AppBar(
                  title: Text(
                    "Summary ${state.cartProducts.length} Items . \$${calculateTotalPrice(state.cartProducts)}",
                  ),
                  centerTitle: true,
                  bottom: TabBar(
                    labelColor: Colors.deepOrange[600],
                    unselectedLabelColor: Colors.deepOrange[900],
                    tabs: [
                      Tab(
                        icon: Icon(Icons.shopping_cart),
                      ),
                      Tab(
                        icon: Icon(Icons.credit_card),
                      ),
                      Tab(
                        icon: Icon(Icons.receipt),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    _cartTab(state),
                    _cardsTab(state),
                    _ordersTab(state),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
