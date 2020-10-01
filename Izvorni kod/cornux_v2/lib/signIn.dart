import 'dart:convert';

import 'package:cornux_v2/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  String _email;
  String _password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  double _width = 250;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  Color errorColor = Colors.white;
  Color textColor = Colors.transparent;
  bool loggedIn = false;

  AnimationController rippleController;
  AnimationController scaleController;

  Animation<double> rippleAnimation;
  Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF48494D),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  color: Color(0xFF37383D),
                ),
                //height: 200,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: _width,
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Text(
                            'Netočni korisnički podatci!',
                            style: TextStyle(color: textColor),
                          ),
                          TextField(
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: errorColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                          ),
                          TextField(
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: errorColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),
                    RaisedButton(
                      onPressed: () {
                        _handleSubmit(context);
                      },
                      child: Text('LOGIN'),
                      color: Color(0xFF40D383),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Color(0xFF40D383))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Molimo pričekajte....",
                            style: TextStyle(color: Colors.white))
                      ]),
                    )
                  ]));
        });

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((AuthResult user) {
      String api = " ";
      Future<String> inputData() async {
        final FirebaseUser user = await FirebaseAuth.instance.currentUser();
        api = user.uid.toString();
        final String url = "http://cornux.net/availableCalls/${api}";
        var response = await http.get(Uri.encodeFull(url));
        print(response.body);
        loggedIn = true;
        Navigator.of(context, rootNavigator: true).pop(); //close the dialoge
        errorColor = Colors.white;
        textColor = Colors.transparent;
        Navigator.of(context).push(PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: Home(
              user: _email,
              api_key: api,
              calls: response.body,
            ),
            duration: Duration(milliseconds: 400)));
        return api;
      }

      inputData();
    }).catchError((e) {
      loggedIn = false;
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        textColor = Colors.redAccent;
        errorColor = Colors.redAccent;
      });
      print('error');
    });
  }
}
