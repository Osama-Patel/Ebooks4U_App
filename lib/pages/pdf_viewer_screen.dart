import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';

// ignore: must_be_immutable
class PDFScreen extends StatefulWidget {
  final String? path;
  String? bookname;
  PDFScreen({Key? key, this.path, this.bookname}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  late int _pageNumber;
  final TextEditingController _searchTextController = TextEditingController();
  final TextEditingController _pageNumberController = TextEditingController();
  late PDFViewController _pdfViewController;

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bookname}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
        ],
        // actions: <Widget>[
        //   Padding(
        //     padding: const EdgeInsets.only(right: 5),
        //     child: Text('${currentPage}/${pages}'),
        //   ),
        // ],
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.path, // Path to PDF file
            swipeHorizontal: false,

            enableSwipe: true,
            // swipeHorizontal: true,

            //  autoSpacing: true,
            pageFling: true,
            pageSnap: false,
            // fitEachPage: true,
            onRender: (total) {
              setState(() {
                pages = total;
              });
            },
            onViewCreated: (PDFViewController controller) {
              _pdfViewController = controller;
            },
            onPageChanged: (page, total) {
              setState(() {
                currentPage = page;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    // style: ButtonStyle(),
                    child: Text(
                      'Go to First',
                      style: TextStyle(color: Colors.white),
                    ),
                    // icon: Icon(Icons.first_page_sharp),
                    // color: Colors.white,
                    onPressed: () {
                      if (_pdfViewController != null) {
                        _pdfViewController.setPage(0);
                        setState(() {
                          _pageNumber = 0;
                        });
                      }
                    },
                  ),
                  Text(
                    'Page ${currentPage! + 1} of $pages',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    child: Text(
                      'Go to Last',
                      style: TextStyle(color: Colors.white),
                    ),
                    // icon: Icon(Icons.last_page),
                    // color: Colors.white,
                    onPressed: () {
                      if (_pdfViewController != null) {
                        _pdfViewController.setPage(pages! - 1);
                        setState(() {
                          currentPage = pages! - 1;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Search Specific Page',
            style: TextStyle(fontSize: 22),
          ),
          content: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //  Text('Enter Page number:'),
                TextFormField(
                  controller: _pageNumberController,
                  decoration: InputDecoration(labelText: 'Enter Page Number'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _pageNumber = int.tryParse(value)!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _searchAndNavigate();
                Navigator.of(context).pop();
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _searchAndNavigate() async {
    if (_pageNumber != null && _pageNumber > 0) {
      _pdfViewController.setPage(_pageNumber - 1);
    }
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _pageNumberController.dispose();
    super.dispose();
  }
}
