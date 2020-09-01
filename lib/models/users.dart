import 'package:flutter/foundation.dart';

class User {
  String email;
  String username;
  String id;
  String jwt;

  User({
    @required this.email,
    @required this.id,
    @required this.jwt,
    @required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      jwt: json['jwt'],
    );
  }
}
