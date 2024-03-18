import 'dart:convert';

import 'package:etailor/constants.dart';
import 'package:etailor/providers/user_provider.dart';
import 'package:etailor/screens/admin/screens/admin_screen.dart';
import 'package:etailor/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:etailor/screens/measurement/measurement.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../error_handling.dart';
import '../models/user.dart';
import '../utils.dart';

class AuthService {
  // sign up user
  void signUpUser({
    required BuildContext context,
    required String? email,
    required String? phone,
    required String? name,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        phone: phone,
        email: email,
        address: [],
        payment: [],
        type: '',
        token: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same phone number!',
          );
          Navigator.pushNamed(context, SignInScreen.routeName);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // sign in user
  void signInUser({
    required BuildContext context,
    required String to,
    required String code,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'phone': to,
          'code': code,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          final user = Provider.of<UserProvider>(context, listen: false).user;
          if (user.type == 'user') {
            Navigator.pushNamedAndRemoveUntil(
                context, measurement.routeName, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, AdminScreen.routeName, (route) => false);
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  Future<bool> getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
      return true;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }
}
