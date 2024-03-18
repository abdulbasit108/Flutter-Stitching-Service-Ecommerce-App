import 'dart:convert';
import 'dart:io';


import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:etailor/constants.dart';
import 'package:etailor/error_handling.dart';
import 'package:etailor/models/user.dart';
import 'package:etailor/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../models/product.dart';
import '../../../providers/user_provider.dart';

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void addToCart({
    required BuildContext context,
    required Product product,
    required String? profile,
    required String? trouserLength, 
    required String? neckStyle, 
    required String? sleeveStyle, 
    required String? instructions, 
    required List<File> images
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final cloudinary = CloudinaryPublic('djtqyymeo', 'aqzcie5r');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: "${product.name} $profile"),
        );
        imageUrls.add(res.secureUrl);
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
          'profile': profile,
          'trouserLength': trouserLength,
          'neckStyle': neckStyle,
          'sleeveStyle': sleeveStyle,
          'instructions': instructions,
          'images': imageUrls,


        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void increaseQuantityCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/inc-quantity-cart/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  
}
