// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:sellers/components/my_current_location.dart';
import 'package:sellers/components/my_delivery_box.dart';
import 'package:sellers/components/my_silver_app_bar.dart';
import 'package:sellers/models/car_wash.dart';
import 'package:sellers/models/packages.dart';

class SellerDetailsScreen extends StatefulWidget {
  final String companyId;
  final String imageUrl;
  final String name;
  final String location;
  final String transportfee;
  final String arrivalTime;
  final String exesmall;
  final String exemedium;
  final String exefull;
  final String intsmall;
  final String intmedium;
  final String intbig;
  final String fullsmall;
  final String fullmedium;
  final String fullbig;
  final String pollsmall;
  final String pollmedium;
  final String pollbig;
  final String description;

  SellerDetailsScreen({
    required this.companyId,
    this.imageUrl = '', // Provide a default empty string if null
    this.name = '', // Provide a default empty string if null
    this.location = '',
    this.transportfee = '',
    this.arrivalTime = '',
    this.exesmall = '',
    this.exemedium = '',
    this.exefull = '',
    this.intsmall = '',
    this.intmedium = '',
    this.intbig = '',
    this.fullsmall = '',
    this.fullmedium = '',
    this.fullbig = '',
    this.pollsmall = '',
    this.pollmedium = '',
    this.pollbig = '',
    this.description = '',
  });

  @override
  State<SellerDetailsScreen> createState() => _SellerDetailsScreenState();
}

class _SellerDetailsScreenState extends State<SellerDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final CarWash carWash = CarWash();
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(
      //     child: Text(
      //       widget.name,
      //       style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      //     ),
      //   ),
      // ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          MySliverAppBar(
            title: MyTabBar(tabController: tabController),
            // title: Text(
            //   widget.name,
            //   style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            // ),

            name: Center(
              child: Text(
                widget.name,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  indent: 25,
                  endIndent: 25,
                  color: Theme.of(context).colorScheme.secondary,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //my current location

                      MyCurrentLocation(),

                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star),
                              Text("5"),
                            ],
                          ),
                          Text("Rating")
                        ],
                      ),
                    ],
                  ),
                ),

                //delivery box

                MyDeliveryBox(
                  transportfee: Column(
                    children: [
                      Row(
                        children: [
                          Text("\$"),
                          Text(widget.transportfee,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary)),
                        ],
                      ),
                      Text(
                        "Transport Fee",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                  arrivalTime: Column(
                    children: [
                      Text(
                        widget.arrivalTime,
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                      Text("Arrival Time",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
        body: TabBarView(
          controller: tabController,
          children: [
            PackageList(
              packages: carWash.menu
                  .where((package) => package.name.contains('Exterior'))
                  .toList(),
              detailerName: widget.name,
            ),
            PackageList(
              packages: carWash.menu
                  .where((package) => package.name.contains('Interior'))
                  .toList(),
              detailerName: widget.name,
            ),
            PackageList(
              packages: carWash.menu
                  .where((package) => package.name.contains('Full'))
                  .toList(),
              detailerName: widget.name,
            ),
            PackageList(
              packages: carWash.menu
                  .where((package) => package.name.contains('Polish'))
                  .toList(),
              detailerName: widget.name,
            ),
          ],
        ),
      ),
    );
  }
}

class PackageList extends StatelessWidget {
  final List<Package> packages;
  final String detailerName;

  PackageList({
    required this.packages,
    required this.detailerName,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: packages.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final package = packages[index];
        return GestureDetector(
          onTap: () async {
            // var orderTime =
            //     DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

            // // Fetch the customer username from Firestore
            // final doc = await FirebaseFirestore.instance
            //     .collection('customers')
            //     .doc(FirebaseAuth.instance.currentUser!.uid)
            //     .get();

            // final customerUsername = doc.data()?['userName'] ?? 'Unknown User';

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ReceiptScreen(
            //       detailerName: detailerName,
            //       packageName: package.name,
            //       orderTime: orderTime,
            //       packagePrice: package.price,
            //       customerUsername: customerUsername,
            //     ),
            //   ),
            // );
          },
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                package.imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              package.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(package.description),
            trailing: Text(
              package.price,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyTabBar extends StatelessWidget {
  final TabController tabController;
  const MyTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
          controller: tabController,
          isScrollable: false,
          labelPadding: EdgeInsets.only(left: 0, right: 0),
          // labelPadding: EdgeInsets.only(left: 0, right: 0),
          tabs: [
            //tab 1
            Tab(
              text: "Exterior ",
            ),
            //tab 2
            Tab(
              text: "Interior ",
            ),
            Tab(
              text: "Full ",
            ),
            //tab 3
            Tab(
              text: "Polish & Wax",
            )
          ]),
    );
  }
}










// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class SellerDetailsScreen extends StatelessWidget {
//   final String companyId;
//   final String imageUrl;
//   final String name;
//   final String description;

//   SellerDetailsScreen({
//     required this.companyId,
//     this.imageUrl = '', // Provide a default empty string if null
//     this.name = '', // Provide a default empty string if null
//     this.description = '', // Provide a default empty string if null
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.only(top: 30.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             imageUrl.isNotEmpty
//                 ? Image.network(
//                     imageUrl,
//                     width: double.infinity,
//                     height: 120.0,
//                     fit: BoxFit.cover,
//                   )
//                 : Container(
//                     width: double.infinity,
//                     height: 250.0,
//                     color: Colors.grey,
//                     child: Icon(
//                       Icons.image,
//                       size: 100,
//                       color: Colors.white,
//                     ),
//                   ),
//             SizedBox(height: 2.0),
//             Center(
//               child: Text(
//                 name,
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               description,
//               style: TextStyle(
//                 fontSize: 16.0,
//                 color: Colors.grey[700],
//               ),
//             ),
//             SizedBox(height: 20.0),
//             Text(
//               'Services Offered',
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10.0),
//             ServicesList(companyId: companyId),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ServicesList extends StatelessWidget {
//   final String companyId;

//   ServicesList({required this.companyId});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('services')
//           .where('companyId', isEqualTo: companyId)
//           .snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         return Column(
//           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//             Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//             return ServiceCard(
//               imageUrl: data['imageUrl'] ?? '',
//               package: data['package'] ?? '',
//               largeVehiclePrice:
//                   double.tryParse(data['largeVehiclePrice'].toString()) ?? 0.0,
//               mediumVehiclePrice:
//                   double.tryParse(data['mediumVehiclePrice'].toString()) ?? 0.0,
//               smallVehiclePrice:
//                   double.tryParse(data['smallVehiclePrice'].toString()) ?? 0.0,
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }

// class ServiceCard extends StatelessWidget {
//   final String imageUrl;
//   final String package;
//   final double largeVehiclePrice;
//   final double mediumVehiclePrice;
//   final double smallVehiclePrice;

//   ServiceCard({
//     required this.imageUrl,
//     required this.package,
//     required this.largeVehiclePrice,
//     required this.mediumVehiclePrice,
//     required this.smallVehiclePrice,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2.0,
//       margin: EdgeInsets.symmetric(vertical: 10.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             imageUrl.isNotEmpty
//                 ? Image.network(
//                     imageUrl,
//                     width: double.infinity,
//                     height: 120.0,
//                     fit: BoxFit.cover,
//                   )
//                 : Container(
//                     width: double.infinity,
//                     height: 120.0,
//                     color: Colors.grey,
//                     child: Icon(
//                       Icons.image,
//                       size: 100,
//                       color: Colors.white,
//                     ),
//                   ),
//             SizedBox(height: 8.0),
//             Text(
//               package,
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               'Large Vehicle: \$${largeVehiclePrice.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 14.0),
//             ),
//             Text(
//               'Medium Vehicle: \$${mediumVehiclePrice.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 14.0),
//             ),
//             Text(
//               'Small Vehicle: \$${smallVehiclePrice.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 14.0),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

























