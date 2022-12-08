import 'package:cooking_app_flutter/core/infrastructure/permissions/all_allow_permissions_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/permissions/permissions_manager.dart';
import 'package:injectable/injectable.dart';

@module
abstract class PermissionsManagerModule {

  PermissionsManager get permissionsManager => AllAllowPermissionsManager();
}
