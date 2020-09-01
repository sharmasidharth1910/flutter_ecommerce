import 'dart:convert';
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Text(
            json.encode(state.user),
          ),
        );
      },
    );
  }
}
