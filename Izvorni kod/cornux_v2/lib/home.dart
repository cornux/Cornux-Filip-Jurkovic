import 'dart:io';
import 'dart:convert';
import 'package:cornux_v2/signIn.dart';
import 'package:cornux_v2/statistics.dart';
import 'package:cornux_v2/user.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cornux_v2/API_layer.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as Path;
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  final String api_key;
  final String calls;
  const Home({Key key, this.user, this.api_key, this.calls}) : super(key: key);
  final user;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _handleSubmit(BuildContext context, File imageFile) async {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
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

    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse("http://cornux.net/upload/${widget.api_key}");
    print(uri);
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: Path.basename(imageFile.path));

    request.files.add(multipartFile);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => API(
                    slika: imageFile,
                    response: value,
                    api_key: widget.api_key,
                    user: widget.user,
                  )));
    });
  }

  openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _handleSubmit(context, image);
  }

  openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _handleSubmit(context, image);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF48494D),
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
          padding: EdgeInsets.all(10.0),
        ),
        Text('${widget.user.toString()}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            )),
        Padding(
          padding: EdgeInsets.all(30.0),
        ),
        Container(
            // Gornji kvadrat
            width: 350,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Color(0xFF37383D),
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 25),
                    child: Text(
                      'Skeniranje',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(children: <Widget>[
                        Material(
                          color: Colors.transparent, // button color
                          child: InkWell(
                            splashColor: Color(0xFF40D383), // inkwell color
                            child: SizedBox(
                                width: 80,
                                height: 80,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 48.0,
                                  color: Colors.white,
                                )),
                            onTap: () {
                              openCamera();
                            },
                            borderRadius:
                                BorderRadius.all(new Radius.circular(40.0)),
                          ),
                          shape: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF40D383), width: 2),
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(40.0))),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Nova',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            )),
                        Text(
                          'fotografija',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                      Padding(
                        padding: EdgeInsets.only(left: 50),
                        child: Column(children: <Widget>[
                          Material(
                            color: Colors.transparent, // button color
                            child: InkWell(
                              splashColor: Color(0xFF40D383), // inkwell color
                              child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Icon(
                                    Icons.attach_file,
                                    size: 48.0,
                                    color: Colors.white,
                                  )),
                              onTap: () {
                                openGallery();
                              },
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(40.0)),
                            ),
                            shape: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF40D383), width: 2),
                                borderRadius: BorderRadius.all(
                                    new Radius.circular(40.0))),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Iz',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              )),
                          Text(
                            'galerije',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        Padding(
          padding: EdgeInsets.all(30.0),
        ),
        Container(
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
        )
      ]))),
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

