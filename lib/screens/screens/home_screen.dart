import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sellers/models/car_wash.dart';
import 'package:sellers/themes/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    Provider.of<ThemeProvider>(context);

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('companies')
          .doc(user!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            !snapshot.data!.exists) {
          return Scaffold(
            body: Center(child: Text("No company data found")),
          );
        }

        final companyData = snapshot.data!.data() as Map<String, dynamic>?;

        if (companyData == null) {
          return Scaffold(
            body: Center(child: Text("Error loading company data")),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: companyData['imageUrl'] != null &&
                                companyData['imageUrl'].isNotEmpty
                            ? NetworkImage(companyData['imageUrl'])
                            : AssetImage('assets/default_image.png')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black54,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            companyData['name'] ?? 'No Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            companyData['location'] ?? 'No Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Transport Fee: ${companyData['transportFee'] ?? 'N/A'}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(
                                "Arrival Time: ${companyData['arrivalTime'] ?? 'N/A'}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Packages Offered",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Consumer<CarWash>(
                  builder: (context, carWash, child) {
                    return Column(
                      children: carWash.menu.map((package) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              Image.network(
                                package.imagePath.isNotEmpty
                                    ? package.imagePath
                                    : 'assets/default_image.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/default_image.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      package.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      package.price,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      package.description,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}






















// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:sellers/screens/sellerdetails_screen.dart';

// // In HomeScreen.dart

// // In HomeScreen.dart

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Pazzles',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               // Handle search action
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.account_circle),
//             onPressed: () {
//               // Handle account action
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Detailers Near You',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10.0),
//             Expanded(
//               child: CompaniesList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // In HomeScreen.dart

// class CompaniesList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('companies').snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         return ListView(
//           scrollDirection: Axis.vertical,
//           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//             Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//             return CompanyCard(
//               companyId: document.id,
//               imageUrl: data['imageUrl'],
//               name: data['name'],
//               slogan: data['slogan'],
//               location: data['location'],
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }

// // In HomeScreen.dart

// class CompanyCard extends StatelessWidget {
//   final String companyId;
//   final String? imageUrl; // Make imageUrl nullable
//   final String? name; // Make name nullable
//   final String? slogan; // Make slogan nullable
//   final String? location; // Make location nullable

//   CompanyCard({
//     required this.companyId,
//     this.imageUrl,
//     this.name,
//     this.slogan,
//     this.location,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SellerDetailsScreen(
//               companyId: companyId,
//               imageUrl: imageUrl ?? '', // Provide a default value if null
//               name: name ?? '', // Provide a default value if null
//               description: slogan ?? '', // Provide a default value if null
//             ),
//           ),
//         );
//       },
//       child: Card(
//         elevation: 2.0,
//         child: Container(
//           width: 200.0,
//           padding: EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               imageUrl != null // Add null check
//                   ? Image.network(
//                       imageUrl!,
//                       width: double.infinity,
//                       height: 150.0,
//                       fit: BoxFit.cover,
//                     )
//                   : SizedBox.shrink(), // Hide image if imageUrl is null
//               SizedBox(height: 8.0),
//               name != null // Add null check
//                   ? Text(
//                       name!,
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     )
//                   : SizedBox.shrink(), // Hide name if name is null
//               location != null // Add null check
//                   ? Text(
//                       location!,
//                       style: TextStyle(fontSize: 14.0),
//                     )
//                   : SizedBox.shrink(), // Hide location if location is null
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


















