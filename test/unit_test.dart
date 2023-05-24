import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_flic/models/user.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Arrange (preparación)
    final objeto = UserModel();

    // Act (acción)
    objeto.setName("Nombre de usuario");

    // Assert (verificación)
    expect(objeto.name, equals("Nombre de usuario"));
  });
}
