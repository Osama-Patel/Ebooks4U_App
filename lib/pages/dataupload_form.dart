import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:learnera/constant/colors.dart';
import 'package:learnera/pages/DeleteBooksScreen.dart';
import 'package:learnera/pages/AddBooksScreen.dart';
import 'package:learnera/pages/UpdateBooksScreen.dart';
import 'package:learnera/pages/login_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    AddBooksScreen(),
    UpdateBooksScreen(),
    DeleteBooksScreen()
  ];
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
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // await prefs.setBool('isLoggedIn', false);
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
        appBar: AppBar(
          title: Text(
            'Admin',
            style: TextStyle(color: Appcolor().whtcolor),
          ),
          backgroundColor: Appcolor().primarycolor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  _handleSignOut(context);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GNav(
              tabBackgroundColor: Color.fromRGBO(32, 117, 143, 1),
              activeColor: Colors.white,
              gap: 8,
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.menu_book,
                  text: 'Add Books',
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                GButton(
                  icon: Icons.update,
                  text: 'Update Books',
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                GButton(
                  icon: Icons.delete,
                  text: 'Delete Books',
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
