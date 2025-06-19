import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';

class CachedNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: DefaultCacheManager().getSingleFile(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ??
              const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(snapshot.data!, fit: fit);
        }

        return errorWidget ?? const Icon(Icons.broken_image);
      },
    );
  }
}
