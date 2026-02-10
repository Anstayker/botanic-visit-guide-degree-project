class UnknownException implements Exception {
  final String message;

  UnknownException([this.message = 'An unknown error occurred.']);

  @override
  String toString() => 'UnknownException: $message';
}
