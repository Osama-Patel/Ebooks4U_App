// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnera/constant/colors.dart';
import 'package:learnera/pages/NotificationDetailScreen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Notifications',
            style: TextStyle(color: Appcolor().whtcolor),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Appcolor().whtcolor,
              )),
          backgroundColor: Appcolor().primarycolor,
        ),
        body: NotificationList(),
        // const Column(
        //   children: [
        //     Padding(
        //       padding: EdgeInsets.only(top: 230),
        //       child: Center(
        //         child: SizedBox(
        //             height: 200,
        //             width: 200,
        //             child: Image(
        //                 image: AssetImage(
        //                     'assets/images/notifications-removebg-preview.png'))),
        //       ),
        //     ),
        //     Text(
        //       'No notifications',
        //       style: TextStyle(
        //         fontSize: 20,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Novel_Genres').snapshots(),
      builder: (context, snapshot1) {
        if (snapshot1.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot1.hasData) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Trending_Genres')
                .snapshots(),
            builder: (context, snapshot2) {
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot2.hasData) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('New_Books')
                      .snapshots(),
                  builder: (context, snapshot3) {
                    if (snapshot3.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot3.hasData) {
                      List<QueryDocumentSnapshot> allDocs = [];
                      allDocs.addAll(snapshot1.data!.docs);
                      allDocs.addAll(snapshot2.data!.docs);
                      allDocs.addAll(snapshot3.data!.docs);

                      if (allDocs.isNotEmpty) {
                        return ListView.builder(
                          itemCount: allDocs.length,
                          itemBuilder: (context, index) {
                            final notification = allDocs[index];
                            return ListTile(
                              leading:
                                  Image.network(notification['book_image']),
                              title: Text(notification['book_name'] + ' Book'),
                              subtitle: Text(
                                  'Added to ${notification.reference.parent.id} collection. Click Here for more details.'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationDetailScreen(
                                            notification: notification),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: Image.asset(
                                    'assets/images/notifications-removebg-preview.png'),
                              ),
                              Text(
                                'No Notifications',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

// class NotificationList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream:
//           FirebaseFirestore.instance.collection('Popular_Genres_1').snapshots(),
//       builder: (context, snapshot1) {
//         if (snapshot1.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot1.hasData) {
//           return StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('Popular_Genres_2')
//                 .snapshots(),
//             builder: (context, snapshot2) {
//               if (snapshot2.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot2.hasData) {
//                 return StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('Novel_Genres')
//                       .snapshots(),
//                   builder: (context, snapshot3) {
//                     if (snapshot3.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot3.hasData) {
//                       return StreamBuilder<QuerySnapshot>(
//                         stream: FirebaseFirestore.instance
//                             .collection('Trending_Genres')
//                             .snapshots(),
//                         builder: (context, snapshot4) {
//                           if (snapshot4.connectionState ==
//                               ConnectionState.waiting) {
//                             return Center(child: CircularProgressIndicator());
//                           } else if (snapshot4.hasData) {
//                             return StreamBuilder<QuerySnapshot>(
//                               stream: FirebaseFirestore.instance
//                                   .collection('New_Books')
//                                   .snapshots(),
//                               builder: (context, snapshot5) {
//                                 if (snapshot5.connectionState ==
//                                     ConnectionState.waiting) {
//                                   return Center(
//                                       child: CircularProgressIndicator());
//                                 } else if (snapshot5.hasData) {
//                                   List<QueryDocumentSnapshot> allDocs = [];
//                                   allDocs.addAll(snapshot1.data!.docs);
//                                   allDocs.addAll(snapshot2.data!.docs);
//                                   allDocs.addAll(snapshot3.data!.docs);
//                                   allDocs.addAll(snapshot4.data!.docs);
//                                   allDocs.addAll(snapshot5.data!.docs);

//                                   if (allDocs.isNotEmpty) {
//                                     return ListView.builder(
//                                       itemCount: allDocs.length,
//                                       itemBuilder: (context, index) {
//                                         final notification = allDocs[index];
//                                         return ListTile(
//                                           leading: Image.network(
//                                               notification['book_image']),
//                                           title: Text(
//                                               notification['book_name'] +
//                                                   ' Book'),
//                                           subtitle: Text(
//                                               'Added to ${notification.reference.parent.id} Click Here for more details'),
//                                           onTap: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     NotificationDetailScreen(
//                                                         notification:
//                                                             notification),
//                                               ),
//                                             );
//                                           },
//                                         );
//                                       },
//                                     );
//                                   } else {
//                                     return Center(
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           SizedBox(
//                                             height: 200,
//                                             width: 200,
//                                             child: Image.asset(
//                                                 'assets/images/notifications-removebg-preview.png'),
//                                           ),
//                                           Text(
//                                             'No Notifications',
//                                             style: TextStyle(fontSize: 20),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }
//                                 } else {
//                                   return Center(
//                                     child: CircularProgressIndicator(),
//                                   );
//                                 }
//                               },
//                             );
//                           } else {
//                             return Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                         },
//                       );
//                     } else {
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                   },
//                 );
//               } else {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           );
//         } else {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }
// }
