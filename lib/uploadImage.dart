import 'package:fanart/posts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

DateFormat dtformat = DateFormat("yy-MM-dd hh:mm");
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference myRef = database.reference();
DatabaseReference postRef = myRef.child('/posts');
final storageRef =
    FirebaseStorage.instanceFor(bucket: 'gs://fanart-563d1.appspot.com');
final _auth = FirebaseAuth.instance;
var currentUser = _auth.currentUser;

class Uploader {
  static var username;
  static String profilepath;
  static Future<void> getUsername() async {
    DatabaseReference userRef = myRef.child('/users');
    await userRef.once().then((DataSnapshot snapshot) {
      List<dynamic> userList = new List<dynamic>.from(snapshot.value);
      print("List is : " + userList.toString());
      for (Map x in userList) {
        if (x['uid'] == currentUser.uid) {
          print("Returning : " + x['username']);
          username = x['username'];
          profilepath = x['pfppath'];
          break;
        }
      }
    });
  }

  static void upload(File image) async {
    var filename = "post" + DateTime.now().toString();
    var userid = currentUser.uid;
    var ref = storageRef.ref('/Users/$userid/$filename.png');
    await ref.putFile(image);
    var url = await ref.getDownloadURL();
    await getUsername();
    print("UNM is : " + username.toString());
    await postRef.once().then((DataSnapshot snapshot) {
      List<dynamic> x = new List<dynamic>.from(snapshot.value);
      var pid = x.length + 1;
      x.add({
        "ImagePath": url,
        "date": dtformat.format(DateTime.now()),
        "dislikes": 0,
        "likes": 0,
        "pid": "$pid",
        "posterid": "$userid",
        "pname": "$username",
        "text": ""
      });
      Map<String, dynamic> updates = {};
      updates['posts'] = x;
      myRef.update(updates);
    });
  }

  static Future<GridPost> imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    await upload(image);
    return GridPost(
      username: username,
      img: Image.file(image),
    );
    //userPosts.add(new Post(username: username, img: Image.file(image)));
  }

  static Future<GridPost> imgFromCam() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    upload(image);
    return GridPost(username: username, img: Image.file(image));
  }
}
