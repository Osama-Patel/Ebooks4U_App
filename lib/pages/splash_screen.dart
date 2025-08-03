import 'dart:async';

import 'package:flutter/material.dart';

import 'package:learnera/constant/images.dart';

import 'package:learnera/pages/home_screen.dart';

import 'package:learnera/pages/onboarding_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _simulateSplash(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Appimg().splashlogo,
                    height: 150,
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          if (snapshot.data!) {
            return MyHome();
          } else {
            return OnbordingScreen();
          }
        }
      },
    );
  }

  Future<bool> _simulateSplash() async {
    await Future.delayed(Duration(seconds: 3)); // Simulate a 3-second delay
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('isLoggedIn')
        ? prefs.getBool('isLoggedIn') ?? false
        : false;
  }
}
