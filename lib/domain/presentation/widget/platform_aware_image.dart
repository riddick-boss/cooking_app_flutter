import 'dart:io';

import 'package:cooking_app_flutter/domain/infrastructure/url_validation/url_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformAwareImage extends StatelessWidget {
  const PlatformAwareImage({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || UrlValidator.isValid(imagePath)) {
      return Image.network(imagePath);
    } else {
      return Image.file(File(imagePath));
    }
  }
}
