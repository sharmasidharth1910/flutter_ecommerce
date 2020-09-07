import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/pages/cart_page.dart';
import 'package:flutter_ecommerce/pages/register_page.dart';
import 'package:flutter_ecommerce/redux/actions.dart';
import 'package:flutter_ecommerce/widgets/product_item.dart';
import 'package:flutter_redux/flutter_redux.dart';

final gradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    stops: [
      0.1,
      0.3,
      0.5,
      0.7,
      0.9,
    ],
    colors: [
      Colors.deepOrange[300],
      Colors.deepOrange[400],
      Colors.deepOrange[500],
      Colors.deepOrange[600],
      Colors.deepOrange[700],
    ],
  ),
);

class ProductsPage extends StatefulWidget {
  static const String id = "ProductsPage";
  final Function() onInit;

  ProductsPage({
    this.onInit,
  });

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  final _appBar = PreferredSize(
    preferredSize: Size.fromHeight(60.0),
    child: StoreConnector<AppState, AppState>(
      builder: (context, state) {
        return AppBar(
          title: SizedBox(
            child: state.user != null
                ? Text(state.user.username)
                : FlatButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      RegisterPage.id,
                    ),
                    child: Text(
                      "Register Here",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
          ),
          centerTitle: true,
          leading: state.user != null
              ? IconButton(
                  icon: Icon(
                    Icons.store,
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    CartPage.id,
                  ),
                )
              : Text(""),
          actions: [
            StoreConnector<AppState, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(logoutUserAction);
              },
              builder: (_, callback) {
                return state.user != null
                    ? IconButton(
                        icon: Icon(Icons.exit_to_app),
                        onPressed: callback,
                      )
                    : Text("");
              },
            ),
          ],
        );
      },
      converter: (store) => store.state,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: Container(
            decoration: gradientBackground,
            child: StoreConnector<AppState, AppState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: SafeArea(
                        top: false,
                        bottom: false,
                        child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: state.products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                orientation == Orientation.portrait ? 2 : 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                            childAspectRatio:
                                orientation == Orientation.portrait ? 1.0 : 1.3,
                          ),
                          itemBuilder: (context, index) => ProductItem(
                            item: state.products[index],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              converter: (store) => store.state,
            ),
          ),
        );
      },
    );
  }
}
