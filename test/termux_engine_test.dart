import 'package:clawd_studio/engine/termux_engine.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const channel = MethodChannel('clawdstudio/termux');
  final calls = <String>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call.method);
          if (call.method == 'checkStatus') {
            return <String, Object?>{
              'installed': true,
              'permissionGranted': true,
              'serviceAvailable': true,
            };
          }
          if (call.method == 'runDiagnostic') {
            return <String, Object?>{
              'ok': true,
              'stdout': 'CLAWDSTUDIO_TERMUX_OK',
              'exitCode': 0,
            };
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('checkStatus calls the native status method', () async {
    final status = await TermuxEngine.checkStatus();

    expect(calls, ['checkStatus']);
    expect(status['installed'], isTrue);
    expect(status['permissionGranted'], isTrue);
  });

  test('runDiagnostic requests only the fixed native diagnostic', () async {
    final result = await TermuxEngine.runDiagnostic();

    expect(calls, ['runDiagnostic']);
    expect(result['ok'], isTrue);
    expect(result['stdout'], 'CLAWDSTUDIO_TERMUX_OK');
  });
}
