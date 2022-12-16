import 'package:cooking_app_flutter/core/infrastructure/permissions/all_allow_permissions_manager.dart';
import 'package:test/test.dart';

void main() {
  late AllAllowPermissionsManager manager;

   setUp(() {
     manager = AllAllowPermissionsManager();
   });

  test("photos granted returns true", () async {
    final result = await manager.arePhotosPermissionsGranted;
    expect(result, true);
  });
}
