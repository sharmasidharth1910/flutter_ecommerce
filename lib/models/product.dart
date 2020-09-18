import 'package:flutter/foundation.dart';

class Product {
  String id;
  String name;
  String description;
  Map<String, dynamic> picture;
  num price;

  Product({
    @required this.description,
    @required this.id,
    @required this.name,
    @required this.picture,
    @required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "picture": picture,
      "price": price,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      picture: json['picture'],
      price: json['price'],
    );
  }
}
