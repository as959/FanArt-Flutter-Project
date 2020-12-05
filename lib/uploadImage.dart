import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:intl/intl.dart';

DateFormat dtformat = DateFormat("yy-MM-dd hh:mm");
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference myRef = database.reference();
DatabaseReference postRef = myRef.child('/posts');
final storageRef =
    FirebaseStorage.instanceFor(bucket: 'gs://fanart-563d1.appspot.com');

class Uploader {
  static void upload(File image) async {
    var filename = "post" + DateTime.now().toString();
    var userid = 1;
    var ref = storageRef.ref('/Users/$userid/$filename.png');
    await ref.putFile(image);
    var url = await ref.getDownloadURL();
    postRef.once().then((DataSnapshot snapshot) {
      List<dynamic> x = new List<dynamic>.from(snapshot.value);
      var pid = x.length + 1;
      x.add({
        "ImagePath": url,
        "date": dtformat.format(DateTime.now()),
        "dislikes": 0,
        "likes": 0,
        "pid": "$pid",
        "posterid": "$userid",
        "text": ""
      });
      Map<String, dynamic> updates = {};
      updates['posts'] = x;
      myRef.update(updates);
    });
  }

  static void imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    upload(image);
    //userPosts.add(new Post(username: username, img: Image.file(image)));
  }

  static void imgFromCam() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    upload(image);
  }
}
