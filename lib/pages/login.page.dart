import 'package:cirrus/authenticators/authenticator.dart';
import 'package:cirrus/pages/explorer.page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _ready = false;
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
          child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(),
            RaisedButton(
              child: Text("Box Authenticate"),
              onPressed: () => _login(context),
            )
          ],
        ),
      )),
      floatingActionButton: FlatButton(
        textColor: Colors.white,
        color: Colors.blueAccent,
        child: Text("Save"),
        onPressed: () {},
      ),
    );
  }
}

_login(context) async {
  var token = await Auth.getToken('box');
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => ExplorerPage(token),
  //   ),
  // );
}
