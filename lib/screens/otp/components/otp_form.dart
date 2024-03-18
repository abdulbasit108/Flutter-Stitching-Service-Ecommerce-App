import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../size_config.dart';
import '../../../constants.dart';
import '../../measurement/measurement.dart';
import 'package:http/http.dart' as http;



class OtpForm extends StatefulWidget {
  const OtpForm({Key? key}) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final AuthService authService = AuthService();
  late FocusNode pin2FocusNode;
  late FocusNode pin3FocusNode;
  late FocusNode pin4FocusNode;
  late FocusNode pin5FocusNode;
  late FocusNode pin6FocusNode;
  late TextEditingController otpController;

  List<String> pinValues = List.filled(6, '');

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
    otpController.dispose();
    super.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  Future<void> verifyOTP(BuildContext context, String phoneNumber) async {
    final String enteredOTP = pinValues.join();
    log(enteredOTP);
    log(phoneNumber);
    //final String url = 'http://192.168.56.1:3000/api/signin'; // Replace with your backend server URL

    try {
      final response = await http.post(
        Uri.parse('$uri/api/signin'),

        body: {'to': phoneNumber ,'code': enteredOTP},
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // OTP verified successfully
        Navigator.pushNamed(context, measurement.routeName);
      } else {
        final errorMessage = response.body;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to the server')),
      );
    }
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      code: pinValues.join(),
      to: ModalRoute.of(context)!.settings.arguments as String,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(0.02)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  autofocus: true,
                  obscureText: true,
                  style: const TextStyle(fontSize: 15),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    pinValues[0] = value;
                    nextField(value, pin2FocusNode);
                  },
                  autofillHints: [AutofillHints.oneTimeCode],
                ),
              ),

              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 15),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    pinValues[1] = value;
                    nextField(value, pin3FocusNode);
                  },
                  autofillHints: [AutofillHints.oneTimeCode],
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 15),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    pinValues[2] = value;
                    nextField(value, pin4FocusNode);
                  },
                  autofillHints: [AutofillHints.oneTimeCode],
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 15),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    pinValues[3] = value;
                    nextField(value, pin5FocusNode);
                  },
                  autofillHints: [AutofillHints.oneTimeCode],
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  focusNode: pin5FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 15),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    pinValues[4] = value;
                    nextField(value, pin6FocusNode);
                  },
                  autofillHints: [AutofillHints.oneTimeCode],
                ),
              ),

              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  focusNode: pin6FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 15),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  controller: otpController,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pinValues[5] = value;
                      pin6FocusNode.unfocus();
                      signInUser();
                      print('object');
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Confirm",
            press: () {
              if (otpController.text.length == 6) {
                signInUser();
                print('object');
              }
            },
          )
        ],
      ),
    );
  }
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 15),
  enabledBorder: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  border: outlineInputBorder(),
);

// Add the outlineInputBorder function definition
OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: kTextColor),
  );
}

// Add the DefaultButton class definition if not already defined
class DefaultButton extends StatelessWidget {
  final String text;
  final Function press;

  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () => press(),
        child: Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}