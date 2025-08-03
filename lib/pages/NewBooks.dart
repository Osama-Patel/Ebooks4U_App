import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:learnera/constant/colors.dart';

import 'package:learnera/pages/bookDetailPage.dart';

class NewBooks extends StatefulWidget {
  const NewBooks({super.key});

  @override
  State<NewBooks> createState() => _NewBooksState();
}

class _NewBooksState extends State<NewBooks> {
  // ignore: unused_field
  int _selectedIndex = 0;
  Future getNewBooksData() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("New_Books").get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'New Books',
          style: TextStyle(
            color: Appcolor().whtcolor,
          ),
        ),
        backgroundColor: Appcolor().primarycolor,
      ),
      body: Container(
        child: FutureBuilder(
          future: getNewBooksData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
              child: GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 15.0,
                ),
                itemBuilder: (context, index) {
                  return GridTile(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    bookDetailPage(
                                      bookName: snapshot.data[index]
                                          ['book_name'],
                                      bookImage: snapshot.data[index]
                                          ['book_image'],
                                      bookDiscription: snapshot.data[index]
                                          ['introduction'],
                                      autherName: snapshot.data[index]
                                          ['author_name'],
                                      autherImage: snapshot.data[index]
                                          ['author_image'],
                                      PdfUrl: snapshot.data[index]['pdfurl'],
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Grid line color
                          ),
                          color: Colors.grey.shade500,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 100,
                                height: 140,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      snapshot.data[index]["book_image"],
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                snapshot.data[index]["book_name"],
                                style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: Appcolor().whtcolor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
