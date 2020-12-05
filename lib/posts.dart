import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

DateFormat dtformat = DateFormat("yy-MM-dd hh:mm");
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference myRef = database.reference();

class GridPost extends StatefulWidget {
  final String username;
  final Image img;
  //final String date = dtformat.format(DateTime.now());
  int likes = 0;
  int dislikes = 0;
  bool likeFlag = true;
  bool dislikeFlag = true;
  GridPost({@required this.username, @required this.img});
  @override
  GridPostState createState() => GridPostState();
}

class GridPostState extends State<GridPost> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      //padding: const EdgeInsets.all(3.0),
      //decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      //height: 425,
      child: Column(
        children: [
          // Stack(children: [
          Expanded(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0), child: widget.img),
          ),
        ],
      ),
    );
  }
}

class FriendPost extends StatefulWidget {
  final String avatar_path;
  final String ref;
  int likes;
  int dislikes;
  bool likeFlag = true;
  bool dislikeFlag = true;
  bool future_is_now = false;
  String username = "";
  String path =
      "https://firebasestorage.googleapis.com/v0/b/fanart-563d1.appspot.com/o/loading.png?alt=media&token=550ecd8b-d694-4c04-8eb6-9df4191036da";
  final String date = dtformat.format(DateTime.now());
  FriendPost({this.avatar_path, @required this.ref}) {
    print(this.ref);

    print(ref);
    DatabaseReference pRef = myRef.child(this.ref);
    pRef.once().then((DataSnapshot snapshot) {
      print("HEllo");
      this.future_is_now = true;
      var x = snapshot.value;
      print(x);
      Map<dynamic, dynamic> values = snapshot.value;
      print(values["ImagePath"]);
      this.username = values["posterid"].toString();
      this.path = values["ImagePath"];
      this.likes = int.parse(values["likes"].toString());
    });
  }
  @override
  FriendPostState createState() => FriendPostState(this.ref);
}

class FriendPostState extends State<FriendPost> {
  DatabaseReference pRef;
  FriendPostState(ref) {
    this.pRef = myRef.child(ref);
    pRef.onValue.listen((event) {
      print("HEllo");
      setState(() {});
      DataSnapshot snapshot = event.snapshot;
      widget.future_is_now = true;
      var x = snapshot.value;
      print(x);
      Map<dynamic, dynamic> values = snapshot.value;
      print(values["ImagePath"]);
      widget.username = values["posterid"].toString();
      widget.path = values["ImagePath"];
      int t = int.parse(values['likes'].toString());
      widget.likes = t;
      widget.dislikes = int.parse(values['dislikes'].toString());
    });
  }
  void addLikes() {
    int temp = widget.likes;
    int temp2 = widget.dislikes;
    temp += 1;
    if (widget.dislikes != 0) {
      temp2 -= 1;
      widget.dislikeFlag = true;
    }
    widget.likeFlag = false;
    Map<String, dynamic> updates = {};
    updates['likes'] = temp;
    updates['dislikes'] = temp2;

    pRef.update(updates);
    setState(() {});
  }

  void removeLikes() {
    int temp = widget.likes;
    temp -= 1;
    Map<String, dynamic> updates = {};
    updates['likes'] = temp;
    pRef.update(updates);
    widget.likeFlag = true;
    setState(() {});
  }

  void addDislikes() {
    int temp = widget.dislikes;
    int temp2 = widget.likes;
    temp += 1;
    if (widget.likes != 0) {
      temp2 -= 1;
      widget.likeFlag = true;
    }
    widget.dislikeFlag = false;
    Map<String, dynamic> updates = {};
    updates['dislikes'] = temp;
    updates['likes'] = temp2;

    pRef.update(updates);
    setState(() {});
  }

  void removeDislikes() {
    int temp = widget.dislikes;
    temp -= 1;
    Map<String, dynamic> updates = {};
    updates['dislikes'] = temp;
    pRef.update(updates);
    widget.dislikeFlag = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    while (widget.future_is_now != true) {
      setState(() {});
    }
    return Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        //decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        height: 425,
        width: 300,
        child: Column(
          children: [
            Row(children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(widget.avatar_path == null
                    ? 'images/default_pfp.png'
                    : widget.avatar_path),
              ),
              SizedBox(
                width: 15,
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.baseline, children: [
                Text(widget.username),
                Text(
                  "  Posted at " + widget.date + "\n",
                  style: TextStyle(fontSize: 7),
                ),
              ]),
            ]),
            SizedBox(
              height: 5,
            ),
            Expanded(
                child: Container(
                    height: 320,
                    width: 200,
                    child: Image.network(widget.path))),
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.thumb_up),
                    onPressed: widget.likeFlag ? addLikes : removeLikes),
                Text(widget.likes.toString()),
                IconButton(
                    icon: Icon(Icons.thumb_down),
                    onPressed:
                        widget.dislikeFlag ? addDislikes : removeDislikes),
                Text(widget.dislikes.toString()),
              ],
            ),
          ],
        ));
  }
}
