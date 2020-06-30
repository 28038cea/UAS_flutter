import 'dart:convert';
import 'dart:io';

import 'package:flutter/src/rendering/box.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apotik/custom/currency.dart';
import 'package:apotik/custom/datePicker.dart';
import 'package:apotik/modal/api.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;

class AddProduk extends StatefulWidget {
  final VoidCallback reload;
  AddProduk(this.reload);
  @override
  _AddProdukState createState() => _AddProdukState();
}

class _AddProdukState extends State<AddProduk> {
  String namaProduk, qty, harga, idUsers, kategori;
  final _key = new GlobalKey<FormState>();
  File _imageFile;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  placeHolder() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: ListView(
              // shrinkWrap: true,
              children: <Widget>[
                Text("Chosen placeholder picture what you want"),
                SizedBox(
                  height: 10.0,
                  child: ListView(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new RaisedButton(
                        color: Colors.green[300],
                        onPressed: () {
                          _pilihGallery();
                        },
                        child: Text("Galery")),
                    SizedBox(
                      width: 16.0,
                    ),
                    new RaisedButton(
                        color: Colors.yellow[200],
                        onPressed: () {
                          _pilihKamera();
                        },
                        child: Text("Camera")),
                  ],
                ),
              ],
            ),
          );
        });
  }

  _pilihGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);

    setState(() {
      Navigator.pop(context);
      _imageFile = image;
    });
  }

  _pilihKamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      Navigator.pop(context);
      _imageFile = image;
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
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.addProduk);
      var request = http.MultipartRequest("POST", uri);

      request.fields['namaProduk'] = namaProduk;
      request.fields['qty'] = qty;
      request.fields['harga'] = harga.replaceAll(",", '');
      request.fields['idUsers'] = idUsers;
      request.fields['ExpDate'] = "$tgl";
      request.fields['kategori'] = kategori;

      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("image failed to uploaded");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  String pilihTanggal, labelText;
  DateTime tgl = DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(1992),
        lastDate: DateTime(2099));

    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        pilihTanggal = new DateFormat.yMd().format(tgl);
      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('images/placeholder2.png'),
    );
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: Text('ADD PRODUCT'),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 150.0,
              child: InkWell(
                onTap: () {
                  placeHolder();
                },
                child: _imageFile == null
                    ? placeholder
                    : Image.file(_imageFile, fit: BoxFit.fill),
              ),
            ),
            TextFormField(
              onSaved: (e) => namaProduk = e,
              decoration: InputDecoration(labelText: 'Name of Produk'),
            ),
            TextFormField(
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: 'Qty'),
            ),
            TextFormField(
              onSaved: (e) => kategori = e,
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            TextFormField(
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                CurrencyFormat()
              ],
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            DateDropDown(
              labelText: labelText,
              valueText: new DateFormat.yMd().format(tgl),
              valueStyle: valueStyle,
              onPressed: () {
                _selectedDate(context);
              },
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("SUBMIT"),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
