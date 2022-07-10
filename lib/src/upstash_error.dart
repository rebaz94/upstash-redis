class UpstashError implements Exception {
  UpstashError(this.message);

  final String message;

  @override
  String toString() {
    return 'UpstashError($message)';
  }
}

class UpstashDecodingError implements Exception {
  UpstashDecodingError(
    this.message,
    this.error,
    this.trace,
  );

  final String message;
  final dynamic error;
  final StackTrace? trace;

  @override
  String toString() {
    return 'UpstashDecodingError($message, error: $error, trace: $trace)';
  }
}
