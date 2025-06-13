import 'package:flutter/material.dart';
import 'bottom_sheet_button.dart';

class BottomScannedFileSheet extends StatelessWidget {
  const BottomScannedFileSheet({super.key});

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
            padding: const EdgeInsets.only(top:14,left: 8),
            child: BottomSheetButton(
              text: "Choose From Gallery",
              icon: Icons.photo_album,
              onPressed: () {
                print('Choosed!');
              },
            ),
          ),
        ],
      ),
    );
  }
}
