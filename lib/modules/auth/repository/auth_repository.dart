import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:food_delivery/core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String baseUrl = ApiConstants.authUrl;
  static const String _tokenKey = 'jwt_token';
  static String? _memoryToken;

  static Future<bool> hasSavedToken() async {
    if (_memoryToken != null && _memoryToken!.isNotEmpty) {
      return true;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      return token != null && token.isNotEmpty;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<void> clearSavedToken() async {
    _memoryToken = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } on MissingPluginException {
      return;
    }
  }

  Future<void> sendOtp({
    required String email,
  }) async {

    final response = await http.post(

      Uri.parse('$baseUrl/send-otp'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception(_messageFromResponse(response.body));
    }
  }



  Future<void> verifyOtp({
    required String name,

    required String email,

    required String password,

    required String phone,

    required String address,

    required String otp,

  }) async {

    final response = await http.post(

      Uri.parse('$baseUrl/verify-otp'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({

        'name': name,

        'email': email,

        'password': password,

        'phone': phone,

        'address': address,

        'otp': otp,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(_messageFromResponse(response.body));
    }
  }



  Future<void> login({
    required String email,

    required String password,

  }) async {

    final response = await http.post(

      Uri.parse('$baseUrl/login'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({

        'email': email,

        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(_messageFromResponse(response.body));
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final token = body['token'] as String?;

    if (token != null && token.isNotEmpty) {
      _memoryToken = token;

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
      } on MissingPluginException {
        return;
      }
    }
  }
  
  Future<void> checkUser({
    required String email,

  }) async {

    final response = await http.post(

      Uri.parse('$baseUrl/login'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({

        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(_messageFromResponse(response.body));
    }

    }
  }

  

  String _messageFromResponse(String responseBody) {
    final body = jsonDecode(responseBody) as Map<String, dynamic>;
    return body['message']?.toString() ?? 'Something went wrong';
  }


