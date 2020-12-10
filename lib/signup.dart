import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fanart/explore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference myRef = database.reference();
DatabaseReference userRef = myRef.child('/users');
final storageRef =
    FirebaseStorage.instanceFor(bucket: 'gs://fanart-563d1.appspot.com');

class MySignForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MySignForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password1 = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  DateTime _date;
  bool s = false;
  File imageURI;
  String path;
  final _auth = FirebaseAuth.instance;
  void registertoFb() async {
    setState(() {
      s = true;
    });
    try {
      print("In try");
      print(email.text);
      print(password.text);
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      print("newuser:$newUser");
      if (newUser != null) {
        print("Should push");
        var filename = "post" + DateTime.now().toString();
        var userid = newUser.user.uid;
        var ref = storageRef.ref('/Users/$userid/profile/$filename.png');
        var url =
            "https://firebasestorage.googleapis.com/v0/b/fanart-563d1.appspot.com/o/Users%2F0%2Fdefault_pfp.png?alt=media&token=5dcf593c-5f97-425a-a348-b437eb4852fe";
        if (imageURI != null) {
          await ref.putFile(imageURI);
          url = await ref.getDownloadURL();
        }
        //User user = newUser.user;
        //await user.updateProfile(displayName: name.text);
        await userRef.once().then((DataSnapshot snapshot) {
          List<dynamic> userList = new List<dynamic>.from(snapshot.value);
          print(userList);
          userList.add({
            "followers": [],
            "following": [],
            "uid": newUser.user.uid,
            "username": username.text,
            "email": email.text,
            "pfppath": url,
          });
          Map<String, dynamic> updates = {};
          updates['users'] = userList;
          myRef.update(updates);
          print("User id is : " + newUser.user.uid);
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Explore(newUser.user.uid)),
        );
        //print('displayname= ${user.displayName}');
      }

      print("over here");
    } catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.teal[300],
              title: Text("Error"),
              content: Text(e.toString()),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
    setState(() {
      s = false;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageURI = image;
      path = image.path;
    });
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String _pass = "";

    // Build a Form widget using the _formKey created above.
    return Scaffold(
        backgroundColor: Colors.teal[200],
        body: ModalProgressHUD(
            inAsyncCall: s,
            child: Form(
                key: _formKey,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white),
                    margin: EdgeInsets.fromLTRB(20, 100, 20, 20),
                    padding: EdgeInsets.all(30),
                    //to avoid bottom overflow problem
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Colors.teal[200],
                                fontSize: 25.0,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageURI ==
                                            null //profilePhoto which is File object
                                        ? AssetImage("assets/person-icon.png")
                                        : FileImage(imageURI), // picked file
                                    fit: BoxFit.fill)),
                          ),
                          FlatButton(
                              padding: EdgeInsets.only(left: 110),
                              onPressed: () => getImageFromGallery(),
                              child: Icon(
                                Icons.add_circle_outline,
                                size: 35,
                                color: Colors.grey[700],
                              )),
                          TextFormField(
                            controller: name,
                            decoration: const InputDecoration(
                              hintText: 'Please enter your name',
                              labelText: 'Full Name *',
                            ),

                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (!(value.length > 2)) {
                                return 'Must contain more than 2 characters';
                              } else if (value.contains("@")) {
                                return 'Do not use @ ';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: username,
                            decoration: const InputDecoration(
                              hintText: 'Displayed as profile name ',
                              labelText: 'Username *',
                            ),

                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (!(value.length > 2)) {
                                return 'Must contain more than 2 characters';
                              } else if (value.contains("@")) {
                                return 'Do not use @ ';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Enter Email ID ',
                              labelText: 'Email ID *',
                            ),

                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value.contains("@") &&
                                  value.contains(".com")) {
                                return null;
                              } else {
                                return 'Please enter valid email!';
                              }
                            },
                          ),
                          TextFormField(
                            controller: password1,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Set New Password ',
                              labelText: 'Password *',
                            ),

                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (!(value.length > 5)) {
                                return 'Must contain more than 5 characters';
                              }
                              _pass = value;

                              return null;
                            },
                          ),
                          TextFormField(
                            controller: password,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Re-enter password',
                              labelText: 'Re-enter Password *',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value != _pass) {
                                return 'Passwords do not match';
                              } else {
                                return null;
                              }
                            },
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                  _date == null
                                      ? "Date of Birth "
                                      : "DOB: ${_date.toString().substring(0, 10)}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 16)),
                              SizedBox(width: 20.0),
                              RaisedButton(
                                child: Icon(Icons.calendar_today),
                                color: Colors.white,
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2001),
                                          lastDate: DateTime(2222))
                                      .then((date) {
                                    setState(() {
                                      _date = date;
                                      print("Date has been set $_date");
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                          new Container(
                            padding: const EdgeInsets.only(top: 50.0),
                            height: 100.0,
                            width: 150.0,
                            child: new RaisedButton(
                              color: Colors.teal[200],
                              child: const Text('Submit'),
                              onPressed: () async {
                                print("Activated button");
                                if (_formKey.currentState.validate()) {
                                  registertoFb();
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(' * marked are required fields.',
                              style: TextStyle(color: Colors.grey[500]))
                        ]))))));
  }
}
