import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  static const String id = "ProductsPage";

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Products Page"),
    );
  }
}
