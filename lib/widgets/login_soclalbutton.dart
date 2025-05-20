import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginSoclalbutton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const LoginSoclalbutton({
    Key? key,
    required this.assetPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          assetPath,
          height: 28,
          width: 28,
        ),
      ),
    );
  }
}
