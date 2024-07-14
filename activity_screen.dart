import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:sellers/maps/mainscreen.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('companies')
          .doc(user!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Orders')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: Text('Orders')),
            body: Center(child: Text("No company data found")),
          );
        }

        final companyData = snapshot.data!.data() as Map<String, dynamic>?;
        final detailerName = companyData?['name'] ?? 'Unknown';

        return Scaffold(
          appBar: AppBar(title: Text('Orders')),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('receipts')
                .where('detailerName', isEqualTo: detailerName)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No orders found"));
              }

              final orders = snapshot.data!.docs;

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final orderData = order.data() as Map<String, dynamic>;

                  return GestureDetector(
                    onTap: () async {
                      await _handleOrderTap(context, user.uid, orderData);
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderData['packageName'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Customer: ${orderData['customerUsername']}"),
                          Text("Price: ${orderData['packagePrice']}"),
                          Text("Order Time: ${orderData['orderTime']}"),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handleOrderTap(BuildContext context, String detailerId,
      Map<String, dynamic> orderData) async {
    final location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData? detailerLocation;

    // Check if location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Handle the case where the user does not enable location services
        return;
      }
    }

    // Check location permissions
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // Handle the case where the user does not grant location permission
        return;
      }
    }

    // Retrieve the detailer's current location
    try {
      detailerLocation = await location.getLocation();
    } catch (e) {
      // Handle location retrieval error
      print("Error retrieving location: $e");
    }

    // Retrieve the customer's location from the order data
    final customerLatitude = orderData['latitude'];
    final customerLongitude = orderData['longitude'];

    if (detailerLocation != null &&
        customerLatitude != null &&
        customerLongitude != null) {
      // Store the locations in Firestore
      await FirebaseFirestore.instance.collection('locations').add({
        'detailerId': detailerId,
        'detailerLatitude': detailerLocation.latitude,
        'detailerLongitude': detailerLocation.longitude,
        'customerLatitude': customerLatitude,
        'customerLongitude': customerLongitude,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Send notification to the detailer
      await _sendNotificationToDetailer(detailerId, orderData);

      // Redirect to the LocationScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      // Handle error if location data is incomplete
      print("Location data is incomplete");
    }
  }

  Future<void> _sendNotificationToDetailer(
      String detailerId, Map<String, dynamic> orderData) async {
    // Retrieve detailer's FCM token from Firestore
    final doc = await FirebaseFirestore.instance
        .collection('companies')
        .doc(detailerId)
        .get();
    if (doc.exists) {
      final detailerToken = doc.data()?['fcmToken'];
      if (detailerToken != null) {
        // Send notification payload
        await FirebaseMessaging.instance.sendMessage(
          to: detailerToken,
          data: {
            'title': 'New Order Placed',
            'body': 'You have received a new order.',
          },
        );
      } else {
        print('Detailer FCM token not found');
      }
    } else {
      print('Detailer document not found in Firestore');
    }
  }
}


















// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:location/location.dart';
// import 'package:sellers/maps/mainscreen.dart';

// class OrdersPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return FutureBuilder<DocumentSnapshot>(
//       future: FirebaseFirestore.instance
//           .collection('companies')
//           .doc(user!.uid)
//           .get(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             appBar: AppBar(title: Text('Orders')),
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (!snapshot.hasData ||
//             snapshot.data == null ||
//             !snapshot.data!.exists) {
//           return Scaffold(
//             appBar: AppBar(title: Text('Orders')),
//             body: Center(child: Text("No company data found")),
//           );
//         }

//         final companyData = snapshot.data!.data() as Map<String, dynamic>?;
//         final detailerName = companyData?['name'] ?? 'Unknown';

//         return Scaffold(
//           appBar: AppBar(title: Text('Orders')),
//           body: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('receipts')
//                 .where('detailerName', isEqualTo: detailerName)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }

//               if (!snapshot.hasData ||
//                   snapshot.data == null ||
//                   snapshot.data!.docs.isEmpty) {
//                 return Center(child: Text("No orders found"));
//               }

//               final orders = snapshot.data!.docs;

//               return ListView.builder(
//                 itemCount: orders.length,
//                 itemBuilder: (context, index) {
//                   final order = orders[index];
//                   final orderData = order.data() as Map<String, dynamic>;

//                   return GestureDetector(
//                     onTap: () async {
//                       await _handleOrderTap(context, user.uid, orderData);
//                     },
//                     child: Container(
//                       margin: EdgeInsets.all(8.0),
//                       padding: EdgeInsets.all(16.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10.0),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 5,
//                             blurRadius: 7,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             orderData['packageName'],
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text("Customer: ${orderData['customerUsername']}"),
//                           Text("Price: ${orderData['packagePrice']}"),
//                           Text("Order Time: ${orderData['orderTime']}"),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _handleOrderTap(BuildContext context, String detailerId,
//       Map<String, dynamic> orderData) async {
//     final location = Location();

//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//     LocationData? detailerLocation;

//     // Check if location service is enabled
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         // Handle the case where the user does not enable location services
//         return;
//       }
//     }

//     // Check location permissions
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         // Handle the case where the user does not grant location permission
//         return;
//       }
//     }

//     // Retrieve the detailer's current location
//     try {
//       detailerLocation = await location.getLocation();
//     } catch (e) {
//       // Handle location retrieval error
//       print("Error retrieving location: $e");
//     }

//     // Retrieve the customer's location from the order data
//     final customerLatitude = orderData['latitude'];
//     final customerLongitude = orderData['longitude'];

//     if (detailerLocation != null &&
//         customerLatitude != null &&
//         customerLongitude != null) {
//       // Store the locations in Firestore
//       await FirebaseFirestore.instance.collection('locations').add({
//         'detailerId': detailerId,
//         'detailerLatitude': detailerLocation.latitude,
//         'detailerLongitude': detailerLocation.longitude,
//         'customerLatitude': customerLatitude,
//         'customerLongitude': customerLongitude,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       // Send notification to the detailer
//       await _sendNotificationToDetailer(detailerId, orderData);

//       // Redirect to the LocationScreen
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => MainScreen()),
//       );
//     } else {
//       // Handle error if location data is incomplete
//       print("Location data is incomplete");
//     }
//   }

//   Future<void> _sendNotificationToDetailer(
//       String detailerId, Map<String, dynamic> orderData) async {
//     // Retrieve detailer's FCM token from Firestore
//     final doc = await FirebaseFirestore.instance
//         .collection('companies')
//         .doc(detailerId)
//         .get();
//     if (doc.exists) {
//       final detailerToken = doc.data()?['fcmToken'];
//       if (detailerToken != null) {
//         // Send notification payload
//         await FirebaseMessaging.instance.sendMessage(
//           to: detailerToken,
//           data: {
//             'title': 'New Order Placed',
//             'body':
//                 'Customer: ${orderData['customerUsername']}, Package: ${orderData['packageName']}',
//           },
//         );
//       } else {
//         print('Detailer FCM token not found');
//       }
//     } else {
//       print('Detailer document not found in Firestore');
//     }
//   }
// }
