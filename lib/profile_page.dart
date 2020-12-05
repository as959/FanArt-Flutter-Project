import 'package:flutter/material.dart';
import 'package:fanart/posts.dart';
import 'package:fanart/home.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fanart/uploadImage.dart';
import 'dart:io';
import 'settings.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference myRef = database.reference();
DatabaseReference postRef = myRef.child('posts');

class Profile extends StatefulWidget {
  final String username;
  final String user;
  Profile(this.username, this.user);
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> with TickerProviderStateMixin {
  // This widget is the root of your application.
  String username;
  String user;
  Image img;
  String header;
  bool isOpen;
  bool menuOn;
  var myAnimation;
  List<Widget> posts = new List();
  ProfileState() {
    isOpen = false;
    menuOn = false;
    myAnimation = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    if (posts.length == 0) {
      postRef.once().then((DataSnapshot snapshot) {
        setState(() {});
        List<dynamic> values = snapshot.value;
        print(values.toString());

        for (Map x in values) {
          print("Hey" + x.toString());
          if (x['posterid'] == '1') {
            posts.add(GridPost(
              username: 'user1',
              img: Image.network(x['ImagePath']),
            ));
          }
        }
      });
    }
    ;
  }

  void newPostOptions() {}
  void animate() {
    if (isOpen) {
      myAnimation.forward();
      setState(() {
        menuOn = true;
      });
    } else {
      myAnimation.reverse();
      setState(() {
        menuOn = false;
      });
    }
    isOpen = !isOpen;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> profileChildren = new List();

    //print(path);
    profileChildren.add(mainProfile());
    if (menuOn) profileChildren.add(menu());
    return WillPopScope(
      onWillPop: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      ),
      child: MaterialApp(
          title: widget.user,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Stack(
            children: profileChildren,
          )),
    );
  }

  Widget mainProfile() => new Scaffold(
        body: Column(children: [
          Stack(children: [
            AppBar(
              backgroundColor: Colors.teal[200],
              title: new Center(
                  child: Text(
                'user1',
                style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: 15.0,
                    color: Colors.white,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold),
              )),
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, top: 30.0),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('images/pfp_myUsername.png'),
              ),
            ),
          ]),
          SizedBox(
            height: 15,
          ),
          Text(widget.username + "'s Artbook ",
              style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: 15.0,
                  color: Colors.black,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: Container(
              child: posts.length != 0
                  ? StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return posts[posts.length - index - 1];
                      },
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(2, index.isEven ? 3 : 3),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    )
                  : Container(),
            ),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal[200],
          onPressed: animate,
          tooltip: 'Add New Post',
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: myAnimation,
          ),
        ),
      );

  Widget menu() => new Positioned(
        bottom: 50,
        right: 15,
        child: new Container(
          height: 200.0,
          width: 50.0,
          child: new Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  CircleIconButton(
                      tooltip: 'Click from Camera',
                      icon: Icon(Icons.add_a_photo),
                      onPress: () {
                        Uploader.imgFromCam();
                        setState(() {});
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  CircleIconButton(
                      tooltip: 'Upload from Gallery',
                      icon: Icon(Icons.add_photo_alternate),
                      onPress: () {
                        setState(() {
                          Uploader.imgFromGallery();
                        });
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  CircleIconButton(
                      tooltip: 'Settings',
                      icon: Icon(Icons.settings),
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingPage()),
                        );
                      }),
                ],
              )),
        ),
      );
}

class CircleIconButton extends StatelessWidget {
  final Function onPress;
  final Icon icon;
  final String tooltip;
  CircleIconButton({this.tooltip, this.icon, this.onPress});
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: RawMaterialButton(
        onPressed: onPress,
        fillColor: Colors.white,
        shape: CircleBorder(),
        child: icon,
      ),
    );
  }
}
