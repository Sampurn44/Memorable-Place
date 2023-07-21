import 'package:favourite_place/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
        latitude: 23.529352, longitude: 77.822368, address: ''),
    this.iselecting = true,
  }); //,
  final PlaceLocation location;
  final bool iselecting;
  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedlocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.iselecting ? "Pick Your Location" : "Your Location"),
        actions: [
          if (widget.iselecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedlocation);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: !widget.iselecting
            ? null
            : (position) {
                setState(() {
                  _pickedlocation = position;
                });
              },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 16,
        ),
        markers: (_pickedlocation == null && widget.iselecting == true)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedlocation ??
                      LatLng(
                          widget.location.latitude, widget.location.longitude),
                ),
              },
      ),
    );
  }
}
