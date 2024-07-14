import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class RatingsPage extends StatefulWidget {
  final String detailerName;

  const RatingsPage({Key? key, required this.detailerName}) : super(key: key);

  @override
  _RatingsPageState createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  int _rating = 0; // Initial rating value

  void _submitRating() async {
    String customerName = ''; // Replace with actual customer name retrieval
    DateTime timestamp = DateTime.now();

    // Validate rating input
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a rating!')),
      );
      return;
    }

    try {
      // Store rating in Firestore
      await FirebaseFirestore.instance.collection('ratings').add({
        'customerName': customerName,
        'detailerName': widget.detailerName,
        'rating': _rating,
        'timestamp': timestamp,
      });

      // Navigate back to HomeScreen
      Navigator.pop(context);
    } catch (e) {
      print('Error submitting rating: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to submit rating. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'RATE',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  iconSize: 40,
                  icon: Icon(Icons.star,
                      color: _rating >= 1 ? Colors.orange : Colors.grey),
                  onPressed: () => setState(() => _rating = 1),
                ),
                IconButton(
                  iconSize: 40,
                  icon: Icon(Icons.star,
                      color: _rating >= 2 ? Colors.orange : Colors.grey),
                  onPressed: () => setState(() => _rating = 2),
                ),
                IconButton(
                  iconSize: 40,
                  icon: Icon(Icons.star,
                      color: _rating >= 3 ? Colors.orange : Colors.grey),
                  onPressed: () => setState(() => _rating = 3),
                ),
                IconButton(
                  iconSize: 40,
                  icon: Icon(Icons.star,
                      color: _rating >= 4 ? Colors.orange : Colors.grey),
                  onPressed: () => setState(() => _rating = 4),
                ),
                IconButton(
                  iconSize: 40,
                  icon: Icon(Icons.star,
                      color: _rating >= 5 ? Colors.orange : Colors.grey),
                  onPressed: () => setState(() => _rating = 5),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRating,
              child: Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }
}
















// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter/material.dart';

// class RatingsPage extends StatefulWidget {
//   final String detailerName;

//   const RatingsPage({Key? key, required this.detailerName}) : super(key: key);

//   @override
//   _RatingsPageState createState() => _RatingsPageState();
// }

// class _RatingsPageState extends State<RatingsPage> {
//   int _rating = 0; // Initial rating value

//   void _submitRating() async {
//     String customerName = ''; // Replace with actual customer name retrieval
//     DateTime timestamp = DateTime.now();

//     // Validate rating input
//     if (_rating == 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select a rating!')),
//       );
//       return;
//     }

//     try {
//       // Store rating in Firestore
//       await FirebaseFirestore.instance.collection('ratings').add({
//         'customerName': customerName,
//         'detailerName': widget.detailerName,
//         'rating': _rating,
//         'timestamp': timestamp,
//       });

//       // Navigate back to HomeScreen
//       Navigator.pop(context);
//     } catch (e) {
//       print('Error submitting rating: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text('Failed to submit rating. Please try again later.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Rate ${widget.detailerName}'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'Rate ${widget.detailerName}',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 IconButton(
//                   iconSize: 40,
//                   icon: Icon(Icons.star,
//                       color: _rating >= 1 ? Colors.orange : Colors.grey),
//                   onPressed: () => setState(() => _rating = 1),
//                 ),
//                 IconButton(
//                   iconSize: 40,
//                   icon: Icon(Icons.star,
//                       color: _rating >= 2 ? Colors.orange : Colors.grey),
//                   onPressed: () => setState(() => _rating = 2),
//                 ),
//                 IconButton(
//                   iconSize: 40,
//                   icon: Icon(Icons.star,
//                       color: _rating >= 3 ? Colors.orange : Colors.grey),
//                   onPressed: () => setState(() => _rating = 3),
//                 ),
//                 IconButton(
//                   iconSize: 40,
//                   icon: Icon(Icons.star,
//                       color: _rating >= 4 ? Colors.orange : Colors.grey),
//                   onPressed: () => setState(() => _rating = 4),
//                 ),
//                 IconButton(
//                   iconSize: 40,
//                   icon: Icon(Icons.star,
//                       color: _rating >= 5 ? Colors.orange : Colors.grey),
//                   onPressed: () => setState(() => _rating = 5),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _submitRating,
//               child: Text('Submit Rating'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
