import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_flic/models/user.dart';

void main() {
  testWidgets('UserModel Methods', (WidgetTester tester) async {
    final objeto = UserModel();

    objeto.setUid("F8TQMb9FyPRcYyePtpCBSjV6fBL2");
    objeto.setUsername("JohnDoe_01");
    objeto.setName("John Doe");
    objeto.setEmail("jonhdoe@gmail.com");
    objeto.setBio("Hello, I am John Doe, a software developer");
    objeto.setSignInMethod("google");
    objeto.setPostsNumber(2);

    expect(objeto.uid, equals("F8TQMb9FyPRcYyePtpCBSjV6fBL2"));
    expect(objeto.username, equals("JohnDoe_01"));
    expect(objeto.name, equals("John Doe"));
    expect(objeto.email, equals("jonhdoe@gmail.com"));
    expect(objeto.bio, equals("Hello, I am John Doe, a software developer"));
    expect(objeto.signInMethod, equals("google"));
    expect(objeto.postsNumber, equals(2));
  });
}
