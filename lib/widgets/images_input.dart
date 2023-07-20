import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedimage;
  void _takepicture() async {
    final imagepicker = ImagePicker();
    final pickedimage =
        await imagepicker.pickImage(source: ImageSource.camera, maxHeight: 600);
    if (pickedimage == null) {
      return;
    }
    setState(() {
      _selectedimage = File(pickedimage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: _takepicture,
        icon: const Icon(Icons.camera_alt_outlined),
        label: const Text('Take Picture'));
    if (_selectedimage != null) {
      content = GestureDetector(
        onTap: _takepicture,
        child: Image.file(
          _selectedimage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
