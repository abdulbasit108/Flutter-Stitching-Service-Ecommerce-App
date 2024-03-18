import 'package:etailor/components/loader.dart';
import 'package:etailor/components/single_product.dart';
import 'package:etailor/models/order.dart';
import 'package:etailor/screens/order_history/order_details.dart';
import 'package:etailor/services/account_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AllOrders extends StatefulWidget {
  static const String routeName = '/all-orders';
  const AllOrders({Key? key}) : super(key: key);

  @override
  State<AllOrders> createState() => _OrdersState();
}

class _OrdersState extends State<AllOrders> {
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);
    print(orders!.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Orders'),
        ),
        body: orders == null
            ? const Loader()
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                    crossAxisCount: 2,),
                itemCount: orders!.length,
                
                itemBuilder: (context, index) {
                  final order = orders![index];
                  final product = order.products[0];
                  
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        OrderDetailScreen.routeName,
                        arguments: order,
                      );
                    },
                    child: Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(
                        image: product.product.images[0],
                      ),
                    ),
                    Text(
                    DateFormat().format(
                      DateTime.fromMillisecondsSinceEpoch(
                          order.orderedAt)),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'PKR ${order.totalPrice}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ],
                ),
                  );
                },
              )
                
              )
              
              ;
  }
}
