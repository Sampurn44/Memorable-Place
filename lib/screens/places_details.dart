import 'package:favourite_place/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:favourite_place/models/place.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;
  String get locationimage {
    final lat = place.location.latitude;
    final lon = place.location.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lon=&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:L%7C$lat,$lon&key=AIzaSyARV2-k5JdaOXqKutgUtg2Ozr9DlUaPzkU';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MapScreen(
                            location: place.location,
                            iselecting: false,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(locationimage),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Text(
                      place.location.address,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
