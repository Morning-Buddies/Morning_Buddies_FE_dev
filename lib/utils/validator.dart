// validator.dart

class Validator {
  static bool isPasswordCompliant(String password,
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

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '빈칸을 채워주세요';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '이메일 형식을 지켜주세요';
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return '이메일 형식을 지켜주세요';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (!isPasswordCompliant(value!)) {
      return '문자+숫자+특수문자 조합 8자 이상 20자 미만으로 구성해주세요';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value != password) {
      return '동일한 비밀번호를 입력해주세요';
    }
    return null;
  }
}
