import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamwhatsapp/main.dart';

Future<void> _toPhoneScreen(WidgetTester tester) async {
  await tester.pumpWidget(const HamWhatsAppApp());
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Agree and continue'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('splash leads to welcome screen', (tester) async {
    await tester.pumpWidget(const HamWhatsAppApp());
    expect(find.text('HamWhatsApp'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to HamWhatsApp'), findsOneWidget);
    expect(find.text('Connect. Chat. Share.'), findsOneWidget);
  });

  testWidgets('phone screen enables Next only for a valid number',
      (tester) async {
    await _toPhoneScreen(tester);
    expect(find.text('Enter your phone number'), findsOneWidget);

    FilledButton button() =>
        tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button().onPressed, isNull);

    await tester.enterText(find.byType(TextField), '3327159336');
    await tester.pump();
    expect(button().onPressed, isNotNull);
  });
}
