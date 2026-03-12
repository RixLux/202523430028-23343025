//auth_service.dart

import 'auth/auth_provider.dart';
import 'auth/auth_user.dart';
import 'auth/firebase_auth_provider.dart';

export 'auth/auth_user.dart';
export 'auth/auth_exceptions.dart';
export 'auth/auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService._(this.provider);

  static late final AuthService _shared = AuthService._(FirebaseAuthProvider());
  factory AuthService() => _shared;

  @override
  Future<void> initialize() => provider.initialize();

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> reloadUser() => provider.reloadUser();
}
