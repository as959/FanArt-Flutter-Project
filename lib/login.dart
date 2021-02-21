import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fanart/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fanart/home.dart';

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}


class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  bool s = false;
  final _auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  void logInToFb() async {
    setState(() {
      s = true;
    });
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    } catch (err) {
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
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

  @override
  Widget build(BuildContext context) {
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
                    margin: EdgeInsets.fromLTRB(20, 150, 20, 150),
                    padding: EdgeInsets.all(30),
                    //to avoid bottom overflow problem
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.teal[200],
                                fontSize: 25.0,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 60.0,
                          ),
                          TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'Please enter Email',
                              labelText: 'Email ID *',
                            ),
                            // The validator receives the text that the user has entered.
                          ),
                          TextFormField(
                            controller: password,
                            obscureText: true,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.lock_open),
                              hintText: 'Enter password',
                              labelText: 'Password *',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (!(value.length > 5)) {
                                return 'Invalid Password';
                              } else {
                                return null;
                              }
                            },
                          ),
                          new Container(
                              padding: const EdgeInsets.only(top: 50.0),
                              height: 100.0,
                              width: 150.0,
                              child: new RaisedButton(
                                  color: Colors.teal[200],
                                  child: const Text('Submit'),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      logInToFb();
                                    }
                                  })),
                        ]))))));
  }
}
