import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:sellers/maps/config_maps.dart';
import 'package:sellers/screens/rating_screen.dart';
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
      googleApiKey: googleMapsApiKey,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingsPage(
                          detailerName: '',
                        ),
                      ),
                    );
                    // Handle "Completed" button press
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


























// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:location/location.dart';
// import 'package:sellers/maps/config_maps.dart';

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
//     if (serviceEnabled) {
//       serviceEnabled = await locationController.requestService();
//     } else {
//       return;
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
//       googleApiKey: googleMapsApiKey,
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
//             child: ElevatedButton(
//               onPressed: () {
//                 // Handle "Completed" button press
//               },
//               child: Text('Completed'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
















// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // ignore: unused_import
// import 'package:sellers/maps/config_maps.dart';

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

//   Map<PolylineId, Polyline> polylines = {};

//   @override
//   void initState() {
//     super.initState();
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
//     });
//   }

//   Future<List<LatLng>> fetchPolylinePoints() async {
//     final polylinePoints = PolylinePoints();

//     // ignore: unused_local_variable
//     final result = await polylinePoints.getRouteBetweenCoordinates(
//       request: PolylineRequest(
//           origin: PointLatLng(
//               _customerLocation!.latitude, _customerLocation!.longitude),
//           destination: PointLatLng(
//               _detailerLocation!.latitude, _detailerLocation!.longitude),
//           mode: TravelMode.driving),
//     );
//     if (result.points.isEmpty) {
//       return result.points
//           .map((point) => LatLng(point.latitude, point.longitude))
//           .toList();
//     } else {
//       debugPrint(result.errorMessage);
//       return [];
//     }
//   }

//   Future<void> generatePolyLineFromPoints(
//       List<LatLng> polylineCoordinates) async {
//     const id = PolylineId('polyline');

//     final polyline = Polyline(
//         polylineId: id,
//         color: Colors.blueAccent,
//         points: polylineCoordinates,
//         width: 5);

//     setState(() => polylines[id] = polyline);
//   }

//   Future<void> initializeMap() async {
//     // await fetchPolylinePoints();
    
//     final coordinates = await fetchPolylinePoints();
//     generatePolyLineFromPoints(coordinates);
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
//             child: ElevatedButton(
//               onPressed: () {
//                 // Handle "Completed" button press
//               },
//               child: Text('Completed'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }















//  import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

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
//   Set<Polyline> _polylines = {};

//   @override
//   void initState() {
//     super.initState();
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

//       _getPolyline();
//     });
//   }

//   void _getPolyline() async {
//     if (_customerLocation == null || _detailerLocation == null) return;

//     String apiKey = 'AIzaSyAOVYRIgupAurZup5y1PRh8Ismb1A3lLao';
//     String url =
//         'https://maps.googleapis.com/maps/api/directions/json?origin=${_detailerLocation!.latitude},${_detailerLocation!.longitude}&destination=${_customerLocation!.latitude},${_customerLocation!.longitude}&key=$apiKey';

//     var response = await http.get(Uri.parse(url));
//     var data = jsonDecode(response.body);

//     if (data['status'] == 'OK') {
//       var points = data['routes'][0]['overview_polyline']['points'];
//       var polylinePoints = _decodePolyline(points);

//       setState(() {
//         _polylines = {
//           Polyline(
//             polylineId: PolylineId('route'),
//             points: polylinePoints,
//             color: Colors.blue,
//             width: 5,
//           ),
//         };
//       });
//     }
//   }

//   List<LatLng> _decodePolyline(String polyline) {
//     List<LatLng> points = [];
//     int index = 0, len = polyline.length;
//     int lat = 0, lng = 0;

//     while (index < len) {
//       int b, shift = 0, result = 0;
//       do {
//         b = polyline.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//       lat += dlat;

//       shift = 0;
//       result = 0;
//       do {
//         b = polyline.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//       lng += dlng;

//       points.add(LatLng(lat / 1E5, lng / 1E5));
//     }

//     return points;
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
//                   polylines: _polylines,
//                 )
//               : Center(child: CircularProgressIndicator()),
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
//     );
//   }
// }













// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:sellers/maps/config_maps.dart';

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
//     });
//   }

//   List<LatLng> polylineCoordinates = [];

//   void getPolyPoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey: mapKey,
//       PointLatLng(_customerLocation!.latitude, _customerLocation.longitude),
//       PointLatLng(_detailerLocation.latitude, _detailerLocation.longitude), 
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach(
//         (PointLatLng point) => polylineCoordinates.add(
//           LatLng(point.latitude, point.longitude),
//         ),
//       );
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     getPolyPoints();
//     super.initState();
//     _fetchLocations();
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
//                   polylines: {
//                     Polyline(
//                         polylineId: polylineId("route"),
//                         points: polylineCoordinates)
//                   },
//                   markers: _markers,
//                 )
//               : Center(child: CircularProgressIndicator()),
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
//     );
//   }
// }


























// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

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
//   Set<Polyline> _polylines = {};

//   @override
//   void initState() {
//     super.initState();
//     _fetchLocations();
//   }

//   void _fetchLocations() async {
//     // Assuming you have the document ID or some way to fetch the specific locations
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

//       _polylines = {
//         Polyline(
//           polylineId: PolylineId('route'),
//           points: [_customerLocation!, _detailerLocation!],
//           color: Colors.blue,
//           width: 5,
//         ),
//       };
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
//                   polylines: _polylines,
//                 )
//               : Center(child: CircularProgressIndicator()),
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

















//import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   late GoogleMapController _mapController;
//   LatLng? _customerLocation;
//   LatLng? _detailerLocation;
//   Set<Marker> _markers = {};
//   Set<Polyline> _polylines = {};

//   @override
//   void initState() {
//     super.initState();
//     _fetchLocations();
//   }

//   void _fetchLocations() async {
//     // Assuming you have the document ID or some way to fetch the specific locations
//     var snapshot = await FirebaseFirestore.instance
//         .collection('locations')
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .get();
//     var data = snapshot.docs.first.data();

//     setState(() {
//       _customerLocation = LatLng(data['customerLatitude'], data['customerLongitude']);
//       _detailerLocation = LatLng(data['detailerLatitude'], data['detailerLongitude']);
      
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

//       _polylines = {
//         Polyline(
//           polylineId: PolylineId('route'),
//           points: [_customerLocation!, _detailerLocation!],
//           color: Colors.blue,
//           width: 5,
//         ),
//       };
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
//                   polylines: _polylines,
//                 )
//               : Center(child: CircularProgressIndicator()),
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
//     );
//   }
// }
