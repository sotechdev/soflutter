import 'package:flutter/material.dart';

import 'async_controller.dart';
import 'async_controller_when_extension.dart';
import 'async_state.dart';

extension AsyncControllerWidgetExtension<T> on AsyncController<T> {
  Widget buildWhen({
    required Widget Function(BuildContext) initial,
    required Widget Function(BuildContext) loading,
    required Widget Function(BuildContext, T data) success,
    required Widget Function(BuildContext, Exception error, StackTrace stackTrace) error,
    required Widget Function(BuildContext) cancelled,
  }) {
    return StreamBuilder<AsyncState>(
      stream: stateStream,
      builder: (context, snapshot) {
        return when(
          initial: () => initial(context),
          loading: () => loading(context),
          success: (data) => success(context, data),
          error: (err, stack) => error(context, err, stack),
          cancelled: () => cancelled(context),
        );
      },
    );
  }
}