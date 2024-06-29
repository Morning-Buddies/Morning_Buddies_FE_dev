// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morning_buddies/screens/home_bottom_nav.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/widgets/custom_form_field.dart';
import 'package:morning_buddies/widgets/custom_outlined_button.dart';
import 'package:morning_buddies/widgets/signup_dropdown.dart';
import 'dart:async';

class SignUpForm extends StatefulWidget {
  final Function(int) onProgressChanged;

  const SignUpForm({
    super.key,
    required this.onProgressChanged,
  });

  @override
  State<SignUpForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
  };
  bool _isPasswordCompliant(String password,
      [int minLength = 8, int maxLength = 20]) {
    if (password.isEmpty) {
      return false;
    }
    bool hasProperLength =
        password.length >= minLength && password.length <= maxLength;
    bool hasNumber = password.contains(RegExp(r'\d'));
    bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasSpecialCase = password.contains(RegExp(r'[!@#\$%^&]'));

    return hasProperLength && hasNumber && hasLetter && hasSpecialCase;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '빈칸을 채워주세요';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '이메일 형식을 지켜주세요';
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return '이메일 형식을 지켜주세요';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (!_isPasswordCompliant(value!)) {
      return '문자+숫자+특수문자 조합 8자 이상 20자 미만으로 구성해주세요';
    }
    return null;
  }

  String? _comfirmPassword(String? value) {
    if (value != _controllers['password']!.text) {
      return '동일한 비밀번호를 입력해주세요';
    }
    return null;
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _smsController.dispose();
    _timer?.cancel();

    super.dispose();
  }

  //  Timer
  Timer? _timer;
  int _remainingSeconds = 120;

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}'; // 분:초 형식으로 변환
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel(); // 타이머 종료
        }
      });
    });
  }

  // Statusbar 계산의 기준이 되는 리스트
  // textcontroller가 생기면 해당하는 인풋 필드가 리스트에 삽입되는 원리
  final List<String> _visibleFields = ['E-mail(ID)'];

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // String _verificationId = '';
  // bool _codeSent = false;
  final TextEditingController _smsController = TextEditingController();

  // SMS 인증번호 발송 및 확인
  // Future<void> _verifyPhoneNumber(String phoneNumber) async {
  //   // 01012345678 -> +821012345678로 변경
  //   String numericPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
  //   String formattedPhoneNumber = '+82$numericPhoneNumber';

  //   try {
  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: formattedPhoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await _auth.signInWithCredential(credential);
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         Fluttertoast.showToast(msg: e.message ?? 'Verification failed');
  //       },
  //       codeSent: (String verificationId, int? resendToken) async {
  //         print("코드 전송 완료");
  //         setState(() {
  //           _verificationId = verificationId;
  //           _codeSent = true;
  //           _remainingSeconds = 120; // 타이머 초기화
  //           _startTimer();
  //         });
  //       },
  //       // 코드 발송후 3분후 Code Time out
  //       timeout: const Duration(seconds: 120),
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         setState(() {
  //           _codeSent = false;
  //         });
  //         Fluttertoast.showToast(msg: 'Time out, please try again');
  //       },
  //     );
  //   } catch (e) {
  //     print(e.toString());
  //     Fluttertoast.showToast(msg: 'Error verifying phone number: $e');
  //   }
  // }

  // Future<void> _signInWithPhoneNumber(String smsCode) async {
  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: _verificationId,
  //       smsCode: smsCode,
  //     );

  //     await _auth.signInWithCredential(credential);
  //     print("Sign-in 성공");

  //     if (mounted) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const Home()),
  //       );
  //     }
  //   } catch (e) {
  //     print("에러 메시지: $e"); // Add this error log for debugging
  //     Fluttertoast.showToast(msg: 'Incorrect verification code');
  //   }
  // }

  Widget _buildFormField(String label, String hintText, bool obscuretext) {
    TextEditingController? controller = _controllers[label.toLowerCase()];
    if (controller == null) {
      controller = TextEditingController();
      _controllers[label.toLowerCase()] = controller;
    }
    bool showVerificationField =
        label == 'Phone #' && _visibleFields.contains('VerificationCode');

    String? Function(String?)? validator;
    switch (label.toLowerCase()) {
      case 'e-mail(id)':
        validator = _validateEmail;
        break;
      case 'password':
        validator = _validatePassword;
        break;
      case 'confirm password':
        validator = _comfirmPassword;
        break;
      case 'first name':
        validator = _validateName;
        break;
      case 'last name':
        validator = _validateName;
        break;
    }

    return _visibleFields.contains(label)
        ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        key: ValueKey(label),
                        controller: controller,
                        hintText: hintText,
                        obscuretext: obscuretext,
                        emptyErrorText: '빈칸을 채워주세요',
                        validator: validator,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            switch (label.toLowerCase()) {
                              case 'e-mail(id)':
                                if (!_visibleFields.contains('Password')) {
                                  if (_formKey.currentState!.validate()) {
                                    setState(
                                        () => _visibleFields.add('Password'));
                                  }
                                }
                                break;
                              case 'password':
                                if (!_visibleFields
                                    .contains('Confirm Password')) {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() =>
                                        _visibleFields.add('Confirm Password'));
                                  }
                                }
                                break;
                              case 'confirm password':
                                if (!_visibleFields.contains('First Name')) {
                                  if (_formKey.currentState!.validate()) {
                                    setState(
                                        () => _visibleFields.add('First Name'));
                                  }
                                }
                                break;
                              case 'first name':
                                if (!_visibleFields.contains('Last Name')) {
                                  if (_formKey.currentState!.validate()) {
                                    setState(
                                        () => _visibleFields.add('Last Name'));
                                  }
                                }
                                break;
                              case 'last name':
                                if (!_visibleFields.contains('Dropdown')) {
                                  if (_formKey.currentState!.validate()) {
                                    setState(
                                        () => _visibleFields.add('Dropdown'));
                                  }
                                }
                                break;
                              case 'phone #':
                                if (!_visibleFields
                                    .contains('AuthenticationButton')) {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _visibleFields
                                        .add('AuthenticationButton'));
                                  }
                                }
                                break;
                            }
                            // _visibleFields 길이를 callback 으로 상위 위젯으로 올림
                            widget.onProgressChanged(_visibleFields.length);
                          }
                        },
                      ),
                    ),
                    if (label == 'Phone #' &&
                        _visibleFields.contains('AuthenticationButton'))
                      Column(
                        children: [
                          Container(
                            // width: 76,
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)))),
                                onPressed: () {
                                  /* 
                                    인증하기 버튼 터치시 키보드로 인해
                                    인증번호 입력창이 보이지 않아서 FocusManager 활용했습니다.
                                  */
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  // _verifyPhoneNumber(
                                  //     _controllers['phone #']!.text);
                                  setState(
                                      () => _visibleFields.add('Verify #'));
                                },
                                child: const Text(
                                  '인증하기',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                          if (_remainingSeconds > 0)
                            Text('${_formatTime(_remainingSeconds)}left',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                )),
                        ],
                      )
                  ],
                ),
                if (showVerificationField)
                  CustomTextFormField(
                    emptyErrorText: "",
                    key: const ValueKey('VerificationCode'),
                    controller: TextEditingController(),
                    hintText: 'Enter verification code',
                    onChanged: (value) {},
                  ),
                const SizedBox(height: 18),
              ],
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: 374,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildFormField(
                  'E-mail(ID)', 'Write your email down here', false),
              _buildFormField('Password', 'Set your password', true),
              _buildFormField('Confirm Password', 'Check your password', true),
              _buildFormField('First Name', 'John', false),
              _buildFormField('Last Name', 'Doe', false),
              if (_visibleFields.contains('Dropdown'))
                HoursDropdown(
                  onChanged: (value) {
                    setState(() {
                      _visibleFields.add('Phone #');
                    });
                  },
                  maxHeight: 300,
                ),
              _buildFormField('Phone #', 'Enter your phone number', false),
              _buildFormField('Verify #', 'Enter your number', false),
              CustomOutlinedButton(
                backgroundcolor: ColorStyles.orange,
                width: 374,
                text: '회원가입 완료하기',
                textStyle: const TextStyle(color: Colors.white),
                onPressed: () {
                  // _signInWithPhoneNumber(_smsController.text);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
