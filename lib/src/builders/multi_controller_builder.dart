import 'package:flutter/material.dart';
import '../controllers/async_state.dart';
import '../controllers/async_controller.dart';
import '../controllers/controller.dart';

class MultiControllerBuilder<C, A> extends StatelessWidget {
  final Controller<C> controller;
  final AsyncController<A> asyncController;
  final Widget Function(
      BuildContext context,
      C state,
      AsyncState asyncState,
      A? asyncData,
      ) builder;

  const MultiControllerBuilder({
    Key? key,
    required this.controller,
    required this.asyncController,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<C>(
      stream: controller.stream,
      initialData: controller.currentState,
      builder: (context, controllerSnapshot) {
        return StreamBuilder<AsyncState>(
          stream: asyncController.stateStream,
          initialData: asyncController.state,
          builder: (context, stateSnapshot) {
            return StreamBuilder<A?>(
              stream: asyncController.dataStream,
              builder: (context, dataSnapshot) {
                return builder(
                  context,
                  controllerSnapshot.data ?? controller.currentState,
                  stateSnapshot.data ?? asyncController.state,
                  dataSnapshot.data ?? asyncController.currentData,
                );
              },
            );
          },
        );
      },
    );
  }
}