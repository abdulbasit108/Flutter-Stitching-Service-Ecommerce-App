import 'dart:convert';

import 'package:etailor/constants.dart';
import 'package:etailor/models/user.dart';
import 'package:etailor/providers/user_provider.dart';
import 'package:etailor/services/shipping_services.dart';
import 'package:etailor/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

String? selectedAddress = '';
String? selectedPayment = '';

class ShippingScreen extends StatefulWidget {
  static const routeName = '/shipping';
  final String totalAmount;
  final bool isQuick;
  const ShippingScreen(
      {super.key, required this.totalAmount, required this.isQuick});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final ShippingServices shippingServices = ShippingServices();
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            if (selectedAddress != '' && selectedPayment != '') {
              shippingServices.placeOrder(
                context: context,
                address: selectedAddress!,
                payment: selectedPayment!,
                totalSum: double.parse(widget.totalAmount),
                isQuick: widget.isQuick,
              );
            } else {
              showSnackBar(context, 'Select Address & Payment Options');
            }
          },
          label: Text(
            'Place Order'.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(17.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 326.w,
                      height: 128.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: kPrimaryColor,
                                ),
                                SizedBox(
                                  width: 10.83.w,
                                ),
                                const Text(
                                  'Delivery Address',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Address Popup',
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
                                      content: AddressPopup(
                                          onAddressSelected: (address) {
                                        setState(() {
                                          selectedAddress = address;
                                        });
                                      }),
                                      actions: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Continue'),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    'Add Delivery Address',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                  ),
                                  SizedBox(
                                    width: 13.w,
                                  ),
                                  Container(
                                      width: 17,
                                      height: 17,
                                      decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 17,
                                      ))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text(
                              'Current Address: $selectedAddress',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 13.h,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 326.w,
                      height: 128.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.credit_card,
                                color: kPrimaryColor,
                              ),
                              SizedBox(
                                width: 10.83.w,
                              ),
                              const Text(
                                'Payment Method',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Payment Popup',
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
                                    content: PaymentPopup(
                                        onPaymentSelected: (payment) {
                                      setState(() {
                                        selectedPayment = payment;
                                      });
                                    }),
                                    actions: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Continue'),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                const Text(
                                  'Add Payment Method',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  width: 13.w,
                                ),
                                Container(
                                    width: 17,
                                    height: 17,
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(100)),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 17,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            'Current Payment Method: $selectedPayment',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 13.h,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 326.w,
                      height: 128.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Selected Measurement Profiles',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            for (int i = 0; i < user.cart.length; i++)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 0),
                                child: Text(
                                    '${user.cart[i]['product']['name']}: ${user.cart[i]['profileData']['profileName']}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              )
                          ],
                        ),
                      ),
                    )
                  ]),
            )));
  }
}

class AddressPopup extends StatefulWidget {
  AddressPopup({required this.onAddressSelected});
  final Function(String) onAddressSelected;

  @override
  _AddressPopupState createState() => _AddressPopupState();
}

class _AddressPopupState extends State<AddressPopup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController addressLabelController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  ShippingServices shippingServices = ShippingServices();

  Future<void> sendAddressToApi() async {
    String addressLabel = addressLabelController.text;
    String street = streetController.text;
    String postCode = postCodeController.text;
    String city = cityController.text;

    String addressData = "$street, $postCode, $city ";

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.post(Uri.parse('$uri/api/save-user-address'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'addressLabel': addressLabel,
            'addressData': addressData,
          }));

      if (response.statusCode == 200) {
        // Measurements successfully sent to the API
        User user = userProvider.user
            .copyWith(address: jsonDecode(response.body)['address']);
        userProvider.setUserFromModel(user);
        Navigator.of(context).pop();
      } else {
        // Handle API error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to send address entry to API.'),
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
            content: Text('Failed to send address entry to API. $e'),
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

  List<dynamic>? address;
  @override
  void initState() {
    super.initState();
    fetchAddress();
  }

  void fetchAddress() async {
    address = await shippingServices.fetchMyAddress(context: context);

    setState(() {
      if (address != null) selectedAddress = address?[0]['addressLabel'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        address == null
            ? const Text("No Address Available")
            : DropdownButton<String>(
                value: selectedAddress,
                hint: const Text('Select Address'),
                onChanged: (value) {
                  setState(() {
                    selectedAddress = value;
                  });
                },
                items: address!.map((address) {
                  return DropdownMenuItem<String>(
                    value: address['addressLabel'],
                    child: Text(address['addressLabel']),
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
                  title: const Text('New Address'),
                  content: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 0.1),
                          const Text(
                            'Enter Your Address Label',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: addressLabelController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: 'Enter Label',
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
                            'Enter Address Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          ShippingInputField(
                            controller: streetController,
                            keyboardType: TextInputType.text,
                            hintText: 'Enter Street Address',
                          ),
                          const SizedBox(height: 12.0),
                          ShippingInputField(
                            controller: postCodeController,
                            keyboardType: TextInputType.number,
                            hintText: 'Enter Post Code',
                          ),
                          const SizedBox(height: 12.0),
                          ShippingInputField(
                            controller: cityController,
                            keyboardType: TextInputType.text,
                            hintText: 'Enter City',
                          ),
                          const SizedBox(height: 12.0),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                sendAddressToApi();
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
          child: const Text('Create New Address'),
        ),
      ],
    );
  }
}

class PaymentPopup extends StatefulWidget {
  PaymentPopup({required this.onPaymentSelected});
  final Function(String) onPaymentSelected;

  @override
  _PaymentPopupState createState() => _PaymentPopupState();
}

class _PaymentPopupState extends State<PaymentPopup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController paymentLabelController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  ShippingServices shippingServices = ShippingServices();

  Future<void> sendPaymentToApi() async {
    String paymentLabel = paymentLabelController.text;
    String expiry = expiryController.text;
    String code = codeController.text;
    String name = nameController.text;

    String paymentData = "$name, $expiry, $code";

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.post(Uri.parse('$uri/api/save-user-payment'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'paymentLabel': paymentLabel,
            'paymentData': paymentData,
          }));

      if (response.statusCode == 200) {
        User user = userProvider.user
            .copyWith(payment: jsonDecode(response.body)['payment']);
        userProvider.setUserFromModel(user);
        Navigator.of(context).pop();
      } else {
        // Handle API error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to send payment entry to API.'),
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
            content: Text('Failed to send payment entry to API. $e'),
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

  List<dynamic>? payment;
  @override
  void initState() {
    super.initState();
    fetchPayment();
  }

  void fetchPayment() async {
    payment = await shippingServices.fetchMyPayment(context: context);

    setState(() {
      if (payment != null) selectedPayment = payment?[0]['paymentLabel'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        payment == null
            ? const Text("No Payment Method Available")
            : DropdownButton<String>(
                value: selectedPayment,
                hint: const Text('Select Method'),
                onChanged: (value) {
                  setState(() {
                    selectedPayment = value;
                  });
                },
                items: payment!.map((payment) {
                  return DropdownMenuItem<String>(
                    value: payment['paymentLabel'],
                    child: Text(payment['paymentLabel']),
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
                  title: const Text('New Payment Method'),
                  content: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 0.1),
                          const Text(
                            'Enter Name on Card',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: 'Enter Name',
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
                            'Enter Card Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            controller: paymentLabelController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Enter Card Number',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 12.0),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (value.length != 16) {
                                return 'Card Number should be 16 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            controller: codeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Enter CVC',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 12.0),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (value.length != 3) {
                                return 'CVC Code should be 3 digit';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            controller: expiryController,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              hintText: 'Enter Expiry of Card',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 12.0),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              final dateFormat = DateFormat('dd/MM/yyyy');
                              try {
                                dateFormat.parseStrict(value);
                              } catch (e) {
                                return 'Invalid! Enter Like dd/MM/yyyy';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12.0),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                sendPaymentToApi();
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
          child: const Text('Create New Method'),
        ),
      ],
    );
  }
}

class ShippingInputField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;

  const ShippingInputField({
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
