import 'dart:convert';

import 'package:cirrus/authenticators/authenticator.dart';
import 'package:http/http.dart' as http;

class BoxService {
  final String token;
  BoxService(this.token);

  Future<Map<dynamic, dynamic>> getFolders() async {
    try{
    var response = await http.get('https://api.box.com/2.0/folders/0/items',
        headers: {'Authorization': 'Bearer ${token}'});

    return json.decode(response.body);
    }catch(err){
      throw err;
    }
  }
}
