import 'package:etailor/components/loader.dart';
import 'package:etailor/providers/user_provider.dart';
import 'package:etailor/screens/admin/screens/admin_screen.dart';
import 'package:etailor/screens/measurement/measurement.dart';
import 'package:etailor/services/auth_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'routes.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context , child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //initialRoute: SplashScreen.routeName,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const AuthenticationHandler(),
    );
  });
  }
}

class AuthenticationHandler extends StatelessWidget {
  const AuthenticationHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return FutureBuilder<void>(
      future: authService.getUserData(context),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loader while waiting for the future to complete
          return const Loader();
        } else if (snapshot.hasError) {
          // Handle any errors that occurred during the future execution
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final user = Provider.of<UserProvider>(context).user;
          return user.token.isNotEmpty
              ? user.type == 'user'
                  ? measurement()
                  : const AdminScreen()
              : SplashScreen();
        }
      },
    );
  }
}
