import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Config {
  static Map<String, dynamic> appSettings;
  static String dbPath;
  static void load() async {
    var data = await rootBundle.loadString("settings.json");
    appSettings = json.decode(data);
    var databasesPath = await getDatabasesPath();
    dbPath = join(databasesPath, appSettings['database']);
  }
}
