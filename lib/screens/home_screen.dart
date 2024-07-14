import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:customers/screens/sellerdetails_screen.dart';
import 'package:flutter/material.dart';

// In HomeScreen.dart

// In HomeScreen.dart

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pazzles',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Handle account action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailers Near You',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: CompaniesList(),
            ),
          ],
        ),
      ),
    );
  }
}

// In HomeScreen.dart

class CompaniesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('companies').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          scrollDirection: Axis.vertical,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return CompanyCard(
              companyId: document.id,
              imageUrl: data['imageUrl'],
              name: data['name'],
              transportfee: data['transportFee'],
              arrivalTime: data['arrivalTime'],
              location: data['location'],
            );
          }).toList(),
        );
      },
    );
  }
}

// In HomeScreen.dart

class CompanyCard extends StatelessWidget {
  final String companyId;
  final String? imageUrl; // Make imageUrl nullable
  final String? name; // Make name nullable
  final String? slogan; // Make slogan nullable
  final String? location;
  final transportfee;
  final arrivalTime; // Make location nullable

  CompanyCard({
    required this.companyId,
    this.imageUrl,
    this.name,
    this.slogan,
    this.location,
    this.transportfee,
    this.arrivalTime,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => SellerDetailsScreen(
        //       companyId: companyId,
        //       imageUrl: imageUrl ?? '', // Provide a default value if null
        //       name: name ?? '', // Provide a default value if null
        //       location: location ?? '', // Provide a default value if null
        //       transportfee: transportfee ?? '',
        //       arrivalTime: arrivalTime ?? '',
        //     ),
        //   ),
        // );
      },
      child: Card(
        elevation: 2.0,
        child: Container(
          width: 200.0,
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageUrl != null // Add null check
                  ? Image.network(
                      imageUrl!,
                      width: double.infinity,
                      height: 150.0,
                      fit: BoxFit.cover,
                    )
                  : SizedBox.shrink(), // Hide image if imageUrl is null
              SizedBox(height: 8.0),
              name != null // Add null check
                  ? Text(
                      name!,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : SizedBox.shrink(), // Hide name if name is null
              location != null // Add null check
                  ? Text(
                      location!,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    )
                  : SizedBox.shrink(),
              // Hide location if location is null

              Padding(
                padding: const EdgeInsets.only(right: 28),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    transportfee != null // Add null check
                        ? Text(
                            "Transport Fee:  $transportfee",
                            style: TextStyle(fontSize: 14.0),
                          )
                        : SizedBox.shrink(),
                    // Hide location if location is null

                    arrivalTime != null // Add null check
                        ? Text(
                            "Arrival Time: $arrivalTime",
                            style: TextStyle(fontSize: 14.0),
                          )
                        : SizedBox.shrink(),
                    // Hide location if location is null
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
