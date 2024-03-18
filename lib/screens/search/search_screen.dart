import 'package:etailor/components/loader.dart';
import 'package:etailor/models/product.dart';
import 'package:etailor/screens/home/components/product.dart';
import 'package:etailor/services/search_services.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';
  final String searchQuery;
  const SearchScreen({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product>? products;
  final SearchServices searchServices = SearchServices();

  @override
  void initState() {
    super.initState();
    fetchSearchedProduct();
  }

  fetchSearchedProduct() async {
    products = await searchServices.fetchSearchedProduct(
        context: context, searchQuery: widget.searchQuery);
    setState(() {});
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey[100],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              onFieldSubmitted: navigateToSearchScreen,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
              // Handle search field changes or submissions
            ),
          ),
        ),
      ),
      body: products == null
          ? const Loader()
          : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
              ),
            itemCount: products!.length,
            itemBuilder: (context, index) {
              final product = products![index];
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
                        style:
                            const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'PKR ${product.price}',
                        style:
                            const TextStyle(fontWeight: FontWeight.bold),
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
