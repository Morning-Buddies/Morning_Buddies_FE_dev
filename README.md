# morning_buddies

A new Flutter project.

## lib 디렉토리 구조
```
📦lib
 ┣ 📂auth
 ┃ ┣ 📜auth_controller.dart : 로그인, 회원가입 시 서버 통신(GetX로 로그인 정보 전역관리)
 ┃ ┣ 📜auth_gate.dart : 어플실행시 로그인 여부 따라 로그인 or 메인화면 안내
 ┃ ┣ 📜dio_client.dart : 로그인시 Response 내 Access token, Refresh token 파싱
 ┃ ┣ 📜firebase_auth_service.dart : firebase 관련 함수들
 ┃ ┗ 📜token_manager.dart : Flutter Secure Stroage에 토큰 저장 및 토큰 호출
 ┣ 📂models
 ┃ ┣ 📜chat_room.dart 
 ┃ ┣ 📜group_controller.dart
 ┃ ┣ 📜groupchat_controller.dart
 ┃ ┣ 📜groupinfo_controller.dart
 ┃ ┣ 📜message.dart
 ┃ ┗ 📜user_model.dart
 ┣ 📂screens
 ┃ ┣ 📂game
 ┃ ┃ ┣ 📜alert_game_service.dart : targetTime type변환 및 Game 화면 이동
 ┃ ┃ ┣ 📜game_error.dart : 게임 실행 과정에서 에러 발생한 경우
 ┃ ┃ ┣ 📜game_jigsaw_puzzle.dart : 퍼즐게임 로직
 ┃ ┃ ┣ 📜game_overlay_util.dart : 퍼즐 게임 클리어시 오버레이 화면
 ┃ ┃ ┗ 📜game_start.dart : 게임 시작 안내 화면
 ┃ ┣ 📂home
 ┃ ┃ ┣ 📂chat
 ┃ ┃ ┃ ┣ 📜chat_bubble.dart : 채팅 메시지 UI
 ┃ ┃ ┃ ┣ 📜chat_page.dart : 채팅 화면
 ┃ ┃ ┃ ┣ 📜group_chat_list_page.dart : 소속된 채팅 그룹 리스트 화면
 ┃ ┃ ┃ ┗ 📜test_handshake.dart : websocket handshake TEST
 ┃ ┃ ┣ 📜home_chat.dart : X
 ┃ ┃ ┣ 📜home_create.dart : 그룹 생성 화면
 ┃ ┃ ┣ 📜home_group_detail.dart : 그룹 상세 정보
 ┃ ┃ ┣ 📜home_main.dart : 메인 화면
 ┃ ┃ ┣ 📜home_profile.dart : 개인 프로필 화면
 ┃ ┃ ┣ 📜home_search.dart : 검색 화면
 ┃ ┃ ┣ 📜home_setting.dart : 비밀번호 재설정, 로그아웃, 탈퇴, 개인정보 처리방침
 ┃ ┃ ┣ 📜my_group_detail.dart : 마이페이지 내 소속 그룹 정보 위젯
 ┃ ┃ ┗ 📜password_reset.dart : 비밀번호 재설정
 ┃ ┣ 📂onboarding 
 ┃ ┃ ┣ 📜onboarding_signin.dart : 초기 로그인 화면
 ┃ ┃ ┗ 📜onboarding_signup.dart : 초기 회원가입 화면
 ┃ ┣ 📜signup_getuserinfo.dart : 회원가입 화면 UI 
 ┃ ┗ 📜subscription_screen.dart : 구독 결제 화면
 ┣ 📂service
 ┃ ┣ 📜chat_service.dart : 채팅 로직
 ┃ ┣ 📜groupchat_service.dart : 그룹 채팅 로직
 ┃ ┗ 📜search_delegate.dart : 검색 로직
 ┣ 📂utils
 ┃ ┣ 📜debouce.dart
 ┃ ┣ 📜design_palette.dart : 색상, 폰트
 ┃ ┣ 📜throttle.dart
 ┃ ┣ 📜time_service.dart : 타이머 함수 -> 추후 통합 예정
 ┃ ┣ 📜time_utils.dart : targetTime 과 현재 시간 차이 계산
 ┃ ┗ 📜validator.dart : 유효성 검사
 ┣ 📂widgets
 ┃ ┣ 📂button
 ┃ ┃ ┣ 📜custom_outlined_button.dart : 버튼 UI
 ┃ ┃ ┗ 📜section_with_btn.dart
 ┃ ┣ 📂dropdown
 ┃ ┃ ┣ 📜custom_dropdown.dart
 ┃ ┃ ┣ 📜member_num_dropdown.dart
 ┃ ┃ ┗ 📜signup_dropdown.dart
 ┃ ┣ 📂form
 ┃ ┃ ┣ 📜custom_form_field.dart
 ┃ ┃ ┣ 📜form_login.dart
 ┃ ┃ ┗ 📜form_sign.dart
 ┃ ┣ 📜custom_dropdown.dart
 ┃ ┣ 📜custom_form_field.dart
 ┃ ┣ 📜custom_outlined_button.dart
 ┃ ┣ 📜form_login.dart
 ┃ ┣ 📜form_sign.dart
 ┃ ┣ 📜home_bottom_nav.dart
 ┃ ┣ 📜number_dropdown.dart
 ┃ ┣ 📜section_with_btn.dart
 ┃ ┣ 📜signup_dropdown.dart
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