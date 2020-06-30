import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apotik/modal/api.dart';
import 'package:apotik/modal/produkModel.dart';
import 'package:http/http.dart' as http;
import 'package:apotik/pages/oders.dart';
//import 'home.dart';

class ProductDetails extends StatefulWidget {
  final ProdukModel model;
  ProductDetails(this.model);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final money = NumberFormat("#,##0", "en_US");
  String idUsers;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
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
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: InkWell(child: Text('APOTEK')),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.search, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Hero(
                  tag: widget.model.id,
                  child: Image.network(
                    BaseUrl.placeholder + widget.model.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(
                  leading: new Text(
                    widget.model.namaProduk,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  title: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text(
                            'Rp. ' +
                                money.format(int.parse(widget.model.harga)),
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          //    ================ 2ND BUTTOM ====================
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new Orders()));
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  elevation: 0.2,
                  child: new Text("Order Now"),
                ),
              ),
              new IconButton(
                  icon: Icon(Icons.add_shopping_cart, color: Colors.red),
                  onPressed: () {}),
            ],
          ),
          Divider(),
          new ListTile(
              title: new Text("Product Details"),
              subtitle: new Text(
                  "Dapur Papa El merupakan store cake, dessert & drink kekinian yang ada di Singaraja, Dapur Papa El mempunyai dua cabang store, yaitu di Singaraja dan Di Seririt")),
          Divider(),
          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Product name",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text(widget.model.namaProduk),
              )
            ],
          ),

          new Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text(
                  "Product condition",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: new Text("New"),
              )
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text("Similar products"),
          ),

// ================= SIMILAR PRODUCT SECTION========================

          Container(
            height: 340.0,
            child: Similar_products(),
          )
        ],
      ),
    );
  }
}

class Similar_products extends StatefulWidget {
  @override
  _Similar_productsState createState() => _Similar_productsState();
}

class _Similar_productsState extends State<Similar_products> {
  final money = NumberFormat("#,##0", "en_US");

  String idUsers;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    _lihatData();
  }

  var loading = false;
  final list = new List<ProdukModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.lihatProduk);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new ProdukModel(
            api['id'],
            api['namaProduk'],
            api['qty'],
            api['harga'],
            api['createdDate'],
            api['idUsers'],
            api['nama'],
            api['kategori'],
            api['image']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  tambahKeranjang(String idProduk, String harga) async {
    final response = await http.post(BaseUrl.tambahKeranjang, body: {
      "idUsers": idUsers,
      "idProduk": idProduk,
      "harga": harga,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
    } else {
      print(pesan);
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
    return GridView.builder(
      itemCount: list.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, i) {
        final x = list[i];
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductDetails(x)));
          },
          child: Card(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image.network(
                    BaseUrl.placeholder + x.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  x.namaProduk,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Text(
                  'Rp. ' + money.format(int.parse(x.harga)),
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
