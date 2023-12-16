// ignore_for_file: unused_element, avoid_print, library_private_types_in_public_api, avoid_init_to_null

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = "/map";
  final String? deliveryAddress;

  const MapScreen({Key? key, this.deliveryAddress}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng restaurantLatLng;
  late Set<Marker> markers;
  late String? addressPassed;
  late LatLng deliveryLatLng;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> polylines = {};
  late Timer? _timer = null;
  late LatLng vanPosition;
  late List<LatLng> vanRoute = [];

  @override
  void initState() {
    super.initState();
    restaurantLatLng = const LatLng(44.76676282625026, 16.660145798572916);
    markers = {};
    addressPassed = widget.deliveryAddress ?? "No address passed";
    _loadSharedPreferences();

    markers.add(
      Marker(
        markerId: const MarkerId('CakeShop Location'),
        position: restaurantLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'CakeShop Location'),
      ),
    );
  }

  Future<void> _loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddress = prefs.getString('delivery_address');
    if (savedAddress != null) {
      setState(() {
        addressPassed = savedAddress;
        if (widget.deliveryAddress == null) {
          getAddressCoordinates(savedAddress).then((value) {
            if (value != null) {
              setState(() {
                deliveryLatLng = value;
                markers.add(
                  Marker(
                    markerId: const MarkerId('Delivery Location'),
                    position: value,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue,
                    ),
                    infoWindow: const InfoWindow(title: 'Delivery Location'),
                  ),
                );
                generateRoute();
              });
            } else {
              print('Address conversion failed or returned null');
            }
          }).catchError((error) {
            print('Error during address conversion: $error');
          });
        }
      });
    }
  }

  Future<void> generateRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCYzY_liNCJT4JJFgfBB47lWnuOBLD_dPg',
      PointLatLng(restaurantLatLng.latitude, restaurantLatLng.longitude),
      PointLatLng(deliveryLatLng.latitude, deliveryLatLng.longitude),
      travelMode: TravelMode.driving,
    );

    List<LatLng> polylineCoordinates = [];

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    setState(() {
      polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.blue,
          width: 3,
          points: polylineCoordinates,
        )
      };
    });

    moveVan();
  }

  Future<void> _loadVanLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final double? vanLatitude = prefs.getDouble('van_latitude');
    final double? vanLongitude = prefs.getDouble('van_longitude');

    if (vanLatitude != null && vanLongitude != null) {
      setState(() {
        vanPosition = LatLng(vanLatitude, vanLongitude);
      });
      moveVan();
    }
  }

  Future<void> _saveVanLocation(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('van_latitude', latitude);
    prefs.setDouble('van_longitude', longitude);
  }

  void moveVan() {
    int counter = 0;
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (counter < polylines.first.points.length) {
        setState(() {
          vanPosition = polylines.first.points[counter];
          vanRoute.add(vanPosition);

          markers.removeWhere((marker) => marker.markerId.value == 'Van');
          markers.add(
            Marker(
              markerId: const MarkerId('Van'),
              position: vanPosition,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
              infoWindow: const InfoWindow(title: 'Moving Van'),
            ),
          );

          counter++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<LatLng?> getAddressCoordinates(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      } else {
        return null;
      }
    } catch (e) {
      print('Error converting address to coordinates: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.deliveryAddress != null)
            Center(
              child: Text(
                'Address Passed: $addressPassed',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: restaurantLatLng,
                zoom: 10.0,
              ),
              markers: markers,
              polylines: polylines,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }
}
