import 'package:customers/screens/rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ignore: unused_field
  late GoogleMapController _mapController;
  LatLng? _customerLocation;
  LatLng? _detailerLocation;

  Set<Marker> _markers = {};

  LatLng? currentPosition;

  final locationController = Location();

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdates());
    _fetchLocations();
  }

  void _fetchLocations() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('locations')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    var data = snapshot.docs.first.data();

    setState(() {
      _customerLocation =
          LatLng(data['customerLatitude'], data['customerLongitude']);
      _detailerLocation =
          LatLng(data['detailerLatitude'], data['detailerLongitude']);

      _markers = {
        Marker(
          markerId: MarkerId('customer'),
          position: _customerLocation!,
          infoWindow: InfoWindow(title: 'Customer Location'),
        ),
        Marker(
          markerId: MarkerId('detailer'),
          position: _detailerLocation!,
          infoWindow: InfoWindow(title: 'Detailer Location'),
        ),
      };

      _initializeMap();
    });
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }

  Future<List<LatLng>> _fetchPolylinePoints() async {
    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      // googleApiKey: googleMapsApiKey,
      request: PolylineRequest(
          origin: PointLatLng(
              _customerLocation!.latitude, _customerLocation!.longitude),
          destination: PointLatLng(
              _detailerLocation!.latitude, _detailerLocation!.longitude),
          mode: TravelMode.driving),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint(result.errorMessage);
      return [];
    }
  }

  Future<void> _generatePolyLineFromPoints(
      List<LatLng> polylineCoordinates) async {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() => polylines[id] = polyline);
  }

  Future<void> _initializeMap() async {
    final coordinates = await _fetchPolylinePoints();
    if (coordinates.isNotEmpty) {
      _generatePolyLineFromPoints(coordinates);
    }
  }

  void _openGoogleMapsDirections() async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&origin=${_customerLocation!.latitude},${_customerLocation!.longitude}&destination=${_detailerLocation!.latitude},${_detailerLocation!.longitude}&travelmode=driving";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Demo'),
      ),
      body: Stack(
        children: [
          _customerLocation != null && _detailerLocation != null
              ? GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _customerLocation!,
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  markers: _markers,
                  polylines: Set<Polyline>.of(polylines.values),
                )
              : Center(child: CircularProgressIndicator()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _openGoogleMapsDirections,
                  child: Text('Directions'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Completed" button press

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingsPage(
                          detailerName:
                              '$_detailerLocation', // Ensure detailerName is passed correctly
                        ),
                      ),
                    );
                  },
                  child: Text('Completed'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}













// import 'package:customers/screens/rating_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:location/location.dart';
// import 'package:url_launcher/url_launcher.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   // ignore: unused_field
//   late GoogleMapController _mapController;
//   LatLng? _customerLocation;
//   LatLng? _detailerLocation;
//   Set<Marker> _markers = {};

//   LatLng? currentPosition;

//   final locationController = Location();

//   Map<PolylineId, Polyline> polylines = {};

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) async => await fetchLocationUpdates());
//     _fetchLocations();
//   }

//   void _fetchLocations() async {
//     var snapshot = await FirebaseFirestore.instance
//         .collection('locations')
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .get();
//     var data = snapshot.docs.first.data();

//     setState(() {
//       _customerLocation =
//           LatLng(data['customerLatitude'], data['customerLongitude']);
//       _detailerLocation =
//           LatLng(data['detailerLatitude'], data['detailerLongitude']);

//       _markers = {
//         Marker(
//           markerId: MarkerId('customer'),
//           position: _customerLocation!,
//           infoWindow: InfoWindow(title: 'Customer Location'),
//         ),
//         Marker(
//           markerId: MarkerId('detailer'),
//           position: _detailerLocation!,
//           infoWindow: InfoWindow(title: 'Detailer Location'),
//         ),
//       };

//       _initializeMap();
//     });
//   }

//   Future<void> fetchLocationUpdates() async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;

//     serviceEnabled = await locationController.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await locationController.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }

//     permissionGranted = await locationController.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await locationController.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     locationController.onLocationChanged.listen((currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null) {
//         setState(() {
//           currentPosition =
//               LatLng(currentLocation.latitude!, currentLocation.longitude!);
//         });
//       }
//     });
//   }

//   Future<List<LatLng>> _fetchPolylinePoints() async {
//     final polylinePoints = PolylinePoints();

//     final result = await polylinePoints.getRouteBetweenCoordinates(
//       // googleApiKey: googleMapsApiKey,
//       request: PolylineRequest(
//           origin: PointLatLng(
//               _customerLocation!.latitude, _customerLocation!.longitude),
//           destination: PointLatLng(
//               _detailerLocation!.latitude, _detailerLocation!.longitude),
//           mode: TravelMode.driving),
//     );

//     if (result.points.isNotEmpty) {
//       return result.points
//           .map((point) => LatLng(point.latitude, point.longitude))
//           .toList();
//     } else {
//       debugPrint(result.errorMessage);
//       return [];
//     }
//   }

//   Future<void> _generatePolyLineFromPoints(
//       List<LatLng> polylineCoordinates) async {
//     const id = PolylineId('polyline');

//     final polyline = Polyline(
//       polylineId: id,
//       color: Colors.blueAccent,
//       points: polylineCoordinates,
//       width: 5,
//     );

//     setState(() => polylines[id] = polyline);
//   }

//   Future<void> _initializeMap() async {
//     final coordinates = await _fetchPolylinePoints();
//     if (coordinates.isNotEmpty) {
//       _generatePolyLineFromPoints(coordinates);
//     }
//   }

//   void _openGoogleMapsDirections() async {
//     final String googleMapsUrl =
//         "https://www.google.com/maps/dir/?api=1&origin=${_customerLocation!.latitude},${_customerLocation!.longitude}&destination=${_detailerLocation!.latitude},${_detailerLocation!.longitude}&travelmode=driving";

//     if (await canLaunch(googleMapsUrl)) {
//       await launch(googleMapsUrl);
//     } else {
//       throw 'Could not launch $googleMapsUrl';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Maps Demo'),
//       ),
//       body: Stack(
//         children: [
//           _customerLocation != null && _detailerLocation != null
//               ? GoogleMap(
//                   initialCameraPosition: CameraPosition(
//                     target: _customerLocation!,
//                     zoom: 15,
//                   ),
//                   onMapCreated: (GoogleMapController controller) {
//                     _mapController = controller;
//                   },
//                   markers: _markers,
//                   polylines: Set<Polyline>.of(polylines.values),
//                 )
//               : Center(child: CircularProgressIndicator()),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ElevatedButton(
//                   onPressed: _openGoogleMapsDirections,
//                   child: Text('Directions'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle "Completed" button press

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => RatingsPage(
//                           detailerName:
//                               '$_detailerLocation', // Ensure detailerName is passed correctly
//                         ),
//                       ),
//                     );
//                   },
//                   child: Text('Completed'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }















// // import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   late GoogleMapController _mapController;
//   LocationData? _currentLocation;
//   Location _location = Location();
//   Set<Marker> _markers = {};
//   Set<Polyline> _polylines = {};

//   @override
//   void initState() {
//     super.initState();
//     _initializeLocation();
//   }

//   void _initializeLocation() async {
//     var serviceEnabled = await _location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _location.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }

//     var permissionGranted = await _location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await _location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     _location.onLocationChanged.listen((LocationData currentLocation) {
//       setState(() {
//         _currentLocation = currentLocation;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Maps Demo'),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: LatLng(0, 0), // Initial center position of the map
//               zoom: 15,
//             ),
//             onMapCreated: (GoogleMapController controller) {
//               _mapController = controller;
//             },
//             markers: _markers,
//             polylines: _polylines,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: ElevatedButton(
//               onPressed: () {
//                 // Handle "Completed" button press
//               },
//               child: Text('Completed'),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _moveToCurrentLocation();
//         },
//         child: Icon(Icons.my_location),
//       ),
//     );
//   }

//   void _moveToCurrentLocation() {
//     if (_currentLocation != null) {
//       _mapController.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(
//               _currentLocation!.latitude!,
//               _currentLocation!.longitude!,
//             ),
//             zoom: 15,
//           ),
//         ),
//       );
//     }
//   }
// }























// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   final Completer<GoogleMapController> _controllerGoogleMap =
//       Completer<GoogleMapController>();
//   late GoogleMapController newGoogleMapController;

//   late Position currentPosition;
//   var geoLocator = Geolocator();
//   double bottomPaddingOfMap = 0;

//   void locatePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     currentPosition = position;

//     LatLng latlanPosition = LatLng(position.latitude, position.longitude);
//     CameraPosition cameraPosition =
//         new CameraPosition(target: latlanPosition, zoom: 14);
//     newGoogleMapController
//         .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//   }

//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Main Screen"),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
//             mapType: MapType.normal,
//             myLocationButtonEnabled: true,
//             initialCameraPosition: _kGooglePlex,
//             myLocationEnabled: true,
//             zoomGesturesEnabled: true,
//             zoomControlsEnabled: true,
//             onMapCreated: (GoogleMapController controller) {
//               _controllerGoogleMap.complete(controller);
//               newGoogleMapController = controller;

//               setState(() {
//                 bottomPaddingOfMap = 500;
//               });

//               locatePosition();
//             },
//           )
//         ],
//       ),
//     );
//   }
// }


