import 'package:logger/logger.dart';

/// Logger that logs everything...
///
/// ```dart
/// t: "Trace log",
/// d: "Debug log",
/// i: "Info log",
/// w: "Warning log",
/// e: "Error log",
/// f: "What a fatal log",
/// ```
class Log {
  static const _verbose = false;
  static final LogPrinter _default = PrettyPrinter();
  static final LogPrinter _singleLine = PrettyPrinter(
    methodCount: 0,
    printEmojis: false,
    lineLength: 80,
  );

  static final _logger = Logger(
    filter: null,
    printer: _verbose ? _default : _singleLine,
    output: null,
    level: Level.all,
  );

  /// Info log => [what] initializing...
  static void initializing(Object what) {
    _logger.t('$what initializing...');
  }

  /// Trace log
  static void trace(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.t(message, time: time, error: error, stackTrace: stackTrace);
  }

  /// Debug log
  static void debug(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.d(message, time: time, error: error, stackTrace: stackTrace);
  }

  /// Info log
  static void info(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.i(message, time: time, error: error, stackTrace: stackTrace);
  }

  /// Warning log
  static void warning(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.w(message, time: time, error: error, stackTrace: stackTrace);

  /// Error log
  static void error(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.e(message, time: time, error: error, stackTrace: stackTrace);

  /// Fatal log
  static void wtf(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.f("WTF!\n\n$message\n",
          time: time, error: error, stackTrace: stackTrace);
}
