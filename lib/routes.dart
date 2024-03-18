import 'package:etailor/models/order.dart';
import 'package:etailor/models/product.dart';
import 'package:etailor/screens/admin/screens/add_product_screen.dart';
import 'package:etailor/screens/admin/screens/admin_screen.dart';
import 'package:etailor/screens/admin/screens/update_product_screen.dart';
import 'package:etailor/screens/cart/screens/cart_screen.dart';
import 'package:etailor/screens/home/category_screen.dart';
import 'package:etailor/screens/measurement/components/Standard.dart';
import 'package:etailor/screens/order_history/all_orders.dart';
import 'package:etailor/screens/order_history/order_details.dart';
import 'package:etailor/screens/search/search_screen.dart';
import 'package:etailor/screens/shipping/shipping_screen.dart';
import 'package:flutter/material.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/otp/otp_screen.dart';
import 'screens/measurement/measurement.dart';
import 'screens/measurement/components/Manual.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/components/product.dart';

// We use name route
// All our routes will be available here
// final Map<String, WidgetBuilder> routes = {
//   SplashScreen.routeName: (context) => SplashScreen(),
//   SignInScreen.routeName: (context) => SignInScreen(),
//   SignUpScreen.routeName: (context) => SignUpScreen(),
//   OtpScreen.routeName:(context) => OtpScreen(),
//   measurement.routeName:(context) => measurement(),
//   manual.routeName:(context) => manual(),
//   HomeScreen.routeName:(context) => HomeScreen(),
//   Product.routeName:(context) => Product(),
//   Measurement.routeName:(context) => Measurement(),
//   Standard.routeName:(context) => Standard(),
//   AdminScreen.routeName:(context) => AdminScreen(),
//   AddProductScreen.routeName:(context) => AddProductScreen(),
//   CategoryDealsScreen.routeName:(context) => CategoryDealsScreen()
//   // MeasurementPopup.routeName:(context) => MeasurementPopup();

// };
// TODO Implement this library.

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SplashScreen(),
      );

    case SignInScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SignInScreen(),
      );

    case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SignUpScreen(),
      );

    case OtpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OtpScreen(),
      );

    case measurement.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => measurement(),
      );

    case manual.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => manual(),
      );

    case Standard.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => Standard(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomeScreen(),
      );

    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );

    case UpdateProductScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => UpdateProductScreen(
          product: product,
        ),
      );

    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );

    case ProductPage.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductPage(
          product: product,
        ),
      );

    case CartScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CartScreen(),
      );

    case ShippingScreen.routeName:
      var args = routeSettings.arguments
          as Map<String, dynamic>; 

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ShippingScreen(
          totalAmount: args['totalAmount']
              as String, 
          isQuick: args['isQuick']
              as bool, 
        ),
      );

    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(
          order: order,
        ),
      );
    case AllOrders.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AllOrders(),
      );
    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminScreen(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
