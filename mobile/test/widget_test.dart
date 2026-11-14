import 'package:flutter_test/flutter_test.dart';
import 'package:hamwhatsapp/main.dart';

void main() {
  testWidgets('splash leads to welcome screen', (tester) async {
    await tester.pumpWidget(const HamWhatsAppApp());
    expect(find.text('HamWhatsApp'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to HamWhatsApp'), findsOneWidget);
    expect(find.text('Connect. Chat. Share.'), findsOneWidget);
  });

  testWidgets('login screen validates phone number', (tester) async {
    await tester.pumpWidget(const HamWhatsAppApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    expect(find.text('7 se 12 digits'), findsOneWidget);
  });
}
