import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController _controller;
  Set<Marker> _markers = {};
  LatLng? _customerLatLng;
  LatLng? _detailerLatLng;
  Polyline? _polyline;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      // Assuming you have a way to get the specific document you need
      DocumentSnapshot locationSnapshot = await FirebaseFirestore.instance
          .collection('locations')
          .doc('your_document_id') // Replace with your document ID
          .get();

      if (locationSnapshot.exists) {
        Map<String, dynamic> locationData =
            locationSnapshot.data() as Map<String, dynamic>;

        double customerLatitude = locationData['customerLatitude'];
        double customerLongitude = locationData['customerLongitude'];
        double detailerLatitude = locationData['detailerLatitude'];
        double detailerLongitude = locationData['detailerLongitude'];

        setState(() {
          _customerLatLng = LatLng(customerLatitude, customerLongitude);
          _detailerLatLng = LatLng(detailerLatitude, detailerLongitude);

          _markers.add(Marker(
            markerId: MarkerId('customerMarker'),
            position: _customerLatLng!,
            infoWindow: InfoWindow(title: 'Customer Location'),
          ));

          _markers.add(Marker(
            markerId: MarkerId('detailerMarker'),
            position: _detailerLatLng!,
            infoWindow: InfoWindow(title: 'Detailer Location'),
          ));

          _polyline = Polyline(
            polylineId: PolylineId('route'),
            points: [_customerLatLng!, _detailerLatLng!],
            color: Colors.blue,
            width: 5,
          );

          // ignore: unnecessary_null_comparison
          if (_controller != null) {
            _controller.animateCamera(
              CameraUpdate.newLatLngBounds(
                LatLngBounds(
                  southwest: LatLng(
                    customerLatitude < detailerLatitude
                        ? customerLatitude
                        : detailerLatitude,
                    customerLongitude < detailerLongitude
                        ? customerLongitude
                        : detailerLongitude,
                  ),
                  northeast: LatLng(
                    customerLatitude > detailerLatitude
                        ? customerLatitude
                        : detailerLatitude,
                    customerLongitude > detailerLongitude
                        ? customerLongitude
                        : detailerLongitude,
                  ),
                ),
                50.0, // padding
              ),
            );
          }
        });
      } else {
        print("Document does not exist.");
      }
    } catch (e) {
      print("Error fetching locations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Screen'),
      ),
      body: _customerLatLng == null || _detailerLatLng == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                if (_customerLatLng != null && _detailerLatLng != null) {
                  _controller.animateCamera(
                    CameraUpdate.newLatLngBounds(
                      LatLngBounds(
                        southwest: LatLng(
                          _customerLatLng!.latitude < _detailerLatLng!.latitude
                              ? _customerLatLng!.latitude
                              : _detailerLatLng!.latitude,
                          _customerLatLng!.longitude <
                                  _detailerLatLng!.longitude
                              ? _customerLatLng!.longitude
                              : _detailerLatLng!.longitude,
                        ),
                        northeast: LatLng(
                          _customerLatLng!.latitude > _detailerLatLng!.latitude
                              ? _customerLatLng!.latitude
                              : _detailerLatLng!.latitude,
                          _customerLatLng!.longitude >
                                  _detailerLatLng!.longitude
                              ? _customerLatLng!.longitude
                              : _detailerLatLng!.longitude,
                        ),
                      ),
                      50.0, // padding
                    ),
                  );
                }
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(0,
                    0), // This will be updated once the locations are fetched
                zoom: 12,
              ),
              markers: _markers,
              polylines:
                  _polyline != null ? Set<Polyline>.of([_polyline!]) : {},
            ),
    );
  }
}















// import 'package:flutter/material.dart';

// class LocationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Screen'),
//       ),
//       body: Center(
//         child: Text('Display locations here'),
//       ),
//     );
//   }
// }
