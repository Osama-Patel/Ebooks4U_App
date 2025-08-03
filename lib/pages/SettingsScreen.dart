import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:learnera/constant/colors.dart';
import 'package:learnera/main.dart';
import 'package:learnera/pages/AboutUsScreen.dart';

import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Appcolor().primarycolor,
          title: Text(
            "Settings",
            style: TextStyle(color: Appcolor().whtcolor),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Enable Dark Mode'),
              trailing: SwitchButton(),
            ),
            Divider(),
            ListTile(
              title: Text('About Us'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.to(AboutUsScreen());
              },
            ),
            Divider(),
          ],
        ));
  }
}

class SwitchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return Switch(
      activeColor: Appcolor().primarycolor,
      //  trackColor: MaterialStatePropertyAll(Colors.blue.shade100),
      activeTrackColor: Colors.blue.shade100,
      value: Theme.of(context).brightness == Brightness.dark,
      onChanged: (value) {
        themeNotifier.toggleTheme();
      },
    );
  }
}
