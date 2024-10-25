import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceLocation {
  const PlaceLocation(
      {required this.title, required this.position, this.address, this.image});
  final String title;
  final String? image;
  final String? address;
  final LatLng position;
}
