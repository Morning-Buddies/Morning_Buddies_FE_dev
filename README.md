# morning_buddies

A new Flutter project.

## lib 디렉토리 구조
```

📦lib
 ┣ 📂models
 ┃ ┣ 📜chat_room.dart
 ┃ ┣ 📜groupchat_controller.dart
 ┃ ┣ 📜groupinfo_controller.dart
 ┃ ┗ 📜message.dart
 ┣ 📂screens
 ┃ ┣ 📂game
 ┃ ┃ ┣ 📜game_jigsaw_puzzle.dart
 ┃ ┃ ┗ 📜game_start.dart
 ┃ ┣ 📂home
 ┃ ┃ ┣ 📂chat
 ┃ ┃ ┃ ┣ 📜chat_bubble.dart
 ┃ ┃ ┃ ┣ 📜chat_page.dart
 ┃ ┃ ┃ ┗ 📜group_list_page.dart
 ┃ ┃ ┣ 📜home_create.dart
 ┃ ┃ ┣ 📜home_group_detail.dart
 ┃ ┃ ┣ 📜home_main.dart
 ┃ ┃ ┣ 📜home_profile.dart
 ┃ ┃ ┣ 📜home_search.dart
 ┃ ┃ ┣ 📜home_setting.dart
 ┃ ┃ ┣ 📜my_group_detail.dart
 ┃ ┃ ┗ 📜password_reset.dart
 ┃ ┣ 📂onboarding
 ┃ ┃ ┣ 📜onboarding_signin.dart
 ┃ ┃ ┗ 📜onboarding_signup.dart
 ┃ ┣ 📜signup_getuserinfo.dart
 ┃ ┗ 📜subscription_screen.dart
 ┣ 📂service
 ┃ ┣ 📜auth_gate.dart
 ┃ ┣ 📜auth_service.dart
 ┃ ┣ 📜chat_service.dart
 ┃ ┣ 📜groupchat_service.dart
 ┃ ┗ 📜time_service.dart
 ┣ 📂utils
 ┃ ┣ 📜debouce.dart
 ┃ ┣ 📜design_palette.dart
 ┃ ┣ 📜throttle.dart
 ┃ ┣ 📜time_utils.dart
 ┃ ┗ 📜validator.dart
 ┣ 📂widgets
 ┃ ┣ 📂button
 ┃ ┃ ┣ 📜custom_outlined_button.dart
 ┃ ┃ ┗ 📜section_with_btn.dart
 ┃ ┣ 📂dropdown
 ┃ ┃ ┣ 📜custom_dropdown.dart
 ┃ ┃ ┣ 📜number_dropdown.dart
 ┃ ┃ ┗ 📜signup_dropdown.dart
 ┃ ┣ 📂form
 ┃ ┃ ┣ 📜custom_form_field.dart
 ┃ ┃ ┣ 📜form_login.dart
 ┃ ┃ ┗ 📜form_sign.dart
 ┃ ┣ 📜home_bottom_nav.dart
 ┃ ┗ 📜user_tile.dart
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