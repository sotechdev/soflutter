import 'package:flutter_test/flutter_test.dart';
import 'package:soflutter/soflutter.dart';

void main() {
  test('Email must be invalid', () {
    const message = 'Invalid email';
    final emailValidator = EmailValidator(message: message);
    final invalidEmail = emailValidator.call('test');
    expect(invalidEmail, message);
  });

  test('Email must be valid', () {
    const message = 'Invalid email';
    final emailValidator = EmailValidator(message: message);
    final invalidEmail = emailValidator.call('test@email.com');
    expect(invalidEmail, null);
  });

  test('Must be required', () {
    const message = 'Cannot be null';
    final validator = RequiredValidator(message: message);
    final required = validator.call('test');
    expect(required, null);
  });

  test('Must be optional', () {
    const message = 'Cannot be null';
    final validator = RequiredValidator(message: message);
    final emptyStr = validator.call('');
    expect(emptyStr, message);

    final nullStr = validator.call(null);
    expect(nullStr, message);
  });
}
