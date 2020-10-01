import 'dart:io';
import 'dart:convert';
import 'package:cornux_v2/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_table/json_table.dart';
import 'dart:async';

import 'package:page_transition/page_transition.dart';

class API extends StatefulWidget {
  final File slika;
  final String response;
  final String api_key;
  final String calls;
  final user;
  API({Key key, this.slika, this.response, this.user, this.api_key, this.calls})
      : super(key: key);

  @override
  _APIState createState() => _APIState();
}

class _APIState extends State<API> {
  var headerController;
  var valueController;
  var array = [];
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool changed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF48494D),
      appBar: AppBar(
        title: Text("Tablica dostavnice"),
        backgroundColor: Color(0xFF40D383),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              print(array);
              _handleSubmit(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Center(
              child: JsonTable(
            jsonDecode(widget.response),
            tableHeaderBuilder: (header) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5), color: Color(0xFF40D383)),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  controller: headerController =
                      TextEditingController(text: header),
                  onChanged: (text) {
                    header = text;
                    changed = true;
                    bool passedTime = false;
                    Timer(Duration(milliseconds: 400), () {
                      passedTime = false;
                      if (changed && passedTime) {
                        array.add(text);
                      }
                    });
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              );
            },
            tableCellBuilder: (value) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5, color: Colors.grey.withOpacity(0.5))),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  controller: valueController =
                      TextEditingController(text: value),
                  onChanged: (text) {
                    value = text;
                    changed = true;
                    bool passedTime = false;
                    Timer(Duration(milliseconds: 400), () {
                      passedTime = false;
                      if (changed && passedTime) {
                        array.add(text);
                      }
                    });
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              );
            },
            showColumnToggle: true,
          ))
        ],
      )),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: _keyLoader,
                  backgroundColor: Color(0xFF48494D),
                  contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        Icon(
                          Icons.done,
                          size: 60,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text("Poslano",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)))
                      ]),
                    )
                  ]));
        });
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).push(PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: Home(
            api_key: widget.api_key,
            user: widget.user,
            calls: widget.calls,
          ),
          duration: Duration(milliseconds: 400)));
    });
  }
}
