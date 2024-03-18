import 'package:etailor/constants.dart';
import 'package:etailor/providers/user_provider.dart';
import 'package:etailor/screens/cart/screens/cart_screen.dart';
import 'package:etailor/screens/home/category_screen.dart';
import 'package:etailor/screens/home/components/product.dart';
import 'package:etailor/screens/order_history/all_orders.dart';
import 'package:etailor/screens/search/search_screen.dart';
import 'package:etailor/services/account_services.dart';
import 'package:etailor/services/home_services.dart';
import 'package:etailor/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> productList = [];
  final HomeServices homeServices = HomeServices();

  
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }
  
   @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  fetchCategoryProducts() async {
    productList = await homeServices.fetchProducts(
      context: context,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.deepPurple),
          elevation: 0,
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey[100],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              onFieldSubmitted: navigateToSearchScreen,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
              // Handle search field changes or submissions
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Colors.deepPurple,
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);

              },

            ),
          ],
        ),

        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(height: 50.h,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user.name!, style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),textAlign: TextAlign.center,),
                
                      Text('${user.phone!} \n${user.email}',textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                        overflow: TextOverflow.visible,
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50.h,),
              ListTile(
                leading: const Icon(Icons.home),
                iconColor: Colors.deepPurple,
                title: const Text('Home'),

                onTap: () {
                  Navigator.pop(context);
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.history),
                iconColor: Colors.deepPurple,
                title: const Text('Order History'),
                onTap: () {
                  Navigator.pushNamed(context, AllOrders.routeName);
                },
              ),

              ListTile(
                leading: const Icon(Icons.category),
                iconColor: Colors.deepPurple,
                title: const Text('Logout'),
                onTap: () {
                  AccountServices().logOut(context);
                },
              ),
              // Add more drawer items as needed
            ],
          ),
        ),
        body: ListView(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/banner.png'),
                  fit: BoxFit.cover,
                ),
              ), // Placeholder for banner image
            ),
            Container(
              alignment: Alignment.center,
              height: 30,
              decoration: const BoxDecoration(
                color: kPrimaryColor
              ),
              child: const Text('FREE TAILORING WITH EVERY PURCHASE!',
              
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 210,
              child: GridView.builder(
              itemCount: productList.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                
              ),
              itemBuilder: (context, index) {
                final product = productList[index];
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
            ),
            // ...
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Collections',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: 'Ideas');
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
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
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Collection/Ideas Logo.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: 'Khaadi');
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
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
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Collection/Khaadi Logo.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: 'MariaB');
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Collection/Khaadi Logo.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,

                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: 'NishatLinen');
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Collection/Ideas Logo.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

// ...

          ],
        ),
      );
    
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;

  ProductCard({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Product Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            '\$99.99',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
