import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:morning_buddies/auth/auth_controller.dart';
import 'package:morning_buddies/auth/firebase_auth_service.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/utils/validator.dart';
import 'package:morning_buddies/widgets/form/custom_form_field.dart';
import 'package:morning_buddies/widgets/button/custom_outlined_button.dart';
import 'package:morning_buddies/widgets/home_bottom_nav.dart';
import 'package:morning_buddies/widgets/dropdown/signup_dropdown.dart';
import 'dart:async'; // Import for Timer

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
  final AuthController authController = Get.find();

  Timer? _timer;
  int _secondsRemaining = 120;
  String? _selectedWakeUpTime;

  // TextController
  final Map<String, TextEditingController> _controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
  };

  String apiKey = dotenv.get("PROJECT_API_KEY");

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          Fluttertoast.showToast(msg: 'Code timed out. Please try again.');
        }
      });
    });
  }

  // Statusbar 계산의 기준이 되는 리스트
  // textcontroller가 생기면 해당하는 인풋 필드가 리스트에 삽입되는 원리
  final List<String> _visibleFields = ['E-mail(ID)'];

  final AuthService _authService = AuthService();

  String _verificationId = '';
  bool _codeSent = false;
  final TextEditingController _smsController = TextEditingController();

  // SMS 인증번호 발송 및 확인
  Future<void> _verifyPhoneNumber() async {
    String phoneNumber = _controllers['phone #']!.text;
    String numericPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericPhoneNumber.startsWith('0')) {
      numericPhoneNumber = numericPhoneNumber.substring(1);
    }
    String formattedPhoneNumber = '+82$numericPhoneNumber';

    await _authService.verifyPhoneNumber(
      formattedPhoneNumber,
      (verificationId, resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _startTimer();
        });
      },
      (verificationId) {
        Fluttertoast.showToast(msg: 'Time out, please try again');
      },
    );
  }

  void sendRegistrationData() async {
    // null 값 확인 로직
    String? email = _controllers['e-mail(id)']?.text;
    String? password = _controllers['password']?.text;
    String? firstName = _controllers['first name']?.text;
    String? lastName = _controllers['last name']?.text;
    String? phoneNumber = _controllers['phone #']?.text;
    String? hour;

    // 예외 처리로 시간이 올바른 형식인지 확인
    try {
      hour = _selectedWakeUpTime!.split(":")[0];
    } catch (e) {
      print('시간 형식 오류: $e');
    }

    // 필수 값이 모두 있는지 확인
    if (email == null ||
        password == null ||
        firstName == null ||
        lastName == null ||
        phoneNumber == null ||
        hour == null) {
      print('필수 항목 중 하나 이상이 null입니다.');
      return; // 필요한 경우 함수 종료
    }

    // 실제 요청
    try {
      await authController.registerUser(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        hour: hour,
      );
    } catch (e) {
      print('회원가입 요청 중 오류 발생: $e');
    }
  }

  // 인증번호 확인시 회원가입 로직
  Future<void> _signInWithPhoneNumber() async {
    await _authService.signInWithPhoneNumber(
        _verificationId,
        _smsController.text,
        _controllers['e-mail(id)']!.text,
        _controllers['password']!.text,
        _controllers['last name']!.text,
        _controllers['first name']!.text);

// BE SERVER POST LOGIC
    sendRegistrationData();

    if (mounted) {
      await Get.to(() => const HomeBottomNav());
    }
  }

  Widget _buildFormField(String label, String hintText, bool obscuretext) {
    // controller 소문자임 정신차리자
    TextEditingController? controller = _controllers[label.toLowerCase()];
    if (controller == null) {
      controller = TextEditingController();
      _controllers[label.toLowerCase()] = controller;
    }

    String? Function(String?)? validator;
    switch (label.toLowerCase()) {
      case 'e-mail(id)':
        validator = Validator.validateEmail;
        break;
      case 'password':
        validator = Validator.validatePassword;
        break;
      case 'confirm password':
        validator = (value) =>
            Validator.confirmPassword(value, _controllers['password']!.text);
        break;
      case 'first name':
      case 'last name':
        validator = Validator.validateName;
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
                      Container(
                        // width: 76,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            OutlinedButton(
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
                                  _verifyPhoneNumber();
                                  setState(
                                      () => _visibleFields.add('Verify #'));
                                },
                                child: const Text(
                                  '인증하기',
                                  style: TextStyle(color: Colors.white),
                                )),
                            if (_codeSent)
                              Text(
                                '${(_secondsRemaining / 60).floor()}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}left',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.red),
                              ),
                          ],
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 18),
              ],
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    if (_visibleFields.contains('Phone #') &&
        !_visibleFields.contains('AuthenticationButton')) {
      _visibleFields.add('AuthenticationButton');
    }
    return Form(
      key: _formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
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
                  selectedHour: _selectedWakeUpTime,
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      _selectedWakeUpTime = value;

                      _visibleFields.add('Phone #');
                    });
                  },
                  maxHeight: 300,
                ),
              _buildFormField('Phone #', 'Enter your phone number', false),
              if (_visibleFields.contains("Verify #") && _codeSent)
                CustomTextFormField(
                  emptyErrorText: "",
                  key: const ValueKey('VerificationCode'),
                  controller: _smsController,
                  hintText: 'Enter verification code',
                  onChanged: (value) {},
                ),
              CustomOutlinedButton(
                backgroundcolor: ColorStyles.orange,
                width: 374,
                text: '회원가입 완료하기',
                textStyle: const TextStyle(color: Colors.white),
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _verificationId.isNotEmpty) {
                    if (_codeSent) {
                      _signInWithPhoneNumber();
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please verify your phone number first.');
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
