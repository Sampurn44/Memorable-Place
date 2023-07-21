import 'dart:io';
import 'package:favourite_place/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addplace(String title, File image, PlaceLocation location) {
    final newplace = Place(title: title, image: image, location: location);
    state = [newplace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
