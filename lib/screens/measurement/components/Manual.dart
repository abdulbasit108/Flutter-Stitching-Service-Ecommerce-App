import 'dart:convert';

import 'package:etailor/constants.dart';
import 'package:etailor/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../size_config.dart';
import '../../../components/default_button.dart';
import '../../home/home_screen.dart';
import 'package:http/http.dart' as http;

class manual extends StatelessWidget {
  static const String routeName = "/manual";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ManualPage(),
    );
  }
}

class ManualPage extends StatefulWidget {
  @override
  _ManualPageState createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage> {
  final _formKey = GlobalKey<FormState>();
  String selectedPreset = '';
  TextEditingController profileNameController = TextEditingController();
  TextEditingController chestMeasurementController = TextEditingController();
  TextEditingController waistMeasurementController = TextEditingController();
  TextEditingController hipsMeasurementController = TextEditingController();
  TextEditingController inseamMeasurementController = TextEditingController();
  TextEditingController sleeveMeasurementController = TextEditingController();
  TextEditingController shoulderMeasurementController = TextEditingController();

  Future<void> sendMeasurementsToApi() async {
    String profileName = profileNameController.text;
    String chestMeasurement = chestMeasurementController.text;
    String waistMeasurement = waistMeasurementController.text;
    String hipsMeasurement = hipsMeasurementController.text;
    String inseamMeasurement = inseamMeasurementController.text;
    String sleeveMeasurement = sleeveMeasurementController.text;
    String shoulderMeasurement = shoulderMeasurementController.text;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Send the measurements to your API
    //String url = '$uri/api/save-measurement';
    try {
      final response = await http.post(Uri.parse('$uri/api/save-measurement'),
      headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          }, 
      body: jsonEncode({
        'profileName': profileName, 
        'chestMeasurement': chestMeasurement, 
        'waistMeasurement': waistMeasurement, 
        'hipsMeasurement': hipsMeasurement, 
        'inseamMeasurement': inseamMeasurement, 
        'sleeveMeasurement': sleeveMeasurement,  
        'shoulderMeasurement': shoulderMeasurement,
      }));

      if (response.statusCode == 200) {
        // Measurements successfully sent to the API
        Navigator.pushNamed(context, HomeScreen.routeName);
      } else {
        // Handle API error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to send measurements to API.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle exception/error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to send measurements to API. $e'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    // Clean up the controllers
    profileNameController.dispose();
    chestMeasurementController.dispose();
    waistMeasurementController.dispose();
    hipsMeasurementController.dispose();
    inseamMeasurementController.dispose();
    sleeveMeasurementController.dispose();
    shoulderMeasurementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(10),
          ),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 0.1),
                const Text(
                  'Enter Your Measurement Profile Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: profileNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter profile name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                const Text(
                  'Enter Your Body Measurements for a Swift Experience',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12.0),
                MeasurementInputField(
                  controller: chestMeasurementController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter chest measurement',
                ),
                const SizedBox(height: 12.0),
                MeasurementInputField(
                  controller: waistMeasurementController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter waist measurement',
                ),
                const SizedBox(height: 12.0),
                MeasurementInputField(
                  controller: hipsMeasurementController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter hips measurement',
                ),
                const SizedBox(height: 12.0),
                MeasurementInputField(
                  controller: inseamMeasurementController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter inseam measurement',
                ),
                const SizedBox(height: 12.0),
                MeasurementInputField(
                  controller: sleeveMeasurementController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter sleeve measurement',
                ),
                const SizedBox(height: 12.0),
                MeasurementInputField(
                  controller: shoulderMeasurementController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter shoulder measurement',
                ),

                SizedBox(height: getProportionateScreenHeight(25)),
                DefaultButton(
                  text: "Confirm",
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      sendMeasurementsToApi();
                      Navigator.pushNamed(context, HomeScreen.routeName);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MeasurementInputField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const MeasurementInputField({
    Key? key,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (double.parse(value) > 50){
          return 'Value is too large';
        }
        if (double.parse(value) < 20){
          return 'Value is too small';
        }
        return null;
      },
    );
  }
}


class PresetSizeButton extends StatelessWidget {
  final String size;
  final bool isSelected;
  final VoidCallback onTap;

  const PresetSizeButton({
    Key? key,
    required this.size,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : const Color(0xFF774AC7),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          size,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
