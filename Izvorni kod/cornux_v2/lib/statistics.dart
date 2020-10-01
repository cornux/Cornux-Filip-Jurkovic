import 'dart:convert';

import 'package:cornux_v2/home.dart';
import 'package:cornux_v2/signIn.dart';
import 'package:cornux_v2/user.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart' as prefix0;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';


class Statistics extends StatefulWidget {
  final String api_key;
  final String calls;
  const Statistics({Key key, this.user, this.api_key, this.calls}) : super(key: key);
  final user;
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Center(
              child: Container(
            //Donji kvadrat
            width: 350,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Color(0xFF37383D),
            ),
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 25),
                child: Text(
                  'Godišnja potrošnja',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 200,
                width: 350,
                child: CustomRoundedBars.withSampleData(),
              )
            ]),
          )),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Center(
              child: Container(
            //Donji kvadrat
            width: 350,
            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Color(0xFF37383D),
            ),
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 25),
                child: Text(
                  'Mjesečna potrošnja',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 20,
                  width: 300,
                  child: LinearProgressIndicator(
                    value: (jsonDecode(widget.calls)[0])/(jsonDecode(widget.calls)[1]), // percent filled
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF40D383)),
                    backgroundColor: Color(0xFF4F5054),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25, bottom: 10),
                child: Text(
                  'Potrošeno ovaj mjesec: ${jsonDecode(widget.calls)[0]}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 25),
                child: Text(
                  'Mjesečni limit: ${jsonDecode(widget.calls)[1]}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
          )),
        ],
      )),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.

        elevation: 10000,
        child: ListView(
          // Important: Remove any padding from the ListView.
          children: <Widget>[
            Padding(padding: prefix0.EdgeInsets.only(top: 50)),
            ListTile(
              title: Text(
                'Početna',
                style: prefix0.TextStyle(color: Colors.white),
              ),
              trailing: prefix0.Icon(
                Icons.home,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: Home(
                      api_key: widget.api_key,
                      user: widget.user,
                      calls: widget.calls,
                    ),
                    duration: Duration(milliseconds: 400)));
              },
            ),
            ListTile(
              title: Text(
                'Statistika',
                style: prefix0.TextStyle(color: Colors.white),
              ),
              trailing: prefix0.Icon(
                Icons.show_chart,
                color: Colors.white,
              ),
              onTap: () {
                // Update the state of the app
                Navigator.pop(context);
                Navigator.of(context).push(PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: Statistics(
                      api_key: widget.api_key,
                      user: widget.user,
                      calls: widget.calls,
                    ),
                    duration: Duration(milliseconds: 400)));
                // ...
                // Then close the drawer
              },
            ),
            ListTile(
              title: Text(
                'O nama',
                style: prefix0.TextStyle(color: Colors.white),
              ),
              trailing: prefix0.Icon(
                Icons.person,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: About_Us(
                      api_key: widget.api_key,
                      user: widget.user,
                      calls: widget.calls,
                    ),
                    duration: Duration(milliseconds: 400)));
              },
            ),
            ListTile(
              title: Text(
                'Log out',
                style: prefix0.TextStyle(color: Colors.white),
              ),
              trailing: prefix0.Icon(
                Icons.input,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);

                final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                _signOut() async {
                  await _firebaseAuth.signOut();
                }

                _signOut();
                Navigator.of(context).push(PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: LoginPage(),
                    duration: Duration(milliseconds: 400)));
              },
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(
              Icons.dehaze,
              size: 32,
            ),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        elevation: 0,
        backgroundColor: Color(0xFF48494D),
      ),
    );
  }
}

class DrawCircle extends CustomPainter {
  Paint _paint;

  DrawCircle() {
    _paint = Paint()
      ..color = Color(0xFF40D383)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), 40, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CustomRoundedBars extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CustomRoundedBars(this.seriesList, {this.animate});

  /// Creates a [BarChart] with custom rounded bars.
  factory CustomRoundedBars.withSampleData() {
    return new CustomRoundedBars(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig(
          // By default, bar renderer will draw rounded bars with a constantarcRendererDecorators: [new charts.ArcLabelDecorator()],
          // radius of 100.

          // To not have any rounded corners, use [NoCornerStrategy]
          // To change the radius of the bars, use [ConstCornerStrategy]

          cornerStrategy: const charts.ConstCornerStrategy(30)),
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 10, // size in Pts.
                  color: charts.MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.white))),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 10, // size in Pts.
                  color: charts.MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.white))),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('Si', 5),
      new OrdinalSales('Ve', 25),
      new OrdinalSales('Ož', 100),
      new OrdinalSales('Tr', 75),
      new OrdinalSales('Sv', 5),
      new OrdinalSales('Li', 25),
      new OrdinalSales('Sr', 100),
      new OrdinalSales('Ko', 75),
      new OrdinalSales('Ru', 5),
      new OrdinalSales('Lis', 25),
      new OrdinalSales('St', 100),
      new OrdinalSales('Pr', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: '#40D383'),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
