import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EasyLoadingConfigurator {
  static TransitionBuilder config() {
    final initialization = EasyLoading.init();
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      // ..loadingStyle = EasyLoadingStyle.
      ..maskType = EasyLoadingMaskType.black
      ..dismissOnTap = false
      ..userInteractions = false;
    return initialization;
  }
}
