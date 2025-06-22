import 'package:flutter/material.dart';
import 'bottom_sheet_button.dart';
import 'package:image_picker/image_picker.dart';

class BottomScannedFileSheet extends StatelessWidget {
  const BottomScannedFileSheet({super.key});

  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Compress image to 85% quality
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        // Close the bottom sheet first
        Navigator.pop(context);

        // Navigate to camera page with the selected image
        Navigator.pushNamed(
          context,
          '/display-picture',
          arguments: {
            'imagePath': pickedFile.path,
          },
        );
      }
    } catch (e) {
      // Handle any errors
      print('Failed to pick image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: BottomSheetButton(
                text: "Take Photo",
                icon: Icons.camera_enhance,
                onPressed: () {
                  Navigator.pushNamed(context, '/camera');
                },
              )),
          Divider(
            color: Colors.grey[600], // Color of the line
            thickness: 1, // Thickness of the line
            height:
                20, // Total height of the Divider widget (includes space above/below)
            indent: 30, // Space to the left of the line
            endIndent: 30, // Space to the right of the line
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14, left: 8),
            child: BottomSheetButton(
              text: "Choose From Gallery",
              icon: Icons.photo_album,
              onPressed: () => pickImageFromGallery(context),
            ),
          ),
        ],
      ),
    );
  }
}
