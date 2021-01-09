class NoAuthException implements Exception {
  String errMsg() => 'user need login before continue';
}
