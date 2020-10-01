import 'package:cornux_v2/home.dart';
import 'package:cornux_v2/signIn.dart';
import 'package:cornux_v2/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class About_Us extends StatefulWidget {
  final String api_key;
  final String calls;
  const About_Us({Key key, this.user, this.api_key, this.calls})
      : super(key: key);
  final user;
  @override
  _About_Us_State createState() => _About_Us_State();
}

class _About_Us_State extends State<About_Us> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String address;
  String body;
  final subjectContoroller = TextEditingController();
  final bodyContoroller = TextEditingController();
  double _width = 350;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
          child: Center(
        child: Column(children: <Widget>[
          Image.asset(
            'assets/logo.png',
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
          ),
          Image.asset(
            'assets/Component1.png',
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
          ),
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 350,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Color(0xFF37383D),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  width: 250,
                  child: TextFormField(
                    controller: subjectContoroller,
                    decoration: new InputDecoration(
                      labelText: "Predmet",
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    onChanged: (text) {
                      address = text;
                    },
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 76,
                child: Container(
                  width: 320,
                  child: TextFormField(
                    controller: bodyContoroller,
                    decoration: new InputDecoration(
                      labelText: "Poruka",
                      alignLabelWithHint: true,
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    maxLines: 9,
                    onChanged: (text) {
                      body = text;
                    },
                  ),
                ),
              ),
              Positioned(
                top: 230,
                left: 250,
                child: RaisedButton(
                  onPressed: () {
                    final Email email = Email(
                      body: body,
                      subject: address,
                      recipients: ['cornux.croatia@gmail.com'],
                      isHTML: false,
                    );

                    FlutterEmailSender.send(email);
                    subjectContoroller.clear();
                    bodyContoroller.clear();
                  },
                  child: Text('POŠALJI'),
                  color: Color(0xFF40D383),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Color(0xFF40D383))),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
          ),
          Stack(
            children: <Widget>[
              Image.asset(
                'assets/map.png',
              ),
            ],
          ),
        ]),
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
