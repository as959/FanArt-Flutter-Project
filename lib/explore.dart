import 'dart:ui';
import 'package:fanart/settings.dart';
import 'package:flutter/material.dart';
import 'package:fanart/home.dart';

class Explore extends StatefulWidget {
  String _uid;
  Explore(String uid) {
    _uid = uid;
  }
  @override
  _ExploreState createState() => _ExploreState(_uid);
}

class _ExploreState extends State<Explore> {
  String _UID;
  _ExploreState(String UID) {
    _UID = UID;
  }
  int i = 0;
  var list = [
    "Canvas",
    "Frozen",
    "Anime",
    "Oil Paint",
    "Sketch",
    "BTS",
    "BlackPink",
    "Flow Art",
    "Child",
    "Galaxy",
    "stars",
    "glitter"
  ];
  double _sigmaX = 0.0; // from 0-10
  double _sigmaY = 0.0; // from 0-10
  double _opacity = 0.5;
  bool _showtick = false;
  var selected_items = new List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Last step,\nTell us what your interests !',
          style: TextStyle(fontSize: 15),
        ),
        backgroundColor: Colors.teal[300],
      ),
      body: GridView.count(
        primary: true,
        padding: const EdgeInsets.all(5),
        crossAxisSpacing: 2,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          for (var item in list)
            Stack(
              children: <Widget>[
                FlatButton(
                  child: Container(
                    width: 380,
                    height: 270,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage('assets/brush${list.indexOf(item)}.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    alignment: Alignment.center,
                    child: BackdropFilter(
                      filter:
                          ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                      child: Container(
                        color: Colors.black.withOpacity(
                            selected_items.contains(list.indexOf(item))
                                ? 0.8
                                : 0.5),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (!selected_items.contains(list.indexOf(item))) {
                        selected_items.add(list.indexOf(item));
                      } else {
                        selected_items.remove(list.indexOf(item));
                      }
                    });
                  },
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      item,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    )),
                selected_items.contains(list.indexOf(item))
                    ? Center(
                        child: Icon(
                        Icons.check,
                        size: 40,
                        color: Colors.white,
                      ))
                    : SizedBox()
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Done"),
        icon: Icon(Icons.check),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        },
        backgroundColor: Colors.teal[300],
        hoverColor: Colors.amber,
        highlightElevation: 2,
      ),
    );
  }
}
