import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/pages/products_page.dart';
import 'package:flutter_ecommerce/redux/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductsDetailPage extends StatelessWidget {
  final Product item;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductsDetailPage({
    this.item,
  });

  bool _isInCart(AppState state, String id) {
    final List<Product> cartProducts = state.cartProducts;
    return cartProducts.indexWhere((element) => element.id == id) > -1;
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(item.name),
        centerTitle: true,
      ),
      body: Container(
        decoration: gradientBackground,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 10.0,
              ),
              child: Hero(
                tag: item,
                child: Image.network(
                  "http://10.0.2.2:1337${item.picture['url']}",
                  height: orientation == Orientation.portrait ? 400 : 200,
                  width: orientation == Orientation.portrait ? 600 : 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              item.name,
              style: TextStyle(
                fontSize: 36.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              "\$" + item.price.toString(),
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              child: StoreConnector<AppState, AppState>(
                builder: (_, state) {
                  return state.user != null
                      ? IconButton(
                          icon: Icon(Icons.shopping_cart),
                          color: _isInCart(state, item.id)
                              ? Colors.cyan[700]
                              : Colors.white,
                          onPressed: () {
                            StoreProvider.of<AppState>(context).dispatch(
                              toggleCartProductAction(item),
                            );
                            final SnackBar snackBar = SnackBar(
                              content: Text(
                                "Cart Updated",
                                style: TextStyle(
                                  color: Colors.green[900],
                                ),
                              ),
                              duration: Duration(
                                seconds: 2,
                              ),
                            );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          },
                        )
                      : Text("");
                },
                converter: (store) => store.state,
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 32.0,
                    left: 32.0,
                    right: 32.0,
                  ),
                  child: Text(
                    item.description,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
