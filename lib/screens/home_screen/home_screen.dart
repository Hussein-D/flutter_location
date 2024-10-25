import 'package:flutter/material.dart';
import 'package:flutter_location/models/place_location.dart';
import 'package:flutter_location/screens/add_place_screen.dart/add_place_screen.dart';
import 'package:flutter_location/widgets/place.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PlaceLocation> _places = [];

  void _addPlace() async {
    final result = await Navigator.push<PlaceLocation?>(
        context, MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()));
    if (result != null) {
      setState(() {
        _places.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: _places.isEmpty ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (_places.isEmpty) const Text("No places added yet"),
            if (_places.isNotEmpty)
              for (PlaceLocation place in _places)
                Place(
                  location: place,
                ),
            ElevatedButton(
              onPressed: _addPlace,
              child: const Text("Add Place"),
            ),
          ],
        ),
      ),
    );
  }
}
