import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}// // import 'package:customers/maps/mainscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class BookingScreen extends StatefulWidget {
//   @override
//   _BookingScreenState createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen> {
//   late Stream<QuerySnapshot> _ordersStream;

//   @override
//   void initState() {
//     super.initState();
//     _loadOrders();
//   }

//   void _loadOrders() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       _ordersStream = FirebaseFirestore.instance
//           .collection('receipts')
//           .where('userId', isEqualTo: user.uid)
//           .snapshots();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your Bookings'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _ordersStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No bookings found.'));
//           }

//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               Map<String, dynamic> data =
//                   document.data() as Map<String, dynamic>;
//               return GestureDetector(
//                 onTap: () {
//                   // Navigate to details screen or show details in dialog
//                   _navigateToOrderDetails(data);
//                 },
//                 child: Card(
//                   elevation: 2,
//                   margin: EdgeInsets.symmetric(vertical: 8.0),
//                   child: Padding(
//                     padding: EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Detailer Name: ${data['detailerName']}'),
//                         SizedBox(height: 8),
//                         Text('Package Name: ${data['packageName']}'),
//                         SizedBox(height: 8),
//                         Text('Package Price: ${data['packagePrice']}'),
//                         SizedBox(height: 8),
//                         Text('Order Time: ${data['orderTime']}'),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }

//   void _navigateToOrderDetails(Map<String, dynamic> orderData) {
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (context) => MainScreen(),
//     //   ),
//     // );
//   }
// }
