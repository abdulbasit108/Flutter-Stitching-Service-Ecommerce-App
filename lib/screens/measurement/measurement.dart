import 'package:etailor/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import '../../size_config.dart';
import '../../components/default_button.dart';
import 'components/Manual.dart';
import 'components/Standard.dart';


class measurement extends StatelessWidget {
  static const String routeName = "/measurement";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text("Sign In"),
      // ),
      body: MeasurePage(),
    );
  }
}

class MeasurePage extends StatefulWidget {
  @override
  _MeasurePageState createState() => _MeasurePageState();
}

class _MeasurePageState extends State<MeasurePage> {
  String selectedPreset = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Tailoring App'),
      // ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(width: 50.0,height: SizeConfig.screenHeight * 0.05),
              Image.asset('assets/images/logo-01.png'),

              SizedBox(height: SizeConfig.screenHeight * 0.01),
              Text(
                "For better experience, provide us with your measurements using one of the options:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(17),
                  fontWeight: FontWeight.w500,
                ),

              ),

              // Card
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, manual.routeName);
                },
                child: const CardWidget(
                  heading: 'Enter Measurements',
                  text: 'Manually provide your measurements by using preset values or entering them',
                  icon: Icons.edit_outlined,
                ),
              ),

              // GestureDetector(
              //   onTap: () {
              //     // Navigator.pushNamed(context, manualpage.routeName);
              //   },
              //   child:CardWidget(
              //     heading: 'Virtual Measure',
              //     text: 'Using your phone camera, find out your measurements',
              //     icon: Icons.mobile_friendly_outlined,
              //   ),
              // ),

              GestureDetector(
                onTap: () {
                   Navigator.pushNamed(context, Standard.routeName);
                },
                child:const CardWidget(
                  heading: 'Get Your Standard Size',
                  text: 'By Entering the height, weight and age, Get your standard size',
                  icon: Icons.mobile_friendly_outlined,
                ),
              ),


              SizedBox(height: getProportionateScreenHeight(20)),
              DefaultButton(

                  text: "I will do it later",
                  press: () {
                    // if all are valid then go to success screen
                    // KeyboardUtil.hideKeyboard(context);
                    Navigator.pushNamed(context, HomeScreen.routeName);
                  }
              ),


            ],
          ),
        ),
      ),
    );
  }
}


class CardWidget extends StatelessWidget {
  final String heading;
  final String text;
  final IconData icon;

  const CardWidget({
    required this.heading,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

      return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 8),

            Text(
              heading,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(text,textAlign: TextAlign.center,),
          ],
        ),
      ),
    // ),
    );
  }
}