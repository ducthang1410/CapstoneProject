import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
      theme: ThemeData(dividerColor: Colors.grey.shade800, primaryColor: Colors.grey),
      home: const LoginPage(),
      // home: HomePage(role: 2,),
      // home: SendApplication(),
    );
  }
}
