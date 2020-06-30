import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apotik/modal/api.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String username, password, nama;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var validate = true;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    } else {
      setState(() {
        validate = true;
      });
    }
  }

  save() async {
    final response = await http.post(BaseUrl.register,
        body: {"nama": nama, "username": username, "password": password});

    final data = jsonDecode(response.body);

    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context, '/pages/login');
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/uwu.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Container(
            color: Colors.grey,
            width: double.infinity,
            height: double.infinity,
          ),
          new Form(
            autovalidate: validate,
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
                                  padding: const EdgeInsets.only(left: 12.0),

                                  //*********text form field nama********//

                                  child: new TextFormField(
                                    validator: (e) {
                                      if (e.isEmpty) {
                                        return "Please insert full name";
                                      }
                                    },
                                    onSaved: (e) => nama = e,
                                    decoration: InputDecoration(
                                      hintText: "Full Name",
                                      icon: Icon(Icons.people),
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
                                  padding: const EdgeInsets.only(left: 12.0),

                                  //********** text form field email**********//

                                  child: new TextFormField(
                                    validator: (e) {
                                      if (e.isEmpty) {
                                        return "Please insert email";
                                      }
                                    },
                                    onSaved: (e) => username = e,
                                    decoration: InputDecoration(
                                      hintText: "Email",
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
                                  padding: const EdgeInsets.only(left: 12.0),

                                  //***********text form field password***********//

                                  child: new TextFormField(
                                    obscureText: _secureText,
                                    validator: (e) {
                                      if (e.length < 5) {
                                        return "Minimal password 5 character";
                                      } else {
                                        return null;
                                      }
                                    },
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
                                check();
                              },
                            ),
                            new Padding(padding: EdgeInsets.only(top: 20)),
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
  }
}
