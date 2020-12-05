//import 'package:fanart/takePic.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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
  CameraDescription camera;
  List<Widget> homePosts = new List();
  List<Widget> userPosts;
  HomeState() {
    header = 'user1';
    isOpen = false;
    menuOn = false;

    if (homePosts.length == 0) {
      postRef.once().then((DataSnapshot snapshot) {
        setState(() {});
        List<dynamic> values = snapshot.value;
        int counter = 0;
        for (Map x in values) {
          String temp = 'posts/' + counter.toString();
          homePosts.add(FriendPost(ref: temp));
          counter += 1;
        }
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
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
                "Other's Artpages",
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
                    ? Container()
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
                                builder: (context) => Profile("user1", "user1"),
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
                                builder: (context) => Profile("user1", "user1"),
                              ),
                            );
                          }),
                      IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile('user1', 'user1'),
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
