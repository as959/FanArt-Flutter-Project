import 'package:fanart/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fanart/login.dart';
import 'package:fanart/signup.dart';

class SettingPage extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(
            'Settings',
            style: new TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile('user1', 'user1')),
              );
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Personal information"),
            ),
            FlatButton(
                child: Text(
                  "  Edit Profile",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                onPressed: () {}),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Support"),
            ),
            FlatButton(
                child: Text(
                  "  Get Help",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                onPressed: () {}),
            FlatButton(
                child: Text(
                  "  About",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                onPressed: () {}),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Actions"),
            ),
            FlatButton(
                child: Text(
                  "  Add account",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MySignForm()),
                  );
                }),
            FlatButton(
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "Log out  ",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyCustomForm()),
                        );
                      },
                    ),
                    Icon(Icons.exit_to_app)
                  ],
                ),
                onPressed: () {}),
          ],
        ));
  }
}
