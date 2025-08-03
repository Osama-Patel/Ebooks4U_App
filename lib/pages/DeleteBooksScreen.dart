import 'package:flutter/material.dart';
import 'package:learnera/constant/colors.dart';
import 'package:learnera/pages/DeleteNewBooks.dart';
import 'package:learnera/pages/DeleteNovelgenres.dart';
import 'package:learnera/pages/DeletePop2.dart';
import 'package:learnera/pages/DeletePopularGenres.dart';
import 'package:learnera/pages/DeleteTrending.dart';

class DeleteBooksScreen extends StatefulWidget {
  const DeleteBooksScreen({super.key});

  @override
  State<DeleteBooksScreen> createState() => _DeleteBooksScreenState();
}

class _DeleteBooksScreenState extends State<DeleteBooksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                "Delete Books",
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
                      MaterialPageRoute(builder: (context) => deletepopular()));
                },
                child: Text(
                  "Delete Popular Genres 1",
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
                      MaterialPageRoute(builder: (context) => deletePop2()));
                },
                child: Text(
                  "Delete Popular Genres 2",
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
                      MaterialPageRoute(builder: (context) => deletenovel()));
                },
                child: Text(
                  "Delete Novel Genres",
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
                          builder: (context) => deleteTrending()));
                },
                child: Text(
                  "Delete Trending Genres",
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
                          builder: (context) => deleteNewBooks()));
                },
                child: Text(
                  "Delete New Books",
                  style: TextStyle(color: Appcolor().whtcolor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
