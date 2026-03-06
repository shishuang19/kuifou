class AppException implements Exception {
  final String message;
  final String? code;

  AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AppException: $message';
}

class ValidationException extends AppException {
  ValidationException({required String message}) : super(message: message);
}

class StorageException extends AppException {
  StorageException({required String message}) : super(message: message);
}

class NotFoundException extends AppException {
  NotFoundException({required String message}) : super(message: message);
}

class ConflictException extends AppException {
  ConflictException({required String message}) : super(message: message);
}
