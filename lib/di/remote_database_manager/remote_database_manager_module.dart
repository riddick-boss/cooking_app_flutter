import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/firestore_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/manager/remote_database_manager.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RemoteDatabaseManagerModule {
  @lazySingleton
  RemoteDatabaseManager getRemoteDatabase() => FirestoreManager();
}
