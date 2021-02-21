import 'package:fanart/home.dart';
import 'package:flutter/material.dart';
import 'package:fanart/signup.dart';
import 'package:fanart/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  final  user = auth.currentUser;
  runApp(MyApp(user));
}

class MyApp extends StatelessWidget {
  var user;
  MyApp(this.user);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: IntroPage(this.user));
  }
}

class IntroPage extends StatelessWidget {
  var user;
  IntroPage(this.user);
  @override
  Widget build(BuildContext context) {
    return user!=null?
    Home()
    :Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Zengo",
            style: TextStyle(
                color: Colors.teal[200],
                fontFamily: 'Lob',
                fontSize: 40.0,
                fontWeight: FontWeight.w200),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 25, 0, 22),
              height: 300.0,
              width: double.infinity,
              child: Image(
                  image: AssetImage("assets/intro_img.jpg"),
                  fit: BoxFit.cover)),
          Text(
            "Share your fan-art with the community today !",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.teal[200],
              fontSize: 20.0,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.teal[200]),
            margin: EdgeInsets.fromLTRB(30, 15, 30, 10),
            height: 80.0,
            width: 250.0,
            child: FlatButton(
                child: Text("Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    )),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MySignForm()),
                  );
                }),
          ),
          FlatButton(
            hoverColor: Colors.grey[100],
            child: Text(
              "Already have an account?",
              style: TextStyle(
                  color: Colors.teal[200],
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCustomForm()),
              );
            },
          )
        ],
      ),
    );
  }
}
