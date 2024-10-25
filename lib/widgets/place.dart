import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_location/models/place_location.dart';
import 'package:flutter_location/screens/map_screen/map_screen.dart';
import 'package:http/http.dart' as http;

class Place extends StatelessWidget {
  const Place({required this.location, super.key});
  final PlaceLocation location;

  Future<String> _getAddress() async {
    final Uri url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.position.latitude},${location.position.longitude}&key=AIzaSyBbUf0tQuV_BOsniJOI-tK0YhlAAgoWQXA");
    final address = await http.get(url);
    log("address : ${jsonDecode(address.body)}");
    return jsonDecode(address.body)["results"][0]["formatted_address"];
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(location.title),
      subtitle: FutureBuilder<String>(
          future: _getAddress(),
          initialData: "",
          builder: (context, snapshot) {
            return Text(snapshot.data ?? "");
          }),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => MapScreen(
                      location: location,
                    )));
      },
    );
  }
}
