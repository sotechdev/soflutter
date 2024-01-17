/// A base exception for all errors handled by SOFlutter library
class SOFlutterException extends Error {
  SOFlutterException({this.message, this.parentException});

  final String? message;
  final Object? parentException;
}
