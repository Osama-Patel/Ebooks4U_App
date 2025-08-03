import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:learnera/pages/bookDetailPage.dart';

class SearchBookScreen extends StatefulWidget {
  const SearchBookScreen({super.key});

  @override
  State<SearchBookScreen> createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen> {
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _books =
      []; // List to hold book data from all collections
  List<DocumentSnapshot> _filteredBooks = []; // List to hold filtered book data

  @override
  void initState() {
    super.initState();
    _getBooksFromFirestore();
  }

  void _getBooksFromFirestore() {
    _fetchBooksFromCollection('Novel_Genres');
    _fetchBooksFromCollection('Trending_Genres');
    _fetchBooksFromCollection('New_Books');
  }

  Future<void> _fetchBooksFromCollection(String collection) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(collection).get();

    setState(() {
      _books.addAll(snapshot.docs);
      _filteredBooks = _books; // Initialize filtered data with all data
    });
  }

  void _filterBooks(String query) {
    setState(() {
      _filteredBooks = _books
          .where((book) =>
              book['book_name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              book['author_name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search Book Title or Author',
            border: InputBorder.none,
          ),
          onChanged: _filterBooks,
        ),
      ),
      body: _filteredBooks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_sharp, size: 48),
                  Text('No results found'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _filteredBooks.length,
              itemBuilder: (context, index) {
                var book = _filteredBooks[index];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => bookDetailPage(
                                    bookName: _filteredBooks[index]
                                        ['book_name'],
                                    bookImage: _filteredBooks[index]
                                        ['book_image'],
                                    bookDiscription: _filteredBooks[index]
                                        ['introduction'],
                                    autherName: _filteredBooks[index]
                                        ['author_name'],
                                    autherImage: _filteredBooks[index]
                                        ['author_image'],
                                    PdfUrl: _filteredBooks[index]['pdfurl'],
                                  )));
                    },
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: book['book_image'],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        title: Text(
                          book['book_name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'By ' + book['author_name'],
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ));
              },
            ),
    );
  }
}
