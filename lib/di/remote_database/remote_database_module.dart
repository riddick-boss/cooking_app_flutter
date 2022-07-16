import 'package:cooking_app_flutter/core/domain/data/database/remote/remote_database.dart';

import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/firebase_remote_database.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RemoteDatabaseModule {
  @lazySingleton
  RemoteDatabase getRemoteDatabase() => FirebaseRemoteDatabase();
}
