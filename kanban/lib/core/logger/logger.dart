import 'package:logger/logger.dart';

export 'package:logger/src/log_level.dart' show Level;

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
late final Log logger;

void initLogger(Log log) {
  logger = log;
  logger.initializing('Logger');
}

class Log {
  final Level level;
  final bool verbose;
  late final Logger _logger;

  Log({this.level = Level.warning, this.verbose = false}) {
    _logger = Logger(
      filter: null,
      printer: !verbose ? _singleLine : null,
      output: null,
      level: level,
    );
  }

  final LogPrinter _singleLine = PrettyPrinter(
    methodCount: 0,
    printEmojis: false,
    lineLength: 80,
  );

  /// Info log => [what] initializing...
  void initializing(Object what) {
    _logger.t('$what initializing...');
  }

  /// Trace log
  void trace(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.t(message, time: time, error: error, stackTrace: stackTrace);

  /// Debug log
  void debug(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.d(message, time: time, error: error, stackTrace: stackTrace);

  /// Info log
  void info(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.i(message, time: time, error: error, stackTrace: stackTrace);

  /// Warning log
  void warning(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.w(message, time: time, error: error, stackTrace: stackTrace);

  /// Error log
  void error(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.e(message, time: time, error: error, stackTrace: stackTrace);

  /// Fatal log
  void wtf(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.f("WTF!\n\n$message\n",
          time: time, error: error, stackTrace: stackTrace);
}
