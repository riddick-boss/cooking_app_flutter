import 'package:cooking_app_flutter/core/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/features/registration/presentation/registration_screen.dart';
import 'package:flutter/material.dart';

enum MainDrawerScreen {
  local,
  public
}

extension Title on MainDrawerScreen {
  String get title {
    switch(this) {
      case MainDrawerScreen.local:
        return AppStrings.localTitle;
      case MainDrawerScreen.public:
        return AppStrings.publicTitle;
    }
  }
}

extension Body on MainDrawerScreen {
  Widget get body { // todo: widgets
    switch(this) {
      case MainDrawerScreen.local:
        return const RegistrationScreen();
      case MainDrawerScreen.public:
        return Text(title);
    }
  }
}