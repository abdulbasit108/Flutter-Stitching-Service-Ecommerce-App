import 'package:etailor/screens/admin/screens/orders_screen.dart';
import 'package:etailor/screens/admin/screens/posts_screen.dart';
import 'package:etailor/services/account_services.dart';
import 'package:flutter/material.dart';


class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin-screen';
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const PostsScreen(),
    const OrdersScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/logo-01.png',
                  width: 120,
                  height: 45,
                  
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Admin',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: () => 
                      AccountServices().logOut(context),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.black,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: Colors.blue,
        //unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: Colors.white,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // POSTS
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? Colors.blue
                        : Colors.white,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: '',
          ),
          // ANALYTICS

          // ORDERS
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? Colors.blue
                        : Colors.white,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.all_inbox_outlined,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
