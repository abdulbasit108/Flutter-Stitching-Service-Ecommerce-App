import 'package:etailor/components/loader.dart';
import 'package:etailor/models/product.dart';
import 'package:etailor/screens/home/components/product.dart';
import 'package:etailor/services/home_services.dart';
import 'package:flutter/material.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  fetchCategoryProducts() async {
    productList = await homeServices.fetchCategoryProducts(
      context: context,
      category: widget.category,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: productList == null
          ? const Loader()
          : GridView.builder(
              itemCount: productList!.length,
              padding: const EdgeInsets.only(top: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final product = productList![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                            context,
                            ProductPage.routeName,
                            arguments: product,
                          );
                  },
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(product.images[0]),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'PKR ${product.price}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
                
              },
            ),
    );
  }
}
