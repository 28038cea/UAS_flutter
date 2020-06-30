import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//own import

//import 'package:sweetfood/komponen/horizontal_listview.dart';
import 'package:apotik/modal/api.dart';
import 'package:apotik/modal/produkModel.dart';
import 'package:apotik/pages/product_detail.dart';

import 'oders.dart';
//import 'dart:async';

class HomePage extends StatefulWidget {
  final VoidCallback signOut;
  HomePage(this.signOut);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final money = NumberFormat("#,##0", "en_US");

  String idUsers;
  String username = "", nama = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      nama = preferences.getString("nama");
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
    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/apotek.jpg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: Text('APOTEK'),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.search, color: Colors.white), onPressed: () {})
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            //HEADER//
            new UserAccountsDrawerHeader(
              accountName: Text('$nama'),
              accountEmail: Text('$username'),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              decoration: new BoxDecoration(color: Colors.black),
            ),

            //BODY//
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new Orders()));
              },
              child: ListTile(
                title: Text('Orders'),
                leading: Icon(
                  Icons.fastfood,
                  color: Colors.black,
                ),
              ),
            ),

            Divider(),

            InkWell(
              onTap: () {
                setState(() {
                  widget.signOut();
                });
              },
              child: ListTile(
                title: Text('Log Out'),
                leading: Icon(
                  Icons.backspace,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: new Column(
        children: <Widget>[
          //IMAGE CAROUSEL
          image_carousel,

          //PADDING WIDGET
          new Padding(
            padding: const EdgeInsets.all(8.0),
          ),

          Container(
            alignment: Alignment.center,
            child: new Text(
              'RECENT PRODUCTS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),

          //GRID VIEW
          Flexible(
            child: GridView.builder(
              itemCount: list.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, i) {
                final x = list[i];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDetails(x)));
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Hero(
                            tag: x.id,
                            child: Image.network(
                              BaseUrl.placeholder + x.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          x.namaProduk,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          'Rp. ' + money.format(int.parse(x.harga)),
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
