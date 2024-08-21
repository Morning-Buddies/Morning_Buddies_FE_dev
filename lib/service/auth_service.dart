import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Wrong password provided.');
        default:
          throw Exception('An error occurred. Please try again.');
      }
    }
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
