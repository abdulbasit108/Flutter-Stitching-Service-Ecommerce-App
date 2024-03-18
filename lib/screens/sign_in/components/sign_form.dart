import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../models/user.dart';
import '../../otp/otp_screen.dart';
import 'package:http/http.dart' as http;

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> sendOTP(BuildContext context) async {
    final String phoneNumber = phoneNumberController.text;
    //final String url = 'http://192.168.56.1:3000/api/sendOTP'; // Replace with your backend server URL

    try {

      User user = User(
        id: '',
        name: '',
        phone: phoneNumber,
        email: '',
        address: [],
        payment: [],
        type: '',
        token: '',
        cart: [],
      );

      final response = await http.post(
        Uri.parse('$uri/api/sendOTP'),
        body: user.toJson(),
        // body: {'phone': phoneNumber},
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // OTP sent successfully
        // Navigator.pushNamed(context, OtpScreen.routeName);
        Navigator.pushNamed(
          context,
          OtpScreen.routeName,
          arguments: phoneNumber, // Pass the phone number as a parameter
        );
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: phoneNumberController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                sendOTP(context);
              }
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
