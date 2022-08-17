import 'package:cooking_app_flutter/core/domain/infrastructure/permissions/permissions_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable
class PermissionsManagerImpl implements PermissionsManager {

  @override
  Future<bool> get arePhotosPermissionsGranted async {
    if(kIsWeb) return true;

    final permissionStatus = await Permission.photos.request();
    return permissionStatus.isGranted;
  }
}
