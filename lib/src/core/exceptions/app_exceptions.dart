abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  const NetworkException(super.message);

  @override
  String toString() => 'NetworkException: $message';
}

class DataException extends AppException {
  const DataException(super.message);

  @override
  String toString() => 'DataException: $message';
}

class CacheException extends AppException {
  const CacheException(super.message);

  @override
  String toString() => 'CacheException: $message';
}

class ValidationException extends AppException {
  const ValidationException(super.message);

  @override
  String toString() => 'ValidationException: $message';
}

class ServerException extends AppException {
  const ServerException(super.message);

  @override
  String toString() => 'ServerException: $message';
}

class UnknownException extends AppException {
  const UnknownException(super.message);

  @override
  String toString() => 'UnknownException: $message';
}
