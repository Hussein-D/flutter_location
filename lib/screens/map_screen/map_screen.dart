import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_location/models/place_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({this.isSelecting = false, this.location, super.key});
  final PlaceLocation? location;
  final bool isSelecting;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Marker? _marker;
  @override
  void initState() {
    if (widget.location != null) {
      _marker = Marker(
          markerId: const MarkerId("m1"),
          position:
              widget.location?.position ?? const LatLng(37.422, -122.084));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (_marker != null && widget.isSelecting) {
            Navigator.pop(context, _marker);
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: widget.isSelecting
                ? const Text("Choose Location")
                : const Text("Your Location"),
          ),
          body: GoogleMap(
            onTap: (position) {
              log("position : ${position.latitude} ${position.longitude}}");
              setState(() {
                _marker = Marker(
                    markerId: const MarkerId("m1"),
                    position: LatLng(position.latitude, position.longitude));
              });
            },
            initialCameraPosition: CameraPosition(
                target:
                    widget.location?.position ?? const LatLng(37.422, -122.084),
                zoom: 16),
            markers: _marker != null ? {_marker!} : {},
          ),
        ),
      );
}
