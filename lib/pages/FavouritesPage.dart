import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:learnera/constant/colors.dart';

import 'package:learnera/pages/bookDetailPage.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});
  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() {
      _loading = true;
    });
    await Future.delayed(Duration(seconds: 2)); // Simulating fetching delay
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Favourites',
          style: TextStyle(color: Appcolor().whtcolor),
        ),
        backgroundColor: Appcolor().primarycolor,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: _firestore.collection('favorites').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    bookDetailPage(
                                      bookName: doc['bookName'],
                                      bookImage: doc['bookImage'],
                                      bookDiscription: doc['bookIntroduction'],
                                      autherName: doc['authorName'],
                                      autherImage: doc['authorImage'],
                                      PdfUrl: doc['pdfUrl'],
                                    )));
                      },
                      child: Card(
                        child: ListTile(
                          leading: Image.network(doc['bookImage']),
                          title: Text(
                            doc['bookName'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('By ' + doc['authorName'],
                              style: TextStyle(fontStyle: FontStyle.italic)),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _showDeleteDialog(doc.reference);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Future<void> _showDeleteDialog(DocumentReference docRef) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Book'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to Remove this book from Favourites?'),
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
                await docRef.delete();
                Navigator.of(context).pop();
                Fluttertoast.showToast(msg: 'Removed from Favourites');
                //  _fetchBooks();
              },
            ),
          ],
        );
      },
    );
  }
}
  // ignore: unused_field
  // int _selectedIndex = 0;
  // List<DocumentSnapshot> _books =
  //     []; // List to hold book data from all collections
  // List<DocumentSnapshot> _filteredBooks = []; // List to hold filtered book data
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _getBooksFromFirestore();
  // }

  // void _getBooksFromFirestore() {
  //   _fetchBooksFromCollection('favorites');
  // }

  // Future<void> _fetchBooksFromCollection(String collection) async {
  //   QuerySnapshot snapshot =
  //       await FirebaseFirestore.instance.collection(collection).get();

  //   setState(() {
  //     _books.addAll(snapshot.docs);
  //     _filteredBooks = _books; // Initialize filtered data with all data
  //   });
  // }

  // void _filterBooks(String query) {
  //   setState(() {
  //     _filteredBooks = _books
  //         .where((book) =>
  //             book['book_name']
  //                 .toString()
  //                 .toLowerCase()
  //                 .contains(query.toLowerCase()) ||
  //             book['author_name']
  //                 .toString()
  //                 .toLowerCase()
  //                 .contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }

  // bool _loading = true;
  // Future<void> _fetchBooks() async {
  //   setState(() {
  //     _loading = true;
  //   });
  //   await Future.delayed(Duration(seconds: 2));
  //   setState(() {
  //     _loading = false;
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //       child: Scaffold(
  //           appBar: AppBar(
  //             backgroundColor: Appcolor().primarycolor,
  //             centerTitle: true,
  //             title: Text(
  //               "Favourites",
  //               style: TextStyle(color: Appcolor().whtcolor),
  //             ),
  //             automaticallyImplyLeading: false,
  //           ),
  //           body: FutureBuilder(
  //             future: FirebaseFirestore.instance.collection('favorites').get(),
  //             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return Center(child: CircularProgressIndicator());
  //               }

  //               if (snapshot.hasError) {
  //                 return Center(child: Text('Error: ${snapshot.error}'));
  //               }

  //               final books = snapshot.data!.docs;

  //               if (books.isEmpty) {
  //                 return Center(
  //                     child: Column(
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 150),
  //                       child: CircleAvatar(
  //                         backgroundImage: AssetImage(
  //                             'assets/images/favouriteScreen-removebg-preview.png'),
  //                         radius: 130,
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(),
  //                       child: Text(
  //                         'No favourites yet!',
  //                         style: TextStyle(
  //                             fontSize: 30, fontWeight: FontWeight.bold),
  //                       ),
  //                     ),
  //                     Center(
  //                         child: Text(
  //                       '  Like a book you see? Add\nthem here to your favourites.',
  //                       style: TextStyle(fontSize: 17),
  //                     ))
  //                   ],
  //                 ));
  //               }

  //               return ListView.builder(
  //                 itemCount: books.length,
  //                 itemBuilder: (context, index) {
  //                   final book = books[index].data() as Map<String, dynamic>;
  //                   return GestureDetector(
  //                     onTap: () {
  //                       Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (BuildContext context) =>
  //                                   bookDetailPage(
  //                                     bookName: _filteredBooks[index]
  //                                         ['bookName'],
  //                                     bookImage: _filteredBooks[index]
  //                                         ['bookImage'],
  //                                     bookDiscription: _filteredBooks[index]
  //                                         ['bookIntroduction'],
  //                                     autherName: _filteredBooks[index]
  //                                         ['authorName'],
  //                                     autherImage: _filteredBooks[index]
  //                                         ['authorImage'],
  //                                     PdfUrl: _filteredBooks[index]['pdfUrl'],
  //                                   )));
  //                     },
  //                     child: Card(
  //                       child: ListTile(
  //                         leading: Image.network(
  //                           book['bookImage'],
  //                           width: 40,
  //                           height: 146,
  //                           fit: BoxFit.fill,
  //                         ),
  //                         title: Text(book['bookName']),
  //                         subtitle: Text('By ' + book['authorName']),
  //                         trailing: IconButton(
  //                           icon: Icon(
  //                             Icons.favorite,
  //                             color: Colors.red,
  //                           ),
  //                           onPressed: () {
  //                             _showDeleteDialog();
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               );
  //             },
  //           )));
  // }

  // void removeFromFavorites() {
  //   //  final book = books[index].data() as Map<String, dynamic>;
  //   //  final books = snapshot.data!.docs;
  //   FirebaseFirestore.instance
  //       .collection('favorites')
  //       .where('bookName')
  //       .get()
  //       .then((querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       doc.reference.delete();
  //     });
  //   });
  // }

//   Future<void> _showDeleteDialog() async {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Remove Book'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(
//                     'Are you sure you want to remove this book from Favorites?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('No'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Yes'),
//               onPressed: () {
//                 removeFromFavorites();
//                 Fluttertoast.showToast(msg: 'Removed from favorites');
//                 Navigator.of(context).pop();
//                 _fetchBooks();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

