import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
  });
  @override
  Widget build(BuildContext context) {
    print('Image path: $imagePath');

    return Scaffold(
        appBar: AppBar(title: Text('Selected Image : Captured Picture')),
        body: Center(
          child: Image.file(File(imagePath)),
        ));
  }
}
