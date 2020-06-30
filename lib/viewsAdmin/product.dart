import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:apotik/modal/api.dart';
import 'package:apotik/modal/produkModel.dart';
import 'package:apotik/viewsAdmin/addProduk.dart';
import 'package:apotik/viewsAdmin/editProduk.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final money = NumberFormat("#,##0", "en_US");
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
          api['image']
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Text("Are you sure to delete this product?"),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                     new RaisedButton(
                      color: Colors.green[300],
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text("No")
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    new RaisedButton(
                      color: Colors.red[400],
                      onPressed: (){
                        _delete(id);
                      },
                      child: Text("Yas")
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  _delete(String id) async {
    final response =
        await http.post(BaseUrl.deleteProduk, body: {"idProduk": id});

    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      Navigator.pop(context);
      setState(() {
        _lihatData();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddProduk(_lihatData)));
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(BaseUrl.placeholder + x.image, 
                        width: 100.0, 
                        height: 100.0,
                        fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                x.namaProduk,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(x.qty),
                              Text('Rp. ' + money.format(int.parse(x.harga))),
                              Text(x.nama),
                              Text(x.kategori),
                              Text('Exp '+ x.createdDate),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditProduk(x, _lihatData)));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            dialogDelete(x.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
