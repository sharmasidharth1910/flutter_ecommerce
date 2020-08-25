import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  static const id = "RegisterPage";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String _username, _password, _email;
  bool _obscureText = true;

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("Form valid");
      print(_email);
      print(_password);
      print(_username);
    } else {
      print("Form invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        RaisedButton(
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
