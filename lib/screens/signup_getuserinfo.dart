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
      _progressPercent = _visibleFieldCount / 10;
      if (_progressPercent == 0.9) {
        _progressPercent = 1.0;
        return;
      }
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
          center: Text(
            "$_progressPercent",
            style: const TextStyle(fontSize: 16),
          ),
          barRadius: const Radius.circular(8.0),
          width: 330,
          lineHeight: 16.0,
          percent: _progressPercent, // 함수 만들어서 질문 진행시마다 업뎃
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
                // controller 에 입력 들어가면 다음 문장 등장?
                // Complete Btn => custom button 재활용
              ],
            ),
          ),
        ),
      ),
    );
  }
}
