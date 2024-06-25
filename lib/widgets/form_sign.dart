// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/debouce.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/utils/throttle.dart';
// import 'package:flutter/widgets.dart';
import 'package:morning_buddies/widgets/custom_form_field.dart';
import 'package:morning_buddies/widgets/custom_outlined_button.dart';
import 'package:morning_buddies/widgets/signup_dropdown.dart';

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
    super.dispose();
  }

  final List<String> _visibleFields = ['E-mail(ID)'];

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
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)))),
                          onPressed: () {
                            /* 
                              인증하기 버튼 터치시 키보드로 인해
                              인증번호 입력창이 보이지 않아서 FocusManager 활용했습니다.
                            */
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() => _visibleFields.add('Verify #'));
                          },
                          child: const Text(
                            '인증하기',
                            style: TextStyle(color: Colors.white),
                          ))
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
              // 🚨
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
                  if (_formKey.currentState!.validate()) {
                    // POST 로직 들어갈 자리
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
