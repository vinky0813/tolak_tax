import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:tolak_tax/widgets/back_button.dart';
import 'package:tolak_tax/services/api_service.dart';

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

  Future<XFile?> takePicture(ApiService apiService) async {
    if (controller == null || !controller!.value.isInitialized) {
      // Use 'controller'
      print('Error: camera not initialized.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera not initialized')),
        );
      }
      return null;
    }

    if (controller!.value.isTakingPicture) {
      return null;
    }

    try {
      final XFile imageFile =
          await controller!.takePicture(); // Use 'controller'

      if (!mounted) return imageFile; // context is available here
      Navigator.pushNamed(
        context,
        '/display-picture',
        arguments: {
          'imagePath': imageFile.path,
        },
      );
      return imageFile;
    } catch (e) {
      print(e);
      if (mounted) {
        // context is available here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error taking picture: $e")),
        );
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final apiService = Provider.of<ApiService>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        FutureBuilder<void>(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (controller != null && controller!.value.isInitialized) {
                return SizedBox.expand(child: CameraPreview(controller!));
              } else {
                return const Center(
                    child:
                        Text("Camera not available or failed to initialize."));
              }
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16.0, // Adjust as needed
          left: 20.0, // Adjust as needed
          child: Container(
            width: 57,
            decoration: BoxDecoration(
              color: Colors.white, // Optional: background color for the circle
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4), // Shadow color
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset:
                      const Offset(0, 0), // changes position of shadow (x, y)
                ),
              ],
            ),
            child: BackButtonWidget(), // Your custom back button
          ),
        )
      ]),
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
            final XFile? image =
                await takePicture(apiService); // Use 'controller'
            final Directory directory =
                await getApplicationDocumentsDirectory();
            final String imagePath = p.join(
                directory.path, '${DateTime.now().millisecondsSinceEpoch}.png');
            await image!.saveTo(imagePath);

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Picture saved to $imagePath')),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error taking picture: $e')),
            );
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false,
    );
  }
}
