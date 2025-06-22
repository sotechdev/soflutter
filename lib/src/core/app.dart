import 'package:flutter/material.dart';

class AppBase extends StatelessWidget {
  const AppBase({
    super.key,
    required this.child,
    this.debugMode = true,
    this.notAllowedParentBinds = false,
  });

  final Widget child;
  final bool debugMode;
  final bool notAllowedParentBinds;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
