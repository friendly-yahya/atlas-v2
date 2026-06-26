sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);
  @override
  String toString() => message;
}

final class NetworkExecption extends AppException {
  const NetworkExecption([super.message = 'Network error. Please try again.']);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'You are not authorised to do this.']);
}

final class NotFoundException extends AppException {
  const NotFoundException(String resource) : super('$resource was not found');
}

final class DataException extends AppException {
  const DataException([super.message = 'Unexepected data. Please contact support.']);
}

final class ValidationException extends AppException {
  const ValidationException(super.message);
}

final class AuthException extends AppException {
  const AuthException(super.message);
}