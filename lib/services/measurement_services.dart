import 'dart:convert';
import 'package:etailor/constants.dart';
import 'package:etailor/error_handling.dart';
import 'package:etailor/models/measurement.dart';
import 'package:etailor/providers/user_provider.dart';
import 'package:etailor/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MeasurementServices {
  Future<List<Measurement>> fetchMyProfiles({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Measurement> measurementList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/measurements/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            measurementList.add(
              Measurement.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return measurementList;
  }

}