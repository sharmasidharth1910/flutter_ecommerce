import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsPage extends StatefulWidget {
  static const String id = "ProductsPage";

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  _getUser() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var userData = preferences.getString("user");
    print("Data in Products Page");
    print(json.decode(userData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Products Page"),
    );
  }
}
