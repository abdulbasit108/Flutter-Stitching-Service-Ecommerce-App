import 'package:carousel_slider/carousel_slider.dart';
import 'package:etailor/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  final Order order;
  const OrderDetailScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  //final AdminServices adminServices = AdminServices();

  // void navigateToSearchScreen(String query) {
  //   Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'View order details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Date:      ${DateFormat().format(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.order.orderedAt),
                    )}'),
                    Text('Order ID:          ${widget.order.id}'),
                    Text('Order Total:     PKR ${widget.order.totalPrice}'),
                    Text('Quick Ship:      ${widget.order.isQuick == false ? 'No' : 'Yes'}'),
                    Text(
                        'Address:          ${widget.order.address.addressData}'),
                    Text(
                        'Payment:         PKR ${widget.order.payment.paymentData}'),
                    
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Purchase Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < widget.order.products.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  widget.order.products[i].product.images[0],
                                  height: 120,
                                  width: 120,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.order.products[i].product.name,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'PKR ${widget.order.products[i].product.price.toString()}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Qty: ${widget.order.products[i].quantity}',
                                      ),
                                      Text(
                                        "Neck Style No: ${widget.order.products[i].neckStyle} \nSleeve Style No: ${widget.order.products[i].sleeveStyle} \nTrouser Lenght: ${widget.order.products[i].trouserLength} \nInstructions: ${widget.order.products[i].instructions} \nMeasurement Profile: ${widget.order.products[i].measurement.profileName}",
                                        style: const TextStyle(
                                          color: Colors.teal,
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            widget.order.products[i].images.isNotEmpty ?
                            CarouselSlider(
                              items: widget.order.products[i].images.map(
                                (i) {
                                  return Builder(
                                    builder: (BuildContext context) =>
                                        Image.network(
                                      i,
                                      fit: BoxFit.contain,
                                      height: 150,
                                    ),
                                  );
                                },
                              ).toList(),
                              options: CarouselOptions(
                                viewportFraction: 1,
                                height: 200,
                              ),
                            )
                            : Text('No Sample Images Provided')

                    
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
