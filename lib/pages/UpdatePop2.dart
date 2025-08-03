import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePop2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Popular Genres 2'),
        centerTitle: true,
      ),
      body: DocumentList(),
    );
  }
}

class DocumentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('Popular_Genres_2').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = snapshot.data!.docs[index];
            return ListTile(
              title: Text(document['book_name']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateDocument(document),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class UpdateDocument extends StatefulWidget {
  final DocumentSnapshot document;

  UpdateDocument(this.document);

  @override
  _UpdateDocumentState createState() => _UpdateDocumentState();
}

class _UpdateDocumentState extends State<UpdateDocument> {
  TextEditingController _bookname = TextEditingController();
  TextEditingController _authorname = TextEditingController();
  TextEditingController _bookintro = TextEditingController();
  late String _imageUrl2;
  late String _imageUrl;
  late String _pdfUrl;

  Future<String> uploadBookImageToStorage(
      String imagePath, String folderName) async {
    File file = File(imagePath);
    String fileName = file.path.split('/').last;

    Reference storageReference =
        FirebaseStorage.instance.ref().child(folderName).child(fileName);
    UploadTask uploadTask = storageReference.putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    return imageUrl;
  }

  Future<String> uploadAuthorImageToStorage(
      String imagePath, String folderName) async {
    File file = File(imagePath);
    String fileName = file.path.split('/').last;

    Reference storageReference =
        FirebaseStorage.instance.ref().child(folderName).child(fileName);
    UploadTask uploadTask = storageReference.putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    return imageUrl;
  }

  Future<String> uploadPdfToStorage(String pdfPath, String folderName) async {
    File file = File(pdfPath);
    String fileName = file.path.split('/').last;

    Reference storageReference =
        FirebaseStorage.instance.ref().child(folderName).child(fileName);
    UploadTask uploadTask = storageReference.putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String pdfUrl = await taskSnapshot.ref.getDownloadURL();

    return pdfUrl;
  }

  @override
  void initState() {
    super.initState();
    _bookname.text = widget.document['book_name'];
    _authorname.text = widget.document['author_name'];
    _bookintro.text = widget.document['introduction'];
    _imageUrl = widget.document['book_image'];
    _pdfUrl = widget.document['pdfurl'];
    _imageUrl2 = widget.document['author_image'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.document['book_name'])
          // centerTitle: true,
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _bookname,
                decoration: InputDecoration(labelText: 'Book Name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _authorname,
                decoration: InputDecoration(labelText: 'Author Name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _bookintro,
                decoration: InputDecoration(labelText: 'Book Introdution'),
              ),
              SizedBox(height: 20),
              IconButton(
                icon: const Icon(
                  Icons.add_photo_alternate,
                  size: 40,
                ),
                onPressed: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    String imageUrl = await uploadBookImageToStorage(
                        pickedFile.path, 'Popular_Genres_2_Images');
                    setState(() {
                      _imageUrl = imageUrl;
                    });
                  }
                },
              ),
              Text('Pick Book Image'),
              SizedBox(height: 20),
              IconButton(
                icon: const Icon(
                  Icons.file_upload,
                  size: 40,
                ),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom, allowedExtensions: ['pdf']);
                  if (result != null && result.files.isNotEmpty) {
                    String pdfUrl = await uploadPdfToStorage(
                        result.files.single.path!, 'Popular_Genres_2_PDFs');
                    setState(() {
                      _pdfUrl = pdfUrl;
                    });
                  }
                },
              ),
              Text('Pick Book Pdf'),
              SizedBox(height: 20),
              IconButton(
                icon: const Icon(
                  Icons.person_add,
                  size: 40,
                ),
                onPressed: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    String imageUrl = await uploadAuthorImageToStorage(
                        pickedFile.path, 'Pop2_Author_Images');
                    setState(() {
                      _imageUrl2 = imageUrl;
                    });
                  }
                },
              ),
              Text('Pick Author Image'),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('Popular_Genres_2')
                        .doc(widget.document.id)
                        .update({
                      'book_name': _bookname.text,
                      'author_name': _authorname.text,
                      'introduction': _bookintro.text,
                      'pdfurl': _pdfUrl,
                      'book_image': _imageUrl,
                      'author_image': _imageUrl2,
                    });
                    Fluttertoast.showToast(msg: 'Updated Successfully');
                    Navigator.pop(context);
                  },
                  child: Text('Update Book'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
