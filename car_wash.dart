// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sellers/models/packages.dart';

class CarWash extends ChangeNotifier {
  final List<Package> _menu = [
    //External
    //external small
    Package(
      name: "Exterior Detail-Small",
      description:
          "This is the fastest way to clean your small sized vehicle. It only cleans the outer side of the Vehicle",
      imagePath:
          'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?q=80&w=1931&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: "\$ 100",
      // category: Category.External,
    ),

    //external medium
    Package(
      name: "Exterior Detail-Medium",
      description:
          "This is the fastest way to clean your medium sized vehicle. It only cleans the outer side of the Vehicle",
      imagePath:
          'https://images.unsplash.com/photo-1633014041037-f5446fb4ce99?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: "\$ 200",
      // category: Category.External,
    ),

    //external big
    Package(
      name: "Exterior Detail-Big",
      description:
          "This is the fastest way to clean your large sized vehicle. It only cleans the outer side of the Vehicle",
      imagePath:
          'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?q=80&w=1742&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: "\$ 300",
      // category: Category.External,
    ),

    //Interior
    //interior small
    Package(
      name: "Interior Detail-Small",
      description:
          "We ensure your small sized vehicle looks spakling clean on the inside",
      imagePath:
          'https://images.unsplash.com/photo-1610647752706-3bb12232b3ab?q=80&w=1925&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: "\$ 200",
      // category: Category.Internal,
    ),

    //internal medium
    Package(
      name: "Interior Detail-Medium",
      description:
          "We ensure your Medium sized vehicle looks spakling clean on the inside",
      imagePath:
          'https://images.unsplash.com/photo-1557245526-45dc0f1a8745?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: "\$ 400",
      // category: Category.Internal,
    ),

    //Interior big
    Package(
      name: "Interior Detail-Big",
      description:
          "We ensure your large sized vehicle looks spakling clean on the inside",
      imagePath:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtyNaw0Hewxw55QBo__N2uy3UQHFDyITQIv-szyQVF-A&s',
      price: "\$ 500",
      // category: Category.Internal,
    ),

    //Full
    //Full small
    Package(
      name: "Full Detail-Small",
      description:
          "We ensure your looks small sized car looks clean both in & out",
      imagePath:
          'https://plus.unsplash.com/premium_photo-1661375337384-b6e1f64d7d3d?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: "\$ 1000",
      // category: Category.full,
    ),

    //full medium
    Package(
      name: "Full Detail-Medium",
      description:
          "We ensure your looks Medium sized car looks clean both in & out",
      imagePath:
          'https://images.unsplash.com/photo-1577582948740-3dd13a31c1e7?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: "\$ 2000",
      // category: Category.full,
    ),

    //full big
    Package(
      name: "FullDetail-Big",
      description:
          "We ensure your looks large sized car looks clean both in & out",
      imagePath:
          'https://images.unsplash.com/photo-1561821277-481f9c1d229c?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: "\$ 3000",
      // category: Category.full,
    ),

    //polishing
    //polishing small
    Package(
      name: "Polish & Wax Small",
      description:
          "We ensure your looks small sized car looks clean both in & out",
      imagePath:
          'https://plus.unsplash.com/premium_photo-1661375337384-b6e1f64d7d3d?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: "\$ 1000",
      // category: Category.full,
    ),

    //internal medium
    Package(
      name: "Polish & Wax Medium",
      description:
          "We ensure your looks Medium sized car looks clean both in & out",
      imagePath:
          'https://images.unsplash.com/photo-1577582948740-3dd13a31c1e7?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: "\$ 2000",
      // category: Category.full,
    ),

    //Interior big
    Package(
      name: "Polish & Wax Big",
      description:
          "We ensure your looks large sized car looks clean both in & out",
      imagePath:
          'https://images.unsplash.com/photo-1561821277-481f9c1d229c?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      price: "\$ 3000",
      // category: Category.full,
    ),
  ];

  // GETTERS

  List<Package> get menu => _menu;

  //generate Receipt
  String generateReceipt({
    required Package package,
    required String location,
    required String orderTime,
  }) {
    return '''
    Receipt:
    Service: ${package.name}
    Description: ${package.description}
    Price: ${package.price}
    Location: $location
    Order Time: $orderTime
    ''';
  }
}
