import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformAwareImage extends StatelessWidget {
  const PlatformAwareImage({super.key, required this.imagePath});

  final String imagePath;

  // Image _image() { // TODO: there must be better way to do it
  //   try {
  //     return Image.network(imagePath);
  // } catch(e) {
  //     return Image.file(File(imagePath));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if(kIsWeb) {
      return Image.network(imagePath);
    } else {
      return Image.file(File(imagePath));
    }
  }
}
