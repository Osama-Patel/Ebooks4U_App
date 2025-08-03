import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot notification;

  const NotificationDetailScreen({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        notification['book_name'],
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                notification['book_image'],
                height: 150,
              ),
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                // color: Colors.blue.shade300,
                //  shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              width: 350,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  notification['book_name'] +
                      ' added to ${notification.reference.parent.id} Check out in ${notification.reference.parent.id} Collection. also check notifications for further updates.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
