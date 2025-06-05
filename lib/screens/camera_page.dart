import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  CameraController? controller;
  Future<void>? initializeControllerFuture;
  List<CameraDescription>? cameras;
  int selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeControllerFuture = initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();

      if (!mounted) return; // Check mounted early

      if (cameras == null || cameras!.isEmpty) {
        print("No cameras found");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No cameras found on this device.")),
        );
        return;
      }

      controller = CameraController(
        cameras![selectedCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      // It's better to await the initialization within this method
      // if the main purpose of initializeControllerFuture (for FutureBuilder)
      // is to know when THIS WHOLE initializeCamera() process is done.
      await controller!.initialize();

      if (!mounted) return;

      setState(() {});

    } catch (e) {
      print("Error initializing camera: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error initializing camera: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {

    if (controller == null || !controller!.value.isInitialized) { // Use 'controller'
      print('Error: camera not initialized.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera not initialized')),
        );
      }
      return;
    }

    if (controller!.value.isTakingPicture) { // Use 'controller'
      // A capture is already pending, do nothing.
      return;
    }

    try {
      final XFile imageFile = await controller!.takePicture(); // Use 'controller'

      if (!mounted) return; // context is available here
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen( // Make sure DisplayPictureScreen is defined
            imagePath: imageFile.path,
          ),
        ),
      );
    } catch (e) {
      print(e);
      if (mounted) { // context is available here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error taking picture: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Page')),
      body: FutureBuilder<void>(
        future: initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (controller != null && controller!.value.isInitialized) {
              return CameraPreview(controller!);
            } else {
              return const Center(child: Text("Camera not available or failed to initialize."));
            }
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (controller == null || !controller!.value.isInitialized) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Camera not initialized')),
            );
            return;
          }
          if (controller!.value.isTakingPicture) return;

          try {
            final XFile image = await controller!.takePicture(); // Use 'controller'
            final Directory directory = await getApplicationDocumentsDirectory();
            final String imagePath = p.join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.png');
            await image.saveTo(imagePath);

            if(!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Picture saved to $imagePath')),
            );
          } catch (e) {
            if(!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error taking picture: $e')),
            );
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}


class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}