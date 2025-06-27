import 'package:flutter/material.dart';

import '../controllers/controller.dart';

class ControllerBuilder<T> extends StatelessWidget {
  final Controller<T> controller;
  final Widget Function(BuildContext, T state) builder;

  const ControllerBuilder({
    Key? key,
    required this.controller,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: controller.stream,
      initialData: controller.currentState,
      builder: (context, snapshot) {
        return builder(context, snapshot.data ?? controller.currentState);
      },
    );
  }
}