import 'package:sqflite/sqflite.dart';

final String tableAccount = "account";
final String columnId = "_id";
final String columnType = "type";
final String columnToken = "token";
final String columnName = "name";

class AccountProvider {
  Database db;

  final String connString;
  AccountProvider(this.connString);
  Future open() async {
    db = await openDatabase(connString, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
            create table $tableAccount ( 
              $columnId integer primary key autoincrement, 
              $columnType text not null,
              $columnToken text not null,
              $columnName text not null)
            ''');
    });
  }

  Future<Account> insert(Account account) async {
    await this.open();
    account.id = await db.insert(tableAccount, account.toMap());
    await this.close();
    return account;
  }

  Future<List<Account>> getAccounts() async {
    await this.open();
    List<Map> maps = await db.query(
      tableAccount,
      columns: [columnId, columnType, columnName, columnToken],
    );
    await this.close();
    if (maps.length > 0) {
      return maps.map((data) => Account.fromMap(data)).toList();
    }
    return new List<Account>();
  }

  Future close() async => db.close();
}

class Account {
  int id;
  String type;
  String token;
  String name;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnType: type,
      columnToken: token,
      columnName: name
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Account();

  Account.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    type = map[columnType];
    token = map[columnToken];
    name = map[columnName];
  }
}
