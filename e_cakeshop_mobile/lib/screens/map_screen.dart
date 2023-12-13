// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  static const String routeName = "/map";

  @override
  Widget build(BuildContext context) {
    LatLng restaurantLatLng =
        const LatLng(44.76676282625026, 16.660145798572916);

    Set<Marker> markers = {};

    markers.add(
      Marker(
        markerId: const MarkerId('CakeShop Location'),
        position: restaurantLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'CakeShop  Location'),
      ),
    );

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
        initialCameraPosition: CameraPosition(
          target: restaurantLatLng,
          zoom: 16.0,
        ),
        markers: markers,
      ),
    );
  }
}
