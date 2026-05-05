import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService(this._auth);

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Future<User?> signInAnonymously() async {
    if (_auth.currentUser != null) {
      return _auth.currentUser;
    }

    final credential = await _auth.signInAnonymously();
    return credential.user;
  }
}
