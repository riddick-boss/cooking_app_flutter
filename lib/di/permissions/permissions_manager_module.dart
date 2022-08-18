import 'package:cooking_app_flutter/core/infrastructure/permissions/permissions_manager_impl.dart';
import 'package:cooking_app_flutter/domain/infrastructure/permissions/permissions_manager.dart';
import 'package:injectable/injectable.dart';

@module
abstract class PermissionsManagerModule {

  @lazySingleton
  PermissionsManager getPermissionsManager() => PermissionsManagerImpl();
}
