class AccessorException implements Exception{
  String message;
  AccessorException(this.message);

  @override
  String toString() {
    return message;
  }
}