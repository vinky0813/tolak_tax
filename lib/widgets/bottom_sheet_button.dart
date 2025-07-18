import 'package:flutter/material.dart';

class BottomSheetButton extends StatelessWidget{
  final String text;
  final IconData icon;

  final VoidCallback? onPressed;

  const BottomSheetButton({super.key, required this.text, this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(icon, color: colorScheme.primary)),
            ),
            Align(
                alignment:Alignment.center,
                child:Text(text))
          ],
        ),
      ),
    );
  }

}