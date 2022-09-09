import 'package:cooking_app_flutter/domain/infrastructure/auth/model/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension Mapper on User {
  AuthUser toAuthUser() => AuthUser(uid: uid, email: email, displayName: displayName);
}
