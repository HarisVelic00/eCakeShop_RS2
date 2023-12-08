import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = "/map";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  static const LatLng _defaultLocation = LatLng(44.7654, 16.6442);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: _defaultLocation,
          zoom: 15.0,
        ),
        markers: {
          const Marker(
            markerId: MarkerId('Sanski Most'),
            position: _defaultLocation,
            infoWindow: InfoWindow(title: 'Sanski Most'),
          ),
        },
      ),
    );
  }
}
