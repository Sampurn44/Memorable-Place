import 'package:favourite_place/providers/user_places.dart';
import 'package:favourite_place/screens/add_places.dart';
import 'package:favourite_place/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userplaces = ref.watch(userPlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) => const AddPlacesScreen()),
                  ),
                );
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: PlacesList(
        places: userplaces,
      ),
    );
  }
}
