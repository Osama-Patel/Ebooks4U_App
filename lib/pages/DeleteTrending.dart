// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
// }

// class updateDeletepage extends StatelessWidget {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final firebase_storage.FirebaseStorage _storage =
//       firebase_storage.FirebaseStorage.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CollectionPage(),
//                   ),
//                 );
//               },
//               child: Text('Open Collection'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CollectionPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Collection Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DocumentPage(
//                       collection: 'Novel_Genres',
//                     ),
//                   ),
//                 );
//               },
//               child: Text('Open Novel_Genres'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DocumentPage(
//                       collection: 'Trending_Genres',
//                     ),
//                   ),
//                 );
//               },
//               child: Text('Open Trending_Genres'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DocumentPage extends StatelessWidget {
//   final String collection;

//   DocumentPage({required this.collection});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Document Page'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection(collection).snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Something went wrong');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }

//           return ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               return ListTile(
//                 title: Text(document.id),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => EditDocumentPage(
//                         collection: collection,
//                         documentId: document.id,
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// class EditDocumentPage extends StatelessWidget {
//   final String collection;
//   final String documentId;

//   EditDocumentPage({required this.collection, required this.documentId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Document'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 // Update document data
//                 FirebaseFirestore.instance
//                     .collection(collection)
//                     .doc(documentId)
//                     .update({'text_field': 'Updated text data'});
//               },
//               child: Text('Update Text Data'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 // Delete document
//                 await FirebaseFirestore.instance
//                     .collection(collection)
//                     .doc(documentId)
//                     .delete();
//                 Navigator.pop(context);
//               },
//               child: Text('Delete Document'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase CRUD Demo',
//       home: FirebaseDemo(),
//     );
//   }
// }

class deleteTrending extends StatefulWidget {
  @override
  _deleteTrendingState createState() => _deleteTrendingState();
}

class _deleteTrendingState extends State<deleteTrending> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // ignore: unused_field
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Trending Genres'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Trending_Genres').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['book_name']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentDetails(doc),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class DocumentDetails extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> document;

  DocumentDetails(this.document);

  @override
  _DocumentDetailsState createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  String _textData = '';
  String _authorname = '';
  @override
  void initState() {
    super.initState();
    _textData = widget.document['book_name'];
    _authorname = widget.document['author_name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document['book_name']),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Column(
            children: [
              Text("Trending Genres Name : " + _textData),
              SizedBox(
                height: 20,
              ),
              Text("Author Name : " + _authorname),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  // Delete document
                  widget.document.reference.delete();
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: 'Deleted Successfully');
                },
                child: Text('Delete Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
