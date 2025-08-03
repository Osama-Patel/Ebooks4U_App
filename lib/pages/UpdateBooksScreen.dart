import 'package:flutter/material.dart';
import 'package:learnera/constant/colors.dart';
import 'package:learnera/pages/UpdateNewBooks.dart';
import 'package:learnera/pages/UpdateNovelGenres.dart';
import 'package:learnera/pages/UpdatePop1.dart';
import 'package:learnera/pages/UpdatePop2.dart';
import 'package:learnera/pages/UpdateTrending.dart';

class UpdateBooksScreen extends StatefulWidget {
  const UpdateBooksScreen({super.key});

  @override
  State<UpdateBooksScreen> createState() => _UpdateBooksScreenState();
}

class _UpdateBooksScreenState extends State<UpdateBooksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              "Update Books",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 20),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Appcolor().primarycolor),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UpdatePop1()));
              },
              child: Text(
                "Update Popular Genres 1",
                style: TextStyle(color: Appcolor().whtcolor),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 45,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Appcolor().primarycolor),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UpdatePop2()));
              },
              child: Text(
                "Update Popular Genres 2",
                style: TextStyle(color: Appcolor().whtcolor),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 45,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Appcolor().primarycolor),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateNovelGenres()));
              },
              child: Text(
                "Update Novel Genres",
                style: TextStyle(color: Appcolor().whtcolor),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 45,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Appcolor().primarycolor),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateTrendingGenres()));
              },
              child: Text(
                "Update Trending Genres",
                style: TextStyle(color: Appcolor().whtcolor),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 45,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Appcolor().primarycolor),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UpdateNewBooks()));
              },
              child: Text(
                "Update New Books",
                style: TextStyle(color: Appcolor().whtcolor),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
