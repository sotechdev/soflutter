import 'package:flutter/material.dart';

/// A indicator to display when app is busy
class BusyIndicator extends StatelessWidget {
  const BusyIndicator(this.message, {Key? key}) : super(key: key);

  /// A busy message
  final String? message;

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
        ],
      ),
    );
  }
}
