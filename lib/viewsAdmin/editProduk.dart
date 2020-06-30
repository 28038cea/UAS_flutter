import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apotik/modal/api.dart';
import 'package:apotik/modal/produkModel.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class EditProduk extends StatefulWidget {
  final ProdukModel model;
  final VoidCallback reload;
  EditProduk(this.model, this.reload);

  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _key = new GlobalKey<FormState>();
  String namaProduk, qty, harga, kategori, idUsers, tgl;
  File _imageFile;

  _pilihGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);

    setState(() {
      Navigator.pop(context);
      _imageFile = image;
    });
  }

  placeHolder() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Text("Chosen placeholder picture what you want"),
                SizedBox(
                  height: 10.0,
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

  _pilihKamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      Navigator.pop(context);
      _imageFile = image;
    });
  }

  TextEditingController txtNama, txtQty, txtHarga, txtKategori;

  setup() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    txtNama = TextEditingController(text: widget.model.namaProduk);
    txtQty = TextEditingController(text: widget.model.qty);
    txtHarga = TextEditingController(text: widget.model.harga);
    txtKategori = TextEditingController(text: widget.model.kategori);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.editProduk);
      var request = http.MultipartRequest("POST", uri);

      request.fields['namaProduk'] = namaProduk;
      request.fields['qty'] = qty;
      request.fields['harga'] = harga.replaceAll(",", '');
      request.fields['kategori'] = kategori;
      request.fields['idUsers'] = idUsers;
      request.fields['idProduk'] = widget.model.id;
      request.fields['ExpDate'] = "$tgl";

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

    // final response = await http.post(BaseUrl.editProduk, body: {
    //   "namaProduk" : namaProduk,
    //   "qty" : qty,
    //   "harga" : harga,
    //   "idProduk" : widget.model.id
    // });

    // final data = jsonDecode(response.body);
    // int value = data['value'];
    // String pesan = data['message'];
    // if (value == 1) {
    //   setState(() {
    //     widget.reload();
    //     Navigator.pop(context);
    //   });
    // } else {
    //   print(pesan);
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text('EDIT PRODUCT'),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.search, color: Colors.white), onPressed: () {}),
          new IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {})
        ],
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
                    ? Image.network(BaseUrl.placeholder + widget.model.image)
                    : Image.file(_imageFile, fit: BoxFit.fill),
              ),
            ),
            TextFormField(
              controller: txtNama,
              onSaved: (e) => namaProduk = e,
              decoration: InputDecoration(labelText: 'Name of Produk'),
            ),
            TextFormField(
              controller: txtQty,
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: 'Qty'),
            ),
            TextFormField(
              controller: txtHarga,
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextFormField(
              controller: txtKategori,
              onSaved: (e) => kategori = e,
              decoration: InputDecoration(labelText: 'Kategori'),
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
