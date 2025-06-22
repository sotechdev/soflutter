import 'package:flutter/widgets.dart';
import 'package:soflutter/src/core/provider.dart';

extension BuildContextExtensions on BuildContext {
  T get<T extends Object>() => serviceProvider<T>();
}
