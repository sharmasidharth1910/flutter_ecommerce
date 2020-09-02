import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

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

  AppBar _appBar() {
    return AppBar(
      title: Text("Products"),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(),
          body: SingleChildScrollView(
            child: state.user != null
                ? Text(
                    state.user.username +
                        "  " +
                        state.user.jwt +
                        "  " +
                        state.user.email,
                  )
                : Text(
                    "No Data",
                  ),
          ),
        );
      },
    );
  }
}
