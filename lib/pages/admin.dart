import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apotik/viewsAdmin/home.dart';
import 'package:apotik/viewsAdmin/product.dart';
import 'package:apotik/viewsAdmin/profile.dart';
// import 'package:apotik/viewsAdmin/users.dart';

class AdminPage extends StatefulWidget {
  final VoidCallback signOut;
  AdminPage(this.signOut);
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "", nama = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      nama = preferences.getString("nama");
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.black,
          title: Text('APOTEK'),
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
              onTap: () {Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new Home()));
              },
              child: ListTile(
                title: Text('Grafic'),
                leading: Icon(
                  Icons.insert_chart,
                  color: Colors.black,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new Product()));
              },
              child: ListTile(
                title: Text('Product'),
                leading: Icon(
                  Icons.grid_on,
                  color: Colors.black,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new Profile()));
              },
              child: ListTile(
                title: Text('Profile'),
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.black,
                ),
              ),
            ),

            Divider(),

            InkWell(
              onTap: () {
                signOut();
              },
              child: ListTile(
                title: Text('Log Out'),
                leading: Icon(
                  Icons.backspace,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
        body: TabBarView(
          children: <Widget>[
            Home(),
            Product(),
            // Users(),
            Profile(),
          ],
        ),
        bottomNavigationBar: TabBar(
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              style: BorderStyle.none
            )
          ),
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
              text: "Home",
            ),
            Tab(
              icon: Icon(Icons.apps),
              text: "Product",
            ),
            Tab(
              icon: Icon(Icons.account_circle),
              text: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
