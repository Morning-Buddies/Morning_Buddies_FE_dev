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

  // 이메일 & 패스워드로 로그인
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

  // 로그아웃
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // 전화 번호 인증

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
          String errorMessage = 'Verification failed';

          if (e.code.isNotEmpty) {
            errorMessage += ' (code: ${e.code})';
          }

          if (e.message != null && e.message!.isNotEmpty) {
            errorMessage += ': ${e.message}';
          }

          Fluttertoast.showToast(msg: errorMessage);
          print(
              'FirebaseAuthException - code: ${e.code}, message: ${e.message}');
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

//  전화번호 회원가입 & 이메일 정보와 연결하여 FIREBASE DB POST
  Future<void> signInWithPhoneNumber(String verificationId, String smsCode,
      String email, String password, String lastName, String firstName) async {
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
        "lastname": lastName,
        "firstname": firstName
      });
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'Verification failed');
    }
  }
}
