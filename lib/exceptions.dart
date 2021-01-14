class NoAuthException implements Exception {
  String errMsg() => 'user need login before continue';
}

class NotFoundTopicException implements Exception {
  String errMsg() => 'not found topic';
}
