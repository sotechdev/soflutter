import 'package:flutter/material.dart';
import 'package:soflutter/src/core/logging.dart';
import 'package:soflutter/src/core/provider.dart';

/// A base page with logger and controller implemented
abstract class BasePage<TWidget extends StatefulWidget,
    TController extends Object> extends State<TWidget> with Logging {
  BasePage() {
    _controller = context.get<TController>();
  }

  /// A provider to load services
  late final TController _controller;
  TController get controller => _controller;

  @override
  void initState() {
    super.initState();
    logger.verbose('Pagina iniciada: $widget');
  }
}
