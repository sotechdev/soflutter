import 'package:flutter/material.dart';

/// A indicator to display when app is busy
class BusyIndicator extends StatelessWidget {
  const BusyIndicator(this.message, {Key? key, this.onCancel, this.onCancelText, this.onCancelIcon,}) : super(key: key);

  /// A busy message
  final String? message;
  final void Function()? onCancel;
  final String? onCancelText;
  final Icon? onCancelIcon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message ?? ''),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: CircularProgressIndicator(),
          ),
          if (onCancel != null) FilledButton.icon(onPressed: onCancel, icon: onCancelIcon ?? const Icon(Icons.cancel), label: Text(onCancelText ?? 'Cancel'),)
        ],
      ),
    );
  }
}
