import 'validator.dart';

/// A email validator to validate forms
final class EmailValidator implements IValidator {
  EmailValidator({this.message});
  @override
  String? call(String? value) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value == null || !regex.hasMatch(value)) {
      return message ?? 'E-mail inválido';
    }
    return null;
  }

  @override
  final String? message;
}
