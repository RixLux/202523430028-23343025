// login exceptions
class InvalidCredentialsAuthException implements Exception {}
class GenericAuthException implements Exception {}

// register exceptions
class WeakPasswordAuthException implements Exception {}
class EmailAlreadyInUseAuthException implements Exception {}
class InvalidEmailAuthException implements Exception {}

// generic auth exceptions
class UserNotFoundAuthException implements Exception {}
class UserNotLoggedInAuthException implements Exception {}
