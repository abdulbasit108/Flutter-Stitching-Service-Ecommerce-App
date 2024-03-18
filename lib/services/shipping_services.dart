import 'dart:convert';
import 'package:etailor/constants.dart';
import 'package:etailor/error_handling.dart';
import 'package:etailor/models/user.dart';
import 'package:etailor/providers/user_provider.dart';
import 'package:etailor/screens/home/home_screen.dart';
import 'package:etailor/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ShippingServices {
  Future<List<dynamic>> fetchMyAddress({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<dynamic> addressList = userProvider.user.address;
    
    return addressList;
  }

  Future<List<dynamic>> fetchMyPayment({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<dynamic> paymentList = userProvider.user.payment;
    
    return paymentList;
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required String payment,
    required double totalSum,
    required bool isQuick,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(Uri.parse('$uri/api/order'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'cart': userProvider.user.cart,
            'addressLabel': address,
            'paymentLabel': payment,
            'totalPrice': totalSum,
            'isQuick': isQuick
          }));

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Your order has been placed!');
          User user = userProvider.user.copyWith(
            cart: [],
          );
          userProvider.setUserFromModel(user);
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
    }
  }

}