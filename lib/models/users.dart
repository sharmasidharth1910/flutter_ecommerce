import 'package:flutter/foundation.dart';

class User {
  String email;
  String username;
  String id;
  String jwt;
  String cartId;
  String customerId;

  User({
    @required this.email,
    @required this.id,
    @required this.jwt,
    @required this.username,
    @required this.cartId,
    @required this.customerId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      cartId: json['cart_id'],
      username: json['username'],
      email: json['email'],
      jwt: json['jwt'],
      customerId: json['customer_id'],
    );
  }
}
