import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CachedNetworkSvg extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedNetworkSvg({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: DefaultCacheManager().getSingleFile(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ?? const Center(child: CircularProgressIndicator.adaptive(strokeWidth: 2));
        }

        if (snapshot.hasData && snapshot.data != null) {
          return SvgPicture.file(
            snapshot.data!,
            fit: fit,
          );
        }

        return errorWidget ?? const Icon(Icons.error_outline);
      },
    );
  }
}