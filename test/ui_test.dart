import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_flic/main.dart';
import 'package:proyecto_flic/pages/forgot_password_page.dart';
import 'package:proyecto_flic/pages/login_page.dart';

void main() {
  testWidgets('Navigation to ForgotPasswordPage', (WidgetTester tester) async {
    final mockNavigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(navigatorKey: mockNavigatorKey),
        routes: {
          '/forgot_password': (_) =>
              ForgotPasswordPage(navigatorKey: navigatorKey),
        },
      ),
    );

    await tester.tap(find.text("¿Olvido su contraseña?"));
    await tester.pump();

    expect(
      mockNavigatorKey.currentState?.canPop(),
      true,
      reason: 'ForgotPasswordPage should be pushed onto the navigator stack',
    );
    expect(
      find.byType(ForgotPasswordPage),
      findsOneWidget,
      reason: 'ForgotPasswordPage should be rendered',
    );
  });
}
