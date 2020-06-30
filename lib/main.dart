import 'package:flutter/material.dart';
// import 'package:sweetfood/pages/admin.dart';
import './pages/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
    routes: <String, WidgetBuilder>{
      // '/pages/admin': (BuildContext context)=> new AdminPage(),
      '/pages/login': (BuildContext context) => new Login(),
    },
  ));
}