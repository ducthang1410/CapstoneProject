import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:toy_world/screens/home_page.dart';

import 'package:toy_world/screens/login_page.dart';
import 'package:toy_world/utils/helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = colorHexa("7265fa")
    ..backgroundColor = Colors.white
    ..indicatorColor = colorHexa("7265fa")
    ..textColor = Colors.black87
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: ThemeData(
          dividerColor: Colors.grey.shade800, primaryColor: Colors.grey),
      // home: const LoginPage(),
      home: AnimatedSplashScreen(
        splashIconSize: 180,
        centered: true,
        duration: 1500,
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: const Color(0xffDB36A4),
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(child: Text("Welcome to", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),)),
            Expanded(child: Image.asset("assets/icons/Logo_Word_Black_Pink.png", width: 250,))
          ],
        ),
        nextScreen: const LoginPage(),
      ),
    );
  }
}
