import 'package:logging/logging.dart';

abstract class AppLogger {
  void verbose(Object message, {Object? error, StackTrace? stackTrace});
  void debug(Object message, {Object? error, StackTrace? stackTrace});
  void info(Object message, {Object? error, StackTrace? stackTrace});
  void warn(Object message, {Object? error, StackTrace? stackTrace});
  void error(Object message, {Object? error, StackTrace? stackTrace});
  void panic(Object message, {Object? error, StackTrace? stackTrace});
}

class _Logger implements AppLogger {
  _Logger(Type runtimeType) : _logger = Logger(runtimeType.toString());

  final Logger _logger;

  @override
  void debug(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger.fine(message, error, stackTrace);
  }

  @override
  void error(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger.severe(message, error, stackTrace);
  }

  @override
  void info(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger.info(message, error, stackTrace);
  }

  @override
  void panic(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger.shout(message, error, stackTrace);
  }

  @override
  void verbose(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger.finest(message, error, stackTrace);
  }

  @override
  void warn(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger.warning(message, error, stackTrace);
  }
}

mixin Logging {
  late final _Logger? _logger;

  AppLogger get logger => _logger ??= _Logger(runtimeType);
}
