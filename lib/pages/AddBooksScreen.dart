import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:learnera/constant/colors.dart';
import 'package:image_picker/image_picker.dart';

class AddBooksScreen extends StatefulWidget {
  const AddBooksScreen({super.key});

  @override
  State<AddBooksScreen> createState() => _AddBooksScreenState();
}

class _AddBooksScreenState extends State<AddBooksScreen> {
  String isfavorite = 'false';
  String rating = '0.0';
  String imageurl = '';
  String downloadURL = '';
  String imageurl2 = '';

  final CollectionReference _referencepop1 =
      FirebaseFirestore.instance.collection('Popular_Genres_1');
  final CollectionReference _referencepop2 =
      FirebaseFirestore.instance.collection('Popular_Genres_2');
  final CollectionReference _referenceNewBook =
      FirebaseFirestore.instance.collection('New_Books');
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('Novel_Genres');
  final CollectionReference reference =
      FirebaseFirestore.instance.collection('Trending_Genres');
  TextEditingController populergeners1 = TextEditingController();
  TextEditingController populergeners2 = TextEditingController();
  TextEditingController novelgenersName = TextEditingController();
  TextEditingController trendinggenersName = TextEditingController();
  TextEditingController novelauthorname = TextEditingController();
  TextEditingController novelintroduction = TextEditingController();
  TextEditingController trendingauthorName = TextEditingController();
  TextEditingController trendingintroduction = TextEditingController();
  TextEditingController popular1authorname = TextEditingController();
  TextEditingController pop1introduction = TextEditingController();
  TextEditingController popular2authorname = TextEditingController();
  TextEditingController pop2introduction = TextEditingController();
  TextEditingController NewBooksintroduction = TextEditingController();
  TextEditingController NewBooksauthorname = TextEditingController();
  TextEditingController NewBooksname = TextEditingController();
  void pickpop1PDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.first.path!);

      if (file.existsSync()) {
        Uint8List fileBytes = await file.readAsBytes();

        String fileName = result.files.first.name;

        print("File Bytes: $fileBytes");

        final response = await FirebaseStorage.instance
            .ref('Popular_Genres_1_PDFs/$fileName')
            .putData(fileBytes);
        print(response.storage.bucket);
        try {
          downloadURL = await response.ref.getDownloadURL();
          print("Pdf Url:" + downloadURL);
        } catch (error) {
          //some error
        }
      } else {
        print("File does not exist");
      }
    } else {
      print("No file selected");
    }
  }

  void pickpop2PDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.first.path!);

      if (file.existsSync()) {
        Uint8List fileBytes = await file.readAsBytes();

        String fileName = result.files.first.name;

        print("File Bytes: $fileBytes");

        final response = await FirebaseStorage.instance
            .ref('Popular_Genres_2_PDFs/$fileName')
            .putData(fileBytes);
        print(response.storage.bucket);
        try {
          downloadURL = await response.ref.getDownloadURL();
          print("Pdf Url:" + downloadURL);
        } catch (error) {
          //some error
        }
      } else {
        print("File does not exist");
      }
    } else {
      print("No file selected");
    }
  }

  void pickNovelPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.first.path!);

      if (file.existsSync()) {
        Uint8List fileBytes = await file.readAsBytes();

        String fileName = result.files.first.name;

        print("File Bytes: $fileBytes");

        final response = await FirebaseStorage.instance
            .ref('Novel_Genres_PDFs/$fileName')
            .putData(fileBytes);
        print(response.storage.bucket);
        try {
          downloadURL = await response.ref.getDownloadURL();
          print("Pdf Url:" + downloadURL);
        } catch (error) {
          //some error
        }
      } else {
        print("File does not exist");
      }
    } else {
      print("No file selected");
    }
  }

  void pickTrendingPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.first.path!);

      if (file.existsSync()) {
        Uint8List fileBytes = await file.readAsBytes();

        String fileName = result.files.first.name;

        print("File Bytes: $fileBytes");

        final response = await FirebaseStorage.instance
            .ref('Trending_Genres_PDFs/$fileName')
            .putData(fileBytes);
        print(response.storage.bucket);
        try {
          downloadURL = await response.ref.getDownloadURL();
          print("Pdf Url:" + downloadURL);
        } catch (error) {
          //some error
        }
      } else {
        print("File does not exist");
      }
    } else {
      print("No file selected");
    }
  }

  void pickNewBooksPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.first.path!);

      if (file.existsSync()) {
        Uint8List fileBytes = await file.readAsBytes();

        String fileName = result.files.first.name;

        print("File Bytes: $fileBytes");

        final response = await FirebaseStorage.instance
            .ref('NewBooks_PDFs/$fileName')
            .putData(fileBytes);
        print(response.storage.bucket);
        try {
          downloadURL = await response.ref.getDownloadURL();
          print("Pdf Url:" + downloadURL);
        } catch (error) {
          //some error
        }
      } else {
        print("File does not exist");
      }
    } else {
      print("No file selected");
    }
  }

  void pickPop1AuthorImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('image path${file?.path}');

    if (file == null) return;

    String uniqueFileName1 = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot1 = FirebaseStorage.instance.ref();
    Reference referenceDirImages1 = referenceRoot1.child('Pop1_Author_Images');
    Reference referenceImageToUpload1 =
        referenceDirImages1.child(uniqueFileName1);

    try {
      await referenceImageToUpload1.putFile(File(file.path));
      imageurl2 = await referenceImageToUpload1.getDownloadURL();
      print("image URL: " + imageurl2);
    } catch (error) {
      //some error
    }
  }

  void pickPop2AuthorImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('image path${file?.path}');

    if (file == null) return;

    String uniqueFileName1 = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot1 = FirebaseStorage.instance.ref();
    Reference referenceDirImages1 = referenceRoot1.child('Pop2_Author_Images');
    Reference referenceImageToUpload1 =
        referenceDirImages1.child(uniqueFileName1);

    try {
      await referenceImageToUpload1.putFile(File(file.path));
      imageurl2 = await referenceImageToUpload1.getDownloadURL();
      print("image URL: " + imageurl2);
    } catch (error) {
      //some error
    }
  }

  void pickNewBooksAuthorImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('image path${file?.path}');

    if (file == null) return;

    String uniqueFileName1 = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot1 = FirebaseStorage.instance.ref();
    Reference referenceDirImages1 =
        referenceRoot1.child('NewBooks_Author_Images');
    Reference referenceImageToUpload1 =
        referenceDirImages1.child(uniqueFileName1);

    try {
      await referenceImageToUpload1.putFile(File(file.path));
      imageurl2 = await referenceImageToUpload1.getDownloadURL();
      print("image URL: " + imageurl2);
    } catch (error) {
      //some error
    }
  }

  void pickNovelAuthorImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('image path${file?.path}');

    if (file == null) return;

    String uniqueFileName1 = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot1 = FirebaseStorage.instance.ref();
    Reference referenceDirImages1 = referenceRoot1.child('Novel_Author_Images');
    Reference referenceImageToUpload1 =
        referenceDirImages1.child(uniqueFileName1);

    try {
      await referenceImageToUpload1.putFile(File(file.path));
      imageurl2 = await referenceImageToUpload1.getDownloadURL();
      print("image URL: " + imageurl2);
    } catch (error) {
      //some error
    }
  }

  void pickTrendingAuthorImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('image path${file?.path}');

    if (file == null) return;

    String uniqueFileName1 = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot1 = FirebaseStorage.instance.ref();
    Reference referenceDirImages1 =
        referenceRoot1.child('Trending_Author_Images');
    Reference referenceImageToUpload1 =
        referenceDirImages1.child(uniqueFileName1);

    try {
      await referenceImageToUpload1.putFile(File(file.path));
      imageurl2 = await referenceImageToUpload1.getDownloadURL();
      print("Trending Author URL: " + imageurl2);
    } catch (error) {
      //some error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "Add Books",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: IconButton(
                      onPressed: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        print('image path${file?.path}');

                        if (file == null) return;

                        String uniqueFileName =
                            DateTime.now().microsecondsSinceEpoch.toString();

                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            referenceRoot.child('Popular_Genres_1_Images');
                        Reference referenceImageToUpload =
                            referenceDirImages.child(uniqueFileName);

                        try {
                          await referenceImageToUpload.putFile(File(file.path));
                          imageurl =
                              await referenceImageToUpload.getDownloadURL();
                          print("image url: " + imageurl);
                        } catch (error) {
                          //some error
                        }
                      },
                      icon: const Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                      )),
                ),
                const Text("Add Popular Genres 1 Image"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                IconButton(
                    onPressed: () async {
                      pickpop1PDF();
                    },
                    icon: const Icon(
                      Icons.upload_file_sharp,
                      size: 40,
                    )),
                const Text("Add Popular Genres 1 Pdf"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                IconButton(
                    onPressed: () async {
                      pickPop1AuthorImage();
                    },
                    icon: const Icon(
                      Icons.person_add,
                      size: 40,
                    )),
                const Text("Add Popular Genres 1 Author Image"),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: populergeners1,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Popular Genres 1 Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: popular1authorname,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Popular Genres 1 Author Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: pop1introduction,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Popular Genres 1 Introduction",
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Appcolor().primarycolor),
                  ),
                  onPressed: () {
                    Map<String, String> dataToSend = {
                      'book_image': imageurl,
                      "book_name": populergeners1.text,
                      "author_image": imageurl2,
                      "author_name": popular1authorname.text,
                      "introduction": pop1introduction.text,
                      "pdfurl": downloadURL,
                    };

                    _referencepop1.add(dataToSend);
                    const snackdemo = SnackBar(
                      content: Text('Popular Genres 1 Saved Sucessfully'),
                      backgroundColor: Color.fromRGBO(32, 117, 143, 1),
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Appcolor().whtcolor),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                IconButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      print('image path${file?.path}');

                      if (file == null) return;

                      String uniqueFileName =
                          DateTime.now().microsecondsSinceEpoch.toString();

                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('Popular_Genres_2_Images');
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);

                      try {
                        await referenceImageToUpload.putFile(File(file.path));
                        imageurl =
                            await referenceImageToUpload.getDownloadURL();
                        print("image url: " + imageurl);
                      } catch (error) {
                        //some error
                      }
                    },
                    icon: const Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                    )),
                const Text("Add Popular Genres 2 Image"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                IconButton(
                    onPressed: () async {
                      pickpop2PDF();
                    },
                    icon: const Icon(
                      Icons.upload_file_sharp,
                      size: 40,
                    )),
                const Text("Add Popular Genres 2 Pdf"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                IconButton(
                    onPressed: () async {
                      pickPop2AuthorImage();
                    },
                    icon: const Icon(
                      Icons.person_add,
                      size: 40,
                    )),
                const Text("Add Popular Genres 2 Author Image"),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: populergeners2,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Popular Genres 2 Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: popular2authorname,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Popular Genres 2 Author Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: pop2introduction,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Popular Genres 2 Introduction",
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Appcolor().primarycolor),
                  ),
                  onPressed: () {
                    Map<String, String> dataToSend = {
                      'book_image': imageurl,
                      "book_name": populergeners2.text,
                      "author_image": imageurl2,
                      "author_name": popular2authorname.text,
                      "introduction": pop2introduction.text,
                      "pdfurl": downloadURL,
                    };

                    _referencepop2.add(dataToSend);
                    const snackdemo = SnackBar(
                      content: Text('Popular Genres 2 Saved Sucessfully'),
                      backgroundColor: Color.fromRGBO(32, 117, 143, 1),
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Appcolor().whtcolor),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                IconButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      print('image path${file?.path}');

                      if (file == null) return;

                      String uniqueFileName =
                          DateTime.now().microsecondsSinceEpoch.toString();

                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('Novel_Genres_Images');
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);

                      try {
                        await referenceImageToUpload.putFile(File(file.path));
                        imageurl =
                            await referenceImageToUpload.getDownloadURL();
                        print("image url: " + imageurl);
                      } catch (error) {
                        //some error
                      }
                    },
                    icon: const Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                    )),
                const Text("Add Novel Genres Image"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                IconButton(
                    onPressed: () async {
                      pickNovelPDF();
                    },
                    icon: const Icon(
                      Icons.upload_file_sharp,
                      size: 40,
                    )),
                const Text("Add Novel Genres Pdf"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                IconButton(
                    onPressed: () async {
                      pickNovelAuthorImage();
                    },
                    icon: const Icon(
                      Icons.person_add,
                      size: 40,
                    )),
                const Text("Add Novel Genres Author Image"),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: novelgenersName,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Novel Genres Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: novelauthorname,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Novel Genres Author Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: novelintroduction,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Novel Genres Introduction",
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Appcolor().primarycolor),
                  ),
                  onPressed: () {
                    Map<String, String> dataToSend = {
                      'book_image': imageurl,
                      "book_name": novelgenersName.text,
                      "author_image": imageurl2,
                      "author_name": novelauthorname.text,
                      "introduction": novelintroduction.text,
                      "pdfurl": downloadURL,
                    };

                    _reference.add(dataToSend);
                    const snackdemo = SnackBar(
                      content: Text('Novel Genres Saved Sucessfully'),
                      backgroundColor: Color.fromRGBO(32, 117, 143, 1),
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Appcolor().whtcolor),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                IconButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      print('${file?.path}');

                      if (file == null) return;

                      String uniqueFileName =
                          DateTime.now().microsecondsSinceEpoch.toString();

                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('Trending_Genres_Images');
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);

                      try {
                        await referenceImageToUpload.putFile(File(file.path));
                        imageurl =
                            await referenceImageToUpload.getDownloadURL();
                      } catch (error) {
                        //some error
                      }
                    },
                    icon: const Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                    )),
                const Text("Add Trending Genres Image"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                IconButton(
                    onPressed: () async {
                      pickTrendingPDF();
                    },
                    icon: const Icon(
                      Icons.upload_file_sharp,
                      size: 40,
                    )),
                const Text("Add Trending Genres Pdf"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                IconButton(
                    onPressed: () async {
                      pickTrendingAuthorImage();
                    },
                    icon: const Icon(
                      Icons.person_add,
                      size: 40,
                    )),
                const Text("Add Trending Genres Author Image"),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: trendinggenersName,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Trending Genres Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: trendingauthorName,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Trending Genres Author Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: trendingintroduction,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Trending Genres Introduction",
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Appcolor().primarycolor),
                    ),
                    onPressed: () {
                      Map<String, String> dataToSend = {
                        'book_image': imageurl,
                        "book_name": trendinggenersName.text,
                        "author_image": imageurl2,
                        "author_name": trendingauthorName.text,
                        "introduction": trendingintroduction.text,
                        "pdfurl": downloadURL,
                      };

                      reference.add(dataToSend);
                      const snackdemo = SnackBar(
                        content: Text('Trending Genres Saved Sucessfully'),
                        backgroundColor: Color.fromRGBO(32, 117, 143, 1),
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(5),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Appcolor().whtcolor),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                IconButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      print('image path${file?.path}');

                      if (file == null) return;

                      String uniqueFileName =
                          DateTime.now().microsecondsSinceEpoch.toString();

                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('NewBooks_Images');
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);

                      try {
                        await referenceImageToUpload.putFile(File(file.path));
                        imageurl =
                            await referenceImageToUpload.getDownloadURL();
                        print("image url: " + imageurl);
                      } catch (error) {
                        //some error
                      }
                    },
                    icon: const Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                    )),
                const Text("Add New Book Image"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                IconButton(
                    onPressed: () async {
                      pickNewBooksPDF();
                    },
                    icon: const Icon(
                      Icons.upload_file_sharp,
                      size: 40,
                    )),
                const Text("Add New Book Pdf"),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                IconButton(
                    onPressed: () async {
                      pickNewBooksAuthorImage();
                    },
                    icon: const Icon(
                      Icons.person_add,
                      size: 40,
                    )),
                const Text("Add New Book Author Image"),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: NewBooksname,
                    decoration: const InputDecoration(
                      hintText: "Enter Your New Book Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: NewBooksauthorname,
                    decoration: const InputDecoration(
                      hintText: "Enter Your New Book Author Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    controller: NewBooksintroduction,
                    decoration: const InputDecoration(
                      hintText: "Enter Your New Book Introduction",
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 27,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Appcolor().primarycolor),
                  ),
                  onPressed: () {
                    Map<String, String> dataToSend = {
                      'book_image': imageurl,
                      "book_name": NewBooksname.text,
                      "author_image": imageurl2,
                      "author_name": NewBooksauthorname.text,
                      "introduction": NewBooksintroduction.text,
                      "pdfurl": downloadURL,
                    };

                    _referenceNewBook.add(dataToSend);
                    const snackdemo = SnackBar(
                      content: Text('New Book Saved Sucessfully'),
                      backgroundColor: Color.fromRGBO(32, 117, 143, 1),
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Appcolor().whtcolor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
