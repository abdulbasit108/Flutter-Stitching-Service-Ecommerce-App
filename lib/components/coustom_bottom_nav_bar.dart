import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
//import 'package:flutter_svg/flutter_svg.dart';



import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    //final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: const SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // IconButton(
              //   icon: SvgPicture.asset(
              //     "assets/icons/Shop Icon.svg",
              //     color: MenuState.home == selectedMenu
              //         ? kPrimaryColor
              //         : inActiveIconColor,
              //   ),
              //   onPressed: () =>
              //       Navigator.pushNamed(context, HomeScreen.routeName),
              // ),
              // IconButton(
              //   icon: SvgPicture.asset("assets/icons/Heart Icon.svg"),
              //   onPressed: () {},
              // ),
              // IconButton(
              //   icon: SvgPicture.asset("assets/icons/Chat bubble Icon.svg"),
              //   onPressed: () {},
              // ),
              // IconButton(
              //   icon: SvgPicture.asset(
              //     "assets/icons/User Icon.svg",
              //     color: MenuState.profile == selectedMenu
              //         ? kPrimaryColor
              //         : inActiveIconColor,
              //   ),
              //   onPressed: () =>
              //       Navigator.pushNamed(context, ProfileScreen.routeName),
              // ),
            ],
          )),
    );
  }
}
