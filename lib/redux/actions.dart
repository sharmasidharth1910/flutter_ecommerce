// User Actions

import 'dart:convert';

import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/users.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedUser = prefs.getString('user');
  final User user =
      storedUser != null ? User.fromJson(json.decode(storedUser)) : null;
  store.dispatch(GetUserAction(
    user,
  ));
};

class GetUserAction {
  final User _user;

  User get user => this._user;

  GetUserAction(
    this._user,
  );
}
