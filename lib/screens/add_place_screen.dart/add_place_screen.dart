import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_location/models/place_location.dart';
import 'package:flutter_location/screens/map_screen/map_screen.dart';
import 'package:flutter_location/utils/location_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});
  @override
  State<AddPlaceScreen> createState() => _AddPaceScreenState();
}

class _AddPaceScreenState extends State<AddPlaceScreen> {
  final TextEditingController _nameController = TextEditingController();
  LocationData? _currentLocation;
  Marker? _chosenMarker;
  String? _image;
  Future<void> _getCurrentLocation() async {
    final currentLocation = await LocationHandler.getCurrentLocation();
    if (currentLocation != null) {
      setState(() {
        _chosenMarker = null;
        _currentLocation = currentLocation;
        _image =
            "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation?.latitude},${_currentLocation?.longitude}&zoom=20&size=400x400&key=AIzaSyBbUf0tQuV_BOsniJOI-tK0YhlAAgoWQXA";
      });
    }
  }

  Future<void> _chooseLocation() async {
    final result = await Navigator.push<Marker?>(
        context,
        MaterialPageRoute(
            builder: (ctx) => const MapScreen(
                  isSelecting: true,
                )));
    if (result != null) {
      setState(() {
        _currentLocation = null;
        _chosenMarker = result;
        _image =
            "https://maps.googleapis.com/maps/api/staticmap?center=${result.position.latitude},${result.position.longitude}&zoom=20&size=400x400&key=AIzaSyBbUf0tQuV_BOsniJOI-tK0YhlAAgoWQXA";
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (_nameController.text.isNotEmpty &&
              (_currentLocation != null || _chosenMarker != null)) {
            Navigator.pop(
                context,
                PlaceLocation(
                    title: _nameController.text,
                    position: _currentLocation != null
                        ? LatLng(_currentLocation!.latitude ?? 0,
                            _currentLocation?.longitude ?? 0)
                        : LatLng(_chosenMarker?.position.latitude ?? 0,
                            _chosenMarker?.position.longitude ?? 0)));
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Add Place"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8),
                        hintText: "Name of your place"),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (_image != null) {
                      final result = await Navigator.push<Marker?>(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => MapScreen(
                                    isSelecting: true,
                                    location: PlaceLocation(
                                        title: "Choose Location",
                                        position: _currentLocation != null
                                            ? LatLng(
                                                _currentLocation!.latitude ?? 0,
                                                _currentLocation?.longitude ??
                                                    0)
                                            : LatLng(
                                                _chosenMarker
                                                        ?.position.latitude ??
                                                    0,
                                                _chosenMarker
                                                        ?.position.longitude ??
                                                    0)),
                                  )));
                      if (result != null) {
                        setState(() {
                          _currentLocation = null;
                          _chosenMarker = result;
                          _image =
                              "https://maps.googleapis.com/maps/api/staticmap?center=${result.position.latitude},${result.position.longitude}&zoom=20&size=400x400&key=AIzaSyBbUf0tQuV_BOsniJOI-tK0YhlAAgoWQXA";
                        });
                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 400,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(border: Border.all()),
                    child: Image.network(
                      _image ?? "",
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.location_on),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                        icon: _currentLocation != null
                            ? const Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : const SizedBox(),
                        onPressed: _getCurrentLocation,
                        label: const Text("Get Current Location")),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton.icon(
                        icon: _chosenMarker != null
                            ? const Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : const SizedBox(),
                        onPressed: _chooseLocation,
                        label: const Text("Choose Location")),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
