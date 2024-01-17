import 'validator.dart';

/// A validator to validate required fields in TextInput
final class RequiredValidator implements IValidator {
  RequiredValidator({this.message});

  @override
  final String? message;

  @override
  String? call(String? value) {
    if (value == null || value.isEmpty) {
      return message ?? 'Required field';
    }
    return null;
  }
}
