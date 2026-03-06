sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(Exception error) failure,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      Failure(:final error) => failure(error),
    };
  }

  T getOrNull() {
    return switch (this) {
      Success(:final data) => data,
      Failure() => null as T,
    };
  }

  T getOrThrow() {
    return switch (this) {
      Success(:final data) => data,
      Failure(:final error) => throw error,
    };
  }
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success($data)';
}

class Failure<T> extends Result<T> {
  final Exception error;

  const Failure(this.error);

  @override
  String toString() => 'Failure($error)';
}
