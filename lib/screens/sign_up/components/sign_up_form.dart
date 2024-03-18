import 'package:flutter/material.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../services/auth_service.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  String? name;
  String? email;
  String? number;
  final List<String> errors = [];

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void signUpUser() async {
    authService.signUpUser(
      context: context,
      email: email,
      phone: number,
      name: name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildNumberFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "SIGNUP",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                signUpUser(); // Pass the context to handleSignup
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      decoration: InputDecoration(
        hintText: "Enter Your Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Name.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Enter Your Email Address",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => number = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        } else if (phoneValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidPhoneError);
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        } else if (!phoneValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidPhoneError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Enter Your Phone Number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }
}
