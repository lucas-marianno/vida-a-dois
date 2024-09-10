import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_data_exception.dart';

// TODO: rename file auth_data_source.dart
abstract class AuthDataSource {
  final FirebaseAuth authInstance;
  AuthDataSource(this.authInstance);

  Stream<User?> get stream;

  Future<OAuthCredential?> getCredentialFromGoogleAuthProvider();

  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password);

  Future<UserCredential?> singInWithEmailAndPassword(
      String email, String password);

  Future<UserCredential> signInWithCredential(AuthCredential credential);

  Future<void> signout();
}

class AuthDataSourceImpl extends AuthDataSource {
  AuthDataSourceImpl(super.authInstance);

  @override
  Stream<User?> get stream => authInstance.authStateChanges();

  @override
  Future<OAuthCredential?> getCredentialFromGoogleAuthProvider() async {
    final gUser = await GoogleSignIn().signIn();
    if (gUser == null) return null;

    final gAuth = await gUser.authentication;

    return GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
  }

  @override
  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) return null;

    final credential = await authInstance.createUserWithEmailAndPassword(
        email: email, password: password);

    await authInstance.currentUser!.updateDisplayName(
      email.split('@')[0].replaceAll(RegExp(r'\W+'), ' '),
    );

    return credential;
  }

  @override
  Future<UserCredential?> singInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) return null;
    return await authInstance.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<UserCredential> signInWithCredential(
    AuthCredential credential,
  ) async {
    return await authInstance.signInWithCredential(credential);
  }

  @override
  Future<void> signout() async {
    return await authInstance.signOut();
  }
}
