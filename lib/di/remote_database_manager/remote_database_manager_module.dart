import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_app_flutter/core/infrastructure/data/database/remote/firebase/firestore_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/manager/remote_database_manager.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RemoteDatabaseManagerModule {
  @lazySingleton
  RemoteDatabaseManager getRemoteDatabase(
      AuthManager authManager,
      FirebaseFirestore firebaseFirestore,
      ) {
    return FirestoreManager(authManager, firebaseFirestore);
  }
}
