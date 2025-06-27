import 'package:flutter/material.dart';
import '../controllers/controller.dart';

class ControllerConsumer<T> extends StatelessWidget {
  final Controller<T> controller;
  final Widget Function(BuildContext, T state, Controller<T> controller) builder;

  const ControllerConsumer({
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
        return builder(
          context,
          snapshot.data ?? controller.currentState,
          controller,
        );
      },
    );
  }
}