import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:learnera/constant/colors.dart';
import 'package:learnera/constant/images.dart';
import 'package:learnera/constant/text.dart';
import 'package:learnera/services/UserDataProvider.dart';
import 'package:learnera/pages/dataupload_form.dart';
import 'package:learnera/pages/home_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  googleLogin() async {
    debugPrint("Google Login method call");

    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var result = await googleSignIn.signIn();
      if (result == null) {
        return;
      }
      final googleAuth = await result.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      // final userdata = await result.authentication;
      // final credential = GoogleAuthProvider.credential(
      //     accessToken: userdata.accessToken, idToken: userdata.idToken);

      // final finalresult =
      //     await FirebaseAuth.instance.signInWithCredential(credential);
      String email = result.email;
      String? username = result.displayName;
      String? photoUrl = result.photoUrl;
      print(result);
      print(result.displayName);
      print(result.photoUrl);
      print(result.email);
      if (result.email == 'aaftabpatel918@gmail.com' ||
          result.email == 'gabbarsingh997654@gmail.com') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      } else {
        await UserDataProvider.saveUserData(photoUrl!, username!, email);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHome()));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ExitAlertDialog();
          },
        );
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Text(
                "Ebooks 4U",
                style: const TextStyle(
                  fontSize: 40,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 100,
              ),
              Image.asset(Appimg().log4),
              const Text(
                "Login/Signup using Gmail Address",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
              const Text(
                "Your gmail address for newsletter purpose\nWe notify you with every new update of app\ncontent.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 17,
                width: MediaQuery.of(context).size.width / 1.20,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Appcolor().primarycolor),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () {
                    googleLogin();
                  },
                  child: Text(
                    Apptxt().congoogle,
                    style: const TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExitAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Exit'),
      content: Text('Are you sure you want to exit?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('No'),
        ),
        TextButton(
          onPressed: () {
            exit(0);
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}
