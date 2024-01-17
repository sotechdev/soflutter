abstract interface class IValidator {
  IValidator({this.message});

  /// A message to return when validation fails
  final String? message;

  /// Valid a string and return null if valid else return messageError
  String? call(String? value);
}
