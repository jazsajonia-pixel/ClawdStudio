import 'package:flutter/services.dart';

/// Narrow bridge for Termux setup and a fixed, non-destructive diagnostic.
///
/// This API deliberately does not accept shell commands from callers.
class TermuxEngine {
  TermuxEngine._();

  static const MethodChannel _channel = MethodChannel('clawdstudio/termux');

  static Future<Map<String, Object?>> checkStatus() async {
    final result = await _channel.invokeMapMethod<String, Object?>(
      'checkStatus',
    );
    return result ?? const <String, Object?>{};
  }

  static Future<Map<String, Object?>> runDiagnostic() async {
    final result = await _channel.invokeMapMethod<String, Object?>(
      'runDiagnostic',
    );
    return result ?? const <String, Object?>{};
  }
}
