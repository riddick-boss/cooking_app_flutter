import 'package:cooking_app_flutter/core/domain/auth/model/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension Mapper on User {
  AuthUser toAuthUser() => AuthUser(email: email, displayName: displayName);
}
