import 'dart:convert';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sweetfood/custom/datePicker.dart';
import 'package:apotik/modal/api.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String namaBarang, jumlahPesanan, alamat, phoneNo, reqOrder, idUsers;

  final _key = new GlobalKey<FormState>();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    final response = await http.post(BaseUrl.orders, body: {
      "namaBarang": namaBarang,
      "jumlahPesanan": jumlahPesanan,
      "alamat": alamat,
      "phoneNo": phoneNo,
      "reqOrder": reqOrder,
      "idUsers": idUsers
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(print);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: Text('ORDER'),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              onSaved: (e) => namaBarang = e,
              decoration: InputDecoration(labelText: 'Name Product'),
            ),
            TextFormField(
              onSaved: (e) => jumlahPesanan = e,
              decoration: InputDecoration(labelText: 'Much Orders'),
            ),
            TextFormField(
              onSaved: (e) => alamat = e,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              onSaved: (e) => phoneNo = e,
              decoration: InputDecoration(labelText: 'Phone Nomor'),
            ),
            TextFormField(
              onSaved: (e) => reqOrder = e,
              decoration: InputDecoration(labelText: 'Request Product'),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text(
                "ORDER",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
