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
  ValidationException({required super.message});
}

class StorageException extends AppException {
  StorageException({required super.message});
}

class NotFoundException extends AppException {
  NotFoundException({required super.message});
}

class ConflictException extends AppException {
  ConflictException({required super.message});
}
