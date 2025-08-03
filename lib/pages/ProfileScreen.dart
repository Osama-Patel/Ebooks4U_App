// ignore_for_file: must_be_immutable, deprecated_member_use, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:learnera/constant/colors.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:learnera/services/UserDataProvider.dart';
import 'package:learnera/pages/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleSignOut(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                await _googleSignIn.signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Appcolor().primarycolor,
                    ),
                  ),
                  Positioned(
                    top: 25,
                    left: 5,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              size: 25, color: Appcolor().whtcolor),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 90),
                          child: Text(
                            'PROFILE',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Appcolor().whtcolor),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 170,
                    child: FutureBuilder<String?>(
                      future: UserDataProvider.getPhotoUrl(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data ?? ''),
                            radius: 144 / 2,
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 30),
                child: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 20,
                    color: Appcolor().primarycolor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: FutureBuilder<String?>(
                  future: UserDataProvider.getUsername(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(
                        snapshot.data! ?? '',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 20),
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 20,
                    color: Appcolor().primarycolor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: FutureBuilder<String?>(
                  future: UserDataProvider.getGmail(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(
                        snapshot.data! ?? '',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 85, left: 80),
                child: SizedBox(
                  height: 60,
                  width: 190,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Appcolor().primarycolor)),
                    onPressed: () {
                      _handleSignOut(context);
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        color: Appcolor().whtcolor,
                      ),
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
