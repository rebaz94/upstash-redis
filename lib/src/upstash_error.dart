class UpstashError implements Exception {
  UpstashError(this.message);

  final String message;

  @override
  String toString() {
    return 'UpstashError($message)';
  }
}

const undefined = Object();