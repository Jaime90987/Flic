// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:proyecto_flic/pages/home_page.dart';
// import 'package:proyecto_flic/pages/login_page.dart';
// import 'package:proyecto_flic/pages/register_page.dart';
// import 'package:proyecto_flic/pages/widgets/common/footer.dart';
// import 'package:proyecto_flic/values/strings.dart';

// void main() {
//   testWidgets('Test de navegación a otra página', (WidgetTester tester) async {
//     // Construir el widget raíz de la aplicación
//     await tester.pumpWidget(const LoginPage());

//     // Encontrar y tocar el botón que realiza la navegación
//     final emailField = find.byKey(const Key('email'));
//     final passwordField = find.byKey(const Key('password'));
//     final button = find.byKey(const Key('button'));

//     // key: const Key("registro"),

//     expect(emailField, findsOneWidget);
//     expect(passwordField, findsOneWidget);
//     expect(button, findsOneWidget);

//     await tester.enterText(
//         emailField, "jaime.jaramillop@uniagustiniana.edu.co");

//     await tester.enterText(passwordField, "123456");

//     await tester.tap(button);
//     await tester.pumpAndSettle();

//     await tester.pumpWidget(
//       const MaterialApp(
//         home: LoginPage(),
//       ),
//     );

//     // Verificar que se ha navegado a la segunda página
//     expect(find.byType(HomePage), findsOneWidget);
//   });

//   testWidgets('Test del Footer', (WidgetTester tester) async {
//     await tester.pumpWidget(const MaterialApp(
//       home: LoginPage(),
//     ));

//     // Buscar el widget Footer dentro de la página LoginPage
//     final footerFinder = find.descendant(
//       of: find.byType(LoginPage),
//       matching: find.byType(Footer),
//     );

//     expect(footerFinder, findsOneWidget);

//     // Simular el toque en el mensaje 2 dentro del widget Footer
//     await tester.tap(find.text(AppStrings.registerHere));
//     await tester.pumpAndSettle();

//     // Verificar que se ha navegado a la página RegisterPage
//     expect(find.byType(RegisterPage), findsOneWidget);
//   });
// }
