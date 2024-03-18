import 'package:etailor/components/custom_button.dart';
import 'package:etailor/constants.dart';
import 'package:etailor/models/product.dart';
import 'package:etailor/screens/cart/widgets/cart_product.dart';
import 'package:etailor/screens/shipping/shipping_screen.dart';
import 'package:etailor/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


import '../../../providers/user_provider.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart';
  
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool quick = false;

  void navigateToAddress(int sum, bool quick) {
    Navigator.pushNamed(
      context,
      ShippingScreen.routeName,
      arguments: <String, dynamic>{'totalAmount': sum.toString(), 'isQuick': quick},
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int quickFee = 0;
    int sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();
    int shipping = 0;
    if(user.cart.length <=1){
      shipping = 400;
    }
    if(quick == true){
      quickFee = 200;
    }

    sum = sum + shipping + quickFee;

    

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: 
        AppBar(
         backgroundColor: Colors.white,
        ),
      body: Column(
        children: [
          SizedBox(
            height: 375.h,
            child: ListView.builder(
              //scrollDirection: Axis.vertical,
              itemCount: user.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(
                  index: index,
                );
              },
            ),
          ),
          Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        
        children: [
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              //scrollDirection: Axis.vertical,
              
              itemCount: user.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final productCart = user.cart[index];
                  final product = Product.fromMap(productCart['product']);
                  final quantity = productCart['quantity'];
                return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  "${product.name} (x${quantity})",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Rs ${product.price.toString()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
              },
            ),
          ),
          const SizedBox(height: 10,),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                'Tailoring ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Free',
                style:  TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shipping ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                shipping == 0 ?
                'Free' : 'Rs $shipping',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quick Shipping (Rs.200)',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Checkbox(value: quick, onChanged: (bool? isChecked){
                setState(() {
                  quick = isChecked!;
                  
                });
              })
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total: ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Rs $sum',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: CustomButton(
              text: 'Continue to Shipping',
              onTap: () {
                if (user.cart.isNotEmpty) {
                  navigateToAddress(sum, quick);
                  
                } else {
                  showSnackBar(context, 'Cart is Empty');
                }
              },
              color: kPrimaryColor,
            ),
          ),
          
          
          
        ],
      ),
    );
  }
}
