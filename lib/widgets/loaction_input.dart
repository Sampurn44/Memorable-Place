import 'dart:convert';

import 'package:favourite_place/models/place.dart';
import 'package:favourite_place/screens/map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onselectedlocation});
  final void Function(PlaceLocation) onselectedlocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedlocation;
  var isgettinglocation = false;
  String get locationimage {
    if (_pickedlocation == null) {
      return '';
    }
    final lat = _pickedlocation!.latitude;
    final lon = _pickedlocation!.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lon=&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:L%7C$lat,$lon&key=${dotenv.env['API_KEY']}';
  }

  void _saveplace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${dotenv.env['API_KEY']}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final resddata = json.decode(response.body);
        print(resddata);

        // Check if 'results' array exists and is not empty
        if (resddata.containsKey('results') &&
            resddata['results'] is List &&
            resddata['results'].isNotEmpty) {
          final address = resddata['results'][0]['formatted_address'];

          setState(() {
            _pickedlocation = PlaceLocation(
              latitude: latitude,
              longitude: longitude,
              address: address,
            );
            isgettinglocation = false;
          });

          widget.onselectedlocation(_pickedlocation!);
        } else {
          // Handle the case where 'results' array is empty or doesn't exist
          print('Error: No results found in the geocoding response.');
          // You might want to display an error message to the user or take appropriate action.
        }
      } else {
        // Handle HTTP error (status code other than 200)
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        // You might want to display an error message to the user or take appropriate action.
      }
    } catch (error) {
      // Handle other errors (e.g., network errors)
      print('Error: $error');
      // You might want to display an error message to the user or take appropriate action.
    }
  }

  void getcurrentlocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isgettinglocation = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lon = locationData.longitude;
    if (lat == null || lon == null) {
      return;
    }
    _saveplace(lat, lon);
  }

  void Selectedonmap() async {
    final pickedloc = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );
    if (pickedloc == null) {
      return;
    }
    _saveplace(pickedloc.latitude, pickedloc.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewlocat = Text(
      "No location Chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );
    if (_pickedlocation != null) {
      previewlocat = Image.network(
        locationimage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (isgettinglocation) {
      previewlocat = CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: previewlocat),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getcurrentlocation,
              icon: const Icon(Icons.location_on_sharp),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: Selectedonmap,
              icon: const Icon(CupertinoIcons.map_pin_ellipse),
              label: const Text('Pick your location'),
            )
          ],
        )
      ],
    );
  }
}
