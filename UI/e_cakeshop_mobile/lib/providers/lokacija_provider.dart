// ignore_for_file: avoid_print
import 'package:e_cakeshop_mobile/models/lokacija.dart';
import 'package:e_cakeshop_mobile/providers/base_provider.dart';
import 'package:geocoding/geocoding.dart';

class LokacijaProvider extends BaseProvider<Lokacija> {
  LokacijaProvider() : super("Lokacija");

  @override
  Lokacija fromJson(x) {
    return Lokacija.fromJson(x);
  }

  Future<Lokacija?> insertLokacija(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        final Location firstLocation = locations.first;
        final double latitude = firstLocation.latitude;
        final double longitude = firstLocation.longitude;

        var request = {
          'naziv': address,
          'latitude': latitude,
          'longitude': longitude,
        };

        return await insert(request);
      } else {
        print('No coordinates found for the address: $address');
        return null;
      }
    } catch (e) {
      print('Error inserting location: $e');
      return null;
    }
  }
}
