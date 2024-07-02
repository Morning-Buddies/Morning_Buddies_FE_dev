# morning_buddies

A new Flutter project.

## lib 디렉토리 구조
```

📦lib
 ┣ 📂models
 ┣ 📂screens
 ┃ ┣ 📂home
 ┃ ┃ ┣ 📜home_chat.dart
 ┃ ┃ ┣ 📜home_create.dart
 ┃ ┃ ┣ 📜home_main.dart
 ┃ ┃ ┣ 📜home_profile.dart
 ┃ ┃ ┗ 📜home_setting.dart
 ┃ ┣ 📂onboarding
 ┃ ┃ ┣ 📜onboarding_signin.dart
 ┃ ┃ ┗ 📜onboarding_signup.dart
 ┃ ┗ 📜signup_getuserinfo.dart
 ┣ 📂service
 ┣ 📂utils
 ┃ ┣ 📜debouce.dart
 ┃ ┣ 📜design_palette.dart
 ┃ ┣ 📜throttle.dart
 ┃ ┗ 📜validator.dart
 ┣ 📂widgets
 ┃ ┣ 📜custom_dropdown.dart
 ┃ ┣ 📜custom_form_field.dart
 ┃ ┣ 📜custom_outlined_button.dart
 ┃ ┣ 📜form_login.dart
 ┃ ┣ 📜form_sign.dart
 ┃ ┣ 📜home_bottom_nav.dart
 ┃ ┗ 📜signup_dropdown.dart
 ┣ 📜firebase_options.dart
 ┗ 📜main.dart
📦lib
 ┣ 📂models
    - 앱에서 사용되는 데이터 모델
    - 앱 전체서 사용되는 데이터들을 저장하는데 사용
 ┣ 📂screens
    - 화면 UI에 대한 폴더, 해당 화면 표현하는 코드
 ┣ 📂service
    - 외부와 인터페이스를 하기 위한 코드(WebAPI, DB...)
 ┣ 📂utils
    - 앱 전체적으로 사용되는 기능을 위한것, 반복되는 기능 
 ┣ 📂widgets
    - 전체적으로 사용되는 위젯(AppBar, BottomNav(Footer)... etc)등 여러 화면에서 이용되는 위젯을 모아두는 공간
 ┗ 📜main.dart
```