import 'package:cirrus/authenticators/authenticator.dart';
import 'package:cirrus/database/accout.provider.dart';
import 'package:cirrus/services/box.service.dart';
import 'package:flutter/material.dart';

class ExplorerPage extends StatefulWidget {
  final Account account;
  ExplorerPage(this.account);
  _ExplorerState createState() => _ExplorerState();
}

class _ExplorerState extends State<ExplorerPage> {
  BoxService service;
  @override
  void initState() {
    super.initState();
    service = new BoxService(widget.account.token);
//    service.getFolders().then((data) {
//      setState(() {});
//    });
  }
  void _loadFolderData()async{
    service = new BoxService(widget.account.token);
    var data =await service.getFolders();
    print("");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Text(widget.account.name),
        RaisedButton(
          child: Text("Load"),
          onPressed:_loadFolderData
        )
      ],),
    );
  }
}
