import 'package:favourite_place/models/place.dart';
import 'package:favourite_place/providers/user_places.dart';
import 'package:favourite_place/widgets/images_input.dart';
import 'package:favourite_place/widgets/loaction_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class AddPlacesScreen extends ConsumerStatefulWidget {
  const AddPlacesScreen({super.key});

  @override
  ConsumerState<AddPlacesScreen> createState() {
    return _AddPlacesScreenState();
  }
}

class _AddPlacesScreenState extends ConsumerState<AddPlacesScreen> {
  final _titleController = TextEditingController();
  File? selectedImage;
  PlaceLocation? selectedLocation;
  void _saveplace() {
    final enteredText = _titleController.text;

    if (enteredText.isEmpty ||
        selectedImage == null ||
        selectedLocation == null) {
      return;
    }
    ref
        .read(userPlacesProvider.notifier)
        .addplace(enteredText, selectedImage!, selectedLocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add new places",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                label: Text("Title"),
              ),
              controller: _titleController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            //
            const SizedBox(
              height: 16,
            ),
            ImageInput(onPickImage: (image) {
              selectedImage = image;
            }),
            const SizedBox(
              height: 16,
            ),
            LocationInput(
              onselectedlocation: (location) {
                selectedLocation = location;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: _saveplace,
              label: const Text('Add Places'),
            ),
          ],
        ),
      ),
    );
  }
}
