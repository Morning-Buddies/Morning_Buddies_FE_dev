import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/widgets/form/custom_form_field.dart';
import 'package:morning_buddies/widgets/dropdown/number_dropdown.dart';

class HomeCreate extends StatefulWidget {
  const HomeCreate({super.key});

  @override
  State<HomeCreate> createState() => _HomeCreateState();
}

class _HomeCreateState extends State<HomeCreate> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  late CroppedFile _croppedFile;

  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // TimePicker 관련 변수
  TimeOfDay initialTime = TimeOfDay.now();
  TimeOfDay? selectedTime;
  // ChatService

  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? imageFile = await _picker.pickImage(source: imageSource);
    if (imageFile != null) {
      _imageFile = imageFile;
      cropImage();
    }
  }

  Future<void> cropImage() async {
    if (_imageFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        compressFormat: ImageCompressFormat.jpg, // 저장할 이미지 확장자(jpg/png)
        compressQuality: 100, // 저장할 이미지의 퀄리티
        uiSettings: [
          // 안드로이드 UI 설정
          AndroidUiSettings(
              toolbarTitle: '이미지 자르기/회전하기', // 타이틀바 제목
              toolbarColor: ColorStyles.secondaryOrange, // 타이틀바 배경색
              toolbarWidgetColor: Colors.white, // 타이틀바 단추색
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio:
                  false), // 고정 값으로 자르기 (기본값 : 사용안함) => 이걸 사용하면 원하는 width, width 넓이로 사용 가능
          // iOS UI 설정
          IOSUiSettings(
            title: '이미지 자르기/회전하기', // 보기 컨트롤러의 맨 위에 나타나는 제목
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  bool _isFormFilled = false;
  @override
  void initState() {
    super.initState();
    // 텍스트 필드의 변경을 감지하여 _isFormFilled 값 업데이트
    _groupNameController.addListener(_updateFormFilledState);
    _descriptionController.addListener(_updateFormFilledState);
  }

  @override
  void dispose() {
    // 컨트롤러와 리스너 해제
    _groupNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateFormFilledState() {
    setState(() {
      _isFormFilled = _groupNameController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Groups",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // 뒤로가기
        leading: IconButton(
            onPressed: () => Get.toNamed("/main"),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            const SizedBox(height: 16),
            _buildPhotoArea(),
            const SizedBox(height: 16),
            _buildInputArea(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 42,
              child: OutlinedButton(
                  onPressed: _isFormFilled ? () {} : null,
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        _isFormFilled ? ColorStyles.orange : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    side: const BorderSide(color: ColorStyles.btnGrey),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      "Create Group",
                      style: TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _imageFile != null
        ? Stack(children: [
            SizedBox(
              child: Image.file(
                File(_croppedFile.path),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.photo_camera_back_sharp)),
            ),
          ])
        : Container(
            width: 356,
            height: 128,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: ColorStyles.btnGrey),
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFEFEFF0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image_outlined),
                const SizedBox(
                  height: 4,
                ),
                SizedBox(
                  height: 24,
                  child: OutlinedButton(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: ColorStyles.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        side: const BorderSide(color: Colors.transparent)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text(
                        "Select an Image",
                        style: TextStyle(color: Colors.white, fontSize: 10.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  Widget _buildInputArea() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Group Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomTextFormField(
            controller: _groupNameController,
            maxLength: 22,
            hintText: "Write Group Name",
            onChanged: (value) => _updateFormFilledState(),
            emptyErrorText: "",
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Wake-up Time",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(398, 56),
              backgroundColor: Colors.white,
              side: const BorderSide(color: ColorStyles.lightGray),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              final TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                initialTime: initialTime,
                builder: (BuildContext context, child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        onSurface: Colors.black,
                      ),
                      timePickerTheme: TimePickerThemeData(
                        dialHandColor: ColorStyles.secondaryOrange,
                        hourMinuteTextColor: WidgetStateColor.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? Colors.white
                                : Colors
                                    .black), // Text color when selected and not selected
                        hourMinuteColor: WidgetStateColor.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? ColorStyles.secondaryOrange
                                : Colors.grey
                                    .shade200), // Background color when selected and not selected
                        dayPeriodColor: WidgetStateColor.resolveWith((states) =>
                            states.contains(WidgetState.selected)
                                ? ColorStyles.secondaryOrange
                                : Colors.grey.shade200),
                        dayPeriodTextColor: WidgetStateColor.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? Colors.black
                                : Colors.black),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          backgroundColor: ColorStyles.secondaryOrange,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (timeOfDay != null) {
                setState(() {
                  selectedTime = timeOfDay;
                });
              }
            },
            child: Text(
              selectedTime != null
                  ? selectedTime!.format(context)
                  : "Press Button and Choose Wake-Up Time",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: selectedTime != null
                    ? ColorStyles.secondaryOrange
                    : ColorStyles.btnGrey,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Number of Members",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: NumberDropdown(),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Group Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: TextField(
              controller: _descriptionController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                hintText: "Enter Group Description",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorStyles.lightGray,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorStyles.lightGray), // When not focused
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
