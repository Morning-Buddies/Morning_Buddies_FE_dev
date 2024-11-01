import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final Dio _dio = Dio();
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

  // DIO 패키지를 이용한 회원가입 요청
  // Future<void> registerUser({
  //   required String email,
  //   required String password,
  //   required String firstName,
  //   required String lastName,
  //   required String phoneNumber,
  //   required String hour,
  // }) async {
  //   String? serverUrl = dotenv.env["PROJECT_API_KEY"];
  //   if (serverUrl == null || serverUrl.isEmpty) {
  //     print("Error: PROJECT_API_KEY is not set in .env file");
  //     return;
  //   }

  //   final url = "$serverUrl/auth/join";

  //   try {
  //     final requestBody = {
  //       "email": email,
  //       "password": password,
  //       "firstName": firstName,
  //       "lastName": lastName,
  //       "preferredWakeupTime": "$hour:00", // 08 형식으로 보내야함
  //       "phoneNumber": phoneNumber,
  //     };

  //     print("Sending request to: $url");
  //     print("Request body: ${jsonEncode(requestBody)}");

  //     final response = await _dio.post(
  //       url,
  //       options: Options(
  //         headers: {"Content-Type": "application/json"},
  //         validateStatus: (status) => status! < 500,
  //       ),
  //       data: jsonEncode(requestBody),
  //     );

  //     if (response.statusCode == 200) {
  //       print('회원가입 성공: ${response.data}');
  //     } else {
  //       print('회원가입 실패: ${response.statusCode} - ${response.data}');
  //     }
  //   } on DioException catch (e) {
  //     print(e.response!.data.toString());
  //     if (e.response != null) {
  //       print('회원가입 실패: ${e.response?.statusCode} - ${e.response?.data}');
  //     } else {
  //       print('오류 발생: ${e.message}');
  //     }
  //   } catch (error) {
  //     print('오류 발생: $error');
  //   }
  // }
}
