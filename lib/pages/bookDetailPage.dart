import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:learnera/constant/colors.dart';
import 'package:learnera/pages/pdf_viewer_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class bookDetailPage extends StatefulWidget {
  var bookName;
  var bookImage;
  var bookDiscription;
  var autherName;
  var autherImage;
  var PdfUrl;

  bookDetailPage(
      {super.key,
      this.bookName,
      this.bookImage,
      this.bookDiscription,
      this.autherName,
      this.autherImage,
      this.PdfUrl});
  bool? islike;
  @override
  State<bookDetailPage> createState() => _bookReadPageState();
}

class _bookReadPageState extends State<bookDetailPage> {
  double? _ratingValue;
  String downloadURL = '';
  String pathPDF = "";
  double _userRating = 0.0;
  bool _hasRating = false;

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      final url = widget.PdfUrl;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  bool isFavorite = false;
  void checkFavoriteStatus() async {
    // Check if the book is in the 'favorites' collection
    var snapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('bookName', isEqualTo: widget.bookName)
        .get();
    setState(() {
      isFavorite = snapshot.docs.isNotEmpty;
    });
  }

  void toggleFavoriteStatus() {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      addToFavorites();
      Fluttertoast.showToast(msg: 'Added to favorites');
    } else {
      removeFromFavorites();
      Fluttertoast.showToast(msg: 'Removed from favorites');
    }
  }

  void addToFavorites() {
    // Add book data to 'favorites' collection in Firebase
    FirebaseFirestore.instance.collection('favorites').add({
      'bookName': widget.bookName,
      'bookImage': widget.bookImage,
      'authorName': widget.autherName,
      'authorImage': widget.autherImage,
      'bookIntroduction': widget.bookDiscription,
      'pdfUrl': widget.PdfUrl,
    });
  }

  void removeFromFavorites() {
    // Remove book data from 'favorites' collection in Firebase
    FirebaseFirestore.instance
        .collection('favorites')
        .where('bookName', isEqualTo: widget.bookName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
    checkFavoriteStatus();
    _checkRating();
  }

  void _showRatingDialog(double rating) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate this book', style: TextStyle(fontSize: 25)),
          content: Text(
            'Your rating: $rating',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(fontSize: 15)),
            ),
            TextButton(
              onPressed: () {
                _saveRatingToFirebase(rating);
                Fluttertoast.showToast(msg: 'You have Sucessfully rated');
                Navigator.of(context).pop();
              },
              child: Text('Submit', style: TextStyle(fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  void _saveRatingToFirebase(double rating) {
    FirebaseFirestore.instance
        .collection('Novel_Genres')
        .where('book_name', isEqualTo: widget.bookName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          FirebaseFirestore.instance
              .collection('Novel_Genres')
              .doc(doc.id)
              .update({
            'rating': rating,
          });
        });
      }
    });
    FirebaseFirestore.instance
        .collection('Popular_Genres_1')
        .where('book_name', isEqualTo: widget.bookName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          FirebaseFirestore.instance
              .collection('Popular_Genres_1')
              .doc(doc.id)
              .update({
            'rating': rating,
          });
        });
      }
    });
    FirebaseFirestore.instance
        .collection('Popular_Genres_2')
        .where('book_name', isEqualTo: widget.bookName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          FirebaseFirestore.instance
              .collection('Popular_Genres_2')
              .doc(doc.id)
              .update({
            'rating': rating,
          });
        });
      }
    });
    FirebaseFirestore.instance
        .collection('Trending_Genres')
        .where('book_name', isEqualTo: widget.bookName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          FirebaseFirestore.instance
              .collection('Trending_Genres')
              .doc(doc.id)
              .update({
            'rating': rating,
          });
        });
      }
    });
    FirebaseFirestore.instance
        .collection('New_Books')
        .where('book_name', isEqualTo: widget.bookName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          FirebaseFirestore.instance
              .collection('New_Books')
              .doc(doc.id)
              .update({
            'rating': rating,
          });
        });
      }
    });
    setState(() {
      _userRating = rating;
      _hasRating = true;
    });
  }

  void _checkRating() {
    FirebaseFirestore.instance
        .collection('Novel_Genres')
        .where('book_name', isEqualTo: widget.bookName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('rating')) {
            setState(() {
              _userRating = data['rating'];
              _hasRating = true;
            });
          }
        });
      }
    });
    FirebaseFirestore.instance
        .collection('Trending_Genres')
        .where('book_name', isEqualTo: widget.bookName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('rating')) {
            setState(() {
              _userRating = data['rating'];
              _hasRating = true;
            });
          }
        });
      }
    });
    FirebaseFirestore.instance
        .collection('New_Books')
        .where('book_name', isEqualTo: widget.bookName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('rating')) {
            setState(() {
              _userRating = data['rating'];
              _hasRating = true;
            });
          }
        });
      }
    });
    FirebaseFirestore.instance
        .collection('Popular_Genres_1')
        .where('book_name', isEqualTo: widget.bookName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('rating')) {
            setState(() {
              _userRating = data['rating'];
              _hasRating = true;
            });
          }
        });
      }
    });
    FirebaseFirestore.instance
        .collection('Popular_Genres_2')
        .where('book_name', isEqualTo: widget.bookName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('rating')) {
            setState(() {
              _userRating = data['rating'];
              _hasRating = true;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isFavorite);
        return true;
      },
      child: Scaffold(
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.1,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(32, 117, 143, 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context, isFavorite);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 17),
                              child: SizedBox(
                                width: 180,
                                child: Text(
                                  widget.bookName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Appcolor().whtcolor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 110, top: 5),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 3.4,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Image.network(
                            widget.bookImage,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 107, top: 10),
                              child: RatingBar.builder(
                                initialRating: _userRating,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 30.0,
                                unratedColor: Colors.orange,
                                itemBuilder: (context, index) {
                                  IconData icon;
                                  Color color;
                                  if (index >= _userRating) {
                                    icon = Icons.star_outline;
                                    color = Colors.orange;
                                  } else if (index > _userRating - 1 &&
                                      index < _userRating) {
                                    icon = Icons.star_half;
                                    color = Colors.orange;
                                  } else {
                                    icon = Icons.star;
                                    color = Colors.orange;
                                  }
                                  return Icon(
                                    icon,
                                    color: color,
                                  );
                                },
                                onRatingUpdate: (rating) {
                                  _showRatingDialog(rating);
                                },
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 10),
                            child: Text(
                              _userRating != 0.0
                                  ? '(' + _userRating.toString() + ')'
                                  : 'Rate it!',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 15),
                    child: SizedBox(
                      width: 250,
                      child: Text(
                        widget.bookName,
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, right: 15),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 35,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: toggleFavoriteStatus,
                    ),
                  ),
                ]),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12, top: 15),
                      child: GestureDetector(
                        onTap: () {
                          _showImagePopup(context);
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(widget.autherImage),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 15),
                      child: Text(
                        widget.autherName,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 217),
                  child: Text(
                    'Introduction',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 15),
                  child: Text(
                    widget.bookDiscription + '\n\n\n',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 27, top: 735),
            child: Container(
              height: MediaQuery.of(context).size.height / 16,
              width: MediaQuery.of(context).size.width / 1.20,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromRGBO(32, 117, 143, 1),
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                onPressed: () {
                  if (pathPDF.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFScreen(
                            path: pathPDF,
                            bookname: widget.bookName,
                          ),
                        ));
                  }
                },
                child: pathPDF.isEmpty
                    ? LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.white,
                        // leftDotColor: Colors.red,
                        // rightDotColor: Appcolor().whtcolor,
                        size: 40,
                      )
                    : Text(
                        "Start Reading",
                        style: TextStyle(
                          fontSize: 19,
                        ),
                      ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _showImagePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: CachedNetworkImage(
            imageUrl: widget.autherImage,
            placeholder: (context, url) => LoadingAnimationWidget.dotsTriangle(
              color: Colors.white,
              size: 200,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
