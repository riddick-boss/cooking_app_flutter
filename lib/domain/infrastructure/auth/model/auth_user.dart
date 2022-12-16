import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

@Freezed()
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String uid,
    required String? email,
    required String? displayName,
  }) = _AuthUser;

  const AuthUser._();
}
