import 'package:flutter/material.dart';
import 'package:gossip_app/pages/homepage/home_page.dart';

class AuthProvider extends ChangeNotifier {
  Future<void> initalStartApp(context) async {
    Future.delayed(
      Duration(seconds: 3),
      () async {
        // var freshInstaller = await storage.read(key: kFreshInstaller);
        // if (freshInstaller == "true") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false);
        // } else {
        //   await storage.write(key: kFreshInstaller, value: 'true');
        //   Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        //       (route) => false);
        // }
      },
    );
  }
}
