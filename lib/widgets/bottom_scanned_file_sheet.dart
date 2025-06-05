import 'package:flutter/material.dart';

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
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/camera');
                },
                child: Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 45),
                        child: Align(
                          alignment: Alignment.centerLeft,
                         child: Icon(Icons.camera)),
                      ),
                      Align(
                        alignment:Alignment.center,
                          child: const Text('Take Photo'))
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey[600], // Color of the line
              thickness: 1,         // Thickness of the line
              height: 20,           // Total height of the Divider widget (includes space above/below)
              indent: 30,           // Space to the left of the line
              endIndent: 30,        // Space to the right of the line
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 45),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.photo_album)),
                    ),
                    Align(
                        alignment:Alignment.center,
                        child: const Text('Choose From Gallery'))
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}