
import 'package:etailor/screens/order_history/order_details.dart';
import 'package:etailor/services/admin_services.dart';
import 'package:flutter/material.dart';

import '../../../components/loader.dart';
import '../../../components/single_product.dart';
import '../../../models/order.dart';


class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orders;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : GridView.builder(
            itemCount: orders!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              final orderData = orders![index];
              final product = orderData.products[0];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    OrderDetailScreen.routeName,
                    arguments: orderData,
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
                    DateTime.fromMillisecondsSinceEpoch(orderData.orderedAt).toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'PKR ${orderData.totalPrice}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ],
                ),
              );
            },
          );
  }
}
