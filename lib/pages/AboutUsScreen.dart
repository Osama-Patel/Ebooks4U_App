import 'package:flutter/material.dart';
import 'package:learnera/constant/colors.dart';
import 'package:learnera/constant/images.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolor().primarycolor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset(
                  Appimg().splashlogo,
                  height: 150,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Email :',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Appcolor().primarycolor,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Ebooks4U@gmail.com',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Company :',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Appcolor().primarycolor,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Ebooks 4U Ltd.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'App info',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Name :',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Appcolor().primarycolor,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Ebooks 4U',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Version :',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Appcolor().primarycolor,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '1.0.0',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'About',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Ebooks 4U is your go-to destination for all your ebook needs. We offer a vast collection of ebooks across various genres for you to explore and enjoy. Display information about the apps current version, including release notes, updates, etc. Our mission is to provide a seamless reading experience to our users, along with exciting features to enhance their journey with us.\n',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
