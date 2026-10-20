import 'package:flutter_test/flutter_test.dart';
import 'package:clawd_studio/main.dart';

void main() {
  testWidgets('shows honest unconnected foundation status', (tester) async {
    await tester.pumpWidget(const ClawdStudioApp());

    expect(find.text('ClawdStudio'), findsOneWidget);
    expect(find.text('Not connected'), findsOneWidget);
    expect(find.text('Not configured'), findsOneWidget);
    expect(find.text('Not selected'), findsOneWidget);
    expect(find.text('Engine setup'), findsNothing);
  });

  testWidgets('bottom navigation opens engine and settings', (tester) async {
    await tester.pumpWidget(const ClawdStudioApp());

    await tester.tap(find.text('Engine').last);
    await tester.pumpAndSettle();
    expect(find.text('Runtime verification required'), findsOneWidget);

    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    expect(find.text('AI providers'), findsOneWidget);
    expect(find.text('GitHub'), findsOneWidget);
  });
}
