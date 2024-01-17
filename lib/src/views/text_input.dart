import 'package:flutter/material.dart';

import '../validators/validator.dart';

/// A text input inspired in NET MAUI
class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    required this.controller,
    required this.label,
    this.textAlign = TextAlign.start,
    this.suffixIcon,
    this.obscureText = false,
    this.validators = const [],
    this.onChanged,
    this.padding = EdgeInsets.zero,
    this.border,
    this.borderRadius,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final TextAlign textAlign;
  final Widget? suffixIcon;
  final bool obscureText;
  final Function(String)? onChanged;
  final List<IValidator> validators;
  final EdgeInsetsGeometry padding;
  final Radius? borderRadius;
  final InputBorder? border;

  String? validate(String? value) {
    for (var validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validate,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffixIcon,
          border: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  borderRadius ?? const Radius.circular(0),
                ),
              ),
        ),
        textAlign: textAlign,
      ),
    );
  }
}
