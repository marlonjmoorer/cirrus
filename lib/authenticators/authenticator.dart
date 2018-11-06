import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cirrus/configuration.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

abstract class Authenticator {
  String get authUrl;
  String get tokenUrl;
  Map get authParams;
  Map get tokenParams;
  String get appId;
  String appSecret;

  Future<Stream<String>> _server() async {
    final StreamController<String> onCode = new StreamController();
    HttpServer server =
        await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
    server.listen((HttpRequest request) async {
      final String code = request.uri.queryParameters["code"];
      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.HTML.mimeType)
        ..write("<html>You can now close this window</html>");
      await request.response.close();
      await server.close(force: true);
      onCode.add(code);
      await onCode.close();
    });
    return onCode.stream;
  }

  Future<Token> getToken() async {
    Stream<String> onCode = await _server();
    final uri = Uri.parse(authUrl);
    uri.queryParameters.addAll(authParams);
    var url = uri.toString();
    final FlutterWebviewPlugin webviewPlugin = new FlutterWebviewPlugin();
    webviewPlugin.launch(url, clearCache: true, clearCookies: true);
    final String code = await onCode.first;
    webviewPlugin.close();
    return exchange(code);
  }

  Future<Token> exchange(String code) async {
    // Map body = {};
    // body['grant_type'] = 'authorization_code';
    // body['code'] = code;
    // body['client_id'] = appId;
    // body['client_secret'] = appSecret;
    final http.Response response = await http.post(tokenUrl, body: tokenParams);
    return Token.fromMap(json.decode(response.body));
  }
}

class BoxAuth extends Authenticator {
  // TODO: implement appId

  Map get settings => Config.appSettings["Box"];
  @override
  String get appId => settings["client_id"];

  // TODO: implement authParams
  @override
  Map get authParams => {
        "response_type": "code",
        "client_id": appId,
        "redirect_uri": "http://localhost:8080",
        "state": "123"
      };

  // TODO: implement authUrl
  @override
  String get authUrl => settings["authUrl"];

  // TODO: implement tokenParams
  @override
  Map get tokenParams => {};

  // TODO: implement tokenUrl
  @override
  String get tokenUrl => settings["tokenUrl"];
  // TODO: implement authUrl

}

class Token {
  final String access;
  final String type;
  final num expiresIn;

  Token(this.access, this.type, this.expiresIn);

  Token.fromMap(Map<String, dynamic> json)
      : access = json['access_token'],
        type = json['token_type'],
        expiresIn = json['expires_in'];
}

class Auth {
  static Future<Stream<String>> _server() async {
    final StreamController<String> onCode = new StreamController();
    HttpServer server =
        await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
    server.listen((HttpRequest request) async {
      final String code = request.uri.queryParameters["code"];
      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.HTML.mimeType)
        ..write("<html>You can now close this window</html>");
      await request.response.close();
      await server.close(force: true);
      onCode.add(code);
      await onCode.close();
    });
    return onCode.stream;
  }

  static Future<Token> getToken(String type) async {
    var creds = Config.appSettings[type];
    String appId = creds['client_id'];
    String appSecret = creds["secret"];
    Stream<String> onCode = await _server();
    final uri = Uri.parse('https://account.box.com/api/oauth2/authorize');
    uri.queryParameters.addAll({'response+type': 'code'});
    var url =
        "https://account.box.com/api/oauth2/authorize?response_type=code&client_id=${appId}&redirect_uri=http://localhost:8080&state=123";

    final FlutterWebviewPlugin webviewPlugin = new FlutterWebviewPlugin();
    webviewPlugin.launch(url, clearCache: true, clearCookies: true);
    final String code = await onCode.first;
    webviewPlugin.close();
    return exchange(code, appId, appSecret);
  }

  static Future<Token> exchange(String code, appId, appSecret) async {
    var token_url = "https://api.box.com/oauth2/token";
    Map body = {};
    body['grant_type'] = 'authorization_code';
    body['code'] = code;
    body['client_id'] = appId;
    body['client_secret'] = appSecret;
    final http.Response response = await http.post(token_url, body: body);
    return Token.fromMap(json.decode(response.body));
  }
}
