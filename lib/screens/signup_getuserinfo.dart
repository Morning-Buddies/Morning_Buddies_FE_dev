import 'package:flutter/material.dart';
import 'package:morning_buddies/utils/design_palette.dart';
import 'package:morning_buddies/widgets/form_sign.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class GetUserInfoScrceen extends StatefulWidget {
  const GetUserInfoScrceen({super.key});

  @override
  State<GetUserInfoScrceen> createState() => _GetUserInfoScrceenState();
}

class _GetUserInfoScrceenState extends State<GetUserInfoScrceen> {
  int _visibleFieldCount = 1;
  double _progressPercent = 0.0;
  // 🚨
  void _updateVisibleFields(int newCount) {
    setState(() {
      _visibleFieldCount = newCount;
      _progressPercent = _visibleFieldCount / 9;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: LinearPercentIndicator(
          // 💡 이 부분에 주석을 해제하면 Statusbar 의 수치를 확인하실 수 있습니다.
          // center: Text(
          //   "$_progressPercent",
          //   style: const TextStyle(fontSize: 16),
          // ),
          barRadius: const Radius.circular(8.0),
          width: 330,
          lineHeight: 16.0,
          percent: _progressPercent <= 0.9
              ? _progressPercent
              : 1.0, // 1.0 이상 올라가지 않게 설정
          progressColor: _progressPercent >= 0.9
              ? ColorStyles.secondaryOrange
              : ColorStyles.orange,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                SignUpForm(
                  onProgressChanged: _updateVisibleFields,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
