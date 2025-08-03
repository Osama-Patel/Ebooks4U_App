import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:learnera/pages/FavouritesPage.dart';
import 'package:learnera/pages/NewBooks.dart';
import 'package:learnera/pages/NotificationScreen.dart';
import 'package:learnera/pages/ProfileScreen.dart';
import 'package:learnera/pages/SearchBookScreen.dart';
import 'package:learnera/pages/SettingsScreen.dart';
import 'package:learnera/services/UserDataProvider.dart';
import 'package:learnera/pages/bookDetailPage.dart';

class MyHome extends StatefulWidget {
  State<MyHome> createState() => _MyHomeState();

  MyHome({
    super.key,
  });
}

class _MyHomeState extends State<MyHome> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    HomeScreen(),
    NewBooks(),
    FavouritesPage(),
    SettingsScreen()
  ];

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
                  icon: Icons.home,
                  text: 'Home',
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                GButton(
                  icon: Icons.book,
                  text: 'New Books',
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                GButton(
                  icon: Icons.favorite,
                  text: 'Favorites',
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3;
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

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  // ignore: unused_field
  int _selectedIndex = 0;

  Future<Map<String, dynamic>> fetchFirebaseData() async {
    QuerySnapshot booksSnapshot =
        await FirebaseFirestore.instance.collection('Novel_Genres').get();
    QuerySnapshot authorsSnapshot =
        await FirebaseFirestore.instance.collection('Trending_Genres').get();

    List<String> bookTitles =
        booksSnapshot.docs.map((doc) => doc['book_name'].toString()).toList();
    List<String> authorNames = authorsSnapshot.docs
        .map((doc) => doc['author_name'].toString())
        .toList();
    List<String> book_image = authorsSnapshot.docs
        .map((doc) => doc['book_image'].toString())
        .toList();
    return {
      'book_name': bookTitles,
      'author_name': authorNames,
      'book_image': book_image
    };
  }

  Future getPop1Data() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("Popular_Genres_1").get();
    return qn.docs;
  }

  Future getPop2Data() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("Popular_Genres_2").get();
    return qn.docs;
  }

  Future getNovelData() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("Novel_Genres").get();
    return qn.docs;
  }

  Future getTrendingData() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("Trending_Genres").get();
    return qn.docs;
  }

  bool _hasNotifications = false;

  @override
  void initState() {
    getPop1Data();
    getPop2Data();
    getNovelData();
    getTrendingData();
    fetchFirebaseData();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        setState(() {
          _hasNotifications = true;
        });
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      setState(() {
        _hasNotifications = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final userDataProvider = Provider.of<UserDataProvider>(context);
    //final userData = userDataProvider.userData;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            //  backgroundColor: Appcolor().whtcolor,
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                  // userName: UserDataProvider().getUsername,
                                  // userName: userData.username,
                                  // photourl: userData.photoUrl,
                                  // email: userData.email,
                                  )),
                        ),
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
                                backgroundImage:
                                    NetworkImage(snapshot.data ?? ''),
                                radius: 30,
                              );
                            }
                          },
                        ),
                        // child: CircleAvatar(
                        //   radius: 30,
                        //   backgroundImage: NetworkImage(userData!.photoUrl),
                        // ),
                      ),
                      Spacer(),
                      Stack(
                        children: [
                          IconButton(
                            icon: _hasNotifications
                                ? Icon(Icons.notifications_active)
                                : Icon(Icons.notifications_outlined),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationScreen(),
                                ),
                              );
                              setState(() {
                                _hasNotifications = false;
                              });
                            },
                          ),
                          if (_hasNotifications)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(Icons.done, color: Colors.blue),
                            ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<String?>(
                    future: UserDataProvider.getUsername(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(
                          'Hello, ' + snapshot.data! ?? '',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 5),
                  SizedBox(height: 12),
                  Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SearchBookScreen()));
                      },
                      controller: _searchController,
                      readOnly: true,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "Search books",
                          hintStyle: TextStyle(color: Colors.grey),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 15, bottom: 5),
                            child: Icon(Icons.search),
                          )),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Popular Genres",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: MediaQuery.of(context).size.height / 20,
                    child: FutureBuilder(
                      future: getPop1Data(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 5),
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
                                              bookDiscription: snapshot
                                                  .data[index]['introduction'],
                                              autherName: snapshot.data[index]
                                                  ['author_name'],
                                              autherImage: snapshot.data[index]
                                                  ['author_image'],
                                              PdfUrl: snapshot.data[index]
                                                  ['pdfurl'],
                                            )));
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromRGBO(32, 117, 143, 1),
                                ),
                                child: Center(
                                  child: Text(
                                    snapshot.data[index]["book_name"],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: MediaQuery.of(context).size.height / 20,
                    child: FutureBuilder(
                      future: getPop2Data(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 5),
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
                                              bookDiscription: snapshot
                                                  .data[index]['introduction'],
                                              autherName: snapshot.data[index]
                                                  ['author_name'],
                                              autherImage: snapshot.data[index]
                                                  ['author_image'],
                                              PdfUrl: snapshot.data[index]
                                                  ['pdfurl'],
                                            )));
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromRGBO(32, 117, 143, 1),
                                ),
                                child: Center(
                                  child: Text(
                                    snapshot.data[index]["book_name"],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 13),
                  Text(
                    "Novel Genres",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 200,
                    child: FutureBuilder(
                      future: getNovelData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(left: 8, right: 5),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                bookDetailPage(
                                                  bookName: snapshot.data[index]
                                                      ['book_name'],
                                                  bookImage:
                                                      snapshot.data[index]
                                                          ['book_image'],
                                                  bookDiscription:
                                                      snapshot.data[index]
                                                          ['introduction'],
                                                  autherName:
                                                      snapshot.data[index]
                                                          ['author_name'],
                                                  autherImage:
                                                      snapshot.data[index]
                                                          ['author_image'],
                                                  PdfUrl: snapshot.data[index]
                                                      ['pdfurl'],
                                                )));
                                  },
                                  child: Container(
                                    height: 146,
                                    width: 100,
                                    padding: EdgeInsets.only(left: 8, right: 5),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          snapshot.data[index]["book_image"],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        60),
                                Container(
                                  width: 102,
                                  child: Text(
                                    snapshot.data[index]["book_name"],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Trending",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 200,
                    child: FutureBuilder(
                      future: getTrendingData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(left: 8, right: 5),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                bookDetailPage(
                                                  bookName: snapshot.data[index]
                                                      ['book_name'],
                                                  bookImage:
                                                      snapshot.data[index]
                                                          ['book_image'],
                                                  bookDiscription:
                                                      snapshot.data[index]
                                                          ['introduction'],
                                                  autherName:
                                                      snapshot.data[index]
                                                          ['author_name'],
                                                  autherImage:
                                                      snapshot.data[index]
                                                          ['author_image'],
                                                  PdfUrl: snapshot.data[index]
                                                      ['pdfurl'],
                                                )));
                                  },
                                  child: Container(
                                    height: 146,
                                    width: 100,
                                    padding: EdgeInsets.only(left: 8, right: 5),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          snapshot.data[index]["book_image"],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        60),
                                Container(
                                  width: 102,
                                  child: Text(
                                    snapshot.data[index]["book_name"],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
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
