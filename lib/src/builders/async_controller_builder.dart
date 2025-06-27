import 'package:flutter/material.dart';

import '../controllers/async_controller.dart';
import '../controllers/async_state.dart';

class AsyncControllerBuilder<D> extends StatelessWidget {
  final AsyncController<D> controller;
  final Widget Function(BuildContext, AsyncState state, D? data)? builder;
  final Widget? initial;
  final Widget? loading;
  final Widget? error;
  final Widget? cancelled;
  final Widget? success;

  const AsyncControllerBuilder({
    Key? key,
    required this.controller,
    this.builder,
    this.initial,
    this.loading,
    this.error,
    this.cancelled,
    this.success,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AsyncState>(
      stream: controller.stateStream,
      initialData: controller.state,
      builder: (context, stateSnapshot) {
        return StreamBuilder<D?>(
          stream: controller.dataStream,
          builder: (context, dataSnapshot) {
            final state = stateSnapshot.data ?? controller.state;
            final data = dataSnapshot.data ?? controller.currentData;

            // Se widgets específicos foram fornecidos, use-os
            switch (state) {
              case AsyncState.initial:
                if (initial != null) return initial!;
                break;
              case AsyncState.loading:
                if (loading != null) return loading!;
                break;
              case AsyncState.error:
                if (error != null) return error!;
                break;
              case AsyncState.cancelled:
                if (cancelled != null) return cancelled!;
                break;
              case AsyncState.success:
                if (success != null) return success!;
                break;
            }

            // Caso contrário, use o builder genérico se fornecido
            if (builder != null) {
              return builder!(context, state, data);
            }

            // Fallback padrão se nenhum builder ou widget específico for fornecido
            return Center(
              child: Text('State: $state | Data: ${data?.toString() ?? "null"}'),
            );
          },
        );
      },
    );
  }
}