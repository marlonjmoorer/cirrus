import 'package:cirrus/configuration.dart';
import 'package:cirrus/database/accout.provider.dart';
import 'package:cirrus/pages/add_account.page.dart';
import 'package:cirrus/pages/explorer.page.dart';
import 'package:cirrus/pages/login.page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final AccountProvider provider;
  HomePage(this.provider);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Account> _accounts;
  bool _loading;
  int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _accounts = new List<Account>();
    _loadAccounts();
  }

  void _loadAccounts() async {
    var accounts = await widget.provider.getAccounts();
    setState(() {
      _loading = false;
      _accounts = accounts;
      _selectedIndex = 0;
    });
  }

  void _addAccount() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAccountPage(),
      ),
    );
    if (result != null) {
      var account = Account.fromMap(result);
      var newAccount = await widget.provider.insert(account);
      if (newAccount.id > 0) {
        _loadAccounts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Acccounts"),
        ),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                  accountName: new Text("John Doe"), accountEmail: null),
              new Column(children: buildDrawerOptions(_accounts)),
              RaisedButton(
                child: Text("Add Account"),
                onPressed: _addAccount,
              )
            ],
          ),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    if (_loading) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else if (_accounts.length > 0) {
      return new Center(
        child: new ExplorerPage(_accounts[_selectedIndex]),
      );
    } else {
      return new Center(child: new Text('No Accounts'));
    }
  }

  List<Widget> buildDrawerOptions(List<Account> accounts) {
    List<Widget> tiles = accounts
        .map((a) =>
    new ListTile(
      leading: new Icon(Icons.account_box),
      title: new Text(a.name),
      onLongPress: () {},
      selected: accounts.indexOf(a) == _selectedIndex,
      onTap: (){
        setState(() {
          _selectedIndex=accounts.indexOf(a);
        });

      },
    ))
        .toList();
    return tiles;
  }
}