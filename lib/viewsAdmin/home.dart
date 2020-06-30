import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Text(
              "Dashboard",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

//  class Sales {
//    final String day;
//    final int sold;
//    final charts.Color color;

//    Sales(this.day, this.sold, Color color)
//    :this.color=charts.Color(r: color.red,g: color.green, b: color.blue, a: color.alpha)
//    ;
