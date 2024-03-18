import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:etailor/constants.dart';
import 'package:etailor/models/measurement.dart';
import 'package:etailor/models/product.dart';
import 'package:etailor/providers/user_provider.dart';
import 'package:etailor/services/cart_services.dart';
import 'package:etailor/services/measurement_services.dart';
import 'package:etailor/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../components/MeasurementPopup.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

// void main() => runApp(ProductPage());
String? selectedProfile = '';

class ProductPage extends StatefulWidget {
  static const String routeName = "/ProductPage";
  final Product product;
  const ProductPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final CartServices cartServices =
      CartServices();

  List<File> images = [];

  String trouserLength = "";
  String neckStyle = "";
  String sleeveStyle = "";
  final noteController = TextEditingController();

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  void addToCart(String? selectedProfile, String? trouserLength, String? neckStyle, String? sleeveStyle, String? instructions, List<File> images){
    if(instructions == ''){
      instructions = 'No Instructions';
    }
    cartServices.addToCart(
      context: context,
      product: widget.product,
      profile: selectedProfile,
      trouserLength: trouserLength,
      neckStyle: neckStyle,
      sleeveStyle: sleeveStyle,
      instructions: instructions,
      images: images

    );
    showSnackBar(context, 'Added to Cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CarouselSlider(
                          items: widget.product.images.map(
                            (i) {
                              return Builder(
                                builder: (BuildContext context) =>
                                    Image.network(
                                  i,
                                  fit: BoxFit.contain,
                                  height: 200,
                                ),
                              );
                            },
                          ).toList(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            height: 250,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Price: ${widget.product.price}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Neck Style

                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Neck Styles',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: neckStyle == "1"
                                        ? kPrimaryColor
                                        : Colors.transparent,
                                    width: 3)),
                            child: StyleCard(
                              imageUrl: 'assets/images/NeckStyle/style1.png',
                              onTap: () {
                                setState(() {
                                  neckStyle = "1";
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: neckStyle == "2"
                                        ? kPrimaryColor
                                        : Colors.transparent,
                                    width: 3)),
                            child: StyleCard(
                              imageUrl: 'assets/images/NeckStyle/style2.png',
                              onTap: () {
                                setState(() {
                                  neckStyle = "2";
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: neckStyle == "3"
                                        ? kPrimaryColor
                                        : Colors.transparent,
                                    width: 3)),
                            child: StyleCard(
                              imageUrl: 'assets/images/NeckStyle/style3.png',
                              onTap: () {
                                setState(() {
                                  neckStyle = "3";
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: neckStyle == "4"
                                        ? kPrimaryColor
                                        : Colors.transparent,
                                    width: 3)),
                            child: StyleCard(
                              imageUrl: 'assets/images/NeckStyle/style4.png',
                              onTap: () {
                                setState(() {
                                  neckStyle = "4";
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sleeves Style

                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sleeves Styles',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: sleeveStyle == "1"
                                        ? kPrimaryColor
                                        : Colors.transparent,
                                    width: 3)),
                            child: StyleCard(
                              imageUrl: 'assets/images/SleeveStyle/Style1.png',
                              onTap: () {
                                setState(() {
                                  sleeveStyle = "1";
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: sleeveStyle == "2"
                                        ? kPrimaryColor
                                        : Colors.transparent,
                                    width: 3)),
                            child: StyleCard(
                              imageUrl: 'assets/images/SleeveStyle/Style2.png',
                              onTap: () {
                                setState(() {
                                  sleeveStyle = "2";
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: sleeveStyle == "3"
                                        ? kPrimaryColor
                                        : Colors.transparent,
                                    width: 3)),
                            child: StyleCard(
                              imageUrl: 'assets/images/SleeveStyle/Style3.png',
                              onTap: () {
                                setState(() {
                                  sleeveStyle = "3";
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: sleeveStyle == "4"
                                        ? kPrimaryColor
                                        : Colors.transparent,
                                    width: 3)),
                            child: StyleCard(
                              imageUrl: 'assets/images/SleeveStyle/Style4.png',
                              onTap: () {
                                setState(() {
                                  sleeveStyle = "4";
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Trouser Length

                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trouser Length',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  trouserLength = "38";
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: trouserLength == "38"
                                          ? kPrimaryColor
                                          : Colors.transparent,
                                      width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                    child: Text(
                                  '38"',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  trouserLength = "39";
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: trouserLength == "39"
                                          ? kPrimaryColor
                                          : Colors.transparent,
                                      width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                    child: Text(
                                  '39"',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  trouserLength = "40";
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: trouserLength == "40"
                                          ? kPrimaryColor
                                          : Colors.transparent,
                                      width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                    child: Text(
                                  '40"',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                  margin: const EdgeInsets.all(8),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        trouserLength = value;
                                      });
                                    },
                                    style: const TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "+",
                                        hintStyle: TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold)),
                                  )),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Instructions',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: noteController,
                      maxLines: 4,
                      style: const TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Enter Special Instructions',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: kPrimaryColor,
                            )),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sample Images',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(onPressed: (){
                              setState(() {
                                images = [];
                              });
                            }, icon: const Icon(Icons.cancel))
                          ],
                        ),
                      ],
                    ),
                  ),
                  images.isNotEmpty
                      ? CarouselSlider(
                          items: images.map(
                            (i) {
                              return Builder(
                                builder: (BuildContext context) => Image.file(
                                  i,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              );
                            },
                          ).toList(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            height: 200,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: selectImages,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              color: kPrimaryColor,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_open,
                                      size: 40,
                                      color: kPrimaryColor,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Select Sample Images',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (neckStyle != "" &&
                        sleeveStyle != "" &&
                        trouserLength != "") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // Variable to store the selected profile
                          
                          return AlertDialog(
                            title: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Measurement Popup',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            content:
                                MeasurementPopup(onProfileSelected: (profile) {
                              setState(() {
                                selectedProfile = profile;
                              });
                            }),
                            actions: [
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (selectedProfile == '') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Error'),
                                            content: const Text(
                                                'No profile selected. Please select a measurement profile.'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                        
                                      );

                                    } else {
                                      print(noteController.text);
                                      addToCart(selectedProfile, trouserLength, neckStyle, sleeveStyle, noteController.text,images);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Added to Cart'),
                                            content: const Text(
                                                'The item has been successfully added to your cart.'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context
                                                          )
                                                      ..pop()..pop();
                                                  
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: const Text('Continue'),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showSnackBar(context, "Please Select Style and Length");
                    }
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StyleCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  StyleCard({
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }
}

class SleevesCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  SleevesCard({required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }
}

class MeasurementPopup extends StatefulWidget {
  MeasurementPopup({required this.onProfileSelected});
  final Function(String) onProfileSelected;

  @override
  _MeasurementPopupState createState() => _MeasurementPopupState();
}

class _MeasurementPopupState extends State<MeasurementPopup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController profileNameController = TextEditingController();
  TextEditingController chestMeasurementController = TextEditingController();
  TextEditingController waistMeasurementController = TextEditingController();
  TextEditingController hipsMeasurementController = TextEditingController();
  TextEditingController inseamMeasurementController = TextEditingController();
  TextEditingController sleeveMeasurementController = TextEditingController();
  TextEditingController shoulderMeasurementController = TextEditingController();
  
  
  String selectedPreset = '';

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
        Navigator.of(context).pop();
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

  List<Measurement>? profiles;
  final MeasurementServices measurementServices = MeasurementServices();

  @override
  void initState() {
    super.initState();
    fetchProfiles();
  }

  void fetchProfiles() async {
    profiles = await measurementServices.fetchMyProfiles(context: context);
    setState(() {
      if (profiles != null)
      selectedProfile = profiles?[0].profileName;
    });
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        profiles == null ? const Text("No Profiles Available") :
        
        DropdownButton<String>(
          value: selectedProfile,
          hint: const Text('Select Profile'),
          onChanged: (value) {
            setState(() {
              selectedProfile = value;
            });
          },
          items: profiles!.map((profile) {
            return DropdownMenuItem<String>(
              value: profile.profileName,
              child: Text(profile.profileName),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        const Text('Or'),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('New Measurement Profile'),
                    content: SingleChildScrollView(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              hintText: 'Enter chest measurement',
                            ),
                            const SizedBox(height: 12.0),
                            MeasurementInputField(
                              controller: waistMeasurementController,
                              hintText: 'Enter waist measurement',
                            ),
                            const SizedBox(height: 12.0),
                            MeasurementInputField(
                              controller: hipsMeasurementController,
                              hintText: 'Enter hips measurement',
                            ),
                            const SizedBox(height: 12.0),
                            MeasurementInputField(
                              controller: inseamMeasurementController,
                              hintText: 'Enter inseam measurement',
                            ),
                            const SizedBox(height: 12.0),
                            MeasurementInputField(
                              controller: sleeveMeasurementController,
                              hintText: 'Enter sleeve measurement',
                            ),
                            const SizedBox(height: 12.0),
                            MeasurementInputField(
                              controller: shoulderMeasurementController,
                              hintText: 'Enter shoulder measurement',
                            ),
                            TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            sendMeasurementsToApi();
                            Navigator.of(context).pop();
                          }
                          
                        },
                        child: const Text('Save'),
                      ),
                          ],
                        ),
                      ),
                    ])),
                    );
              },
            );
          },
          child: const Text('Create New Profile'),
        ),
      ],
    );
  }
}

class MeasurementInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const MeasurementInputField({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
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
