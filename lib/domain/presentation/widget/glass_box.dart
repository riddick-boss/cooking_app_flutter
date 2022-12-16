import 'dart:ui';

import 'package:flutter/cupertino.dart';

class GlassBox extends StatelessWidget {
  const GlassBox({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Container(
      height: 60,
      padding: const EdgeInsets.all(2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      ),
    ),
  );
}
