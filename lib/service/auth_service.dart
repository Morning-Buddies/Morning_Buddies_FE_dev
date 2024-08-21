import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 현재 사용자 정보 가져오기

  User? getCurrentUser() {
    return _auth.currentUser;
  }

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

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(String verificationId, int? resendToken) codeSent,
    Function(String verificationId) codeAutoRetrievalTimeout,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolve the SMS code
        },
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(msg: e.message ?? 'Verification failed');
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 120),
      );
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: 'Error verifying phone number: $e');
    }
  }

  Future<void> signInWithPhoneNumber(String verificationId, String smsCode,
      String email, String password) async {
    try {
      PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential emailUserCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await emailUserCredential.user?.linkWithCredential(phoneCredential);
      Fluttertoast.showToast(
          msg: 'Successfully linked email and phone number!');

      await _firestore
          .collection("Users")
          .doc(emailUserCredential.user!.uid)
          .set({
        'uid': emailUserCredential.user!.uid,
        'email': email,
      });
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'Verification failed');
    }
  }
}
