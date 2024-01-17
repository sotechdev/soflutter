import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:soflutter/soflutter.dart';

/// A base page with logger and controller implemented
abstract class Page<TWidget extends StatefulWidget, TController extends Object>
    extends State<TWidget> {
  Page({this.serviceProvider}) {
    _controller = SOFlutter.get<TController>(serviceProvider: serviceProvider);
  }

  /// A provider to load services
  TController Function<TController>()? serviceProvider;
  late TController _controller;
  TController get controller => _controller;

  final Logger _logger = Logger();
  Logger get logger => _logger;

  @override
  void initState() {
    super.initState();
    logger.d('Pagina iniciada: $widget');
  }
}
