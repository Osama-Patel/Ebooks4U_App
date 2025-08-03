import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get_navigation/get_navigation.dart';

import 'package:learnera/pages/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();

  ThemeData getTheme() => _themeData;
  void toggleTheme() {
    if (_themeData == ThemeData.light()) {
      _themeData = ThemeData.dark();
    } else {
      _themeData = ThemeData.light();
    }
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(),
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return GetMaterialApp(
            theme: themeNotifier.getTheme(),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
