import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  static const id = "RegisterPage";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _username, _password, _email;
  bool _obscureText = true;
  bool isLoading = false;

  // void _registerUser() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final cart = await http.post("http://10.0.2.2:1337/carts");
  //   http.Response response = await http.post(
  //     "http://10.0.2.2:1337/auth/local/register",
  //     body: {
  // "username": _username,
  // "password": _password,
  // "email": _email,
  //     },
  //   );
  //   final responseData = json.decode(response.body);
  //   setState(() {
  //     isLoading = false;
  //   });
  //   print("Data from http request: $responseData");
  //   if (response.statusCode == 200) {
  //     // model.set('cart_id', cart.data.id);
  //     _saveUserData(responseData);
  //     _showSuccessSnackBar();
  //   } else {
  //     final errorMsg = responseData['message'][0]['messages'][0]['message'];
  //     _showErrorSnackBar(errorMsg);
  //   }
  // }

  void _registerUser() async {
    setState(
      () => isLoading = true,
    );

    // create a new cart
    var cartResponse = await http.post('http://10.0.2.2:1337/carts');
    final cartData = json.decode(cartResponse.body);
    if (cartResponse.statusCode == 200) {
      final http.Response result = await http.post(
        "https://api.stripe.com/v1/customers",
        headers: {
          "Authorization":
              "Bearer sk_test_51HQQNzAHq1q1hh4yKWHe7O3aw8R2oZGAmgC3qJdaFeHPOgdZ4K2PLihXV2h4PDzJVxbovkajcVJw1ZkbvdOI8XJ300vNw0Vaxe",
        },
        body: {
          "email": _email,
        },
      );

      print(json.decode(result.body)["id"]);

      print('new cart responseData: $cartData');
      final cartId = cartData['id'].toString();

      // create a new user
      var response =
          await http.post('http://10.0.2.2:1337/auth/local/register', body: {
        "username": _username,
        "password": _password,
        "email": _email,
        "cart_id": cartId,
        "customer_id": json.decode(result.body)["id"],
      });
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() => isLoading = false);
        _saveUserData(responseData);
        _showSuccessSnackBar();
        print('new user responseData: $responseData');
      } else {
        // because creating a user failed, delete the cart
        await http.delete(
          "https://api.stripe.com/v1/customers/${json.decode(result.body)["id"]}",
          headers: {
            "Authorization":
                "Bearer sk_test_51HQQNzAHq1q1hh4yKWHe7O3aw8R2oZGAmgC3qJdaFeHPOgdZ4K2PLihXV2h4PDzJVxbovkajcVJw1ZkbvdOI8XJ300vNw0Vaxe",
          },
        );
        await http.delete('http://10.0.2.2:1337/carts/$cartId');

        setState(() => isLoading = false);
        final String errorMsg =
            responseData['message'][0]['messages'][0]['message'];
        _showErrorSnackBar(errorMsg);
      }
    } else {
      setState(() => isLoading = false);
      final String errorMsg = cartData['message'];
      _showErrorSnackBar(errorMsg);
    }
  }

  void _saveUserData(responseData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData['user'];
    user.putIfAbsent("jwt", () => responseData['jwt']);
    prefs.setString('user', json.encode(user));
  }

  void _showErrorSnackBar(String errorMsg) {
    final SnackBar snackBar = SnackBar(
      content: Text(
        "$errorMsg",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
    print("Error: $errorMsg");
  }

  void _showSuccessSnackBar() {
    final SnackBar snackBar = SnackBar(
      content: Text(
        "User $_username created successfully",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
    _formKey.currentState.reset();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
        context,
        '/',
      );
    });
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _registerUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "REGISTER",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Register",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      onSaved: (value) => _username = value,
                      validator: (value) {
                        if (value.trim().length < 6) {
                          return "Username too short";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        labelText: "UserName",
                        labelStyle: TextStyle(
                          fontSize: 18.0,
                          // color: Theme.of(context).accentColor,
                        ),
                        hintText: "Enter username, min length 6",
                        icon: Icon(
                          Icons.face,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      onSaved: (value) => _email = value,
                      validator: (value) {
                        if (!value.trim().contains("@")) {
                          return "Please enter a valid email";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 18.0,
                          // color: Theme.of(context).accentColor,
                        ),
                        hintText: "Enter a valid email",
                        icon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      obscureText: _obscureText,
                      onSaved: (value) => _password = value,
                      validator: (value) {
                        if (value.trim().length < 6) {
                          return "Password too short";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 18.0,
                          // color: Theme.of(context).accentColor,
                        ),
                        hintText: "Enter password",
                        icon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Column(
                      children: [
                        isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).primaryColor,
                                ),
                              )
                            : RaisedButton(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 15.0,
                                ),
                                onPressed: _submit,
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                        FlatButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            LoginPage.id,
                          ),
                          child: Text(
                            'Existing user? Login',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
