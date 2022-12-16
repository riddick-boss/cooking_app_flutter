import 'package:cooking_app_flutter/domain/infrastructure/permissions/permissions_manager.dart';
import 'package:injectable/injectable.dart';

@injectable
class AllAllowPermissionsManager implements PermissionsManager {
  @override
  Future<bool> get arePhotosPermissionsGranted async => true;
}
