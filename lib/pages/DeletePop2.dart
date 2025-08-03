import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class deletePop2 extends StatefulWidget {
  const deletePop2({super.key});

  @override
  State<deletePop2> createState() => _deletePop2State();
}

class _deletePop2State extends State<deletePop2> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // ignore: unused_field
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Popular Genres 2'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Popular_Genres_2').snapshots(),
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
              Text("Popular Genres 2 Name : " + _textData),
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
