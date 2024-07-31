import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_data_exception.dart';

class AuthData {
  static final _auth = FirebaseAuth.instance;

  static Stream<User?> listenToChanges() => _auth.authStateChanges();

  static Future<OAuthCredential?> getCredentialFromGoogleAuthProvider() async {
    final gUser = await GoogleSignIn().signIn();
    if (gUser == null) return null;

    final gAuth = await gUser.authentication;

    return GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
  }

  static Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) return null;

    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential?> singInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) return null;
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<UserCredential> signInWithCredential(
    AuthCredential credential,
  ) async {
    return await _auth.signInWithCredential(credential);
  }

  static Future<void> signout() async {
    return await _auth.signOut();
  }
}
