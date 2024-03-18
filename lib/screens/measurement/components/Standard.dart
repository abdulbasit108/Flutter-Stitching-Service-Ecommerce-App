// import 'dart:convert';
// import 'dart:math';
// import 'package:etailor/screens/otp/components/body.dart';
// import 'package:flutter/material.dart';
// import '../../../components/account_text.dart';
// import '../../../constants.dart';
// import '../../../size_config.dart';
// import '../../../components/custom_surfix_icon.dart';
// import '../../../components/default_button.dart';
// import '../../../components/form_error.dart';
// import '../../../components/form_error.dart';
// import '../../../size_config.dart';
// import 'package:http/http.dart' as http;

// class Standard extends StatelessWidget {
//   static String routeName = "/Standard";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // title: Text("Sign Up"),
//       ),
//       body: StandardSize(),
//     );
//   }
// }

// class StandardSize extends StatefulWidget {
//   @override
//   _StandardSizeState createState() => _StandardSizeState();
// }

// class _StandardSizeState extends State<StandardSize> {
//   final _formKey = GlobalKey<FormState>();
//   double? _weight;
//   int? _age;
//   double? _height;
//   String _prediction = '';

//   Future<String> predictSize(double weight, int age, double height) async {
//     final baseUrl = 'http://192.168.100.20:5000'; // Replace with your backend IP address
//     final url = Uri.parse('$baseUrl/predict');

//     final request = http.MultipartRequest('POST', url);
//     print('Request Status Code: ${request}');
//     request.fields['weight'] = weight.toString();
//     request.fields['age'] = age.toString();
//     request.fields['height'] = height.toString();

//     print('Request Status Code: ${request.fields['weight']},${request.fields['age']},${request.fields['height']}');

//     await for (List<int> bytes in request.finalize()) {
//       final requestBody = utf8.decode(bytes);
//       print('Request Body: $requestBody');
//     }

//     final response = await request.send();

//     print('Response Status Code: ${response}');

//     if (response.statusCode == 200) {
//       final responseData = await response.stream.bytesToString();
//       final data = jsonDecode(responseData);
//       print('Response Status Code: ${data}');
//       return data['prediction'];
//     } else {
//       print('Response Status Code: ${response.statusCode}');
//       throw Exception('Failed to load data');
//     }
//   }

// void _predictSize() async {
//   if (_formKey.currentState!.validate()) {
//     _formKey.currentState!.save();
//     try {
//       print('Sending request with weight: $_weight, age: $_age, height: $_height');
//       final prediction = await predictSize(_weight!, _age!, _height!);
//       setState(() {
//         _prediction = prediction;
//       });
//     } catch (e) {
//       print('Error: $e');
//       // Handle error, e.g., show a snackbar or dialog with error message
//     }
//   }
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(title: Text('T-Shirt Size Predictor')),
//     body: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextFormField(
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'Weight (kg)'),
//               validator: (value) {
//                 if (value!.isEmpty) return 'Please enter weight';
//                 return null;
//               },
//               onSaved: (value) => _weight = double.tryParse(value!) ?? 0.0,
//             ),
//             TextFormField(
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'Age'),
//               validator: (value) {
//                 if (value!.isEmpty) return 'Please enter age';
//                 return null;
//               },
//               onSaved: (value) => _age = int.tryParse(value!) ?? 0,
//             ),
//             TextFormField(
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'Height (cm)'),
//               validator: (value) {
//                 if (value!.isEmpty) return 'Please enter height';
//                 return null;
//               },
//               onSaved: (value) => _height = double.tryParse(value!) ?? 0.0,
//             ),
//             ElevatedButton(
//               onPressed: _predictSize,
//               child: Text('Predict'),
//             ),
//             if (_prediction.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 child: Text(
//                   'Predicted T-Shirt Size: $_prediction',
//                   style: TextStyle(fontSize: 18),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../size_config.dart';

class Standard extends StatelessWidget {
  static const String routeName = "/Standard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StandardSize(),
    );
  }
}

class StandardSize extends StatefulWidget {
  @override
  _StandardSizeState createState() => _StandardSizeState();
}

class _StandardSizeState extends State<StandardSize> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _prediction = '';

  Future<String> predictSize(double weight, int age, double height) async {
    final baseUrl = 'http://192.168.1.9:5000';
    // 192.168.1.9:5000
    // Replace with your backend IP address
    final url = Uri.parse('$baseUrl/predict');

    final response = await http.post(
      url,
      body: {
        'weight': weight.toString(),
        'age': age.toString(),
        'height': height.toString(),
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['prediction'];
    } else {
      print('Response Status Code: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  void _predictSize() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        double weight = double.tryParse(_weightController.text) ?? 0.0;
        int age = int.tryParse(_ageController.text) ?? 0;
        double height = double.tryParse(_heightController.text) ?? 0.0;

        final prediction = await predictSize(weight, age, height);
        print(prediction + '123');
        setState(() {
          _prediction = prediction;
        });
      } catch (e) {
        print('Error: $e');
        // Handle error, e.g., show a snackbar or dialog with an error message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Size Predictor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter weight';
                  if (double.parse(value) > 120) {
                    return 'Value is too large';
                  }
                  if (double.parse(value) < 35) {
                    return 'Value is too small';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter age';
                  if (double.parse(value) > 100) {
                    return 'Value is too large';
                  }
                  if (double.parse(value) < 15) {
                    return 'Value is too small';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter height';
                  if (double.parse(value) > 188) {
                    return 'Value is too large';
                  }
                  if (double.parse(value) < 120) {
                    return 'Value is too small';
                  }
                  return null;
                },
              ),
              SizedBox(width: 50.0, height: SizeConfig.screenHeight * 0.02),
              ElevatedButton(
                onPressed: _predictSize,
                child: const Text('Predict'),
              ),
              if (_prediction.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Predicted Standard Size is : $_prediction',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
