import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/utils/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;

  Future<void> _authenticate(String email, String password, String urlSegment) async {
   final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAKwqRG0Lsc9A9gmi0EqMvsC_1wVMve5S8';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final respondeData = json.decode(response.body);
      if (respondeData['error'] != null) {
        throw HttpException(respondeData['error']['message']);
      }
    } catch (error) {
      throw error; 
    }
  }
   Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
