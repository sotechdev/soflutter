import 'package:flutter/material.dart';
import '../controllers/async_controller.dart';
import '../controllers/async_controller_when_extension.dart';
import '../controllers/async_state.dart';

class AsyncControllerWhenBuilder<D> extends StatelessWidget {
  final AsyncController<D> controller;
  final Widget Function() initial;
  final Widget Function() loading;
  final Widget Function(D data) success;
  final Widget Function(Exception error, StackTrace? stackTrace) error;
  final Widget Function() cancelled;

  const AsyncControllerWhenBuilder({
    Key? key,
    required this.controller,
    required this.initial,
    required this.loading,
    required this.success,
    required this.error,
    required this.cancelled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AsyncState>(
      stream: controller.stateStream,
      initialData: controller.state,
      builder: (context, snapshot) {
        return controller.when(
          initial: initial,
          loading: loading,
          success: success,
          error: error,
          cancelled: cancelled,
        );
      },
    );
  }
}