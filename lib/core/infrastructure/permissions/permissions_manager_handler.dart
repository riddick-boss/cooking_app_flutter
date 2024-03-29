import 'package:cooking_app_flutter/domain/infrastructure/permissions/permissions_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable
class PermissionsManagerHandler implements PermissionsManager {

  @override
  Future<bool> get arePhotosPermissionsGranted async {
    if(kIsWeb) return true;

    final permissionStatus = await Permission.photos.request();
    return permissionStatus.isGranted;
  }
}
