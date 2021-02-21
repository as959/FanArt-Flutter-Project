//import 'package:fanart/takePic.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'profile_page.dart';
import 'package:fanart/posts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fanart/uploadImage.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference myRef = database.reference();
DatabaseReference postRef = myRef.child('posts');

class Home extends StatefulWidget {
  static String id = 'home';

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  // This widget is the root of your application.
  String username;
  String user;
  String header;
  bool isOpen;
  bool menuOn;
  bool flag;
  bool s = false;
  CameraDescription camera;
  List<Widget> homePosts = new List();
  List<Widget> userPosts;
  HomeState() {
    print("Hello There");
    flag = false;
    if (Uploader.username == null) Uploader.getUsername();
    header =
        Uploader.username == null ? 'waiting for username' : Uploader.username;
    isOpen = false;
    menuOn = false;

    ;
  }

  @override
  Widget build(BuildContext context) {
    if (homePosts.length == 0) {
      postRef.once().then((DataSnapshot snapshot) {
        print(snapshot.value);
        try {
          List<dynamic> values = snapshot.value;
          print(values);
          var counter = 0;
          for (Map x in values) {
            print("X is " + x.toString());
            String temp = 'posts/' + counter.toString();
            print("hey" + temp);
            homePosts.add(Post(ref: temp));
            counter += 1;
          }
          setState(() {});
        } catch (e) {
          var x = snapshot.value.keys.toString()[1];
          print("hi " + x);
          String temp = 'posts/' + x;
          print("hey" + temp);
          homePosts.add(Post(ref: temp));
        }
      });
    }
    print(homePosts.length);
    return MaterialApp(
        title: header,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Stack(children: [
          Scaffold(
            appBar: AppBar(
              title: Text(
                "FanArt",
                style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: 15.0,
                    color: Colors.white,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: Column(children: [
              Expanded(
                child: homePosts.length == 0
                    ? Container(
                      child:Text("Hello There"),
                    )
                    : ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: homePosts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return homePosts[homePosts.length - index - 1];
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
              ),
              SizedBox(
                height: 70,
              ),
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 65.0,
              width: 300.0,
              margin: EdgeInsets.only(bottom: 35),
              decoration: BoxDecoration(
                  color: Colors.teal[200],
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        tooltip: 'Search',
                        icon: Icon(Icons.search),
                        onPressed: null,
                      ),
                      IconButton(
                          tooltip: 'Click from Camera',
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () {
                            Uploader.imgFromCam();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(),
                              ),
                            );
                          }),
                      IconButton(
                          tooltip: 'Upload from Gallery',
                          icon: Icon(Icons.add_photo_alternate),
                          onPressed: () {
                            Uploader.imgFromGallery();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(),
                              ),
                            );
                          }),
                      IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ]));
  }
}
