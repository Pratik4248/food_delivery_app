import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:food_delivery/core/constants/api_constants.dart';

class AuthRepository {
static const String baseUrl = ApiConstants.authUrl;


  Future<void> sendOtp({
    required String email,
  }) async {

    final response = await http.post(

      Uri.parse('$baseUrl/send-otp'),

      headers: {
        'Content-Type': 'application/json'
      },

      body: jsonEncode({
        'email': email
      }),
    );

    if (response.statusCode != 200) {

      throw Exception(
        jsonDecode(response.body)['message'],
      );
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

      headers: {
        'Content-Type': 'application/json'
      },

      body: jsonEncode({

        'name': name,

        'email': email,

        'password': password,

        'phone': phone,

        'address': address,

        'otp': otp
      }),
    );

    if (response.statusCode != 201) {

      throw Exception(
        jsonDecode(response.body)['message'],
      );
    }
  }



  Future<void> login({

    required String email,

    required String password,

  }) async {

    final response = await http.post(

      Uri.parse('$baseUrl/login'),

      headers: {
        'Content-Type': 'application/json'
      },

      body: jsonEncode({

        'email': email,

        'password': password
      }),
    );

    if (response.statusCode != 200) {

      throw Exception(
        jsonDecode(response.body)['message'],
      );
    }
  }
}