import 'package:cirrus/authenticators/authenticator.dart';
import 'package:flutter/material.dart';

class AddAccountPage extends StatefulWidget {
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _type="";
  String _name="";
  final List options=["Box"];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Add Account"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                  decoration: new InputDecoration(
                      labelText: 'Name'
                  ),
                 onSaved: (value){
                    _name=value;
                 },
                ),
                DropdownButton(
                    items:options.map((value){
                      return DropdownMenuItem<String>(
                          value: value,
                          child:Text(value)
                      );
                    }).toList(),
                    hint:Text(_type),
                    onChanged: (value){
                      setState(() {
                        _type=value;
                      });
                    },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: ()async {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (this._formKey.currentState.validate()) {
                        this._formKey.currentState.save();
                        var token = await Auth.getToken(_type);
                        Navigator.of(context).pop({
                          "token":token.access,
                          "name":_name,
                          "type":_type
                        });
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
