import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apotik/modal/api.dart';
import 'admin.dart';
import 'home.dart';
import 'register.dart';
import 'dart:convert';
//import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn, signInUsers }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  String username, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var _autovalidate = false;
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  login() async {
    final response = await http.post(BaseUrl.login,
        body: {"username": username, "password": password});

    final data = jsonDecode(response.body);

    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String namaAPI = data['nama'];
    String id = data['id'];
    String level = data['level'];
    if (value == 1) {
      //Control flow pengecekan Level
      if (level == "1") {
        setState(() {
          _loginStatus = LoginStatus.signIn;
          savePref(value, usernameAPI, namaAPI, id, level);
        });
      } else {
        setState(() {
          _loginStatus = LoginStatus.signInUsers;
          savePref(value, usernameAPI, namaAPI, id, level);
        });
      }
      print(pesan);
    } else {
      print(pesan);
    }
  }

  savePref(
      int value, String username, String nama, String id, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("username", username);
      preferences.setString("id", id);
      preferences.setString("level", level);
      preferences.commit();
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      //preferences.setString("level", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == "1"
          ? LoginStatus.signIn
          : value == "2" ? LoginStatus.signInUsers : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Image.asset(
                'images/uwu.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Container(
                color: Colors.grey.withOpacity(0.4),
                width: double.infinity,
                height: double.infinity,
              ),
              new Form(
                autovalidate: _autovalidate,
                key: _key,
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: new Column(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(top: 80),
                          ),
                          new Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white.withOpacity(0.5),
                                    elevation: 0.0,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),

                                      // ************text form field email************* //

                                      child: new TextFormField(
                                        validator: (e) {
                                          if (!e.contains("@")) {
                                            return "Wrong format email";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onSaved: (e) => username = e,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Enter your email address..",
                                          icon: Icon(Icons.email),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                new Padding(padding: EdgeInsets.only(top: 20)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white.withOpacity(0.5),
                                    elevation: 0.0,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),

                                      // ********text form feald password******** //

                                      child: new TextFormField(
                                        obscureText: _secureText,
                                        onSaved: (e) => password = e,
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          suffixIcon: IconButton(
                                              icon: Icon(_secureText
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                              onPressed: showHide),
                                          icon: Icon(Icons.lock_outline),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                new Padding(padding: EdgeInsets.only(top: 20)),
                                new RaisedButton(
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      new Text(
                                        "Login",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                  color: Colors.black87,
                                  onPressed: () {
                                    check();
                                  },
                                ),
                                new RaisedButton(
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      new Text(
                                        "Register",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                  color: Colors.white70,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Register()));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      case LoginStatus.signIn:
        return AdminPage(signOut);
        break;
      case LoginStatus.signInUsers:
        return HomePage(signOut);
        break;
    }
  }
}
