import 'dart:io';

import 'package:cooking_app_flutter/domain/infrastructure/url_validation/url_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformAwareImage extends StatelessWidget {
  const PlatformAwareImage({super.key, required this.imagePath, this.height, this.width, this.fit});

  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || UrlValidator.isValid(imagePath)) {
      return Image.network(
        imagePath,
        height: height,
        width: width,
        fit: fit,
      );
    } else {
      return Image.file(
        File(imagePath),
        height: height,
        width: width,
        fit: fit,
      );
    }
  }
}
