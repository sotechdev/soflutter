import 'package:soflutter/src/exceptions/soflutter_exception.dart';

/// A error caused by some access to services
class ServiceError extends SOFlutterException {
  ServiceError({String? message, Object? parentError})
      : super(message: message, parentException: parentError);
}
