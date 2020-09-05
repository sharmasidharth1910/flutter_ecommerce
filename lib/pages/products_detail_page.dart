import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/pages/products_page.dart';

class ProductsDetailPage extends StatelessWidget {
  final Product item;

  ProductsDetailPage({
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
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
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              "\$" + item.price.toString(),
              style: Theme.of(context).textTheme.bodyText1,
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
